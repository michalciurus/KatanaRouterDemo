//
//  FirstTabViewController.swift
//  KatanaDemo
//
//  Created by Michal Ciurus on 19/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import UIKit
import KatanaRouter

class FirstTabNavigationController: UINavigationController {
    
}

extension FirstTabNavigationController: Routable {
    func push(destination: Destination, completionHandler: @escaping RoutableCompletion) -> Routable {
        switch(destination.routableType) {
        case is RandomViewController.Type:
            let randomViewController = RandomViewController(instanceIdentifier: destination.instanceIdentifier)
            randomViewController.view.backgroundColor = UIColor.red
            self.pushViewController(randomViewController, animated: true)
            completionHandler()
            return randomViewController
        default: fatalError("Not Supported")
        }
    }
    
    func pop(destination: Destination, completionHandler: @escaping RoutableCompletion) {
        
    }
}
