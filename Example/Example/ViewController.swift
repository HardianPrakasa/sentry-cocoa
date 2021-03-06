//
//  ViewController.swift
//  Example
//
//  Created by Daniel Griesser on 27.02.20.
//  Copyright © 2020 Sentry. All rights reserved.
//

import UIKit
import Sentry

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SentrySDK.configureScope { (scope) in
            scope.setEnvironment("debug")
            scope.setTag(value: "swift", key: "language")
            scope.setExtra(value: String(describing: self), key: "currentViewController")
        }
    }
    
    @IBAction func addBreadcrumb(_ sender: Any) {
        let crumb = Breadcrumb()
        crumb.message = "tapped addBreadcrumb"
        SentrySDK.addBreadcrumb(crumb: crumb)
    }
    
    @IBAction func captureMessage(_ sender: Any) {
        let eventId = SentrySDK.capture(message: "Yeah captured a message")
        // Returns eventId in case of successfull processed event
        // otherwise nil
        print("\(String(describing: eventId))")
    }
    
    @IBAction func captureError(_ sender: Any) {
        let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Object does not exist"])
        SentrySDK.capture(error: error) { (scope) in
            // Changes in here will only be captured for this event
            // The scope in this callback is a clone of the current scope
            // It contains all data but mutations only influence the event being sent
            scope.setTag(value: "value", key: "myTag")
        }
    }
    
    @IBAction func captureNSException(_ sender: Any) {
        let exception = NSException(name: NSExceptionName("My Custom exeption"), reason: "User clicked the button", userInfo: nil)
        let scope = Scope()
        scope.setLevel(.fatal)
        // By explicity just passing the scope, only the data in this scope object will be added to the event
        // The global scope (calls to configureScope) will be ignored
        // Only do this if you know what you are doing, you loose a lot of useful info
        // If you just want to mutate what's in the scope use the callback, see: captureError
        SentrySDK.capture(exception: exception, scope: scope)
    }
    
    @IBAction func crash(_ sender: Any) {
        SentrySDK.crash()
    }
}

