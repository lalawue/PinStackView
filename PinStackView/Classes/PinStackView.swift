//
//  PinStackView.swift
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinLayout

/// debug output
fileprivate func debugLog(_ msg: String) {
    #if DEBUG
    debugPrint("[PinStackView] \(msg)")
    #endif
}

fileprivate enum Unit: Int, Equatable {
    case point = 0
    case ratio
    static func ==(lhs: Unit, rhs: Unit) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

fileprivate class Value {
    var value = CGFloat(0)
    var unit = Unit.point
}

fileprivate class SizeValue {
    var value = CGSize.zero
    var unit = Unit.point
}

/** layout info
 */
open class PinStackItemInfo {
    
    fileprivate weak var _view: PinStackView?
    
    /// margins
    fileprivate var _top = Value()
    fileprivate var _bottom = Value()
    fileprivate var _left = Value()
    fileprivate var _right = Value()

    /// size has prior than width、height, max-width, max-height
    fileprivate var _size: SizeValue?
    
    fileprivate var _width: Value?
    fileprivate var _height: Value?
    
    /// max-width, max-height has prior than width, height
    fileprivate var _max_width: Value?
    fileprivate var _max_height: Value?
    
    fileprivate var _min_width: Value?
    fileprivate var _min_height: Value?

    /// aligment in corss direction
    fileprivate var _alignSelf: PinStackViewAlignment?
    
    /// dynamic  value / total value, greater than 0, only for style fixed
    fileprivate var _grow = CGFloat(0)

    /// dynamic value / total value, greater than 0, only for style fixed
    fileprivate var _shrink = CGFloat(0)
    
    // MARK: -
    
    @inline(__always)
    fileprivate func setProperty(_ np: inout Value, _ unit: Unit, _ float: CGFloat) -> PinStackItemInfo {
        np.unit = unit
        np.value = float
        return self
    }
    
    @inline(__always)
    fileprivate func setProperty(_ property: inout Value?, _ unit: Unit, _ float: CGFloat) -> PinStackItemInfo {
        let np = property ?? Value()
        changeValue(&np.unit, unit)
        changeValue(&np.value, float)
        property = np
        return self
    }
    
    @inline(__always)
    fileprivate func setSize(_ sz: inout SizeValue?, _ unit: Unit, _ w: CGFloat, _ h: CGFloat) -> PinStackItemInfo {
        let nsz = sz ?? SizeValue()
        nsz.unit = unit
        if unit == .point {
            changeValue(&nsz.value, CGSize(width: w, height: h))
        } else {
            if h.isNaN {
                changeValue(&nsz.value, CGSize(width: regularRatio(w), height: .nan))
            } else {
                changeValue(&nsz.value, CGSize(width: regularRatio(w), height: regularRatio(h)))
            }
        }
        sz = nsz
        return self
    }
    
    @inline(__always)
    fileprivate func changeValue<T: Equatable>(_ a: inout T, _ b: T) {
        if a != b {
            a = b
            _view?.markDirty()
        }
    }
    
    // MARK: -
    
    /// top margin
    @discardableResult
    open func top(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_top, .point, value)
    }

    /// top margin inside padding, [0, 1]
    @discardableResult
    open func top(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_top, .ratio, ratio)
    }
    
    /// bottom margin
    @discardableResult
    open func bottom(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_bottom, .point, value)
    }

    /// bottom margin inside padding, [0, 1]
    @discardableResult
    open func bottom(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_bottom, .ratio, ratio)
    }
    
    /// left margin
    @discardableResult
    open func left(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_left, .point, value)
    }

    /// left margin inside padding, [0, 1]
    @discardableResult
    open func left(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_left, .ratio, ratio)
    }
    
    /// right margin
    @discardableResult
    open func right(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_right, .point, value)
    }
    
    /// right margin inside padding, [0, 1]
    @discardableResult
    open func right(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_right, .ratio, ratio)
    }
    
    /// specifiy size, has hight priority
    @discardableResult
    open func size(_ width: CGFloat, _ height: CGFloat) -> PinStackItemInfo {
        return setSize(&_size, .point, width, height)
    }
    
    @discardableResult
    open func size(_ length: CGFloat) -> PinStackItemInfo {
        return setSize(&_size, .point, length, length)
    }

    @discardableResult
    open func size(_ size: CGSize) -> PinStackItemInfo {
        return setSize(&_size, .point, size.width, size.height)
    }
    
    /// when hratio as .nan，keep aspect ratio, otherwise using seperated ratio for width / height, [0, 1]
    @discardableResult
    open func size(ratio: CGFloat, _ hratio: CGFloat = .nan) -> PinStackItemInfo {
        return setSize(&_size, .ratio, ratio, hratio)
    }
    
    /// width
    @discardableResult
    open func width(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_width, .point, value)
    }
    
    /// width ratio after padding, [0, 1]
    @discardableResult
    open func width(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_width, .ratio, ratio)
    }
    
    /// height
    @discardableResult
    open func height(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_height, .point, value)
    }

    /// height ratio after padding, [0, 1]
    @discardableResult
    open func height(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_height, .ratio, ratio)
    }
    
    @discardableResult
    open func maxWidth(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_max_width, .point, value)
    }
    
    @discardableResult
    open func maxWidth(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_max_width, .ratio, ratio)
    }
    
    @discardableResult
    open func maxHeight(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_max_height, .point, value)
    }
    
    @discardableResult
    open func maxHeight(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_max_height, .ratio, ratio)
    }
    
    @discardableResult
    open func minWidth(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_min_width, .point, value)
    }
    
    @discardableResult
    open func minWidth(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_min_width, .ratio, ratio)
    }
    
    @discardableResult
    open func minHeight(_ value: CGFloat) -> PinStackItemInfo {
        return setProperty(&_min_height, .point, value)
    }
    
    @discardableResult
    open func minHeight(ratio: CGFloat) -> PinStackItemInfo {
        return setProperty(&_min_height, .ratio, ratio)
    }
    
    /// self cross aligment
    @discardableResult
    open func alignSelf(_ align: PinStackViewAlignment) -> PinStackItemInfo {
        if let alignSelf = _alignSelf, alignSelf == align {
            return self
        }
        _alignSelf = align
        _view?.markDirty()
        return self
    }
    
    /// grow ratio for axis directon (0, inf]
    @discardableResult
    open func grow(_ value: CGFloat) -> PinStackItemInfo {
        changeValue(&_grow, max(0, value))
        return self
    }
    
    /// shrink ratio for axis directon, (0, inf)
    @discardableResult
    open func shrink(_ value: CGFloat) -> PinStackItemInfo {
        changeValue(&_shrink, max(0, value))
        return self
    }

    // reset to default value
    open func reset() {
        _top = Value()
        _left = Value()
        _bottom = Value()
        _right = Value()
        _width = nil
        _height = nil
        _max_width = nil
        _max_height = nil
        _min_width = nil
        _min_height = nil
        _size = nil
        _grow = 0
        _shrink = 0
        _alignSelf = nil
    }
    
    // MARK: -
    
    @inline(__always)
    fileprivate func value(_ p: Value, _ outer: CGFloat) -> CGFloat {
        if p.unit == .point {
            return p.value
        }
        return p.value * outer
    }

    @inline(__always)
    fileprivate func value(_ p: Value?, _ outer: CGFloat) -> CGFloat? {
        guard let p = p else {
            return nil
        }
        if p.unit == .point {
            return p.value
        }
        return p.value * outer
    }

    @inline(__always)
    fileprivate func size(_ property: SizeValue?, _ width: CGFloat, _ height: CGFloat) -> CGSize? {
        guard let s = property else {
            return nil
        }
        let wr = s.value.width
        let hr = s.value.height
        if s.unit == .point {
            return s.value
        }
        if hr.isNaN {
            return CGSize(width: wr * width, height: wr * height)
        } else {
            return CGSize(width: wr * width, height: hr * height)
        }
    }
    
    @inline(__always)
    private func regularRatio(_ ratio: CGFloat) -> CGFloat {
        return min(1, max(0, ratio))
    }
}

