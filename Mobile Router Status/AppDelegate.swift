//
//  AppDelegate.swift
//  Mobile Router Status
//
//  Created by Tom Howard on 8/1/19.
//  Copyright © 2019 Mountain Pass. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    let API_URL = "http://m.home/api/model.json"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("\(NSRunningApplication.current.localizedName!)")
        self.statusItem.button?.image = NSImage(named:NSImage.Name("signal0"))
        refresh(self)
        constructMenu()
        popover.contentViewController = ConfigViewController.freshController()
        var helloWorldTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(AppDelegate.refresh), userInfo: nil, repeats: true)

    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func refresh(_ sender: Any?) {
        
        let urlString = "http://m.home/api/model.json"
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil,let usableData = data {
                print("no error")
                print(response as Any)
                print(usableData) //JSONSerialization
                if let jsonObj = try? JSONSerialization.jsonObject(with: usableData, options: .allowFragments) as? NSDictionary {
                    print(jsonObj!);
                    if let wwanDic = jsonObj!.value(forKey: "wwan") as? NSDictionary {
                        if let connection = wwanDic.value(forKey: "connection") as? String {
                            DispatchQueue.main.async {
                                if connection != "Connected" {
                                    self.statusItem.button?.image = NSImage(named:NSImage.Name("signal0"))
                                }
                                else {
                                    if let signalStrengthDict = wwanDic.value(forKey: "signalStrength") as? NSDictionary {
                                        print(signalStrengthDict)
                                        if let bars = signalStrengthDict.value(forKey: "bars") as? NSInteger {
                                            if( bars >= 0 && bars <= 5) {
                                                self.statusItem.button?.image = NSImage(named:NSImage.Name("signal" + String(bars)))
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else {
                print("error")

            }

        }
        task.resume()

        
        
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
    }
    
    func constructMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refresh(_:)), keyEquivalent: "R"))
//        let deviceMenuItem = NSMenuItem(title: "Device", action: #selector(AppDelegate.refresh(_:)), keyEquivalent: "")
//        let deviceSubMenuItem = NSMenu()
//        deviceMenuItem.submenu = deviceSubMenuItem
//        let netgearNighthawkM1MenuItem = NSMenuItem(title: "Netgear Nighthawk M1", action: #selector(AppDelegate.refresh(_:)), keyEquivalent: "")
//        netgearNighthawkM1MenuItem.state = NSControl.StateValue.on
//        deviceSubMenuItem.addItem(netgearNighthawkM1MenuItem)
//        menu.addItem(deviceMenuItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit \(NSRunningApplication.current.localizedName!)", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem.menu = menu
    }

}

