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
    let context = EAGLContext.init(api: EAGLRenderingAPI.openGLES2)
    var glView: GLKView!
    let controller = GLKViewController.init()
    let button = UIButton.init(type: UIButtonType.roundedRect)
    let slider = UISlider.init()
    let label = UILabel.init()

    override func viewDidLoad() {
        super.viewDidLoad()

        glView = GLKView.init(frame: self.view.frame)
        glView.context = context!
        glView.delegate = self

        controller.view = glView
        controller.delegate = self
        controller.preferredFramesPerSecond = 60

        self.view.addSubview(glView)

        button.setTitle("Change Color", for: UIControlState.normal)
        button.sizeToFit()
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonIsClicked), for: .touchUpInside)

        glView.addSubview(button)

        slider.minimumValue = 0
        slider.maximumValue = 1000
        slider.value = 100
        slider.isContinuous = true
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(sliderValueDidChange),for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderStart), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderEnd), for: .touchUpInside)
        slider.addTarget(self, action: #selector(sliderEnd), for: .touchUpOutside)

        glView.addSubview(slider)

        label.text = "Iterations: \(Int(slider.value))"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false

        glView.addSubview(label)

        let sliderHeight = NSLayoutConstraint.init(item: slider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let sliderWidth = NSLayoutConstraint.init(item: slider, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let sliderX = NSLayoutConstraint.init(item: slider, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let sliderY = NSLayoutConstraint.init(item: slider, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -32)

        let buttonHeight = NSLayoutConstraint.init(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let buttonWidth = NSLayoutConstraint.init(item: button, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.5, constant: 0)
        let buttonX = NSLayoutConstraint.init(item: button, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let buttonY = NSLayoutConstraint.init(item: button, attribute: .top, relatedBy: .equal, toItem: glView, attribute: .top, multiplier: 1.0, constant: 32)

        let labelHeight = NSLayoutConstraint.init(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let labelWidth = NSLayoutConstraint.init(item: label, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let labelX = NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let labelY = NSLayoutConstraint.init(item: label, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -4)

        glView.addConstraints([sliderHeight, sliderWidth, sliderX, sliderY, buttonX, buttonY, buttonWidth, buttonHeight, labelHeight, labelWidth, labelX, labelY])

        EAGLContext.setCurrent(context)

        frac.setup(size: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
    }
    
    func sliderStart(sender: UISlider!) {
        frac.renderMode = Fractal.RENDER_DOWNSCALE
    }
    
    func sliderEnd(sender: UISlider!) {
        frac.renderMode = Fractal.RENDER_UPSCALE
    }

    func sliderValueDidChange(sender: UISlider!) {
        label.text = "Iterations: \(Int(sender.value))"
    }

    func buttonIsClicked(sender: UIButton!) {
        frac.changeColor()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        frac.renderMode = Fractal.RENDER_DOWNSCALE
        
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
        frac.renderMode = Fractal.RENDER_UPSCALE
    }

    func glkView(_: GLKView, drawIn: CGRect) {
        frac.render()
    }

    func glkViewControllerUpdate(_: GLKViewController) {

    }
}
