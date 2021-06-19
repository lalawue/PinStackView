//
//  PinStackView.swift
//
//  Created by lalawue on 2021/5/14.
//

import UIKit
import PinLayout

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
public class PinStackItemInfo {
    
    /// margins
    fileprivate var _top = Value()
    fileprivate var _bottom = Value()
    fileprivate var _left = Value()
    fileprivate var _right = Value()

    /// size has prior than width、height
    fileprivate var _size: SizeValue?
    
    fileprivate var _width: Value?
    fileprivate var _height: Value?

    /// aligment in corss direction
    fileprivate var _alignSelf: PinStackViewAlignment?
    
    /// dynamic  value / total value, greater than 0
    fileprivate var _grow = CGFloat(0)
    
    // MARK: -
    
    fileprivate init() {        
    }

    /// top margin
    @discardableResult
    public func top(_ value: CGFloat) -> PinStackItemInfo {
        _top.value = value
        _top.unit = .point
        return self
    }

    /// top margin inside padding
    @discardableResult
    public func top(ratio: CGFloat) -> PinStackItemInfo {
        _top.value = regularRatio(ratio)
        _top.unit = .ratio
        return self
    }
    
    /// bottom margin
    @discardableResult
    public func bottom(_ value: CGFloat) -> PinStackItemInfo {
        _bottom.value = value
        _bottom.unit = .point
        return self
    }

    /// bottom margin inside padding
    @discardableResult
    public func bottom(ratio: CGFloat) -> PinStackItemInfo {
        _bottom.value = regularRatio(ratio)
        _bottom.unit = .ratio
        return self
    }
    
    /// left margin
    @discardableResult
    public func left(_ value: CGFloat) -> PinStackItemInfo {
        _left.value = value
        _left.unit = .point
        return self
    }

    /// left margin inside padding
    @discardableResult
    public func left(ratio: CGFloat) -> PinStackItemInfo {
        _left.value = regularRatio(ratio)
        _left.unit = .ratio
        return self
    }
    
    /// right margin
    @discardableResult
    public func right(_ value: CGFloat) -> PinStackItemInfo {
        _right.value = value
        _right.unit = .point
        return self
    }
    
    /// right margin inside padding
    @discardableResult
    public func right(ratio: CGFloat) -> PinStackItemInfo {
        _right.value = regularRatio(ratio)
        _right.unit = .ratio
        return self
    }
    
    /// specifiy size, has hight priority
    @discardableResult
    public func size(_ width: CGFloat, _ height: CGFloat) -> PinStackItemInfo {
        let s = _size ?? SizeValue()
        s.value = CGSize(width: width, height: height)
        s.unit = .point
        _size = s
        return self
    }
    
    @discardableResult
    public func size(_ length: CGFloat) -> PinStackItemInfo {
        let s = _size ?? SizeValue()
        s.value = CGSize(width: length, height: length)
        s.unit = .point
        _size = s
        return self
    }

    @discardableResult
    public func size(_ size: CGSize) -> PinStackItemInfo {
        let s = _size ?? SizeValue()
        s.value = size
        s.unit = .point
        _size = s
        return self
    }
    
    /// when hratio as .nan，keep aspect ratio, otherwise using seperated ratio for width / height
    @discardableResult
    public func size(ratio: CGFloat, _ hratio: CGFloat = .nan ) -> PinStackItemInfo {
        let s = _size ?? SizeValue()
        if hratio.isNaN {
            s.value = CGSize(width: regularRatio(ratio), height: .nan)
        } else {
            s.value = CGSize(width: regularRatio(ratio), height: regularRatio(hratio))
        }
        s.unit = .ratio
        _size = s
        return self
    }
    
    /// width
    @discardableResult
    public func width(_ width: CGFloat) -> PinStackItemInfo {
        let w = _width ?? Value()
        w.value = width
        w.unit = .point
        _width = w
        return self
    }
    
    /// width ratio after padding
    @discardableResult
    public func width(ratio: CGFloat) -> PinStackItemInfo {
        let w = _width ?? Value()
        w.value = regularRatio(ratio)
        w.unit = .ratio
        _width = w
        return self
    }
    
    /// height
    @discardableResult
    public func height(_ height: CGFloat) -> PinStackItemInfo {
        let h = _height ?? Value()
        h.value = height
        h.unit = .point
        _height = h
        return self
    }

    /// height ratio after padding
    @discardableResult
    public func height(ratio: CGFloat) -> PinStackItemInfo {
        let h = _height ?? Value()
        h.value = regularRatio(ratio)
        h.unit = .ratio
        _height = h
        return self
    }
    
    /// self cross aligment
    @discardableResult
    public func alignSelf(_ align: PinStackViewAlignment) -> PinStackItemInfo {
        _alignSelf = align
        return self
    }
    
    /// grow ratio for axis directon
    @discardableResult
    public func grow(_ value: CGFloat) -> PinStackItemInfo {
        _grow = max(0, value)
        return self
    }
    
    // MARK: -
    
