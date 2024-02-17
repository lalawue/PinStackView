//
//  AutoHorizontalView.swift
//  Example
//
//  Created by lalawue on 2021/5/15.
//

import UIKit
import PinStackView

/// auto horizontal exmaple view
class AutoHorizontalView: PinStackView {
    
    let v1 = UILabel().then {
        $0.backgroundColor = UIColor.red
        $0.text = "Hello"
    }
    
    let v2 = UIView().then {
        $0.backgroundColor = UIColor.green
    }
    
    let v3 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.backgroundColor = UIColor.brown
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.setTitle("ClickMe", for: .normal)
    }
    
    let v4 = UIView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        $0.backgroundColor = UIColor.cyan
    }
    
    var changedFlag = 0
    
    var onTapButtonCallback: (() -> Void)? = nil
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .auto
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .start
            $0.spacing = 10
            $0.addItem(v1).left(20)
            $0.addItem(v2).size(20)
            $0.addItem(v3)
            $0.addItem(v4).right(20)
        }
        self.layer.do {
            $0.borderWidth = 1
            $0.borderColor = UIColor.gray.cgColor
        }
        v3.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        DemoUIHelper.appendInfo(view: self, name: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        if let cb = onTapButtonCallback {
            cb()
        } else {
            if changedFlag > 0 {
                if changedFlag > 1 {
                    changedFlag = 1
                    v4.frame = CGRect(origin: .zero, size: CGSize(width: 90, height: v4.frame.height))
                } else {
                    changedFlag = 2
                    v4.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: v4.frame.height))
                }
            } else {
                v4.isHidden = !v4.isHidden
            }
        }
    }
}
