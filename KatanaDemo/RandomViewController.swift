//
//  RandomViewController.swift
//  KatanaDemo
//
//  Created by Michal Ciurus on 22/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import UIKit
import KatanaRouter

class RandomViewController: UIViewController {
    
    let pushButton: UIButton
    let popButton: UIButton
    let instanceIdentifier: UUID
    
    required init(instanceIdentifier: UUID) {
        pushButton = UIButton()
        popButton = UIButton()
        self.instanceIdentifier = instanceIdentifier
        super.init(nibName: nil, bundle: nil)
        
        pushButton.addTarget(self, action:#selector(didTapPush), for: .touchUpInside)
        popButton.addTarget(self, action: #selector(didTapPop), for: .touchUpInside)
        
        popButton.setTitle("Pop", for: .normal)
        pushButton.setTitle("Push", for: .normal)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParentViewController {
            let removeSelf = RemoveDestination(instanceIdentifier: self.instanceIdentifier)
            store.dispatch(removeSelf)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(pushButton)
        view.addSubview(popButton)
        
        self.view.backgroundColor = self.getRandomColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pushButton.center = self.view.center
        pushButton.sizeToFit()
        var popButtonCenter = self.view.center
        popButtonCenter.y += 80
        popButton.center = popButtonCenter
        popButton.sizeToFit()
    }
    
    func didTapPush() {
        let pushAction = AddNewDestination(destination: Destination(routableType: RandomViewController.self))
        store.dispatch(pushAction)
    }
    
    func didTapPop() {
        store.dispatch(RemoveCurrentDestination())
    }
    
    func getRandomColor() -> UIColor{
        let red:CGFloat = CGFloat(drand48())
        let green:CGFloat = CGFloat(drand48())
        let blue:CGFloat = CGFloat(drand48())
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}

extension RandomViewController: Routable {
    
    func push(destination: Destination, completionHandler: @escaping RoutableCompletion) -> Routable {
        switch(destination.routableType) {
        case is RandomViewController.Type:
            let randomViewController = RandomViewController(instanceIdentifier: destination.instanceIdentifier)
            self.navigationController?.pushViewController(randomViewController, animated: true)
            completionHandler()
            return randomViewController
        default: fatalError("Not supported")
        }
    }
    
    func pop(destination: Destination, completionHandler: @escaping RoutableCompletion) {
        switch(destination.routableType) {
        case is RandomViewController.Type:
            let currentRandomViewController = self.navigationController?.viewControllers.last
            if let currentRandomViewController = currentRandomViewController as? RandomViewController {
                if currentRandomViewController.instanceIdentifier == destination.instanceIdentifier {
                    _ = self.navigationController?.popViewController(animated: true)
                }
            }
        completionHandler()
        default: fatalError("Not supported")
        }
    }
    
}
