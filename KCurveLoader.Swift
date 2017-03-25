//
//  Created by Kenan Atmaca
//  kenanatmaca.com
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//

import UIKit

class KCurveLoader {
    
    var loaderView:UIView!
    var rootView:UIView!
    var aShapes = [CAShapeLayer]()
    var loadingText:UITextView!
    let size = UIScreen.main.bounds
    
    static var instance = KCurveLoader()

    
    lazy var displayLink:CADisplayLink = {
        
        let displayLink = CADisplayLink(target: self, selector: #selector(animate))
        displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        return displayLink
        
    }()
    
    
    fileprivate init() {
        setupView()
    }
    
    
    fileprivate func setupView() {
        
        loaderView = UIView()
        loaderView.frame = size
        loaderView.backgroundColor = UIColor.white
        
        loadingText = UITextView()
        loadingText.text = "Loading..."
        loadingText.font = UIFont(name: "Avenir", size: 28)
        loadingText.textColor = UIColor.darkGray
        loadingText.sizeToFit()
        loadingText.center = CGPoint(x: size.width / 2, y: size.height / 1.3)
        
        (0..<3).forEach { (_) in
            
           aShapes.append(shapesSetup())
            
        }
    }
    
    
    fileprivate func shapesSetup() -> CAShapeLayer {
        
        let shape = CAShapeLayer()
        shape.path = randPath().cgPath
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineWidth = 3
        
        return shape
        
    }
    
    fileprivate func animateSetup(_ shape:CAShapeLayer) {
        
        let animate = CABasicAnimation(keyPath: "path")
        animate.toValue = randPath().cgPath
        animate.duration = 1.7
        animate.fillMode = kCAFillModeForwards
        animate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        shape.add(animate, forKey: nil)
        
    }
    
    fileprivate func textAnimateSetup(_ tview:UITextView) {
        
        let tanimate = CABasicAnimation(keyPath: "opacity")
        tanimate.fromValue = 1.0
        tanimate.toValue = 0.5
        tanimate.duration = 1
        tanimate.fillMode = kCAFillModeForwards
        tanimate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        tanimate.autoreverses = true
        tanimate.repeatCount = Float.infinity
        
        tview.layer.add(tanimate, forKey: nil)
        
    }
    
    fileprivate func randPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        
        let endPoint = CGPoint(x: size.width, y: 300)
        
        path.move(to: CGPoint(x: 0, y: size.height / 2))
        
        let randY = CGFloat(200 + drand48() * 300)
        
        let c1 = CGPoint(x: 150, y: randY + 100)
        let c2 = CGPoint(x: 250 , y: randY - 100)
        
        path.addCurve(to: endPoint, controlPoint1: c1, controlPoint2: c2)
        
        return path
    }
    
    func setup() {
        
        let colors = [UIColor.orange,UIColor.purple,UIColor.green]

        for i in 0..<3 {
            aShapes[i].fillColor = colors[i].withAlphaComponent(0.8).cgColor
            loaderView.layer.addSublayer(aShapes[i])
        }
        
        loaderView.addSubview(loadingText)
        rootView.addSubview(loaderView)
        
        textAnimateSetup(loadingText)
        
        displayLink.isPaused = false
        displayLink.frameInterval = 9

    }
    
    func remove() {
        
        UIView.animate(withDuration: 1, animations: { 
            self.loaderView.alpha = 0
        }) { (_) in
            self.loaderView.layer.removeAllAnimations()
            self.loaderView.removeFromSuperview()
        }
        
    }
    
    @objc private func animate() {
      
        for i in 0..<3 {
            animateSetup(aShapes[i])
        }
    }
    
}//