// MARK: -

/// axis direction
public enum PinStackViewAxis {
    
    /// horizontal
    case horizontal
    
    /// vertical
    case vertical
}

/// axis distribution
public enum PinStackViewDistribution {
    
    /// from start
    case start
    
    /// from end
    case end

    /// same length along axis, seperated by spacing, ignore grow, append margin
    case equal
}

/// cross direction
public enum PinStackViewAlignment {

    /// default value
    case stretch

    /// from left to right, or from top to bottom
    case start
    
    /// center
    case center
    
    /// from right to left, or from bottom to top
    case end
}

/// axis length style, for fixed or dynamic by its subviews
public enum PinStackViewLayoutStyle {

    /// fixed in axis direction
    case fixed
    
    /// dynamic length in axis direction,
    case auto
}

/// for calculating dynamic length, with total grow & shrink value
fileprivate struct DynamicSizeInfo {
    
    /// total length
    let extra: CGFloat
    
    /// total grow
    let grow: CGFloat

    /// total shrink
    let shrink: CGFloat
}

// MARK: -

/** Frame base StackView relies on PinLayout
 */
open class PinStackView: UIView {

    /// store item layout info
    fileprivate var itemInfos = NSMapTable<UIView,PinStackItemInfo>.weakToStrongObjects()
    
