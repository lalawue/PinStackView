//
//  NestedViewController.swift
//  Example
//
//  Created by lii on 2023/1/27.
//

import UIKit
import PinStackView

fileprivate class MyLabel: UILabel {
    
    var tick: Int = 0 {
        didSet {
            text = "\(tick) ticks"
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let s = super.sizeThatFits(size)
        if tick & 1 == 1 {
            return CGSize(width: s.width * 2, height: s.height)
        } else {
            return s
        }
    }
}

class NestedViewController: BaseViewController {
    
    fileprivate let calcTimeContentLabel = MyLabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor.black
        $0.tick = 0
    }
    
    fileprivate var timer: Timer?
    
    fileprivate lazy var stackView = PinStackView().then {
        $0.style = .auto
        $0.axis = .vertical
        $0.padding = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.addItem(PinStackView().then {
            $0.style = .fixed
            $0.axis = .horizontal
            $0.distribution = .end
            $0.addItem(UILabel().then {
                $0.font = UIFont.boldSystemFont(ofSize: 12)
                $0.textColor = .gray
                $0.text = "Example 1."
            })
            $0.addItem(UIView()).grow(1)
            $0.addItem(UILabel().then {
                $0.font = UIFont.boldSystemFont(ofSize: 12)
                $0.textColor = UIColor.gray
                $0.text = "Tick passed: "
            }).right(8)
            $0.addItem(calcTimeContentLabel)
        })
            .height(18)
            .bottom(2)
            .refresh()
        // ---
        $0.addItem(UIView().then {
            $0.backgroundColor = .black
        }).height(0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Nested Example"
        
        scrollview.addSubview(stackView)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] _ in
            self?.updateTimer()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.pin.all()
    }
    
    @objc fileprivate func updateTimer() {
        calcTimeContentLabel.tick += 1
        //calcTimeContentLabel.sizeToFit()
        stackView.setNeedsLayout()
    }
}
