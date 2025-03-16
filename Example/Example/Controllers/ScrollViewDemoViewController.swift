//
//  ScrollViewDemoViewController.swift
//  Example
//
//  Created by lii on 2025/3/16.
//

import UIKit
import PinStackView

class ScrollViewDemoViewController: UIViewController {
    
    private let scrollView = PinScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Scroll View Demo"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.addSubview(scrollView)
        configUI()
    }
    
    private func configUI() {
        scrollView.do {
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.backgroundColor = .white
            $0.stackView.do {
                $0.padding = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
                // title
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 24)
                    $0.text = "README.md"
                }).height(32).alignSelf(.center)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Introduction"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = "PinStackView was a Frame base StackView relies on PinLayout."
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Features"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
- can be used with manual layout, Autolayout
- is a real view and only layout specified sub-views
- has inner padding
- has equal distribution like UIStackView
- has auto style with dynamic length in axis direction
- has grow/shrink
- observ item layout properties
- KVO item views 'isHidden'
"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Install"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
To integrate PinStackView into your Xcode project using CocoaPods, specify it in your Podfile:

    pod 'PinStackView'

Then, run pod install.
"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Usage"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
examples listed in project 'Views/' group

    $ cd Example
    $ pod install
    $ open Example.xcworkspace

"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Interface"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
- addItems(): add managed sub-views, return PinStackItemInfo for chained setting, you can addSubviews() and layout view by yourself
- insertItem(): like addItems(), can defined sequence
- removeItem(): remove managed sub-views, also removed from subviews
- remakeItem(): replace with new item but did not change subview's sequence
- itemForView(): get PinStackItemInfo from PinStackView after addItem() or insertItem()
- define(): a sugar to chain items info definition
- markDirty(): like setNeesLayout(), force layout in next view update
- triggerNeedsLayout(): trigger subview's setNeedsLayout when PinStackView setNeedsLayout.
"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Properties"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
- style: default .fixed, the axis length will not change after layout; .auto style means its axis length will change by items
- axis: .horizontal or .vertical direction, dynamic length direction
- distribution: axis direction layout style, .equal only support .fixed style; .auto style always .start
- alignment: cross axis direction, you can specify view's alignment by alignSelf()
- spacing: spacing between items in axis direction
- padding: items will layout after padding
- layoutCallback: call back after every layout, will pass in true when size changed
"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "PinStackItemInfo"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
PinStackItemInfo was each item's layout definition, you will get instance after addItem()

- top(): top margin, points or inner height ratio after padding
- bottom(): bottom margin, points or inner height ratio after padding
- left(): left margin, points or inner width ratio after padding
- right(): right margin, points or inner width ratio after padding
- width(): points or inner width ratio after padding
- height(): points or inner height ratio after padding
- maxWidth(): max points or inner width ratio after padding, high priority than width()
- maxHeight(): max points or inner height ratio after padding, high priority than height()
- minWidth(): min points or inner width ratio after padding, high priority than width()
- minHeight(): min points or inner height ratio after padding, high priority than height()
- size(): highest priority than width(), height(), max/min width & height, points or ratio after padding
- alignSelf(): high priroty than PinStackView's alignment, only for this item
- grow(): in .fixed style and .start / .end distribution, it means item using dynamic length in axis direction after all fixed items length acumulated; no meanings in .equal distribution or .auto style
- shrink(): in .fixed style and.start / .end distribution, it means item using dynamic length in axis direction after all fixed items length acumulated; no meanings in .equal distribution or .auto style
"""
                    $0.numberOfLines = 0
                }).top(10)
                
                $0.addItem(UILabel().then {
                    $0.font = .boldSystemFont(ofSize: 16)
                    $0.text = "Coding Example"
                }).top(24).height(20)
                
                $0.addItem(UILabel().then {
                    $0.font = .systemFont(ofSize: 12)
                    $0.text = """
using Then from Suyeol Jeon

    lazy var stackView = PinStackView().then {
        $0.style = .auto
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .start
        $0.spacing = 10
        $0.addItem(v1).left(20)
        $0.addItem(v2).size(20).shrik(2.0)
        $0.addItem(v3).grow(1.0) // with grow ratio 1.0 / (1.0 + 2.0)
        $0.addItem(v4).size(30).grow(2.0).right(20)
    }
"""
                    $0.numberOfLines = 0
                }).top(10)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.pin.all()
    }
    
    fileprivate func createTextField(_ placeHolder: String) -> InsetTextField {
        return InsetTextField().then {
            $0.placeholder = placeHolder
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.layer.cornerRadius = 4
            $0.layer.borderWidth = 0.5
            $0.layer.borderColor = UIColor.gray.cgColor
        }
    }
}

fileprivate class InsetTextField: UITextField {

    var textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInsets)
    }
}
