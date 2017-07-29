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

class MainViewController: UIViewController, GLKViewDelegate, GLKViewControllerDelegate {

    var frac: Fractal = Fractal()
    let context = EAGLContext(api: EAGLRenderingAPI.openGLES2)
    var glView: GLKView!
    let controller = GLKViewController()

    let colorButton = UIButton(type: UIButtonType.roundedRect)

    let doubleSwitch = UISwitch()
    let doubleLabel = UILabel()

    let iterationsSlider = UISlider()
    let iterationsLabel = UILabel()

    let uiButton = UIButton(type: UIButtonType.roundedRect)
    var visibility = true

    override func viewDidLoad() {
        super.viewDidLoad()

        glView = GLKView(frame: view.frame)
        glView.context = context!
        glView.delegate = self

        controller.view = glView
        controller.delegate = self
        controller.preferredFramesPerSecond = 60

        view.addSubview(glView)

        colorButton.setTitle("Change Color", for: .normal)
        colorButton.sizeToFit()
        colorButton.layer.cornerRadius = 5
        colorButton.clipsToBounds = true
        colorButton.backgroundColor = UIColor.white
        colorButton.translatesAutoresizingMaskIntoConstraints = false
        colorButton.addTarget(self, action: #selector(colorButtonIsClicked), for: .touchUpInside)

        glView.addSubview(colorButton)

        doubleSwitch.isOn = false
        doubleSwitch.sizeToFit()
        doubleSwitch.clipsToBounds = true
        doubleSwitch.translatesAutoresizingMaskIntoConstraints = false
        doubleSwitch.addTarget(self, action: #selector(doubleSwitchIsClicked), for: .touchUpInside)

        glView.addSubview(doubleSwitch)

        doubleLabel.text = "Double Precision"
        doubleLabel.textAlignment = .center
        doubleLabel.textColor = .white
        doubleLabel.translatesAutoresizingMaskIntoConstraints = false

        glView.addSubview(doubleLabel)

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
        uiButton.addTarget(self, action: #selector(uiButtonIsClicked), for: .touchUpInside)

        glView.addSubview(uiButton)

        iterationsSlider.minimumValue = 0
        iterationsSlider.maximumValue = 1000
        iterationsSlider.value = 100
        iterationsSlider.isContinuous = true
        iterationsSlider.translatesAutoresizingMaskIntoConstraints = false
        iterationsSlider.addTarget(self, action: #selector(iterationsSliderValueDidChange), for: .valueChanged)
        iterationsSlider.addTarget(self, action: #selector(iterationsSliderStart), for: .touchDown)
        iterationsSlider.addTarget(self, action: #selector(iterationsSliderEnd), for: .touchUpInside)
        iterationsSlider.addTarget(self, action: #selector(iterationsSliderEnd), for: .touchUpOutside)

        glView.addSubview(iterationsSlider)

        iterationsLabel.text = "Iterations: \(Int(iterationsSlider.value))"
        iterationsLabel.textAlignment = .center
        iterationsLabel.textColor = .white
        iterationsLabel.translatesAutoresizingMaskIntoConstraints = false

        glView.addSubview(iterationsLabel)

        constraints()

        uiVisibility()

        EAGLContext.setCurrent(context)

        frac.setup(size: CGPoint(x: view.frame.width, y: view.frame.height))
    }

    func constraints() {
        let doubleSwitchHeight = NSLayoutConstraint(item: doubleSwitch, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let doubleSwitchWidth = NSLayoutConstraint(item: doubleSwitch, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 52)
        let doubleSwitchX = NSLayoutConstraint(item: doubleSwitch, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 80)
        let doubleSwitchY = NSLayoutConstraint(item: doubleSwitch, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -72)

        let doubleLabelHeight = NSLayoutConstraint(item: doubleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16)
        let doubleLabelWidth = NSLayoutConstraint(item: doubleLabel, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let doubleLabelX = NSLayoutConstraint(item: doubleLabel, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 80)
        let doubleLabelY = NSLayoutConstraint(item: doubleLabel, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -112)

        let iterationsSliderHeight = NSLayoutConstraint(item: iterationsSlider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 24)
        let iterationsSliderWidth = NSLayoutConstraint(item: iterationsSlider, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let iterationsSliderX = NSLayoutConstraint(item: iterationsSlider, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: 0)
        let iterationsSliderY = NSLayoutConstraint(item: iterationsSlider, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -48)

        let iterationsLabelHeight = NSLayoutConstraint(item: iterationsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 16)
        let iterationsLabelWidth = NSLayoutConstraint(item: iterationsLabel, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.75, constant: 0)
        let iterationsLabelX = NSLayoutConstraint(item: iterationsLabel, attribute: .centerX, relatedBy: .equal, toItem: glView, attribute: .centerX, multiplier: 1.0, constant: -80)
        let iterationsLabelY = NSLayoutConstraint(item: iterationsLabel, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -80)

        let colorButtonHeight = NSLayoutConstraint(item: colorButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let colorButtonWidth = NSLayoutConstraint(item: colorButton, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.45, constant: 0)
        let colorButtonX = NSLayoutConstraint(item: colorButton, attribute: .left, relatedBy: .equal, toItem: glView, attribute: .left, multiplier: 1.0, constant: 8)
        let colorButtonY = NSLayoutConstraint(item: colorButton, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -8)

        let uiButtonHeight = NSLayoutConstraint(item: uiButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 32)
        let uiButtonWidth = NSLayoutConstraint(item: uiButton, attribute: .width, relatedBy: .equal, toItem: glView, attribute: .width, multiplier: 0.4, constant: 0)
        let uiButtonX = NSLayoutConstraint(item: uiButton, attribute: .right, relatedBy: .equal, toItem: glView, attribute: .right, multiplier: 1.0, constant: -8)
        let uiButtonY = NSLayoutConstraint(item: uiButton, attribute: .bottom, relatedBy: .equal, toItem: glView, attribute: .bottom, multiplier: 1.0, constant: -8)

        glView.addConstraints([
            colorButtonX, colorButtonY, colorButtonWidth, colorButtonHeight,
            doubleSwitchX, doubleSwitchY, doubleSwitchWidth, doubleSwitchHeight,
            doubleLabelX, doubleLabelY, doubleLabelHeight, doubleLabelWidth,
            iterationsSliderX, iterationsSliderY, iterationsSliderHeight, iterationsSliderWidth,
            iterationsLabelX, iterationsLabelY, iterationsLabelHeight, iterationsLabelWidth,
            uiButtonX, uiButtonY, uiButtonWidth, uiButtonHeight,
        ])
    }

    func colorButtonIsClicked(sender _: UIButton!) {
        frac.changeColor()
    }

    func doubleSwitchIsClicked(sender _: UIButton!) {
        // React to change here
    }

    func iterationsSliderStart(sender _: UISlider!) {
        frac.renderMode = Fractal.RENDER_DOWNSCALE
    }

    func iterationsSliderEnd(sender _: UISlider!) {
        frac.renderMode = Fractal.RENDER_UPSCALE
    }

    func iterationsSliderValueDidChange(sender: UISlider!) {
        iterationsLabel.text = "Iterations: \(Int(sender.value))"
    }

    func uiButtonIsClicked(sender _: UIButton!) {
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
                self.iterationsSlider.alpha = 1.0
                self.colorButton.alpha = 1.0
                self.doubleSwitch.alpha = 1.0
                self.doubleLabel.alpha = 1.0
                self.iterationsLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.iterationsSlider.alpha = 0.0
                self.colorButton.alpha = 0.0
                self.doubleSwitch.alpha = 0.0
                self.doubleLabel.alpha = 0.0
                self.iterationsLabel.alpha = 0.0
            })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        frac.renderMode = Fractal.RENDER_DOWNSCALE

        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: touch.view)
        let str: String = NSStringFromCGPoint(point)
        print(str)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with _: UIEvent?) {
        let touch: UITouch = touches.first!
        let point: CGPoint = touch.location(in: touch.view)
        let str: String = NSStringFromCGPoint(point)
        print(str)
    }

    override func touchesEnded(_: Set<UITouch>, with _: UIEvent?) {
        frac.renderMode = Fractal.RENDER_UPSCALE
    }

    func glkView(_: GLKView, drawIn _: CGRect) {
        frac.render()
    }

    func glkViewControllerUpdate(_: GLKViewController) {
    }
}
