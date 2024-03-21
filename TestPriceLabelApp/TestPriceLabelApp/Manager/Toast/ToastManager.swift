import UIKit

public enum ToastContentType: Equatable {

    case price(Double)
    case boldText(String)
    case defaultText(String)

}

public enum ToastShowOption {

    case closeOnAnyTap
    case closeOnAnyScroll

}

public protocol ToastManager {

    func showToast(content: [ToastContentType])

}

public final class ToastManagerImpl: ToastManager {

    public func showToast(content: [ToastContentType]) {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            let toastView = ToastView(content: content) { [weak self] in
                self?.currentContent = nil
            }
            guard let container = topController.view ,
                    currentContent != content
            else {
                return
            }
            container.addSubview(toastView)
            toastView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toastView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                toastView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                toastView.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: Constant.toastSafeInsets),
                toastView.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -Constant.toastSafeInsets),
                toastView.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: Constant.toastSafeInsets),
                toastView.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -Constant.toastSafeInsets)
            ])
            currentContent = content
        }
    }

    private enum Constant {

        static let toastSafeInsets: CGFloat = 10
    }

    private var currentContent: [ToastContentType]?

}
