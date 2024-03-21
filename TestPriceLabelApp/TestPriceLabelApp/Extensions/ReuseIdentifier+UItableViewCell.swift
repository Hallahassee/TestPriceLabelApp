import UIKit

protocol ReuseIdentifier {}

extension ReuseIdentifier {

    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }

}

extension UITableViewCell: ReuseIdentifier {}