    fileprivate func topValue(_ outer: CGFloat) -> CGFloat {
        if _top.unit == .point {
            return _top.value
        }
        return _top.value * outer
    }

    fileprivate func bottomValue(_ outer: CGFloat) -> CGFloat {
        if _bottom.unit == .point {
            return _bottom.value
        }
        return _bottom.value * outer
    }
    
    fileprivate func leftValue(_ outer: CGFloat) -> CGFloat {
        if _left.unit == .point {
            return _left.value
        }
        return _left.value * outer
    }

    fileprivate func rightValue(_ outer: CGFloat) -> CGFloat {
        if _right.unit == .point {
            return _right.value
        }
        return _right.value * outer
    }
    
    fileprivate func widthValue(_ outer: CGFloat) -> CGFloat? {
        guard let w = _width else {
            return nil
        }
        if w.unit == .point {
            return w.value
        }
        return w.value * outer
    }
    
    fileprivate func heightValue(_ outer: CGFloat) -> CGFloat? {
        guard let h = _height else {
            return nil
        }
        if h.unit == .point {
            return h.value
        }
        return h.value * outer
    }
    
    fileprivate func sizeValue(_ width: CGFloat, _ height: CGFloat) -> CGSize? {
        guard let s = _size else {
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
    
    private func regularRatio(_ ratio: CGFloat) -> CGFloat {
        return min(1.0, max(0.0, ratio))
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

/// for calculating dynamic length, with total grow value
fileprivate struct ExtraDynamic {
    
    /// dynamic length
    let extra: CGFloat
    
    /// total grow
    let grow: CGFloat
}

// MARK: -

/** Frame base StackView relies on PinLayout
 */
open class PinStackView: UIView {

    /// store item layout info
    fileprivate var iteminfos = NSMapTable<UIView,PinStackItemInfo>.weakToStrongObjects()

    /// default fixed style, has highest priority
    public var style = PinStackViewLayoutStyle.fixed

    /// axis direciton, default horizontal
    public var axis = PinStackViewAxis.horizontal

    /// axis distribution, default from start, and auto style not support equal, will change to start
    public var distribution = PinStackViewDistribution.start

    /// cross direction style, default value
    public var alignment = PinStackViewAlignment.stretch
    
    /// axis direciton spacing between items, default 0
    public var spacing = CGFloat(0)
    
    /// padding before items caculation
    public var padding = UIEdgeInsets.zero

    /// if bounds changed in auto style, invoke callback
    public var autoSizeChangedCallback: ((PinStackView) -> Void)?
    
    // MARK: -
    
    /// add views for calculation
    @discardableResult
    public func addItem(_ item: UIView) -> PinStackItemInfo {
        let info = iteminfos.object(forKey: item) ?? PinStackItemInfo()
        addSubview(item)
        iteminfos.setObject(info, forKey: item)
        markDirty()
        return info
    }
    
    /// insert view for calculation
    @discardableResult
    public func insertItem(_ item: UIView, below: UIView) -> PinStackItemInfo {
        let info = iteminfos.object(forKey: item) ?? PinStackItemInfo()
        insertSubview(item, belowSubview: below)
        iteminfos.setObject(info, forKey: item)
        markDirty()
        return info
    }

    /// remove view for calculation
    public func removeItem(_ item: UIView) {
        iteminfos.removeObject(forKey: item)
        item.removeFromSuperview()
        markDirty()
    }

    /// 通过 view 获取描述的 item
    public func itemForView(_ view: UIView) -> PinStackItemInfo? {
        return iteminfos.object(forKey: view)
    }
    
    @discardableResult
    public func define(_ closure: (_ stackView: Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
    
    /// mark re-calcualtion then layout
    public func markDirty() {
        setNeedsLayout()
    }
    
    open override var intrinsicContentSize: CGSize {
        return bounds.size
    }
    
    public override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return sizeThatFits(targetSize)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layout()
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
        let count = CGFloat( views.compactMap { self.iteminfos.object(forKey: $0) }.count )
        
        let unit_width = (inner_width - max(0, count - 1) * spacing) / max(1, count)
        let unit_height = (inner_height - max(0, count - 1) * spacing) / max(1, count)
        
        var in_startx = CGFloat(0)
        var in_starty = CGFloat(0)
        
        for view in views {
            guard let info = iteminfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.topValue(inner_height)
            let margin_bottom = info.bottomValue(inner_height)
            let margin_left = info.leftValue(inner_width)
            let margin_right = info.rightValue(inner_width)

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
        let extra = fixedSEApply(inner_width, inner_height, false, ExtraDynamic(extra: 0, grow: 0))
        let dynamic_length: CGFloat
        if axis == .horizontal {
            dynamic_length = inner_width - extra.extra
        } else {
            dynamic_length = inner_height - extra.extra
        }
        let input_extra = ExtraDynamic(extra: dynamic_length, grow: extra.grow)
        fixedSEApply(inner_width, inner_height, true, input_extra)
    }
    
    /// for measure and apply, collect fixed content length, total grow when apply false, then apply those dynamic length
    @discardableResult
    private func fixedSEApply(_ inner_width: CGFloat,
                              _ inner_height: CGFloat,
                              _ apply: Bool,
                              _ extra: ExtraDynamic) -> ExtraDynamic {
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

        var fixed_length = CGFloat(0)
        var grow = CGFloat(0)
        var begin = CGFloat(0)

        for view in views {
            guard let info = iteminfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.topValue(inner_height)
            let margin_bottom = info.bottomValue(inner_height)
            let margin_left = info.leftValue(inner_width)
            let margin_right = info.rightValue(inner_width)

            let cross_width = inner_width - margin_left - margin_right
            let cross_height = inner_height - margin_top - margin_bottom
            
            let limit_width: CGFloat
            let limit_height: CGFloat
            
            if distribution == .start {
                limit_width = inner_width - (in_startx + begin * spacing + margin_left + margin_right)
                limit_height = inner_height - (in_starty + begin * spacing + margin_top + margin_bottom)
            } else {
                limit_width = in_startx - begin * spacing - margin_right - margin_left
                limit_height = in_starty - begin * spacing - margin_bottom - margin_top
            }
            
            let size: CGSize
            if axis == .horizontal {
                let width = info._grow > 0 ? 0 : limit_width
                let s = calcViewSize(view, info, width, cross_height, inner_width, inner_height)
                if apply {
                    size = calcFixedSEDynamicSize(axis: axis, size: s, info: info, extra: extra)
                } else {
                    size = info._grow > 0 ? CGSize(width:0, height: s.height) : s
                }
            } else {
                let height = info._grow > 0 ? 0 : limit_height
                let s = calcViewSize(view, info, cross_width, height, inner_width, inner_height)
                if apply {
                    size = calcFixedSEDynamicSize(axis: axis, size: s, info: info, extra: extra)
                } else {
                    size = info._grow > 0 ? CGSize(width: s.width, height: 0) : s
                }
            }
            grow += info._grow

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
                fixed_length += margin_left + margin_right + begin * spacing
                if info._grow <= 0 {
                    fixed_length += size.width
                }
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
                fixed_length += margin_top + margin_bottom + begin * spacing
                if info._grow <= 0 {
                    fixed_length += size.height
                }
            }
            begin = 1
        }
        // return total length, total grow
        return ExtraDynamic(extra: fixed_length, grow: grow)
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
                autoSizeChangedCallback?(self)
            }
            return CGSize(width: outer_length, height: inner_height + padding.top + padding.bottom)
        } else {
            let outer_length = inner_length + padding.top + padding.bottom
            if apply && frame.height != outer_length {
                pin.height(outer_length)
                autoSizeChangedCallback?(self)
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
            guard let info = iteminfos.object(forKey: view) else {
                continue
            }
            let margin_top = info.topValue(inner_height)
            let margin_bottom = info.bottomValue(inner_height)
            let margin_left = info.leftValue(inner_width)
            let margin_right = info.rightValue(inner_width)

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
    
    /** calculate view size
     *  - size has highest priority, calc by outer width / height after padding
     *  - if no size，call view's sizeThatFits()
     *  - if item info has width / height, overrite sizeThatFits result
     *  - restrict fixed style views' width or height
     */
    private func calcViewSize(_ view: UIView,
                              _ info: PinStackItemInfo,
                              _ uwidth: CGFloat,
                              _ uheight: CGFloat,
                              _ owidth: CGFloat,
                              _ oheight:CGFloat) -> CGSize {
        if let s = info.sizeValue(owidth, oheight) {
            return s
        }
        let w = info.widthValue(owidth)
        let h = info.heightValue(oheight)
        let unit_size = CGSize(width: w ?? uwidth, height: h ?? uheight)
        let s = view.sizeThatFits(unit_size)
        if s.equalTo(.zero) {
            return unit_size
        }
        var ow = s.width
        if let ww = w, s.width != ww {
            ow = ww
        }
        var oh = s.height
        if let hh = h, s.height != hh {
            oh = hh
        }
        if ow > uwidth {
            ow = uwidth
        }
        if oh > uheight {
            oh = uheight
        }
        return CGSize(width: ow, height: oh)
    }
    
    /// calculate dynamic size on total grow, extra length
    private func calcFixedSEDynamicSize(axis: PinStackViewAxis,
                                        size: CGSize,
                                        info: PinStackItemInfo,
                                        extra: ExtraDynamic) -> CGSize {
        guard extra.extra > 0 && extra.grow > 0 && info._grow > 0 else {
            return size
        }
        let length = extra.extra * (info._grow / extra.grow)
        if axis == .horizontal {
            return CGSize(width: max(0, length), height: size.height)
        } else {
            return CGSize(width: size.width, height: max(0, length))
        }
    }
    
    /// debug output
    private func debugLog(_ msg: String) {
        #if DEBUG
        print("[PinStackView] \(msg)")
        #endif
    }
}
