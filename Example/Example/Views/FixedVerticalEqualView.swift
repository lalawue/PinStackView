//
//  FixedVerticalEqualView.swift
//  Example
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinStackView

class FixedVerticalEqualView: UIView {
    
    let v1 = AutoSizeView().then {
        $0.backgroundColor = UIColor.red
    }
    
    let v2 = UIButton().then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        $0.setImage(UIImage(named: "icon"), for: .normal)
        $0.backgroundColor = UIColor.green
        $0.setTitle("ClickMe", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let v3 = AutoSizeView().then {
        $0.isHidden = true
        $0.backgroundColor = UIColor.brown
    }
    
    lazy var stackView = PinStackView().then {
        $0.style = .fixed
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .equal
        $0.addItem(v1).width(100)
        $0.addItem(v2).grow(0.4)
        $0.addItem(v3).width(100)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        v2.addTarget(self, action: #selector(onTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        v3.isHidden = !v3.isHidden
        stackView.markDirty()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.pin.all()
    }
}
