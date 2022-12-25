//
//  DemoUIHelper.swift
//  Example
//
//  Created by lii on 2022/12/25.
//

import PinStackView

class DemoUIHelper {
    
    private init() {
    }
    
    static func appendInfo(view: PinStackView, name: String, spancer: String = "\n") {
        
        let nameLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 8)
            $0.textColor = UIColor.gray
            $0.text = name
        }
        
        let infoLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 8)
            $0.textColor = UIColor.gray
            $0.numberOfLines = 0
        }
        
        view.insertSubview(nameLabel, at: 0)
        view.insertSubview(infoLabel, at: 1)
        
        let oldCallback = view.layoutCallback
        view.layoutCallback = { sview, changed in
            oldCallback?(sview, changed)
            guard let `sview` = sview else {
                return
            }
            do {
                // layout name label
                nameLabel.pin.left()
                    .bottom(to: sview.edge.top)
                    .marginBottom(1)
                    .height(9)
                    .sizeToFit(.height)
            }
            do {
                // collect item info, output to infoLabel, then layout
                var text = "[bounds size]\(spancer)"
                var index = 0
                for v in sview.subviews {
                    guard let _ = sview.itemForView(v) else {
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
                    .top(to: sview.edge.bottom)
                    .marginTop(1)
                if spancer == "\n" {
                    s.width(100).sizeToFit(.width)
                } else {
                    s.height(9).sizeToFit(.height)
                }
            }
        }
    }
}
