//
//  CustomTextfield.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import UIKit

@IBDesignable class CustomTextField: UITextField {

    var upperLabel: UILabel?
    var topPlaceHolderText = ""

    @IBInspectable var borderSelectedColor: UIColor? = #colorLiteral(red: 0.2901960784, green: 0.831372549, blue: 0.831372549, alpha: 1)
    @IBInspectable var topPlaceHolderColor: UIColor? = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    @IBInspectable var enableTopPlaceholder: Bool = true

    override var placeholder: String? {
        didSet{
            if !self.placeholder!.isEmpty{
                upperLabel?.text = self.topPlaceHolderText + " "
                self.placeholder = ""
            }
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var labelFont: UIFont? = UIFont(name: "Helvetica", size: 15)!{
        didSet {
            self.upperLabel?.font = self.labelFont
        }
    }

//    @IBInspectable override var borderWidth: CGFloat {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.upperLabel?.font = self.labelFont
        self.upperLabel?.textColor = self.borderColor
        self.upperLabel?.backgroundColor = self.topPlaceHolderColor

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 1.0
        self.addTarget(self, action: #selector(customTextfieldEditingDidBegin), for: UIControl.Event.editingDidBegin)
        self.addTarget(self, action: #selector(customTextFieldDidEndEditing), for: UIControl.Event.editingDidEnd)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 4.0
        self.upperLabel?.center = CGPoint(x: self.frame.minX + (self.upperLabel!.frame.size.width/2) + 10, y: self.frame.minY)

    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.enableTopPlaceholder{
            if superview != nil{
                if upperLabel == nil {
                    let fontSize = self.labelFont?.pointSize ?? 15.0
                    let size = self.placeholder!.size(withAttributes:[.font: self.labelFont!.withSize(fontSize)])

                    let topLabel = UILabel(frame: CGRect(x: self.frame.minX + 10, y: self.frame.minY - (size.height/2), width: size.width, height: size.height))
                    topLabel.font = self.font?.withSize(fontSize) ?? UIFont.systemFont(ofSize:15.0)
                    topLabel.text = self.placeholder! + " "
                    topLabel.backgroundColor = topPlaceHolderColor
                    topLabel.lineBreakMode = .byWordWrapping
                    topLabel.numberOfLines = 1
                    topLabel.sizeToFit()

                    self.upperLabel = topLabel
                    self.topPlaceHolderText = self.placeholder!
                    self.placeholder = ""
                    self.superview!.addSubview(topLabel)
                }
            }
        }
    }

    @objc func customTextfieldEditingDidBegin(textField: UITextField) {
        layer.borderColor = self.borderSelectedColor?.cgColor
        self.upperLabel?.textColor = self.borderSelectedColor
    }

    @objc func customTextFieldDidEndEditing(textField: UITextField) {
        layer.borderColor = self.borderColor?.cgColor
        self.upperLabel?.textColor = self.borderColor
    }
}

