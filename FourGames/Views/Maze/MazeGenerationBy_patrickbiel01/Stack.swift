//
//  Stack.swift
//
//  Created by Patrick Biel & Ximing Yang on 2019-05-04.
//  Copyright © 2019 YBMW. All rights reserved.
//

struct Stack<Element> {
    var isEmpty: Bool {
        return array.isEmpty
    }
    
    var count: Int {
        return array.count
    }
    
    fileprivate var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
}
