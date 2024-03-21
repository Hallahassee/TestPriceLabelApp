import Foundation
import Combine


// MARK: - PriceLabel Data State

enum PriceLabelDataState {
    
    case loading
    case data([PriceLabelDisplayModel])
    
}

// MARK: - PriceLabel Sort Type

enum PriceLabelSortType {
    
    case abc
    case price
    
}

// MARK: - PriceLabel ViewModel

protocol PriceLabelViewModel: AnyObject {
    
    var dataStatePublisher: AnyPublisher<PriceLabelDataState, Never> { get }
    var sortTypeSubject: CurrentValueSubject<PriceLabelSortType, Never> { get }
    
    func onAppear()
    func didSelectData(with id: String)
    
}

// MARK: - PriceLabel ViewModel External Dependencies

public protocol PriceLabelViewModelExternalDeps {
    
    var toastManager: ToastManager { get }
    var dataService: PriceLabelDataService { get }
    
}

// MARK: - PriceLabel ViewModel External Implementation

final class PriceLabelViewModelImpl: PriceLabelViewModel {
    
    // MARK: - Internal Init
    
    init(deps: PriceLabelViewModelExternalDeps) {
        self.deps = deps
        
        sortTypeSubject
            .sink { [weak self] sortType in
                self?.updateDisplayData(with: sortType)
            }
            .store(in: &cancellable)
    }
    
    // MARK: - Internal Properties
    
    var sortTypeSubject: CurrentValueSubject<PriceLabelSortType, Never> = CurrentValueSubject(.price)
    var dataStatePublisher: AnyPublisher<PriceLabelDataState, Never> {
        dataStateSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Internal Methods
    
    func onAppear() {
        dataStateSubject.send(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            let newData = self.deps.dataService.getAllData()
            self.data = newData
            self.updateDisplayData(with: self.sortTypeSubject.value)
        }
    }
    
    func didSelectData(with id: String) {
        guard let item = data.first(where: {$0.id == id}) else {
            assertionFailure("Can`t find item with \(id)")
            return
        }
        deps.toastManager.showToast(
            content: [
                .boldText(item.name),
                .price(item.price),
                .defaultText(item.description)
            ]
        )
    }
    
    // MARK: - Private Methods

    private func updateDisplayData(with sortType: PriceLabelSortType) {
        let newData = data.map({PriceLabelDisplayModel(id: $0.id, name: $0.name, price: $0.price)})
        switch sortType {
        case .abc:
            dataStateSubject.send(.data(newData.sorted(by: {$0.name < $1.name})))
        case .price:
            dataStateSubject.send(.data(newData.sorted(by: {$0.price < $1.price})))
        }
    }
    
    // MARK: - Private Properties
    
    private var data: [PriceLabelDataModel] = []
    private let deps: PriceLabelViewModelExternalDeps
    private var dataStateSubject = PassthroughSubject<PriceLabelDataState, Never>()
    private var cancellable = Set<AnyCancellable>()
    
}
