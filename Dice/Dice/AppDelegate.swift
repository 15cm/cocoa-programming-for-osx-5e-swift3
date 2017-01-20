//
//  AppDelegate.swift
//  Dice
//
//  Created by Sinkerine on 19/01/2017.
//  Copyright © 2017 sinkerine. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let mainWindowController = MainWindowController()
        mainWindowController.showWindow(self)
        self.mainWindowController = mainWindowController
    }
}

