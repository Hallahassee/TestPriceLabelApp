import UIKit
import Combine

final class PriceLabelViewController<Model: PriceLabelViewModel>: UIViewController, UITableViewDelegate {

    // MARK: - Internal Init

    init(model: Model) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        self.setupTableView()
        self.bindToViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model.onAppear()
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        switch item {
        case .filter, .loading, nil:
            return
            
        case .dataCell(let PriceLabelDisplayModel):
            model.didSelectData(with: PriceLabelDisplayModel.id)
        }
    }

    // MARK: - Private Types

    private enum Section {
        case main
    }

    private enum Item: Hashable {

        case filter
        case loading
        case dataCell(PriceLabelDisplayModel)

    }

    private enum Constant {

        static func filterButtonTitle(for sort: PriceLabelSortType) -> String {
            switch sort {
            case .abc:
                return "Сортировать по цене"

            case .price:
                return "Сортировать по алфавиту"
            }
        }
    }

    private typealias TableViewDataSource = UITableViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Private Properties

    private let tableView = UITableView()
    private lazy var dataSource: UITableViewDiffableDataSource<Section, Item> = {
        self.buildDataSource()
    }()

    private let model: Model
    private var cancellable = Set<AnyCancellable>()

    // MARK: - Private Methods

    private func bindToViewModel() {
        model.dataStatePublisher
            .debounce(for: 0.1, scheduler: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleDataState(state)
            }
            .store(in: &cancellable)
    }

    private func handleDataState(_ state: PriceLabelDataState) {
        var snapshot = Snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])

        switch state {
        case .loading:
            snapshot.appendItems([.loading])
            tableView.separatorColor = .clear
        case .data(let array):
            snapshot.appendItems([.filter])
            snapshot.appendItems(array.map({Item.dataCell($0)}))
            tableView.separatorColor = .black
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self

        tableView.register(FilterButtonCell.self)
        tableView.register(PriceWithLabelCell.self)
        tableView.register(LoadingCell.self)
    }

    private func buildDataSource() -> UITableViewDiffableDataSource<Section, Item> {
        let dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: tableView) { [weak self] _, indexPath, itemIdentifier in
            guard let self else {
                assertionFailure("\(Self.self) is deinited")
                return nil
            }
            switch itemIdentifier {
            case .dataCell(let data):
                guard let cell = tableView.reuse(PriceWithLabelCell.self, indexPath) else {
                    return nil
                }
                let cellModel = PriceWithLabelCell.Model(title: data.name, price: data.price)
                cell.applyModel(cellModel)
                return cell

            case .filter:
                guard let cell = tableView.reuse(FilterButtonCell.self, indexPath) else {
                    return nil
                }
                cell.applyAction {
                    let sort = self.model.sortTypeSubject.value
                    self.model.sortTypeSubject.send(sort == .abc ? .price : .abc)

                    cell.applyTitle(Constant.filterButtonTitle(for: sort == .abc ? .price : .abc))
                }
                cell.applyTitle(Constant.filterButtonTitle(for: self.model.sortTypeSubject.value))
                return cell

            case .loading:
                guard let cell = tableView.reuse(LoadingCell.self, indexPath) else {
                    return nil
                }
                return cell
            }
        }
        return dataSource
    }

}

// MARK: - Support Methods

extension UITableView {

    fileprivate func register<T: UITableViewCell>(_ type: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    fileprivate func reuse<T: UITableViewCell>(_ type: T.Type, _ indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            assertionFailure("Can`t cast cell to \(T.Type.self)")
            return nil
        }
        return cell
    }

}
