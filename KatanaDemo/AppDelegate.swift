//
//  AppDelegate.swift
//  KatanaDemo
//
//  Created by Michal Ciurus on 06/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import UIKit
import Katana
import KatanaElements
import KatanaRouter

let store = Store<CounterState>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var router: Router<CounterState>?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = UITabBarController()
        self.router = Router<CounterState>(store: store, rootRoutable: rootViewController, rootIdentifier: "MainTab")
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
        
        let addFirstTabChild = Destination(routableType: FirstTabNavigationController.self, contextData: nil, userIdentifier: "FirstTabNav")
        let addSecondTabChild = Destination(routableType: SecondTabNavigationController.self, contextData: nil, userIdentifier: "SecondTabNav")
        
        let addChildrenAction = AddChildrenToDestination(identifier: "MainTab", destinations: [addFirstTabChild, addSecondTabChild], activeDestination: addFirstTabChild)
        
        store.dispatch(addChildrenAction)
        
        let randomVcDestination = Destination(routableType: RandomViewController.self, contextData: nil, userIdentifier: nil)
        
        let addFirstTabNavChild = AddChildrenToDestination(identifier: "FirstTabNav", child: randomVcDestination)
        
        store.dispatch(addFirstTabNavChild)
    
        return true
    }
    
}

extension UITabBarController: Routable {
    
    public func change(destinationsToPop: [Destination], destinationsToPush: [Destination], completionHandler: @escaping RoutableCompletion) -> [Destination : Routable] {
        var createdRoutables: [Destination : Routable] = [:]
        var childrenToAdd: [UIViewController] = []
        for destinationToPush in destinationsToPush {
            switch destinationToPush.routableType {
            case is FirstTabNavigationController.Type:
                let firstTabNav = FirstTabNavigationController()
                firstTabNav.navigationItem.title = "First"
                firstTabNav.tabBarItem.title = "First"

                createdRoutables[destinationToPush] = firstTabNav
                childrenToAdd.append(firstTabNav)
            case is SecondTabNavigationController.Type:
                let secondTabNav = SecondTabNavigationController()
                secondTabNav.navigationItem.title = "Second"
                secondTabNav.tabBarItem.title = "Second"
                createdRoutables[destinationToPush] = secondTabNav
                childrenToAdd.append(secondTabNav)
            default: fatalError("Not supported")
            }
        }
        
        self.viewControllers = childrenToAdd
        // Remember to always call the CompletionHandler when finished with the transition!
        completionHandler()
        return createdRoutables
    }
    
    public func changeActiveDestination(currentActiveDestination: Destination, completionHandler: @escaping RoutableCompletion) {
        switch currentActiveDestination.routableType {
            case is FirstTabNavigationController.Type:
                self.selectedIndex = 0
            case is SecondTabNavigationController.Type:
                self.selectedIndex = 1
        default: fatalError("Not supported")
        }
        
        completionHandler()
    }
}


