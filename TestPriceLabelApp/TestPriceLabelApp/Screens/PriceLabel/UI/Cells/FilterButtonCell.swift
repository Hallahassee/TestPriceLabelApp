import UIKit

final class FilterButtonCell: UITableViewCell {

    // MARK: - Internal Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func applyAction(_ action: @escaping () -> Void) {
        let uiAction = UIAction { _ in
            action()
        }
        button.addAction(uiAction, for: .touchUpInside)
    }

    func applyTitle(_ title: String) {
        button.setTitle(title, for: .normal)
    }

    override func prepareForReuse() {
        button.setTitle(nil, for: .normal)
        button.removeAllActions()
    }

    // MARK: - Private Types

    private enum Constant {

        static let edgesOffset: CGFloat = 15

    }

    // MARK: - Private Properties

    private let button = UIButton()

    // MARK: - Private Methods

    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .gray
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.edgesOffset),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.edgesOffset),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.edgesOffset),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.edgesOffset)
        ])
    }

}

// MARK: - Support Methods

extension UIButton {

    fileprivate func removeAllActions() {
        enumerateEventHandlers { action, _, event, _ in
            if let action = action {
                removeAction(action, for: event)
            }
        }
    }

}
