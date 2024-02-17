//
//  BaseViewController.swift
//  Example
//
//  Created by lalawue on 2021/6/19.
//

import UIKit
import PinStackView

class BaseViewController: UIViewController {
    
    lazy var scrollview = UIScrollView().then {
        $0.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollview)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollview.pin.all()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let height = scrollview.subviews
            .filter { $0.isKind(of: PinStackView.self) }
            .last?.frame.maxY ?? 0
        scrollview.contentSize = CGSize(width: view.frame.width,
                                        height: height + 60)
    }
}
