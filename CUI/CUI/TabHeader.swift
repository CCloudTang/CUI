//
//  TabHeader.swift
//  CUI
//
//  Created by CC on 2020/4/28.
//  Copyright © 2020 cc. All rights reserved.
//

import UIKit
public class TabHeader: UIView {
    var titles: [String]
    var style: TabHeaderStyle
    let scrollView: UIScrollView = UIScrollView()
    let container = UIStackView()
    let indicatorLine = UIView()
    let indicatorBG = UIView()
    let bottomSeparatorLine = UIView()
    var indicatorLeading = NSLayoutConstraint()
    var indicatorTrailing = NSLayoutConstraint()
    var indicatorWidthAnchor = NSLayoutConstraint()

    var previousBtn = UIButton()
    var titleButtons: [UIButton] = []
    var selectHandle: ((Int) -> Void)?
    public weak var delegate: TabHeaderDelegate?
    
    init(with titles: [String], style: TabHeaderStyle = TabHeaderStyle()) {
        self.titles = titles
        self.style = style
        super.init(frame: .zero)
        setupSubviews()
    }
    
    private func setupSubviews() {
        backgroundColor = style.backgroundColor
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)

        scrollView.addSubview(indicatorBG)
        indicatorBG.backgroundColor = style.indicatorColor
        indicatorBG.translatesAutoresizingMaskIntoConstraints = false
        
        container.axis = .horizontal
        container.alignment = .center
        container.spacing = style.margin
        container.translatesAutoresizingMaskIntoConstraints = false
        switch style.type {
        case .fixed(let equal):
            if equal {
                container.distribution = .fillEqually
            } else {
                container.distribution = .fillProportionally
            }
        case .scrollable:
            container.distribution = .equalSpacing
        }
        scrollView.addSubview(container)
        
        bottomSeparatorLine.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparatorLine.backgroundColor = style.separatorColor
        addSubview(bottomSeparatorLine)
        
        indicatorLine.translatesAutoresizingMaskIntoConstraints = false
        indicatorLine.backgroundColor = style.indicatorColor
        indicatorLine.layer.cornerRadius = style.indicatorLineHeight * 0.5
        addSubview(indicatorLine)
        
