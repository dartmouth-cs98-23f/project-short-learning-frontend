//
//  NavigationDots.swift
//  Discite
//
//  Created by Jessie Li on 3/7/24.
//

import SwiftUI
import UIKit

struct NavigationDots: View {
    var body: some View {
        NavigationDotsRep()
//            .background(.pink)
    }
}

struct NavigationDotsRep: UIViewRepresentable {
    func makeUIView(context: Context) -> DotNavigationView2 {
        
        let navigationDots = DotNavigationView2()
        return navigationDots
        
    }
    
    func updateUIView(_ uiView: DotNavigationView2, context: Context) {
        
    }
}

class DotNavigationView2: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func draw(_ rect: CGRect) {
//        print("draw called")
//        let currentIndex = 1
//        let dotSpacing: CGFloat = 10
//        let dotSizeSelected: CGFloat = 12
//        let dotSizeUnselected: CGFloat = 8
//
//        let centerY = rect.height / 2
//
//        for index in 0..<3 {
//            let centerX = CGFloat(index) * dotSpacing + dotSpacing / 2
//
//            let circlePath = UIBezierPath(
//                roundedRect: CGRect(x: centerX - 2, y: centerY - 2, width: dotSizeUnselected, height: dotSizeUnselected),
//                cornerRadius: dotSizeUnselected / 2
//            )
//
//            let fillColor = currentIndex == index ? UIColor.systemPurple.cgColor : UIColor.systemPurple.withAlphaComponent(0.5).cgColor
//
//            // circlePath.fill()
//            // fillColor.setFill()
//            circlePath.fill()
//        }
//    }
    
    override func draw(_ rect: CGRect) {
        let dotSpacing: CGFloat = 10
        let dotSize: CGFloat =  12
        
        let centerY = rect.height / 2
        let centerX = rect.width / 2
        
        let circle = UIShape.circle 
        
        for index in 0..<3 {
            let x = centerX + CGFloat(index) * dotSpacing + dotSpacing / 2
            drawRingFittingInsideView(rect: CGRect(x: centerX - dotSize/2, y: centerY - dotSize/2, width: dotSize, height: dotSize))
            
        }
    }
    
    internal func drawRingFittingInsideView(rect: CGRect) {
        let desiredLineWidth:CGFloat = 4    // Your desired value
        let hw:CGFloat = desiredLineWidth/2
        
        let circlePath = UIBezierPath(ovalIn: CGRectInset(rect, hw, hw))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.systemPurple.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        layer.addSublayer(shapeLayer)
    }
}

#Preview {
    NavigationDots()
}
