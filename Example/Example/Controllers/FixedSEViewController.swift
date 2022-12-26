//
//  FixedSEViewController.swift
//  Example
//
//  Created by lalawue on 2021/6/19.
//

import UIKit

class FixedSEViewController: BaseViewController {
    
    lazy var v1 = FixedHorizontalSEView(frame: .zero, name: "distribution start with maxWidth").then {
        $0.stackView.itemForView($0.v1)?.maxWidth(50)
    }

    lazy var v2 = FixedHorizontalSEView(frame: .zero, name: "distribution end with maxHeight").then {
        $0.stackView.distribution = .end
        $0.stackView.itemForView($0.v1)?.maxHeight(30)
    }

    lazy var v3 = FixedHorizontalSESpacing(frame: .zero, name: "grow equal")

    lazy var v4 = FixedVerticalSEGrowView(frame: .zero, name: "grow middle")

    lazy var v5 = FixedVerticalSEShrinkView(frame: .zero, name: "shrink middle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fixed Start / End"
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        scrollview.addSubview(v3)
        scrollview.addSubview(v4)
        scrollview.addSubview(v5)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        v1.pin.horizontally(15).top(10).marginTop(30).height(100)
        v2.pin.horizontally(15).top(to: v1.edge.bottom).marginTop(30).height(100)

        v3.pin.horizontally(15).top(to: v2.edge.bottom).marginTop(30).height(100)

        v4.pin.horizontally(15).top(to: v3.edge.bottom).marginTop(30).height(150)
        v5.pin.horizontally(15).top(to: v4.edge.bottom).marginTop(30).height(150)
    }
}
