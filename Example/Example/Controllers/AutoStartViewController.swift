//
//  AutoStartViewController.swift
//  Example
//
//  Created by tuu on 2021/6/19.
//

import UIKit
import PinStackView

class AutoStartViewController: BaseViewController {
    
    lazy var v1 = AutoVerticalView(frame: .zero, name: "auto size vertical hidden")
    
    lazy var v2 = AutoHorizontalView(frame: .zero, name: "auto size horizontal hidden")
    
    lazy var v3 = AutoVerticalView(frame: .zero, name: "auto size with child item property changed").then {
        $0.changedFlag = 2
        $0.itemForView($0.v3)?.alignSelf(.start)
    }
    
    lazy var v4 = AutoHorizontalView(frame: .zero, name: "auto size with child frame size changed").then {
        $0.changedFlag = 2
    }
    
    lazy var v5 = AutoHorizontalView(frame: .zero, name: "auto size with random length label text (may be empty)").then {
        $0.v4.isHidden = true
        let randomLengthTextFn: () -> String = {
            (0..<(arc4random() % 16)).map { "\($0 % 10)" }.joined()
        }
        let label = UILabel().then {
            $0.tag = 5
            $0.text = randomLengthTextFn()
            $0.backgroundColor = UIColor.cyan
        }
        $0.addItem(label).right(20).alignSelf(.center).height(20)
        weak var weakView = $0
        $0.onTapButtonCallback = {
            (weakView?.viewWithTag(5) as? UILabel)?.text = randomLengthTextFn()
            weakView?.setNeedsLayout()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        scrollview.addSubview(v3)
        scrollview.addSubview(v4)
        scrollview.addSubview(v5)
        title = "Auto Style"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v1.pin.horizontally(15).top(20).marginTop(30).sizeToFit(.width)
        v2.pin.right(15).top(to: v1.edge.bottom).marginTop(40).height(50).sizeToFit(.height)
        v3.pin.horizontally(15).top(to: v2.edge.bottom).marginTop(80).sizeToFit(.width)
        v4.pin.left(15).top(to: v3.edge.bottom).marginTop(80).height(50).sizeToFit(.height)
        v5.pin.left(15).top(to: v4.edge.bottom).marginTop(80).height(50).sizeToFit(.height)
    }
}
