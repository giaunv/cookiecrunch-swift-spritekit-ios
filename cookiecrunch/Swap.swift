//
//  Swap.swift
//  cookiecrunch
//
//  Created by giaunv on 3/9/15.
//  Copyright (c) 2015 366. All rights reserved.
//

struct Swap: Printable {
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie){
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String{
        return "swap \(cookieA) with \(cookieB)";
    }
}
