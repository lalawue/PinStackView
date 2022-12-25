//
//  AutoStartViewController.swift
//  Example
//
//  Created by tuu on 2021/6/19.
//

import UIKit

class AutoStartViewController: BaseViewController {
    
    lazy var v1 = AutoVerticalView(frame: .zero, name: "auto size vertical")
    
    lazy var v2 = AutoHorizontalView(frame: .zero, name: "auto size horizontal")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        title = "Auto Style"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v1.pin.horizontally(15).top(30).marginTop(30).sizeToFit(.width)
        v2.pin.right(15).top(to: v1.edge.bottom).marginTop(30).height(50).sizeToFit(.height)
    }
}
