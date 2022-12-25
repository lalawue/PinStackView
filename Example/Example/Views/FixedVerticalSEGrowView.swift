//
//  FixedVerticalSEGrowView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

class FixedVerticalSEGrowView: UIView {
    
    let v1 = UILabel().then {
        $0.backgroundColor = UIColor.red
        $0.text = "Hello"
    }
    
    let v2 = UILabel().then {
        $0.backgroundColor = UIColor.green
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.text = "32\nx\n32"
    }
    
    let v3 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.backgroundColor = UIColor.brown
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.setTitle("ClickMe", for: .normal)
    }
    
    lazy var stackView = PinStackView().then {
        $0.style = .fixed
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .end
        $0.spacing = 10
        $0.addItem(v1).top(10)
        $0.addItem(v2).size(32).grow(1)
        $0.addItem(v3).bottom(10)
    }
    
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        addSubview(stackView)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        v3.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        DemoUIHelper.appendInfo(view: stackView, name: name, spancer: "    ")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.pin.all()
    }
    
    @objc private func onTap() {
        v2.isHidden = !v2.isHidden
    }
}