        updateTitles(titles)

        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            container.topAnchor.constraint(equalTo: scrollView.topAnchor),
            container.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            container.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: style.leftPadding),
            container.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -style.rightPadding),
            container.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            bottomSeparatorLine.leftAnchor.constraint(equalTo: self.leftAnchor),
            bottomSeparatorLine.rightAnchor.constraint(equalTo: self.rightAnchor),
            bottomSeparatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomSeparatorLine.heightAnchor.constraint(equalToConstant: style.separatorHeight),
            
            indicatorLine.heightAnchor.constraint(equalToConstant: style.indicatorLineHeight),
            indicatorLine.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        var indicatorBgHeight = style.titleSelectedFont.lineHeight + style.indicatorBGInsetTop * 2
        if style.indicatorBGHeight > 0 {
            indicatorBgHeight = style.indicatorBGHeight
        }
        indicatorBG.layer.cornerRadius = indicatorBgHeight * 0.5
        indicatorBG.heightAnchor.constraint(equalToConstant: indicatorBgHeight).isActive = true
        indicatorBG.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        
        switch style.type {
        case .fixed:
            NSLayoutConstraint.activate([
                container.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -style.margin * 2)
            ])
        case .scrollable:
            moveTitleToCenter(previousBtn)
        }
        
    }
    
    func updateTitles(_ titles: [String]) {
        if titles.isEmpty {
            return
        }
        for btn in titleButtons {
            container.removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        titleButtons.removeAll()
        NSLayoutConstraint.deactivate([self.indicatorLeading,self.indicatorTrailing])

        for title in titles {
            let btn = UIButton(type: .custom)
            btn.setTitle(title, for: .normal)
            btn.addTarget(self, action: #selector(titleButtonAction(_:)), for: .touchUpInside)
            btn.setTitleColor(style.titleNormalColor, for: .normal)
            btn.setTitleColor(style.titleSelectedColor, for: .selected)
            btn.titleLabel?.font = style.titleNormalFont
            btn.titleLabel?.adjustsFontForContentSizeCategory = true
            switch style.type {
            case .fixed:
                btn.titleLabel?.numberOfLines = 0
            case .scrollable:
                btn.titleLabel?.numberOfLines = 1
            }
            titleButtons.append(btn)
            container.addArrangedSubview(btn)
        }
        var index = 0
        if style.defaultSelectIndex < titles.count {
            index = style.defaultSelectIndex
        }
        let defaultBtn = titleButtons[index]
        previousBtn = defaultBtn
        defaultBtn.titleLabel?.font = style.titleSelectedFont
        defaultBtn.isSelected = true
        updateIndicator(animate: false)
        
    }
    func updateIndicator(animate: Bool = false) {
        let btn = previousBtn
        let duration: TimeInterval = animate ? 0.3 : 0
        UIView.animate(withDuration: duration) {
            NSLayoutConstraint.deactivate([self.indicatorLeading,self.indicatorTrailing, self.indicatorWidthAnchor])

            switch self.style.indicatorWidthType {
            case .equal:
                if self.style.indicatorType == .line {
                    self.indicatorLeading = self.indicatorLine.leadingAnchor.constraint(equalTo: btn.leadingAnchor)
                    self.indicatorTrailing = self.indicatorLine.trailingAnchor.constraint(equalTo: btn.trailingAnchor)
                } else {
                    self.indicatorLeading = self.indicatorBG.leadingAnchor.constraint(equalTo: btn.leadingAnchor)
                    self.indicatorTrailing = self.indicatorBG.trailingAnchor.constraint(equalTo: btn.trailingAnchor)
                }
                NSLayoutConstraint.activate([self.indicatorLeading,self.indicatorTrailing])
            case .fixed:
                if self.style.indicatorType == .line {
                    self.indicatorWidthAnchor = self.indicatorLine.widthAnchor.constraint(equalToConstant: self.style.indicatorWidth)
                    self.indicatorLeading = self.indicatorLine.leadingAnchor.constraint(equalTo: btn.centerXAnchor, constant: -self.style.indicatorWidth *  0.5)

                } else {
                    self.indicatorWidthAnchor = self.indicatorBG.widthAnchor.constraint(equalToConstant: self.style.indicatorWidth)
                    self.indicatorLeading = self.indicatorBG.leadingAnchor.constraint(equalTo: btn.centerXAnchor, constant: -self.style.indicatorWidth *  0.5)
                }
                NSLayoutConstraint.activate([self.indicatorLeading, self.indicatorWidthAnchor])
            }
            self.layoutIfNeeded()
        }
    }
    
    
    @objc
    private func titleButtonAction(_ btn: UIButton) {
        previousBtn.isSelected = false
        previousBtn.titleLabel?.font = style.titleNormalFont
        btn.titleLabel?.font = style.titleSelectedFont
        btn.isSelected = true
        previousBtn = btn
        moveTitleToCenter(btn)
        updateIndicator(animate: true)
        guard let index = titleButtons.firstIndex(of: btn) else {
            return
        }
        selectHandle?(index)
        delegate?.tabSelect(at: index)
    }
    private func moveTitleToCenter(_ btn: UIButton){
        if style.shouldMoveToCenter == false {
            return
        }
        layoutIfNeeded()
        let width = scrollView.frame.size.width
        var offsetX = btn.center.x - width * 0.5
        let maxOffsetX = scrollView.contentSize.width - width
        if offsetX >= maxOffsetX {
            offsetX = maxOffsetX
        } else if offsetX <= 0 {
            offsetX = 0
        }
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    public func selectIndex(_ index: Int) {
        let btn = titleButtons[index]
        titleButtonAction(btn)
    }
    public func updateSelectIndex(scrollView: UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let scale = contentOffsetX / width
        let index = Int(scale)
        selectIndex(index)
    }
    public func updateIndicatorFrame(scrollView: UIScrollView) {
        let point = scrollView.panGestureRecognizer.translation(in: scrollView)
        let contentOffsetX = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        var scale = contentOffsetX / width
        let index = Int(scale)
        scale = scale - CGFloat(index)
        let leftBtn = titleButtons[index]
        var rightBtn = titleButtons[index]
        if (index + 1) < titleButtons.count {
            rightBtn = titleButtons[index + 1]
        }
        if point.x < 0 {
            //向 ← 拖动
        } else {
            //向 → 拖动
        }
        let centerBetween = rightBtn.center.x - leftBtn.center.x
        var rect = indicatorLine.frame
        if scale < 0.5 {
            rect.origin.x = style.leftPadding + leftBtn.center.x - style.indicatorWidth * 0.5
            rect.size.width = style.indicatorWidth + centerBetween * scale * 2
        } else {
            rect.origin.x = style.leftPadding + leftBtn.center.x + 2 * (scale - 0.5) * centerBetween - style.indicatorWidth * 0.5
            rect.size.width = style.indicatorWidth + centerBetween * (1-scale) * 2
        }
        indicatorLine.frame = rect
        NSLayoutConstraint.deactivate([self.indicatorLeading,self.indicatorTrailing, self.indicatorWidthAnchor])
        if self.style.indicatorType == .line {
            self.indicatorWidthAnchor = self.indicatorLine.widthAnchor.constraint(equalToConstant: rect.width)
            self.indicatorLeading = self.indicatorLine.leadingAnchor.constraint(equalTo: leadingAnchor, constant: rect.origin.x)
        }
        NSLayoutConstraint.activate([self.indicatorLeading, self.indicatorWidthAnchor])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public protocol TabHeaderDelegate: class {
    func tabSelect(at index: Int)
}

public struct TabHeaderStyle {
    public var backgroundColor: UIColor = .white
    public var type: StyleType = .fixed(true)
    public var margin: CGFloat = 10
    public var leftPadding: CGFloat = 10
    public var rightPadding: CGFloat = 10
    public var separatorColor: UIColor = .clear
    public var separatorHeight: CGFloat = 1
    public var indicatorColor: UIColor = .red
    public var indicatorLineHeight: CGFloat = 3
    public var indicatorWidth: CGFloat = 30
    public var indicatorWidthType: IndicatorWidthType = .equal
    public var indicatorMoveType: IndicatorMoveType = .none
    public var indicatorType: IndicatorType = .line
    public var indicatorBGInsetTop: CGFloat = 2
    public var indicatorBGHeight: CGFloat = -1
    public var titleNormalColor: UIColor = .lightGray
    public var titleSelectedColor: UIColor = .red
    public var titleNormalFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var titleSelectedFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var defaultSelectIndex: Int = 0
    public var shouldMoveToCenter: Bool = true
    
    public enum StyleType {
        case fixed(_ equal: Bool)
        case scrollable
    }
    public enum IndicatorType {
        case line
        case background
    }
    
    public enum IndicatorMoveType {
        case none
        case follow
    }
    public enum IndicatorWidthType {
        case fixed
        case equal
    }
    
    public init() { }
}
