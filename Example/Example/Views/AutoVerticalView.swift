//
//  AutoVerticalView.swift
//  Example
//
//  Created by lalawue on 2021/5/15.
//

import UIKit
import PinStackView

class AutoVerticalView: UIView {
    
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
    
    lazy var stackView = PinStackInfoView().then {
        $0.style = .auto
        $0.axis = .vertical
        $0.alignment = .center
        $0.distribution = .start
        $0.spacing = 10
        $0.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.addItem(v1)
        $0.addItem(v2).size(10)
        $0.addItem(v3).alignSelf(.end)
        $0.addItem(v4).size(30)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        v3.addTarget(self, action: #selector(onTap), for: .touchUpInside)
        stackView.layoutCallback = { [weak self] stacview, changed in
            guard let sv = self?.superview, changed else {
                return
            }
            let f = sv.bounds
            sv.bounds = CGRect(x: f.origin.x, y: f.origin.y, width: f.size.width, height: f.size.height + 0.001)
            sv.bounds = f
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func onTap() {
        v2.isHidden = !v2.isHidden
        stackView.markDirty()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.pin.horizontally().sizeToFit(.width)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return stackView.sizeThatFits(size)
    }
}
