//
//  AppDelegate.swift
//  Fast Fractal Generator
//
//  Created by Shahar Sandhaus on 6/25/17.
//  Copyright © 2017 Shahar Sandhaus. All rights reserved.
//

import UIKit;
import GLKit;
import CoreGraphics;

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GLKViewDelegate, GLKViewControllerDelegate {

    var window: UIWindow?;
    var frac: Fractal = Fractal();

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds);
        
        let context: EAGLContext = EAGLContext.init(api: EAGLRenderingAPI.openGLES2);
        let view: GLKView = GLKView.init(frame: UIScreen.main.bounds);
        view.context = context;
        view.delegate = self;
        
        let controller: GLKViewController = GLKViewController.init();
        controller.view = view;
        controller.delegate = self;
        controller.preferredFramesPerSecond = 60;
        
        let button: UIButton = UIButton.init(type: UIButtonType.roundedRect);
        button.setTitle("Change Color", for: UIControlState.normal);
        button.sizeToFit();
        button.layer.cornerRadius = 5;
        button.clipsToBounds = true;
        button.backgroundColor = UIColor.white;
        button.translatesAutoresizingMaskIntoConstraints = false;
        
        view.addSubview(button);
        
        var constraint: NSLayoutConstraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 30.0);
        view.addConstraint(constraint);
        
        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 30.0);
        view.addConstraint(constraint);
        
        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 20.0);
        view.addConstraint(constraint);
        
        constraint = NSLayoutConstraint.init(item: button, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 20.0);
        view.addConstraint(constraint);
        
        let label: UILabel = UILabel.init(frame: CGRect(x: 100, y: 300, width: 100, height: 100));
        label.text = "Hello world";
        label.textColor = UIColor.white;
        
        window?.addSubview(label);
        
        window?.rootViewController = controller;
        window?.backgroundColor = UIColor.white;
        window?.makeKeyAndVisible();
        
        EAGLContext.setCurrent(context);
        
        frac.setup(size: CGPoint(x: window!.bounds.width, y: window!.bounds.height));
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!;
        let point: CGPoint = touch.location(in: touch.view);
        let str: String = NSStringFromCGPoint(point);
        NSLog(str);
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!;
        let point: CGPoint = touch.location(in: touch.view);
        let str: String = NSStringFromCGPoint(point);
        NSLog(str);
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func glkView(_: GLKView, drawIn: CGRect) {
        frac.render();
    }
    
    func glkViewControllerUpdate(_: GLKViewController) {
        
    }

}

