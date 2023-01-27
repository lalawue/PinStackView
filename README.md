

# Introduction

PinStackView was a Frame base StackView relies on [PinLayout](https://github.com/layoutBox/PinLayout.git).

## Features

- can be used with manual layout, Autolayout
- is a real view and only layout specified sub-views
- has inner padding
- has equal distribution like UIStackView
- has auto style with dynamic length in axis direction
- has grow/shrink
- observ item layout properties
- KVO item views 'isHidden'

## Install

To integrate `PinStackView` into your Xcode project using CocoaPods, specify it in your Podfile:

```
    pod 'PinLayout'
```

Then, run `pod install`.

## Usage

examples listed in project 'Views/' group

```bash
$ cd Example
$ pod install
$ open Example.xcworkspace
```

## PinStackView

### Interface

- addItems(): add managed sub-views, return PinStackItemInfo for chained setting, you can addSubviews() and layout view by yourself
- insertItem(): like addItems(), can defined sequence
- removeItem(): remove managed sub-views, also removed from subviews
- remakeItem(): replace with new item but did not change subview's sequence
- itemForView(): get PinStackItemInfo from PinStackView after addItem() or insertItem()
- define(): a sugar to chain items info definition
- markDirty(): like setNeesLayout(), force layout in next view update
- triggerNeedsLayout(): trigger subview's setNeedsLayout when PinStackView setNeedsLayout.

### Properties

- style: default .fixed, the axis length will not change after layout; .auto style means its axis length will change by items
- axis: .horizontal or .vertical direction, dynamic length direction
- distribution: axis direction layout style, .equal only support .fixed style; .auto style always .start
- alignment: cross axis direction, you can specify view's alignment by alignSelf()
- spacing: spacing between items in axis direction
- padding: items will layout after padding
- layoutCallback: call back after every layout, will pass in true when size changed

### PinStackItemInfo

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


## Coding Example

using [Then](https://github.com/devxoul/Then/) from Suyeol Jeon

```swift
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
```

## Demo GIF

![image](https://github.com/lalawue/PinStackView/blob/master/Images/demo.gif)
