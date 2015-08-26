//
//  GMPSwiftTests.swift
//  GMPSwiftTests
//
//  Created by José María Gómez Cama on 26/8/15.
//  Copyright (c) 2015 José María Gómez Cama. All rights reserved.
//

import Cocoa
import XCTest
import GMPSwift

class GMPSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testInitBase() {
        // This is an example of a functional test case.
        var value = IntMP()
        
        XCTAssert(value == 0, "Pass")
    }
    
    func testInitInitialValue() {
        // This is an example of a functional test case.
        let check = 36
        var value = IntMP(check)
        
        XCTAssert(value == check, "Pass")
    }
    
    func testInitIntMaxMax() {
        // This is an example of a functional test case.
        var check = IntMax.max
        var value = IntMP(check)
        
        XCTAssert(value.description == check.description, "Pass")
    }
    
    func testInitIntMaxMin() {
        // This is an example of a functional test case.
        var check = IntMax.min
        var value = IntMP(check)
        
        XCTAssert(value.description == check.description, "Pass")
    }
    
    func testDescriptionVar() {
        // This is an example of a functional test case.
        var value = IntMP(36)
        
        XCTAssert(value.description == 36.description, "Pass")
    }
    
    func testDescriptionFunc() {
        // This is an example of a functional test case.
        var value = IntMP(36)
        
        XCTAssert(value.description(16) == "24", "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
