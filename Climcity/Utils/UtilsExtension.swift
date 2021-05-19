//
//  UtilsExtension.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import Foundation
import UIKit
import PKHUD

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

extension UIView{
    /// show loading overlay over current view
    func showLoading(message:String = "") {
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        HUD.show(.progress, onView: self)
    }

    /// dissmiss loading view from current view with success animation at the end.
    func showSuccessIndicator(){
        HUD.flash(.success, delay: 1.5)
    }

    /// dissmiss loading view from current view
    func dismissLoading (isSuccess:Bool = true){
        HUD.hide()
    }
}
