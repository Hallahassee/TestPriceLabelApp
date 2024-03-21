//import Foundation
//import UIKit
//
//public enum ToastContentType {
//
//    case description(String)
//    case title(String)
//    case currency(Double)
//}
//
//public enum ToastShowOption {
//
//    case closeOnScroll
//    case closeOnAnyTapOutside
//}
//
//// MARK: - Toast Manager
//
//public protocol ToastManager {
//
//    func show(content: [ToastContentType], with options: [ToastShowOption])
//
//}
//
//// MARK: - ToastManager Implementation
//
//final class ToastManagerImpl: ToastManager {
//    
//    func show(content: [ToastContentType], with options: [ToastShowOption]) {
//        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
//        if var topController = keyWindow?.rootViewController {
//            while let presentedViewController = topController.presentedViewController {
//                topController = presentedViewController
//            }
//
//            NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
//let stack = UIStackView()
//            stack.
//
//
//        }
//    }
//
//    private func buildContentStack(with content: [ToastContentType]) -> UIView {
//        let stack = UIStackView()
//
//        content.forEach { contentType in
//            switch contentType {
//            case .description(let string):
//                <#code#>
//            case .title(let string):
//                <#code#>
//            case .currency(let double):
//                <#code#>
//            }
//        }
//    }
//
//
//
//    private var presentedToast: UIView?
//
//
//}
//
//
