import UIKit

final class PriceWithLabelCell: UITableViewCell {

    // MARK: - Internal Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal Methods

    func applyModel(_ model: Model) {
        applyPrice(model.price)
        applyTitle(model.title)
    }

    override func prepareForReuse() {
        titleLabel.text = nil
        priceLabel.currency = nil
    }

    // MARK: - Private Types

    private enum Constant {

        static let labelsBottomTopOffset: CGFloat = 10
        static let titleLabelLeadingOffset: CGFloat = 15
        static let priceLabelTrailingOffset: CGFloat = 10
        static let labelsSpacing: CGFloat = 15

    }

    // MARK: - Private Properties

    private let titleLabel = UILabel()
    private let priceLabel = CurrencyLabel()

    // MARK: - Private Methods

    private func applyPrice(_ price: Double) {
        priceLabel.currency = price
    }

    private func applyTitle(_ text: String) {
        titleLabel.text = text
    }

    private func setupUI() {
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        titleLabel.numberOfLines = .zero
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.labelsBottomTopOffset),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.labelsBottomTopOffset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constant.titleLabelLeadingOffset),
        ])

        contentView.addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constant.priceLabelTrailingOffset),
            priceLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constant.labelsSpacing)
        ])
    }

}
