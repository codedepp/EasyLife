//
//  GCD.swift
//  EasyLife
//
//  Created by Lee Arromba on 07/06/2017.
//  Copyright © 2015 Lee Arromba. All rights reserved.
//

import Foundation

func performAfterDelay(_ delay:Double, closure: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}