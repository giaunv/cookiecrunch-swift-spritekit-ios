//
//  Swap.swift
//  cookiecrunch
//
//  Created by giaunv on 3/9/15.
//  Copyright (c) 2015 366. All rights reserved.
//

struct Swap: Printable, Hashable {
    let cookieA: Cookie
    let cookieB: Cookie
    
    init(cookieA: Cookie, cookieB: Cookie){
        self.cookieA = cookieA
        self.cookieB = cookieB
    }
    
    var description: String{
        return "swap \(cookieA) with \(cookieB)";
    }
    
    var hashValue: Int{
        return cookieA.hashValue ^ cookieB.hashValue
    }
}

func ==(lhs: Swap, rhs: Swap) -> Bool{
    return (lhs.cookieA == rhs.cookieA && lhs.cookieB == rhs.cookieB) || (lhs.cookieB == rhs.cookieA && lhs.cookieA == rhs.cookieB)
}
