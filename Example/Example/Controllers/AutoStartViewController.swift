//
//  AutoStartViewController.swift
//  Example
//
//  Created by tuu on 2021/6/19.
//

import UIKit

class AutoStartViewController: BaseViewController {
    
    lazy var v1 = AutoVerticalView(frame: .zero, name: "auto size vertical hidden")
    
    lazy var v2 = AutoHorizontalView(frame: .zero, name: "auto size horizontal hidden")
    
    lazy var v3 = AutoVerticalView(frame: .zero, name: "auto size with child item property changed").then {
        $0.changed = 2
        $0.stackView.itemForView($0.v3)?.alignSelf(.start)
    }
    
    lazy var v4 = AutoHorizontalView(frame: .zero, name: "auto size with child frame size changed").then {
        $0.changeSize = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        scrollview.addSubview(v3)
        scrollview.addSubview(v4)
        title = "Auto Style"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v1.pin.horizontally(15).top(30).marginTop(30).sizeToFit(.width)
        v2.pin.right(15).top(to: v1.edge.bottom).marginTop(40).height(50).sizeToFit(.height)
        v3.pin.horizontally(15).top(to: v2.edge.bottom).marginTop(80).sizeToFit(.width)
        v4.pin.left(15).top(to: v3.edge.bottom).marginTop(80).height(50).sizeToFit(.height)
    }
}
