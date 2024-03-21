import UIKit

final class LoadingView: UIView {

    // MARK: - Public Init

   public init() {
        super.init(frame: .zero)
        setupIndicator()    
    }

    // MARK: - Internal Init

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Properties

    private let loadingIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Private Method

    private func setupIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        loadingIndicator.startAnimating()
    }

}
