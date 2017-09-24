//
//  CustomSwitch.swift
//  Yelp
//
//  Created by Oscar Bonilla on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit


// https://medium.com/@milenko_52829/making-custom-uiswitch-part-1-cc3ab9c0b05b
class CustomSwitch: UIControl {

    public var onTintColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }

    public var offTintColor = UIColor.lightGray {
        didSet {
            self.setupUI()
        }
    }
    public var cornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }


    public var thumbTintColor = UIColor.white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }

    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var isOn = true
    public var animationDuration: Double = 0.5

    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false

    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }

    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor

            // thumb managment
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        }
    }

    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIViewAnimationOptions.curveEaseOut,
                                                             UIViewAnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControlEvents.valueChanged)
        })
    }

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }

}

