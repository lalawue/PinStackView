//
//  FixedEqualViewConrtroller.swift
//  Example
//
//  Created by lalawue on 2021/6/19.
//

import UIKit

class FixedEqualViewConrtroller: BaseViewController {

    lazy var v1 = FixedHorizontalEqualView()
    lazy var v2 = FixedVerticalEqualView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(v1)
        scrollview.addSubview(v2)
        
        title = "Fixed Equal"
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        v1.pin.horizontally(15).top(70).height(100)
        v2.pin.top(to: v1.edge.bottom).marginTop(30).hCenter().width(130).height(400)
    }
}
