import UIKit

final class CurrencyLabel: UIView {

    // MARK: - Public Init

    public init(currency: Double? = nil) {
        super.init(frame: .zero)
        setupUI()
    }

    // MARK: - Public Properties

    public var currency: Double? {
        didSet {
            guard let currency else {
                label.attributedText = nil
                return
            }
            apply(currency)
        }
    }

    // MARK: - Internal Init

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Types

    private enum Constant {

        static let mainColor: UIColor = .black
        static let currencyColor: UIColor = .gray
        static let currencySymbol: String = "₽"
        static let font: UIFont = .boldSystemFont(ofSize: 15)

    }

    // MARK: - Private Properties

    private let label = UILabel()

    // MARK: - Private Methods

    private func apply(_ currency: Double) {

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.currencySymbol = Constant.currencySymbol
        formatter.numberStyle = .currencyAccounting

        let mainString = formatter.string(from: NSNumber(value: currency))!
        let stringToColor = Constant.currencySymbol

        let range = (mainString as NSString).range(of: stringToColor)

        let mutableAttributedString = NSMutableAttributedString(
            string: mainString,
            attributes: [
                .foregroundColor : Constant.mainColor,
                .font : UIFont.boldSystemFont(ofSize: 15)

            ]
        )
        mutableAttributedString.addAttribute(.foregroundColor, value: Constant.currencyColor, range: range)

        label.attributedText = mutableAttributedString
    }

    private func setupUI() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
