//
//  ConfigViewController.swift
//  Mobile Router Status
//
//  Created by Tom Howard on 10/1/19.
//  Copyright © 2019 Mountain Pass. All rights reserved.
//

import Cocoa

class ConfigViewController: NSViewController {

    
    @IBOutlet var textLabel: NSTextField!
    
    // MARK: Storyboard instantiation
    static func freshController() -> ConfigViewController {
        //1.
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        //2.
        let identifier = "ConfigViewController"
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ConfigViewController else {
            fatalError("Why cant i find ConfigViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        textLabel.stringValue = "Hello"
    }
    
}
