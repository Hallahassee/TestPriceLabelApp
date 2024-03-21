import UIKit

final class ToastView: UIView {

    // MARK: - Internal Init

    init(content: [ToastContentType], onClose: (() -> Void)?) {
        self.onClose = onClose
        super.init(frame: .zero)
        setupUI()
        setupContent(content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = super.point(inside: point, with: event)
        if !result {
            UIView.animate(withDuration: 0.3) {
                self.alpha = .zero
            } completion: { _ in
                self.onClose?()
                self.removeFromSuperview()
            }
        }
        return result
    }

    // MARK: - Private Types

    private enum Constant {

        static let boldFont: UIFont = .boldSystemFont(ofSize: 15)
        static let cornerRadius: CGFloat = 15
        static let contentSpacing: CGFloat = 10
        static let contentInsets: CGFloat = 10
    }

    // MARK: - Private Properties

    private let stackView = UIStackView()
    private let onClose: (() -> Void)?

    // MARK: - Private Methods

    private func setupUI() {
        layer.cornerRadius = Constant.cornerRadius
        backgroundColor = .black.withAlphaComponent(0.1)

        addSubview(stackView)
        stackView.spacing = Constant.contentSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constant.contentInsets),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.contentInsets),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.contentInsets),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.contentInsets)
        ])
    }

    private func setupContent(_ content: [ToastContentType]) {
        content.forEach { contentType in
            switch contentType {
            case .price(let double):
                let view = CurrencyLabel()
                view.currency = double
                stackView.addArrangedSubview(view)

            case .boldText(let string):
                let label = UILabel()
                label.text = string
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                label.numberOfLines = .zero
                label.font = Constant.boldFont
                label.textAlignment = .center
                stackView.addArrangedSubview(label)

            case .defaultText(let string):
                let label = UILabel()
                label.text = string
                label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                label.numberOfLines = .zero
                label.textAlignment = .center
                stackView.addArrangedSubview(label)
            }
        }
    }

}
