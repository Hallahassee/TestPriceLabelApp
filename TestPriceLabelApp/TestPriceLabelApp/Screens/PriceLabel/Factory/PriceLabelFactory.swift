import Foundation
import UIKit

public protocol PriceLabelExternalDeps: PriceLabelViewModelExternalDeps {}

public struct PriceLabelExternalDepsImpl: PriceLabelExternalDeps {

    public var toastManager: ToastManager
    public var dataService: PriceLabelDataService

}

public protocol PriceLabelFactory {

    func makePriceLabelScreen(deps: PriceLabelExternalDeps) -> UIViewController

}

public final class PriceLabelFactoryImpl: PriceLabelFactory {

    public func makePriceLabelScreen(deps: PriceLabelExternalDeps) -> UIViewController {
        let vm = PriceLabelViewModelImpl(deps: deps)
        let vc = PriceLabelViewController(model: vm)
        return vc
    }

}
