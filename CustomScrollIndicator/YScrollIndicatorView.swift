//
//  YScrollIndicatorView.swift
//  CustomScrollIndicator
//
//  Created by Yuvrajsinh Jadeja on 01/05/22.
//

import Foundation
import UIKit

class YScrollIndicatorView: UIView {
    var diamondColor: UIColor = .white {
        didSet {
            diamond.fillColor = diamondColor
        }
    }
    var indicatorColor: UIColor = .white {
        didSet {
            capsuleView1.capsuleColor = indicatorColor.withAlphaComponent(0.3)
            capsuleView2.capsuleColor = indicatorColor.withAlphaComponent(0.3)
            capsuleView3.capsuleColor = indicatorColor.withAlphaComponent(0.3)
        }
    }
    
    private var capsuleView1: CapsuleView!
    private var capsuleView2: CapsuleView!
    private var capsuleView3: CapsuleView!
    private var diamond: DiamondView!
    
    private var prevAngle: CGFloat = 0
    
    private let gradient = CAGradientLayer()
        
    private var view2Width: CGFloat {
        return bounds.width * 0.75
    }
    
    private var view3Width: CGFloat {
        return bounds.width * 0.50
    }
    
    private var view4Width: CGFloat {
        return bounds.width * 0.25
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeCapsuleViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func initializeCapsuleViews() {
        clipsToBounds = true
        layer.cornerRadius = bounds.height / 2.0
        
        applyGradientBorder()
        
        let view2Frame = CGRect(x: 0.0, y: 0.0, width: view2Width, height: bounds.height)
        capsuleView1 = CapsuleView(frame: view2Frame)
        capsuleView1.capsuleColor = indicatorColor.withAlphaComponent(0.3)
        addSubview(capsuleView1)
        
        let view3Frame = CGRect(x: 0.0, y: 0.0, width: view3Width, height: bounds.height)
        capsuleView2 = CapsuleView(frame: view3Frame)
        capsuleView2.capsuleColor = indicatorColor.withAlphaComponent(0.3)
        addSubview(capsuleView2)
        
        let view4Frame = CGRect(x: 0.0, y: 0.0, width: view4Width, height: bounds.height)
        capsuleView3 = CapsuleView(frame: view4Frame)
        capsuleView3.capsuleColor = indicatorColor.withAlphaComponent(0.3)
        addSubview(capsuleView3)
        
        let diamondSize = frame.height
        diamond = DiamondView(frame: CGRect(x: view4Frame.width / 2 - diamondSize / 2 , y: 0, width: diamondSize, height: diamondSize))
        diamond.fillColor = diamondColor
        addSubview(diamond)
    }
    
    private func applyGradientBorder() {
        let gradientFrame = bounds
        
        gradient.frame = gradientFrame
        gradient.cornerRadius = layer.cornerRadius
        gradient.colors = [indicatorColor.withAlphaComponent(0.3).cgColor, indicatorColor.cgColor, indicatorColor.withAlphaComponent(0.3).cgColor]
        gradient.locations = [0, 0, 1]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: gradientFrame, cornerRadius: bounds.height/2.0).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        layer.addSublayer(gradient)
    }
    
    func adjustIndicator(scrollView: UIScrollView) {
        let offset100Per = scrollView.contentSize.width - scrollView.frame.width // Calculating 100% offset for ScrollView
        let offsetPer = scrollView.contentOffset.x * 100 / offset100Per // Calculate current offset percent
        
        // Don't change view positions if scrollView is over scrolling
        if offsetPer < -8.0 || offsetPer > 108.0 {
            return
        }
        // Calculate gradient color based on contentOffset position
        // Color will be darker at current offset position, opposite direction will be lighter
        gradient.colors = [indicatorColor.withAlphaComponent(max(1 - offsetPer/100, 0.3)).cgColor,
                           indicatorColor.cgColor,
                           indicatorColor.withAlphaComponent(max(offsetPer/100, 0.3)).cgColor]
        // Gradient locations will be based on `offsetPer`
        gradient.locations = [0, NSNumber(value: fabs(offsetPer/100)), 1]
        
        // View2 rearrange
        setNewCapsulePosition(for: capsuleView1, with: offsetPer)
        
        // View3 rearrange
        setNewCapsulePosition(for: capsuleView2, with: offsetPer)
        
        // View4 rearrange
        setNewCapsulePosition(for: capsuleView3, with: offsetPer)
        
        // Diamond view rotation
        setNewDiamondPosition(for: diamond, with: offsetPer)
    }
    
