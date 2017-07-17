//
//  MainViewController.swift
//  Fast Fractal Generator
//
//  Created by Steven Steiner on 7/15/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import UIKit
import GLKit
import CoreGraphics

class MainViewController: UIViewController, GLKViewDelegate, GLKViewControllerDelegate  {

    var frac: Fractal = Fractal()

    override func viewDidLoad() {
        super.viewDidLoad()

        let context: EAGLContext = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
        let glView: GLKView = GLKView.init(frame: self.view.frame)
        glView.context = context
        glView.delegate = self

        let controller: GLKViewController = GLKViewController.init()
        controller.view = glView
        controller.delegate = self
        controller.preferredFramesPerSecond = 60

        self.view.addSubview(glView)

        let button: UIButton = UIButton.init(type: UIButtonType.roundedRect)
        button.setTitle("Change Color", for: UIControlState.normal)
        button.sizeToFit()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false

        glView.addSubview(button)

        var constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: glView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 30.0)
        glView.addConstraint(constraint)

        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: glView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 30.0)
        glView.addConstraint(constraint)

        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 20.0)
        glView.addConstraint(constraint)

        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 20.0)
        glView.addConstraint(constraint)

        let label: UILabel = UILabel.init(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
        label.text = "Hello world"
        label.textColor = UIColor.white

        glView.addSubview(label)
        
        EAGLContext.setCurrent(context)

        frac.setup(size: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: touch.view)
        let str: String = NSStringFromCGPoint(point)
        print(str)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: touch.view)
        let str: String = NSStringFromCGPoint(point)
        print(str)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    func glkView(_: GLKView, drawIn: CGRect) {
        print("Hello")
        frac.render()
    }

    func glkViewControllerUpdate(_: GLKViewController) {

    }
}
