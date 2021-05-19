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

    // MARK: - View model
    lazy var viewModel: LoginViewModel = {
        return LoginViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.shapeViews()
    }

    private func showDatePicker(_ sender: UIButton){
        self.viewModel.showDatePicker(sender)
    }

    @IBAction func buttonLogInTap(_ sender: UIButton){
        self.viewModel.performLogin()
    }


    @IBAction func buttonBirthDayTap(_ sender: UIButton){
        self.showDatePicker(sender)
    }
}