    private func setNewCapsulePosition(for view: UIView, with offsetPercent: CGFloat) {
        let view_100_Per = frame.width - view.frame.width // Calculate 100% value for view's maximum X offset
        let viewX = offsetPercent * view_100_Per / 100.0 // Calcuate view's new X position based on scrollView's current offsetPercent

        var newFrame = view.frame
        newFrame.origin.x = viewX
        view.frame = newFrame
        
        // Alternate calculation for view's new frame
        /*if viewX < 0 {
            var newFrame = view.frame
            newFrame.origin.x = 0
            newFrame.size.width = width + viewX
            view.frame = newFrame
        }
        else if viewX > view_100_Per {
            let diff = viewX - view.frame.minX
            var newFrame = view.frame
            newFrame.origin.x += diff
            newFrame.size.width = width - diff
            view.frame = newFrame
        }
        else {
            var newFrame = view.frame
            newFrame.origin.x = viewX
            view.frame = newFrame
        }*/
    }
    
    private func setNewDiamondPosition(for view: UIView, with offsetPercent: CGFloat) {
        // New position
        diamond.center = capsuleView3.center
        
        // New angle
        let angle = offsetPercent * 360 / 100
        let angleDiff = angle - prevAngle
        let radians = angleDiff / 180.0 * CGFloat.pi
        let transform = view.transform.rotated(by: radians)
        view.transform = transform
        prevAngle = angle
    }
}

// MARK: - Custom view with shape of capsule
class CapsuleView: UIView {
    var capsuleColor: UIColor = .white {
        didSet {
            layer.borderColor = capsuleColor.cgColor
        }
    }
    
    private let gradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2.0
        layer.borderWidth = 1
        layer.borderColor = capsuleColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Custom view with Diamond shape
private class DiamondView: UIView {
    /// Enum for Points required to draw a diamond
    private enum DiamondPoint {
    case centerTop, rightCenter, centerBottom, leftCenter
    }
    
    /// Fill color for view
    var fillColor: UIColor = .white
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getPoint(for point: DiamondPoint, rect: CGRect) -> CGPoint {
        switch point {
        case .centerTop:
            return CGPoint(x: rect.width / 2.0, y: 0)
        case .rightCenter:
            return CGPoint(x: rect.width, y: rect.height / 2.0)
        case .centerBottom:
            return CGPoint(x: rect.width / 2.0, y: rect.height)
        case .leftCenter:
            return CGPoint(x: 0.0, y: rect.height / 2.0)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        fillColor.setFill()
        let controlPoint = CGPoint(x: rect.width / 2.0, y: rect.height / 2.0) // Center of view
        
        let diamond = UIBezierPath()
        diamond.move(to: getPoint(for: .centerTop, rect: rect))
        diamond.addQuadCurve(to: getPoint(for: .rightCenter, rect: rect), controlPoint: controlPoint)
        diamond.addLine(to: getPoint(for: .rightCenter, rect: rect))
        diamond.addQuadCurve(to: getPoint(for: .centerBottom, rect: rect), controlPoint: controlPoint)
        diamond.addLine(to: getPoint(for: .centerBottom, rect: rect))
        diamond.addQuadCurve(to: getPoint(for: .leftCenter, rect: rect), controlPoint: controlPoint)
        diamond.addLine(to: getPoint(for: .leftCenter, rect: rect))
        diamond.addQuadCurve(to: getPoint(for: .centerTop, rect: rect), controlPoint: controlPoint)
        diamond.close()
        
        diamond.fill()
    }
}
