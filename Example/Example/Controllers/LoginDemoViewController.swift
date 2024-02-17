//
//  LoginDemoViewController.swift
//  Example
//
//  Created by lii on 2023/2/19.
//

import UIKit
import PinStackView

class LoginDemoViewController: UIViewController {
    
    fileprivate let labelHeight = CGFloat(16)
    fileprivate let textFieldHeight = CGFloat(32)
    
    fileprivate lazy var signInButton = createButton("Sign In").then {
        $0.isSelected = true
    }
    fileprivate lazy var signUpButton = createButton("Sign Up")
    
    fileprivate lazy var signInView = PinStackView().then {
        $0.style = .auto
        $0.axis = .vertical
        $0.spacing = 2
        
        $0.addItem(createLabel("Name:")).height(labelHeight)
        $0.addItem(createTextField("Name")).height(textFieldHeight).bottom(8)
        
        $0.addItem(createLabel("Password:")).height(labelHeight)
        $0.addItem(createTextField("Password").then {
            $0.isSecureTextEntry = true
        }).height(textFieldHeight)
    }
    
    fileprivate lazy var signUpView = PinStackView().then {
        $0.style = .auto
        $0.axis = .vertical
        $0.spacing = 2
        
        $0.addItem(createLabel("Email:")).height(labelHeight)
        $0.addItem(createTextField("Email").then {
            $0.keyboardType = .emailAddress
        }).height(textFieldHeight).bottom(8)
        
        $0.addItem(createLabel("Name:")).height(labelHeight)
        $0.addItem(createTextField("Name")).height(textFieldHeight).bottom(8)
        
        $0.addItem(createLabel("Password:")).height(labelHeight)
        $0.addItem(createTextField("Password").then {
            $0.isSecureTextEntry = true
        }).height(textFieldHeight)
    }
    
    fileprivate lazy var cancelButton = createButton("Cancel", .black, 4).then {
        $0.titleLabelFont = (UIFont.systemFont(ofSize: 14), UIFont.systemFont(ofSize: 14))
        $0.isSelected = true
    }
    fileprivate lazy var confirmButton = createButton("Confirm", .black, 4).then {
        $0.titleLabelFont = (UIFont.systemFont(ofSize: 14), UIFont.systemFont(ofSize: 14))
        $0.isSelected = true
    }
    
    fileprivate lazy var contentView = PinStackView().then {
        $0.style = .auto
        $0.axis = .vertical
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
        $0.backgroundColor = UIColor.white
        $0.padding = UIEdgeInsets(top: 0, left: 16, bottom: 24, right: 16)
        $0.addItem(PinStackView().then {
            $0.spacing = 10
            $0.addItem(signInButton)
            $0.addItem(createLabel("/", 18))
            $0.addItem(signUpButton)
        }).bottom(12).height(52)
        
        $0.addItem(signInView)
        $0.addItem(signUpView.then {
            $0.isHidden = true
        })
        
        $0.addItem(PinStackView().then {
            $0.spacing = 10
            $0.addItem(cancelButton).grow(1)
            $0.addItem(confirmButton).grow(1)
        }).top(32).height(34)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login Demo"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(contentView)
        for btn in [signInButton, signUpButton] {
            btn.addTarget(self, action: #selector(onTapSignInUp(_:)), for: .touchUpInside)
        }
//        for btn in [cancelButton, confirmButton] {
//            btn.addTarget(self, action: #selector(onTapPop), for: .touchUpInside)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.pin.top(225).horizontally(32).sizeToFit(.width)
    }
    
    // MARK: -
    
    @objc fileprivate func onTapSignInUp(_ button: UIButton) {
        let views = [signInView, signUpView]
        for (index, btn) in [signInButton, signUpButton].enumerated() {
            if button == btn {
                btn.isSelected = true
                views[index].isHidden = false
            } else {
                btn.isSelected = false
                views[index].isHidden = true
            }
            btn.sizeToFit()
        }
    }
    
    @objc fileprivate func onTapPop() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func createButton(_ title: String, _ borderColor: UIColor? = nil, _ radius: CGFloat? = nil) -> LoginTabButton {
        return LoginTabButton().then {
            $0.setTitleColor(UIColor.gray, for: .normal)
            $0.setTitleColor(UIColor.black, for: .selected)
            $0.setTitleColor(UIColor.black, for: .highlighted)
            $0.setTitle(title, for: .normal)
            if let borderColor = borderColor {
                $0.layer.borderWidth = 0.5
                $0.layer.borderColor = borderColor.cgColor
            }
            if let radius = radius {
                $0.layer.cornerRadius = radius
            }
        }
    }
    
    fileprivate func createLabel(_ title: String, _ fontSize: CGFloat = 14) -> UILabel {
        return UILabel().then {
            $0.font = UIFont.systemFont(ofSize: fontSize)
            $0.textColor = UIColor.gray
            $0.text = title
        }
    }
    
    fileprivate func createTextField(_ placeHolder: String) -> LoginTextField {
        return LoginTextField().then {
            $0.placeholder = placeHolder
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

fileprivate class LoginTextField: UITextField {

    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}

fileprivate class LoginTabButton: UIButton {
    
    var titleLabelFont: (UIFont, UIFont) = (UIFont.systemFont(ofSize: 22), UIFont.boldSystemFont(ofSize: 22)) {
        didSet {
            _updateFont()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            _updateFont()
        }
    }
    
    private func _updateFont() {
        if self.isSelected {
            self.titleLabel?.font = titleLabelFont.1
        } else {
            self.titleLabel?.font = titleLabelFont.0
        }
    }
}
