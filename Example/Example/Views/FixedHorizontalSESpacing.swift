//
//  FixedHorizontalSESpacing.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

/// fixed horizontal start/end exmaple view
class FixedHorizontalSESpacing: PinStackView {
    
    let v1 = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    
    let v2 = UIView().then {
        $0.backgroundColor = UIColor.green
    }
    
    let v3 = UIView().then {
        $0.backgroundColor = UIColor.brown
    }
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .fixed
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .start
            $0.spacing = 10
            $0.addItem(v1).height(40).grow(1.0).left(10)
            $0.addItem(v2).height(40).grow(1.0)
            $0.addItem(v3).height(40).grow(1.0).right(10)
        }
        self.layer.do {
            $0.borderWidth = 1
            $0.borderColor = UIColor.gray.cgColor
        }
        DemoUIHelper.appendInfo(view: self, name: name, spancer: "    ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
