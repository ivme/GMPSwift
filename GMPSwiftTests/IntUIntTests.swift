/* IntMP tests for GNU multiple precision on Switch.   -*- mode: c -*-

Copyright 2015 Jose Maria Gomez Cama

This file is part of the GMPSwitch Library.

The GMPSwitch Library is free software; you can redistribute it and/or modify
it under the terms of either:

* the GNU Lesser General Public License as published by the Free
Software Foundation; either version 3 of the License, or (at your
option) any later version.

or

* the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any
later version.

or both in parallel, as here.

The GMPSwitch Library is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

You should have received copies of the GNU General Public License and the
GNU Lesser General Public License along with the GNU MP Library.  If not,
see https://www.gnu.org/licenses/.  */

import XCTest
import GMPSwift

class IntUIntTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIntInt() {
        // This is an example of a functional test case.
        let a = 3
        let aMP = IntMP(a)
        let aInt = Int(aMP)
        
        XCTAssert(aMP == aInt, "Pass")
        XCTAssert(aInt == a, "Pass")
    }
    
    func testUIntUInt() {
        // This is an example of a functional test case.
        let a: UInt = 3
        let aMP = IntMP(a)
        let aInt = UInt(aMP)
        
        XCTAssert(aMP == aInt, "Pass")
        XCTAssert(aInt == a, "Pass")
    }
    
    func testPower() {
        // This is an example of a functional test case.
        var a = 3
        var b = -5
        var c: UInt = 4
        
        var acc = 1
        for i in 0 ..< c {
            acc *= a
        }
        
        XCTAssert(UInt(a) ** c == UInt(acc), "Pass")
        
        acc = 1
        for i in 0 ..< a {
            acc *= b
        }
        var powN = Int(b) ** Int(a)
        
        XCTAssert(powN == Int(acc), "Pass")
        
        a = 2
        b = -1
        
        powN = Int(a) ** Int(b)
        
        XCTAssert(powN == 0, "Pass")
        
        a = 2
        b = 0
        
        powN = Int(a) ** Int(b)
        var powP = UInt(a) ** UInt(b)
        
        XCTAssert(powN == 1, "Pass")
        XCTAssert(powP == 1, "Pass")
        
        a = 0
        b = 2
        
        powN = Int(a) ** Int(b)
        powP = UInt(a) ** UInt(b)
        
        XCTAssert(powN == 0, "Pass")
        XCTAssert(powP == 0, "Pass")
        
        a = 2
        b = 2
        
        acc = 1
        for i in 0 ..< a {
            acc *= b
        }
        powN = Int(b) ** Int(a)
        powP = UInt(b) ** UInt(a)
        
        XCTAssert(powN == Int(acc), "Pass")
        XCTAssert(powP == UInt(acc), "Pass")
        
        a = -2
        b = 0
        
        powN = Int(a) ** Int(b)
        
        XCTAssert(powN == 1, "Pass")
        
        a = 0
        b = 0
        
        powN = Int(a) ** Int(b)
        powP = UInt(a) ** UInt(b)
        
        XCTAssert(powN == 1, "Pass")
        XCTAssert(powP == 1, "Pass")
    }

    func testIntCollectionGet() {
        // This is an example of a functional test case.
        let a = random()
        var i = a.startIndex
        
        for val in a {
            var check = a[i++]
            XCTAssert(val == check, "Pass")
        }

        XCTAssert(i == a.endIndex, "Pass")
    }

    func testIntCollectionSet() {
        // This is an example of a functional test case.
        var a = random()
        var i = a.startIndex
        
        for val in a {
            a[i] = !(val!)
            var check = a[i++]
            XCTAssert(val != check, "Pass")
        }
        
        XCTAssert(i == a.endIndex, "Pass")
    }

    func testIntSliceGet() {
        // This is an example of a functional test case.
        let a = random()
        let startIndex = 7
        let endIndex = 12
        let range = startIndex..<endIndex
        let b = a[range]

        var i = 0

        for j in range {
            var checkA = a[j]!
            var checkB = b[i++]!
            XCTAssert(checkA == checkB, "Pass")
        }
        
        XCTAssert(i == endIndex - startIndex , "Pass")
    }
    
    func testIntSliceSet() {
        // This is an example of a functional test case.
        var a = random()
        let startIndex = 7
        let endIndex = 12
        let range = startIndex..<endIndex
        let b = ~a[range]
        a[range] = b
        
        var i = 0
        
        for j in range {
            var checkA = a[j]!
            var checkB = b[i++]!
            XCTAssert(checkA == checkB, "Pass")
        }
        
        XCTAssert(i == endIndex - startIndex , "Pass")
    }

    func testUIntCollectionGet() {
        // This is an example of a functional test case.
        let a = UInt(random())
        var i = a.startIndex
        
        for val in a {
            var check = a[i++]
            XCTAssert(val == check, "Pass")
        }
        
        XCTAssert(i == a.endIndex, "Pass")
    }
    
    func testUIntCollectionSet() {
        // This is an example of a functional test case.
        var a = UInt(random())
        var i = a.startIndex
        
        for val in a {
            a[i] = !(val!)
            var check = a[i++]
            XCTAssert(val != check, "Pass")
        }
        
        XCTAssert(i == a.endIndex, "Pass")
    }
    
    func testUIntSliceGet() {
        // This is an example of a functional test case.
        let a = UInt(random())
        let startIndex = 7
        let endIndex = 12
        let range = startIndex..<endIndex
        let b = a[range]
        
        var i = 0
        
        for j in range {
            var checkA = a[j]!
            var checkB = b[i++]!
            XCTAssert(checkA == checkB, "Pass")
        }
        
        XCTAssert(i == endIndex - startIndex , "Pass")
    }
    
    func testUIntSliceSet() {
        // This is an example of a functional test case.
        var a = UInt(random())
        let startIndex = 7
        let endIndex = 12
        let range = startIndex..<endIndex
        let b = ~a[range]
        a[range] = b
        
        var i = 0
        
        for j in range {
            var checkA = a[j]!
            var checkB = b[i++]!
            XCTAssert(checkA == checkB, "Pass")
        }
        
        XCTAssert(i == endIndex - startIndex , "Pass")
    }
}
