//
//  PinStackInfoView.swift
//  Example
//
//  Created by lii on 2022/12/25.
//

import UIKit
import PinStackView

/// append item infos
class PinStackInfoView: PinStackView {
    
    var spancer = "\n"
    
    let nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 8)
        $0.textColor = UIColor.gray
        $0.numberOfLines = 0
    }
    
    fileprivate let infoLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 8)
        $0.textColor = UIColor.gray
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectItemInfo()
        nameLabel.pin.bottom(to: edge.top).height(9).sizeToFit(.height)
    }
    
    fileprivate func collectItemInfo() {
        var text = "[bounds size]\(spancer)"
        var index = 0
        for v in subviews {
            guard let _ = itemForView(v) else {
                continue
            }
            index += 1
            let sz = v.bounds.size
            if v.isHidden {
                text += "\(index): 0 x 0\(spancer)"
            } else {
                text += "\(index): \(ceil(sz.width)) x \(ceil(sz.height))\(spancer)"
            }
        }
        infoLabel.text = text
        let s = infoLabel.pin.left()
            .top(to: edge.bottom)
            .marginTop(1)
        if spancer == "\n" {
            s.width(100).sizeToFit(.width)
        } else {
            s.height(9).sizeToFit(.height)
        }
    }
}
