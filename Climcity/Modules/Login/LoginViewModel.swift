//
//  LoginViewModel.swift
//  Climcity
//
//  Created by Mervin Flores on 5/19/21.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

class LoginViewModel{

    private var viewController: LoginViewController?
    private var selectedDate: Date?

    init(viewController: LoginViewController) {
        self.viewController = viewController
        return
    }

    func performLogin(){
        guard let loginViewController = self.viewController else { return }

        if self.validateForm() {
            let newUser = UserInfo(birthDay: self.selectedDate, name: loginViewController.textFieldName.text ?? "", email: loginViewController.textFieldEmail.text ?? "")
            let container = try! Container()

            try! container.write { transaction in
                transaction.add(newUser, update: .modified)
            }

            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appdelegate.setHomeScreen()

        } else {
            DispatchQueue.main.async() {
                loginViewController.present(ClimcityAlert.sharedInstance.unaryAlertWithTitle("Error", Message: "Please fill all the fields to continue"), animated: true, completion: nil)
            }
        }
    }

    private func validateForm() -> Bool{
        guard let loginViewController = self.viewController else { return false }
        guard let textName = loginViewController.textFieldName.text else { return false }
        guard let textEmail = loginViewController.textFieldEmail.text else { return false }

        var isValid = true

        if textName.isEmpty{
            isValid = false
        } else if textEmail.isEmpty {
            isValid = false
        } else if selectedDate == nil {
            isValid = false
        }

        return isValid
    }

    func showDatePicker(_ sender: UIButton){
        guard let loginViewController = self.viewController else { return }
        ActionSheetDatePicker.show(withTitle: "BirthDay", datePickerMode: .date, selectedDate: self.selectedDate ?? Date(), doneBlock: { (picker, value, indexes) in

            guard let selectedDate = value as? Date else { return }

            self.selectedDate = selectedDate
            loginViewController.labelBirthDay.text = "\(selectedDate.get(.day)) / \(selectedDate.get(.month)) / \(selectedDate.get(.year))"

        }, cancel: { (ActionSheetDatePickerCancelBlock) in
        }, origin: sender)
    }

    func shapeViews(){
        guard let loginViewController = self.viewController else { return }
        guard let containerView = loginViewController.labelBirthDay.superview else { return }

        containerView.superview!.layer.borderWidth = 1.0
        containerView.superview!.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        containerView.superview!.layer.cornerRadius = 4.0

        loginViewController.buttonLogIn.layer.cornerRadius = 4.0
    }

}
