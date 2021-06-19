//
//  FixedSEViewController.swift
//  Example
//
//  Created by lalawue on 2021/6/19.
//

import UIKit

class FixedSEViewController: BaseViewController {
    
    lazy var v1 = FixedHorizontalSEView()
    lazy var v2 = FixedHorizontalSEView().then {
        $0.stackView.distribution = .end
    }
    
    lazy var v3 = FixedHorizontalSESpacing()
    lazy var v4 = FixedVerticalSEView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        scrollview.addSubview(v3)
        scrollview.addSubview(v4)
        title = "Fixed Start / End"
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        v1.pin.horizontally(15).top(30).marginTop(30).height(100)
        v2.pin.horizontally(15).top(to: v1.edge.bottom).marginTop(30).height(100)
        v3.pin.horizontally(15).top(to: v2.edge.bottom).marginTop(30).height(100)
        v4.pin.horizontally(15).top(to: v3.edge.bottom).marginTop(30).height(200)
    }
}
