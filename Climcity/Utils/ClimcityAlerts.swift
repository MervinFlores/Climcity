//
//  ClimcityAlerts.swift
//  Climcity
//
//  Created by Mervin Flores on 5/19/21.
//

import Foundation
import UIKit

class ClimcityAlert: UIAlertController {

    static var sharedInstance = ClimcityAlert()

    open func unaryAlertDefault(Message message : String) -> ClimcityAlert {
        return unaryAlertWithTitle(nil, Message: message, ButtonText: nil, ResponseHandler: nil)
    }

    open func unaryAlertWithTitle(_ title : String, Message message : String) -> ClimcityAlert {
        return unaryAlertWithTitle(title, Message: message, ButtonText: nil, ResponseHandler: nil)
    }

    open func unaryAlertWithTitle(_ title : String?, Message message : String, ButtonText buttonTitle : String?, ResponseHandler handler : ((UIAlertAction) -> Void)? ) -> ClimcityAlert {
        let alert = ClimcityAlert.init(title: (title == nil) ? "Climcity" : title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: (buttonTitle == nil) ? "OK" : buttonTitle, style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(action)
        return alert
    }

    open func binaryAlertWithTitle(Message message : String) -> ClimcityAlert {
        return binaryAlert(WithTitle: nil, Message: message, PositiveButton: nil, NegativeButton: nil, PositiveHandler: nil, NegativeHandler: nil)
    }


    func binaryAlert(WithTitle title : String?,
                     Message message : String,
                     PositiveButton okTitle : String?,
                     NegativeButton cancelTitle : String?,
                     PositiveHandler okHandler : ((UIAlertAction?) -> Void)?,
                     NegativeHandler cancelHandler : ((UIAlertAction) -> Void)?) -> ClimcityAlert {

        let alert = ClimcityAlert.init(title: title ?? "Climcity", message: message, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: okTitle ?? "OK", style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancelTitle ?? "Cancel", style: .cancel, handler: cancelHandler)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        return alert
    }
}
