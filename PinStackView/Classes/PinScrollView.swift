//
//  PinScrollView.swift
//  PinStackView
//
//  Created by lii on 2025/3/16.
//

import UIKit
import PinLayout

/** auto content size UIScrollView relies on PinStackView
 */
open class PinScrollView: UIScrollView {

    var axis: PinStackViewAxis = .vertical {
        didSet {
            stackView.axis = axis
            setNeedsLayout()
        }
    }
    
    open var stackView = PinStackView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.style = .auto
        stackView.axis = axis
        addSubview(stackView)
        weak var weak_self = self
        stackView.layoutCallback = { sview, changed in
            guard let `self` = weak_self, let `sview` = sview, changed else { return }
            self.contentSize = self.scrollViewContentSize(sview)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollViewLayout()
    }

    /// return scroll view content size from stack view
    open func scrollViewContentSize(_ sview: PinStackView) -> CGSize {
        if axis == .horizontal {
            return CGSize(width: sview.frame.width, height: self.frame.height)
        } else {
            return CGSize(width: self.frame.width, height: sview.frame.height)
        }
    }

    /// layout stack view with anchor
    open func scrollViewLayout() {
        if axis == .horizontal {
            stackView.pin.left().vertically().sizeToFit(.height)
        } else {
            stackView.pin.top().horizontally().sizeToFit(.width)
        }
    }
}
