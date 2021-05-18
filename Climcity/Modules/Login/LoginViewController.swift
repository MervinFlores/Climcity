//
//  LoginViewController.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import UIKit
import ActionSheetPicker_3_0

class LoginViewController: UIViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textFieldName: CustomTextField!
    @IBOutlet weak var textFieldEmail: CustomTextField!
    @IBOutlet weak var labelBirthDay: UILabel!
    @IBOutlet weak var buttonBirthDay: UIButton!
    @IBOutlet weak var buttonLogIn: UIButton!

    private var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        self.labelBirthDay.superview!.layer.borderWidth = 1.0
        self.labelBirthDay.superview!.layer.borderColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        self.labelBirthDay.superview!.layer.cornerRadius = 4.0
        self.buttonLogIn.layer.cornerRadius = 4.0
    }

    private func showDatePicker(_ sender: UIButton){
        ActionSheetDatePicker.show(withTitle: "BirthDay", datePickerMode: .date, selectedDate: self.selectedDate ?? Date(), doneBlock: { (picker, value, indexes) in

            guard let selectedDate = value as? Date else { return }

            self.selectedDate = selectedDate
            self.labelBirthDay.text = "\(selectedDate.get(.day)) / \(selectedDate.get(.month)) / \(selectedDate.get(.year))"

        }, cancel: { (ActionSheetDatePickerCancelBlock) in
        }, origin: sender)
    }

    @IBAction func buttonLogInTap(_ sender: UIButton){
        // TODO: Validations for fields and go to home screen.
        let newUser = UserInfo(birthDay: self.selectedDate, name: textFieldName.text ?? "", email: textFieldEmail.text ?? "")
        let container = try! Container()

        try! container.write { transaction in
            transaction.add(newUser, update: .modified)
        }
    }


    @IBAction func buttonBirthDayTap(_ sender: UIButton){
        self.showDatePicker(sender)
    }
}
