//
//  FixedVerticalSEShrinkView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

/// fixed vertical start/end shrink exmaple view
class FixedVerticalSEShrinkView: PinStackView {
    
    let v1 = UILabel().then {
        $0.backgroundColor = UIColor.red
        $0.text = "Hello"
    }
    
    let v2 = UILabel().then {
        $0.backgroundColor = UIColor.green
        $0.numberOfLines = 0
        $0.text = "30\nx\n75"
        $0.textAlignment = .center
    }
    
    let v3 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.backgroundColor = UIColor.brown
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.setTitle("ClickMe", for: .normal)
    }
    
    fileprivate var changedFlag = false
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        self.do {
            $0.style = .fixed
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .start
            $0.spacing = 10
            $0.addItem(v1).top(10)
            $0.addItem(v2).width(30).height(75).shrink(1)
            $0.addItem(v3).bottom(10)
        }
        self.layer.do {
            $0.borderWidth = 1
            $0.borderColor = UIColor.gray.cgColor
        }
        v3.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        DemoUIHelper.appendInfo(view: self, name: name, spancer: "    ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        changedFlag = !changedFlag
        if changedFlag {
            self.itemForView(v2)?.shrink(0)
        } else {
            self.itemForView(v2)?.shrink(1)
        }
    }
}