    /// default fixed style, has highest priority
    open var style = PinStackViewLayoutStyle.fixed

    /// axis direciton, default horizontal
    open var axis = PinStackViewAxis.horizontal

    /// axis distribution, default from start, and auto style not support equal, will change to start
    open var distribution = PinStackViewDistribution.start

    /// cross direction style, default value
    open var alignment = PinStackViewAlignment.stretch
    
    /// axis direciton spacing between items, default 0
    open var spacing = CGFloat(0)
    
    /// padding before items caculation
    open var padding = UIEdgeInsets.zero

    /// callback after layout subviews for other normal subviews, true when size changed
    open var layoutCallback: ((PinStackView?, Bool) -> Void)?
    
    // MARK: -
    
    open func createItemInfo(_ view: PinStackView) -> PinStackItemInfo {
        let info = PinStackItemInfo()
        info._view = view
        return info
    }
    
    /// add views for calculation
    @discardableResult
    open func addItem(_ item: UIView) -> PinStackItemInfo {
        let info = itemInfos.object(forKey: item) ?? createItemInfo(self)
        addSubview(item)
        itemInfos.setObject(info, forKey: item)
        markDirty()
        KvoHelper.addObserver(view: item)
        return info
    }
    
    /// insert view for calculation
    @discardableResult
    open func insertItem(_ item: UIView, below: UIView) -> PinStackItemInfo {
        let info = itemInfos.object(forKey: item) ?? createItemInfo(self)
        insertSubview(item, belowSubview: below)
        itemInfos.setObject(info, forKey: item)
        markDirty()
        KvoHelper.addObserver(view: item)
        return info
    }

    /// remove view for calculation
    open func removeItem(_ item: UIView) {
        itemInfos.removeObject(forKey: item)
        item.removeFromSuperview()
        markDirty()
        KvoHelper.removeObserver(view: item)
    }

    /// 通过 view 获取描述的 item
    open func itemForView(_ view: UIView) -> PinStackItemInfo? {
        return itemInfos.object(forKey: view)
    }
    
