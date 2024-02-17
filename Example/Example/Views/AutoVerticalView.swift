//
//  AutoVerticalView.swift
//  Example
//
//  Created by lalawue on 2021/5/15.
//

import UIKit
import PinStackView

/// auto vertical exmaple view
class AutoVerticalView: PinStackView {
    
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
        $0.backgroundColor = UIColor.cyan
    }
    
    var changedFlag = 0
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .auto
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .start
            $0.spacing = 10
            $0.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            $0.addItem(v1)
            $0.addItem(v2).size(25)
            $0.addItem(v3).alignSelf(.end)
            $0.addItem(v4).size(40)
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
        if changedFlag > 0 {
            if changedFlag > 1 {
                changedFlag = 1
                self.itemForView(v3)?.alignSelf(.end)
            } else {
                changedFlag = 2
                self.itemForView(v3)?.alignSelf(.start)
            }
        } else {
            v2.isHidden = !v2.isHidden
        }
    }
}
