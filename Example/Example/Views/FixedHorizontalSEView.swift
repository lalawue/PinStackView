//
//  FixedHorizontalSEView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

/// fixed horizontal start/end exmaple view
class FixedHorizontalSEView: PinStackView {
    
    let v1 = UILabel().then {
        $0.backgroundColor = UIColor.red
        $0.textAlignment = .center
        $0.text = "Hello"
    }
    
    let v2 = UIView().then {
        $0.backgroundColor = UIColor.green
    }
    
    let v3 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.backgroundColor = UIColor.brown
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.setTitle("String", for: .normal)
    }
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .fixed
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .start
            $0.spacing = 10
            $0.addItem(v1).left(10).width(ratio: 0.25).height(ratio: 0.6)//.size(ratio: 0.25, 0.6)
            $0.addItem(v2).width(20).height(8).left(10)
            $0.addItem(v3).right(10)
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