    @discardableResult
    open func define(_ closure: (_ stackView: Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
    
    /// mark re-calcualtion then layout
    open func markDirty() {
        setNeedsLayout()
    }
    
    open override var intrinsicContentSize: CGSize {
        return bounds.size
    }
    
    open override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return sizeThatFits(targetSize)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.frame.size
        layout()
        weak var weakSelf = self
        layoutCallback?(weakSelf, self.frame.size != size)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return measure(outer_width: size.width, outer_height: size.height)
    }

    /// here layout, update bounds and change instrins content size
    private func layout() {
        let size = bounds.size
        let inner_width = bounds.width - padding.left - padding.right
        let inner_height = bounds.height - padding.top - padding.bottom
        if style == .fixed {
            layoutFixed(inner_width, inner_height)
        } else {
            layoutAuto(inner_width, inner_height, true)
        }
        if !size.equalTo(bounds.size) {
            invalidateIntrinsicContentSize()
        }
    }
    
    /// only measure, not apply layout
    private func measure(outer_width: CGFloat, outer_height: CGFloat) -> CGSize {
        if style == .auto {
            let inner_width = outer_width - padding.left - padding.right
            let inner_height = outer_height - padding.top - padding.bottom
            return layoutAuto(inner_width, inner_height, false)
        }
        return CGSize(width: outer_width, height: outer_height)
    }
    
    // MARK: - Fixed
    
    /// using fixed style, stack view will not change its bounds
    private func layoutFixed(_ inner_width: CGFloat, _ inner_height: CGFloat) {
        if distribution == .equal {
            fixedEqual(inner_width, inner_height)
        } else {
            fixedStartEnd(inner_width, inner_height)
        }
    }

    /// fixed stack view, and distribution equal
    private func fixedEqual(_ inner_width: CGFloat, _ inner_height: CGFloat) {
        let views = subviews.filter { !$0.isHidden }
        let count = CGFloat( views.compactMap { self.itemInfos.object(forKey: $0) }.count )
        
        let unit_width = (inner_width - max(0, count - 1) * spacing) / max(1, count)
        let unit_height = (inner_height - max(0, count - 1) * spacing) / max(1, count)
        
        var in_startx = CGFloat(0)
        var in_starty = CGFloat(0)
        
        for view in views {
            guard let info = itemInfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.value(info._top, inner_height)
            let margin_bottom = info.value(info._bottom, inner_height)
            let margin_left = info.value(info._left, inner_width)
            let margin_right = info.value(info._right, inner_width)

            let cross_width = inner_width - margin_left - margin_right
            let cross_height = inner_height - margin_top - margin_bottom
            
            let size: CGSize
            if axis == .horizontal {
                size = calcViewSize(view, info, unit_width, cross_height, inner_width, inner_height)
            } else {
                size = calcViewSize(view, info, cross_width, unit_height, inner_width, inner_height)
            }
            
            let ox = in_startx + (unit_width - size.width) / 2 + margin_left - margin_right + padding.left
            let oy = in_starty + (unit_height - size.height) / 2 + margin_top - margin_bottom + padding.top
            
            if axis == .horizontal {
                switch info._alignSelf ?? alignment {
                case .start: view.pin.left(ox).top(margin_top + padding.top).size(size)
                case .center: view.pin.left(ox).vCenter().marginTop(margin_top).size(size)
                case .end: view.pin.left(ox).bottom(margin_bottom + padding.bottom).size(size)
                case .stretch: view.pin.left(ox).top(margin_top + padding.top).bottom(margin_bottom + padding.bottom).width(size.width)
                }
                in_startx += unit_width + spacing
            } else {
                switch info._alignSelf ?? alignment {
                case .start: view.pin.top(oy).left(margin_left + padding.left).size(size)
                case .center: view.pin.top(oy).hCenter().marginLeft(margin_left).size(size)
                case .end: view.pin.top(oy).right(margin_right + padding.right).size(size)
                case .stretch: view.pin.top(oy).left(margin_left + padding.left).right(margin_right + padding.right).height(size.height)
                }
                in_starty += unit_height + spacing
            }
        }
    }
    
    /// fixed stack view, distributed as start, end, apply grow ratio
    private func fixedStartEnd(_ inner_width: CGFloat, _ inner_height: CGFloat) {
        let tot_info = fixedSEApply(inner_width, inner_height, false, DynamicSizeInfo(extra: 0, grow: 0, shrink: 0))
        let dynamic_length: CGFloat
        if axis == .horizontal {
            dynamic_length = inner_width - tot_info.extra
        } else {
            dynamic_length = inner_height - tot_info.extra
        }
        let dynamic_info = DynamicSizeInfo(extra: dynamic_length, grow: tot_info.grow, shrink: tot_info.shrink)
        fixedSEApply(inner_width, inner_height, true, dynamic_info)
    }
    
    /// for measure and apply, collect fixed content length, total grow when apply false, then apply those dynamic length
    @discardableResult
    private func fixedSEApply(_ inner_width: CGFloat,
                              _ inner_height: CGFloat,
                              _ apply: Bool,
                              _ dn_info: DynamicSizeInfo) -> DynamicSizeInfo {
        var in_startx: CGFloat
        var in_starty: CGFloat
        let views: [UIView]
        
        if distribution == .start {
            in_startx = 0
            in_starty = 0
            views = subviews.filter { !$0.isHidden }
        } else {
            in_startx = inner_width
            in_starty = inner_height
            views = subviews.filter { !$0.isHidden }.reversed()
        }

        var tot_length = CGFloat(0)
        var grow = CGFloat(0)
        var shrink = CGFloat(0)
        var begin = CGFloat(0)

        for view in views {
            guard let info = itemInfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.value(info._top, inner_height)
            let margin_bottom = info.value(info._bottom, inner_height)
            let margin_left = info.value(info._left, inner_width)
            let margin_right = info.value(info._right, inner_width)

            let cross_width = inner_width - margin_left - margin_right
            let cross_height = inner_height - margin_top - margin_bottom
            
//            let limit_width: CGFloat
//            let limit_height: CGFloat
            
//            if distribution == .start {
//                limit_width = inner_width - (in_startx + begin * spacing + margin_left + margin_right)
//                limit_height = inner_height - (in_starty + begin * spacing + margin_top + margin_bottom)
//            } else {
//                limit_width = in_startx - begin * spacing - margin_right - margin_left
//                limit_height = in_starty - begin * spacing - margin_bottom - margin_top
//            }
            
            let size: CGSize
            if axis == .horizontal {
                let s = calcViewSize(view, info, .greatestFiniteMagnitude, cross_height, inner_width, inner_height)
                if apply {
                    size = calcFixedSEDynamicSize(axis: axis, size: s, info: info, dn_info: dn_info)
                } else {
                    size = s
                }
            } else {
                let s = calcViewSize(view, info, cross_width, .greatestFiniteMagnitude, inner_width, inner_height)
                if apply {
                    size = calcFixedSEDynamicSize(axis: axis, size: s, info: info, dn_info: dn_info)
                } else {
                    size = s
                }
            }
            grow += info._grow
            shrink += info._shrink

            let ox: CGFloat
            let oy: CGFloat
            
            if distribution == .start {
                ox = in_startx + begin * spacing + margin_left + padding.left
                oy = in_starty + begin * spacing + margin_top + padding.top
            } else {
                ox = in_startx - begin * spacing - margin_right - size.width + padding.left
                oy = in_starty - begin * spacing - margin_bottom - size.height + padding.top
            }

            if axis == .horizontal {
                if apply {
                    switch info._alignSelf ?? alignment {
                    case .start: view.pin.left(ox).top(margin_top + padding.top).size(size)
                    case .center: view.pin.left(ox).vCenter().marginTop(margin_top).size(size)
                    case .end: view.pin.left(ox).bottom(margin_bottom + padding.bottom).size(size)
                    case .stretch: view.pin.left(ox).top(margin_top + padding.top).bottom(margin_bottom + padding.bottom).width(size.width)
                    }
                }
                let item_width = begin * spacing + margin_left + size.width + margin_right
                if distribution == .start {
                    in_startx += item_width
                } else {
                    in_startx -= item_width
                }
                tot_length += margin_left + margin_right + begin * spacing + size.width
            } else {
                if apply {
                    switch info._alignSelf ?? alignment {
                    case .start: view.pin.top(oy).left(margin_left + padding.left).size(size)
                    case .center: view.pin.top(oy).hCenter().marginLeft(margin_left).size(size)
                    case .end: view.pin.top(oy).right(margin_right + padding.right).size(size)
                    case .stretch: view.pin.top(oy).left(margin_left + padding.left).right(margin_right + padding.right).height(size.height)
                    }
                }
                let item_height = begin * spacing + margin_top + size.height + margin_bottom
                if distribution == .start {
                    in_starty += item_height
                } else {
                    in_starty -= item_height
                }
                tot_length += margin_top + margin_bottom + begin * spacing + size.height
            }
            begin = 1
        }
        // return total length, total grow
        return DynamicSizeInfo(extra: tot_length, grow: grow, shrink: shrink)
    }
    
    // MARK: - Auto
    
    /// auto style, when distribution always .start, return outer size
    @discardableResult
    private func layoutAuto(_ inner_width: CGFloat, _ inner_height: CGFloat, _ apply: Bool) -> CGSize {
        if distribution != .start {
            distribution = .start
            debugLog("auto style distribution only support .start !!!")
        }
        let inner_length = autoStartEnd(inner_width, inner_height, apply)
        if axis == .horizontal {
            let outer_length = inner_length + padding.left + padding.right
            if apply && frame.width != outer_length {
                pin.width(outer_length)
            }
            return CGSize(width: outer_length, height: inner_height + padding.top + padding.bottom)
        } else {
            let outer_length = inner_length + padding.top + padding.bottom
            if apply && frame.height != outer_length {
                pin.height(outer_length)
            }
            return CGSize(width: inner_width + padding.left + padding.right, height: outer_length)
        }
    }

    /// only support start/end, ignore item's grow
    private func autoStartEnd(_ inner_width: CGFloat, _ inner_height: CGFloat, _ apply: Bool) -> CGFloat {
        var in_startx = CGFloat(0)
        var in_starty = CGFloat(0)
        let views = subviews.filter { !$0.isHidden }
        
        var begin = CGFloat(0)
        var content_length = CGFloat(0)
        
        for view in views {
            guard let info = itemInfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.value(info._top, inner_height)
            let margin_bottom = info.value(info._bottom, inner_height)
            let margin_left = info.value(info._left, inner_width)
            let margin_right = info.value(info._right, inner_width)

            let cross_width = inner_width - margin_left - margin_right
            let cross_height = inner_height - margin_top - margin_bottom
            
            let size: CGSize
            if axis == .horizontal {
                size = calcViewSize(view, info, .greatestFiniteMagnitude, cross_height, inner_width, inner_height)
            } else {
                size = calcViewSize(view, info, cross_width, .greatestFiniteMagnitude, inner_width, inner_height)
            }
            
            let ox = in_startx + begin * spacing + margin_left + padding.left
            let oy = in_starty + begin * spacing + margin_top + padding.top
            
            if axis == .horizontal {
                if apply {
                    switch info._alignSelf ?? alignment {
                    case .start: view.pin.left(ox).top(margin_top + padding.top).size(size)
                    case .center: view.pin.left(ox).vCenter().marginTop(margin_top).size(size)
                    case .end: view.pin.left(ox).bottom(margin_bottom + padding.bottom).size(size)
                    case .stretch: view.pin.left(ox).top(margin_top + padding.top).bottom(margin_bottom + padding.bottom).width(size.width)
                    }
                }
                let item_width = begin * spacing + margin_left + size.width + margin_right
                in_startx += item_width
                content_length += item_width
            } else {
                if apply {
                    switch info._alignSelf ?? alignment {
                    case .start: view.pin.top(oy).left(margin_left + padding.left).size(size)
                    case .center: view.pin.top(oy).hCenter().marginLeft(margin_left).size(size)
                    case .end: view.pin.top(oy).right(margin_right + padding.right).size(size)
                    case .stretch: view.pin.top(oy).left(margin_left + padding.left).right(margin_right + padding.right).height(size.height)
                    }
                }
                let item_height = begin * spacing + margin_top + size.height + margin_bottom
                in_starty += item_height
                content_length += item_height
            }
            begin = 1.0
        }
        return content_length
    }
    
    // MARK: - Helper
    
    /// calculate view size
    /// - size has highest priority, calc by outer width / height after padding
    /// - if no size，call view's sizeThatFits()
    /// - if item info has width / height, overrite sizeThatFits result
    /// - restrict fixed style views' width or height
    private func calcViewSize(_ view: UIView,
                              _ info: PinStackItemInfo,
                              _ uwidth: CGFloat,
                              _ uheight: CGFloat,
                              _ owidth: CGFloat,
                              _ oheight:CGFloat) -> CGSize {
        if let s = info.size(info._size, owidth, oheight) {
            return s
        }
        let w = info.value(info._width, owidth)
        let h = info.value(info._height, oheight)
        let unit_size = CGSize(width: w ?? uwidth, height: h ?? uheight)
        let s = view.sizeThatFits(unit_size)
        if s.equalTo(.zero) {
            return unit_size
        }
        var ow = s.width
        if let ww = w, ww != ow {
            ow = ww
        }
        var oh = s.height
        if let hh = h, hh != oh {
            oh = hh
        }
        // check max/min width & height
        if let max_width = info.value(info._max_width, owidth), ow > max_width {
            ow = max_width
        } else if let min_width = info.value(info._min_width, owidth), ow < min_width {
            ow = min_width
        }
        if let max_height = info.value(info._max_height, oheight), oh > max_height {
            oh = max_height
        } else if let min_height = info.value(info._min_width, oheight), oh > min_height {
            oh = min_height
        }
        // .isInfinite and .greatestFiniteMagnitude meanings '0'
        // otherwise it will take all space, but space was finite
        if ow.isInfinite || ow == .greatestFiniteMagnitude {
            ow = 0
        } else if ow > uwidth {
            ow = uwidth
        }
        if oh.isInfinite || oh == .greatestFiniteMagnitude {
            oh = 0
        } else if oh > uheight {
            oh = uheight
        }
        return CGSize(width: ow, height: oh)
    }
    
    /// calculate dynamic size on total grow, extra length
    private func calcFixedSEDynamicSize(axis: PinStackViewAxis,
                                        size: CGSize,
                                        info: PinStackItemInfo,
                                        dn_info: DynamicSizeInfo) -> CGSize {
        if dn_info.extra > 0 && dn_info.grow > 0 && info._grow > 0 {
            let length = dn_info.extra * (info._grow / dn_info.grow)
            if axis == .horizontal {
                return CGSize(width: size.width + length, height: size.height)
            } else {
                return CGSize(width: size.width, height: size.height + length)
            }
        }
        if dn_info.extra < 0 && dn_info.shrink > 0 && info._shrink > 0 {
            let length = dn_info.extra * (info._shrink / dn_info.shrink)
            if axis == .horizontal {
                return CGSize(width: size.width + length, height: size.height)
            } else {
                return CGSize(width: size.width, height: size.height + length)
            }
        }
        return size
    }

}

/// item view KVO helper
fileprivate class KvoHelper: NSObject {
    
    fileprivate let kvoHidden: NSKeyValueObservation
    fileprivate let kvoSize: NSKeyValueObservation
    
    deinit {
        kvoHidden.invalidate()
        kvoSize.invalidate()
    }
    
    init(kvoHidden: NSKeyValueObservation, kvoSize: NSKeyValueObservation) {
        self.kvoHidden = kvoHidden
        self.kvoSize = kvoSize
    }
    
    // MARK: - static
    
    static func addObserver(view: UIView) {
        if nil == view.pinstack_kvohelper {
            let refHidden = view.observe(\UIView.isHidden, options: [.new], changeHandler: Self.hiddenChangeHandler)
            let refSize = view.observe(\UIView.bounds, options: [.new], changeHandler: Self.sizeChangeHandler)
            view.pinstack_kvohelper = KvoHelper(kvoHidden: refHidden, kvoSize: refSize)
        }
    }
    
    static func removeObserver(view: UIView) {
        if let _ = view.pinstack_kvohelper {
            view.pinstack_kvohelper = nil
        }
    }

    private static func hiddenChangeHandler(_ view: UIView, _ value: NSKeyValueObservedChange<Bool>) {
        guard let _ = view.pinstack_kvohelper else {
            return
        }
        if let sview = view.superview as? PinStackView,
           let _ = sview.itemForView(view)
        {
            sview.markDirty()
        }
    }
    
    /// only observ style .auto
    private static func sizeChangeHandler(_ view: UIView, _ value: NSKeyValueObservedChange<CGRect>) {
        guard let _ = view.pinstack_kvohelper else {
            return
        }
        guard let sview = view.superview as? PinStackView,
              sview.style == .auto,
              let _ = sview.itemForView(view),
              let oldValue = value.oldValue,
              let newValue = value.newValue else
        {
            return
        }
        if (sview.axis == .horizontal && oldValue.size.width != newValue.size.width) ||
            (sview.axis == .vertical && oldValue.size.height != newValue.size.height)
        {
            sview.markDirty()
        }
    }
}

/// KVO key
fileprivate var pinstackview_kvohelper_observation_key = "pinstackview_kvohelper_observation_key"

extension UIView {

    fileprivate var pinstack_kvohelper: KvoHelper? {
        get {
            return objc_getAssociatedObject(self, &pinstackview_kvohelper_observation_key) as? KvoHelper
        }
        set {
            objc_setAssociatedObject(self, &pinstackview_kvohelper_observation_key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
