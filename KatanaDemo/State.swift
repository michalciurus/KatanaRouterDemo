//
//  State.swift
//  KatanaDemo
//
//  Created by Michal Ciurus on 06/02/17.
//  Copyright © 2017 Michal Ciurus. All rights reserved.
//

import Katana
import KatanaRouter

struct CounterState: State, RoutableState {
    var navigationState: NavigationState = NavigationState()
}
