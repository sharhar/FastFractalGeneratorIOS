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
    let colorButton = UIButton.init(type: UIButtonType.roundedRect)
    let uiButton = UIButton.init(type: UIButtonType.roundedRect)
    let slider = UISlider.init()
    let label = UILabel.init()
    var visibility = true

    override func viewDidLoad() {
        super.viewDidLoad()

        glView = GLKView.init(frame: self.view.frame)
        glView.context = context!
        glView.delegate = self

        controller.view = glView
        controller.delegate = self
        controller.preferredFramesPerSecond = 60

        self.view.addSubview(glView)

        colorButton.setTitle("Change Color", for: .normal)
        colorButton.sizeToFit()
        colorButton.layer.cornerRadius = 5
        colorButton.clipsToBounds = true
        colorButton.backgroundColor = UIColor.white
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.addTarget(self, action: #selector(colorIsClicked), for: .touchUpInside)

        glView.addSubview(colorButton)

        if visibility {
            uiButton.setTitle("Hide UI", for: .normal)
        } else {
            uiButton.setTitle("Show UI", for: .normal)
        }

        uiButton.sizeToFit()
        uiButton.layer.cornerRadius = 5
        uiButton.clipsToBounds = true
        uiButton.backgroundColor = UIColor.white
        uiButton.translatesAutoresizingMaskIntoConstraints = false
        uiButton.addTarget(self, action: #selector(uiIsClicked), for: .touchUpInside)
        
        glView.addSubview(uiButton)

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

        let colorButtonHeight = NSLayoutConstraint.init(item: colorButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let colorButtonWidth = NSLayoutConstraint.init(item: colorButton, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.5, constant: 0)
        let colorButtonX = NSLayoutConstraint.init(item: colorButton, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let colorButtonY = NSLayoutConstraint.init(item: colorButton, attribute: .top, relatedBy: .equal, toItem: glView, attribute: .top, multiplier: 1.0, constant: 96)

        let uiButtonHeight = NSLayoutConstraint.init(item: uiButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let uiButtonWidth = NSLayoutConstraint.init(item: uiButton, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.5, constant: 0)
        let uiButtonX = NSLayoutConstraint.init(item: uiButton, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let uiButtonY = NSLayoutConstraint.init(item: uiButton, attribute: .top, relatedBy: .equal, toItem: glView, attribute: .top, multiplier: 1.0, constant: 32)

        let labelHeight = NSLayoutConstraint.init(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let labelWidth = NSLayoutConstraint.init(item: label, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let labelX = NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let labelY = NSLayoutConstraint.init(item: label, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -4)

        glView.addConstraints([sliderX, sliderY, sliderHeight, sliderWidth,
                               colorButtonX, colorButtonY, colorButtonWidth, colorButtonHeight,
                               uiButtonX, uiButtonY, uiButtonWidth, uiButtonHeight,
                               labelX, labelY, labelHeight, labelWidth])

        uiVisibility()

        EAGLContext.setCurrent(context)

        frac.setup(size: CGPoint(x: self.view.frame.width, y: self.view.frame.height))
    }

    func colorIsClicked(sender: UIButton!) {
        frac.changeColor()
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

    func uiIsClicked(sender: UIButton!) {
        if visibility {
            uiButton.setTitle("Show UI", for: .normal)
            visibility = false
        } else {
            uiButton.setTitle("Hide UI", for: .normal)
            visibility = true
        }
        uiVisibility()
    }

    func uiVisibility() {
        if visibility {
            UIView.animate(withDuration: 0.25, animations: {
            self.slider.alpha = 1.0
            self.colorButton.alpha = 1.0
            self.label.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
            self.slider.alpha = 0.0
            self.colorButton.alpha = 0.0
            self.label.alpha = 0.0
            })
        }
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
