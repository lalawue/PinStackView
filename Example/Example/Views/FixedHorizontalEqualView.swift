//
//  FixedHorizontalEqualView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

class FixedHorizontalEqualView: UIView {
    
    let v1 = UILabel().then {
        $0.backgroundColor = UIColor.red
        $0.text = "Hello"
    }
    
    let v2 = AutoSizeView().then {
        $0.backgroundColor = UIColor.green
    }
    
    let v3 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.backgroundColor = UIColor.brown
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.setTitle("Click...............", for: .normal)
    }
    
    let v4 = AutoSizeView().then {
        $0.backgroundColor = UIColor.green
    }
    
    lazy var stackView = PinStackView().then {
        $0.style = .fixed
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equal
        $0.addItem(v1)
        $0.addItem(v2)
        $0.addItem(v3)
        $0.addItem(v4)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        v3.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        if v1.text == "Hello" {
            v1.text = "HelloHello"
        } else {
            v1.text = "Hello"
        }
        v4.isHidden = !v4.isHidden
        stackView.markDirty()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.pin.all()
    }
}
