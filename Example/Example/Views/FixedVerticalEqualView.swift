//
//  FixedVerticalEqualView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

/// fixed vertical equal exmaple view
class FixedVerticalEqualView: PinStackView {
    
    let v1 = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    
    let v2 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.backgroundColor = UIColor.green
        $0.setTitle("ClickMe", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let v3 = UIView().then {
        $0.isHidden = true
        $0.backgroundColor = UIColor.brown
    }
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .fixed
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equal
            $0.addItem(v1).width(100)
            $0.addItem(v2).grow(0.4)
            $0.addItem(v3).width(100)
        }
        self.layer.do {
            $0.borderWidth = 1
            $0.borderColor = UIColor.gray.cgColor
        }
        v2.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        DemoUIHelper.appendInfo(view: self, name: name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        v3.isHidden = !v3.isHidden
    }
}
