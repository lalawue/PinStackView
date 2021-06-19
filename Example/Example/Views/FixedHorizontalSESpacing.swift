//
//  FixedHorizontalSESpacing.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

class FixedHorizontalSESpacing: UIView {
    
    let v1 = UIView().then {
        $0.backgroundColor = UIColor.red
    }
    
    let v2 = UIView().then {
        $0.backgroundColor = UIColor.green
    }
    
    let v3 = UIView().then {
        $0.backgroundColor = UIColor.brown
    }
    
    lazy var stackView = PinStackView().then {
        $0.style = .fixed
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .start
        $0.spacing = 10
        $0.addItem(v1).height(40).grow(1.0).left(10)
        $0.addItem(v2).height(40).grow(1.0)
        $0.addItem(v3).height(40).grow(1.0).right(10)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.pin.all()
    }
}
