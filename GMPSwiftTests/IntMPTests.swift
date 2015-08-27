/* IntMP tests for GNU multiple precision over Switch.   -*- mode: c -*-

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

import Cocoa
import XCTest
import GMPSwift

class IntMPTests: XCTestCase {
    
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
    
    func testHashable() {
        // This is an example of a functional test case.
        var check = IntMP(value: IntMax.min, bitcnt: 130)
        var value = IntMP(value: IntMax.min, bitcnt: 200)

        XCTAssert(check.description == value.description, "Pass")
        XCTAssert(check.hashValue == value.hashValue, "Pass")
        
        value = IntMP(value: IntMax.max, bitcnt: 200)
        
        XCTAssert(check.description != value.description, "Pass")
        XCTAssert(check.hashValue != value.hashValue, "Pass")
    }
    
    func testEqual() {
        // This is an example of a functional test case.
        let lhsInt = 36
        let rhsInt = 14
        let lhsMP = IntMP(36)
        let rhsMP = IntMP(14)
        
        XCTAssert(!(lhsMP == rhsMP), "Pass")
        XCTAssert(!(lhsMP == rhsInt), "Pass")
        XCTAssert(!(lhsInt == rhsMP), "Pass")
        XCTAssert(lhsMP == lhsMP, "Pass")
        XCTAssert(rhsMP == rhsMP, "Pass")
    }
    
    func testGreaterEqual() {
        // This is an example of a functional test case.
        let lhsInt = 36
        let rhsInt = 14
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert(lhsMP >= rhsMP, "Pass")
        XCTAssert(lhsMP >= rhsInt, "Pass")
        XCTAssert(lhsInt >= rhsMP, "Pass")
        XCTAssert(lhsMP >= lhsMP, "Pass")
        XCTAssert(rhsMP >= rhsMP, "Pass")
        XCTAssert(!(rhsMP >= lhsMP), "Pass")
        XCTAssert(!(rhsInt >= lhsMP), "Pass")
        XCTAssert(!(rhsMP >= lhsInt), "Pass")
    }
    
    func testLesserEqual() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert(lhsMP <= rhsMP, "Pass")
        XCTAssert(lhsMP <= rhsInt, "Pass")
        XCTAssert(lhsInt <= rhsMP, "Pass")
        XCTAssert(lhsMP <= lhsMP, "Pass")
        XCTAssert(rhsMP <= rhsMP, "Pass")
        XCTAssert(!(rhsMP <= lhsMP), "Pass")
        XCTAssert(!(rhsInt <= lhsMP), "Pass")
        XCTAssert(!(rhsMP <= lhsInt), "Pass")
    }
    
    func testGreater() {
        // This is an example of a functional test case.
        let lhsInt = 36
        let rhsInt = 14
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert(lhsMP > rhsMP, "Pass")
        XCTAssert(lhsMP > rhsInt, "Pass")
        XCTAssert(lhsInt > rhsMP, "Pass")
        XCTAssert(!(lhsMP > lhsMP), "Pass")
        XCTAssert(!(rhsMP > rhsMP), "Pass")
        XCTAssert(!(rhsMP > lhsMP), "Pass")
        XCTAssert(!(rhsInt > lhsMP), "Pass")
        XCTAssert(!(rhsMP > lhsInt), "Pass")
    }
    
    func testLesser() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert(lhsMP < rhsMP, "Pass")
        XCTAssert(lhsMP < rhsInt, "Pass")
        XCTAssert(lhsInt < rhsMP, "Pass")
        XCTAssert(!(lhsMP < lhsMP), "Pass")
        XCTAssert(!(rhsMP < rhsMP), "Pass")
        XCTAssert(!(rhsMP < lhsMP), "Pass")
        XCTAssert(!(rhsInt < lhsMP), "Pass")
        XCTAssert(!(rhsMP < lhsInt), "Pass")
    }
    
    func testAnd() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert((lhsMP & rhsMP) == (lhsInt & rhsInt), "Pass")
        XCTAssert((lhsMP & rhsInt) == (lhsInt & rhsInt), "Pass")
        XCTAssert((lhsInt & rhsMP) == (lhsInt & rhsInt), "Pass")
    }
    
    func testOr() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert((lhsMP | rhsMP) == (lhsInt | rhsInt), "Pass")
        XCTAssert((lhsMP | rhsInt) == (lhsInt | rhsInt), "Pass")
        XCTAssert((lhsInt | rhsMP) == (lhsInt | rhsInt), "Pass")
    }
    
    func testXor() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert((lhsMP ^ rhsMP) == (lhsInt ^ rhsInt), "Pass")
        XCTAssert((lhsMP ^ rhsInt) == (lhsInt ^ rhsInt), "Pass")
        XCTAssert((lhsInt ^ rhsMP) == (lhsInt ^ rhsInt), "Pass")
    }
    
    func testComp() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert((~lhsMP) == (~lhsInt), "Pass")
        XCTAssert((~rhsMP) == (~rhsInt), "Pass")
    }
    
    func testAdd() {
        // This is an example of a functional test case.
        let lhsPInt = 27
        let rhsPInt = 56
        let lhsPMP = IntMP(lhsPInt)
        let rhsPMP = IntMP(rhsPInt)
        let nInt = -33
        
        XCTAssert((lhsPMP + rhsPMP) == (lhsPInt + rhsPInt), "Pass")
        XCTAssert((lhsPMP + rhsPInt) == (lhsPInt + rhsPInt), "Pass")
        XCTAssert((lhsPInt + rhsPMP) == (lhsPInt + rhsPInt), "Pass")
        XCTAssert((lhsPMP + nInt) == (lhsPInt + nInt), "Pass")
        XCTAssert((nInt + rhsPMP) == (nInt + rhsPInt), "Pass")
    }
    
    func testSub() {
        // This is an example of a functional test case.
        let lhsPInt = 27
        let rhsPInt = 56
        let lhsPMP = IntMP(lhsPInt)
        let rhsPMP = IntMP(rhsPInt)
        let nInt = -33
        
        XCTAssert((lhsPMP - rhsPMP) == (lhsPInt - rhsPInt), "Pass")
        XCTAssert((lhsPMP - rhsPInt) == (lhsPInt - rhsPInt), "Pass")
        XCTAssert((lhsPInt - rhsPMP) == (lhsPInt - rhsPInt), "Pass")
        XCTAssert((lhsPMP - nInt) == (lhsPInt - nInt), "Pass")
        XCTAssert((nInt - rhsPMP) == (nInt - rhsPInt), "Pass")
    }
    
    func testMul() {
        // This is an example of a functional test case.
        let lhsPInt = 27
        let rhsPInt = 56
        let lhsPMP = IntMP(lhsPInt)
        let rhsPMP = IntMP(rhsPInt)
        let nInt = -33
        
        XCTAssert((lhsPMP * rhsPMP) == (lhsPInt * rhsPInt), "Pass")
        XCTAssert((lhsPMP * rhsPInt) == (lhsPInt * rhsPInt), "Pass")
        XCTAssert((lhsPInt * rhsPMP) == (lhsPInt * rhsPInt), "Pass")
        XCTAssert((lhsPMP * nInt) == (lhsPInt * nInt), "Pass")
        XCTAssert((nInt * rhsPMP) == (nInt * rhsPInt), "Pass")
    }
    
    func testDiv() {
        // This is an example of a functional test case.
        let lhsPInt = 27
        let rhsPInt = 56
        let lhsPMP = IntMP(lhsPInt)
        let rhsPMP = IntMP(rhsPInt)
        let nInt = -33
        
        XCTAssert((lhsPMP / rhsPMP) == (lhsPInt / rhsPInt), "Pass")
        XCTAssert((lhsPMP / rhsPInt) == (lhsPInt / rhsPInt), "Pass")
        XCTAssert((lhsPInt / rhsPMP) == (lhsPInt / rhsPInt), "Pass")
        XCTAssert((lhsPMP / nInt) == (lhsPInt / nInt), "Pass")
        XCTAssert((nInt / rhsPMP) == (nInt / rhsPInt), "Pass")
    }
    
    func testMod() {
        // This is an example of a functional test case.
        let lhsPInt = 27
        let rhsPInt = 56
        let lhsPMP = IntMP(lhsPInt)
        let rhsPMP = IntMP(rhsPInt)
        let nInt = -33
        
        XCTAssert((lhsPMP % rhsPMP) == (lhsPInt % rhsPInt), "Pass")
        XCTAssert((lhsPMP % rhsPInt) == (lhsPInt % rhsPInt), "Pass")
        XCTAssert((lhsPInt % rhsPMP) == (lhsPInt % rhsPInt), "Pass")
        XCTAssert((lhsPMP % nInt) == (lhsPInt % nInt), "Pass")
        XCTAssert((nInt % rhsPMP) == (nInt % rhsPInt), "Pass")
    }
    
    func testNeg() {
        // This is an example of a functional test case.
        let lhsInt = 27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert((-lhsMP) == (-lhsInt), "Pass")
        XCTAssert((-rhsMP) == (-rhsInt), "Pass")
    }
    
    func testDescriptionVar() {
        // This is an example of a functional test case.
        let value = IntMP(36)
        
        XCTAssert(value.description == 36.description, "Pass")
    }

    func testDescriptionFunc() {
        // This is an example of a functional test case.
        let value = IntMP(36)
        
        XCTAssert(value.description(16) == "24", "Pass")
    }
    
    func testToIntMax() {
        // This is an example of a functional test case.
        let max = IntMax.max
        let min = IntMax.min
        let maxMP = IntMP(max)
        let minMP = IntMP(min)
        
        XCTAssert(maxMP.toIntMax() == max, "Pass")
        XCTAssert(minMP.toIntMax() == min, "Pass")
    }

    func testIntInt() {
        // This is an example of a functional test case.
        let a = 3
        let aMP = IntMP(a)
        let aInt = Int(aMP)
        
        XCTAssert(aMP == aInt, "Pass")
        XCTAssert(aInt == a, "Pass")
    }
    
    func testDistanceTo() {
        // This is an example of a functional test case.
        let lhsInt = -27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        let distancelrMP = Int(lhsMP.distanceTo(rhsMP))
        let distancelrInt = lhsInt.distanceTo(rhsInt)
        let distancerlMP = Int(rhsMP.distanceTo(lhsMP))
        let distancerlInt = rhsInt.distanceTo(lhsInt)

        XCTAssert(distancelrMP == distancelrInt, "Pass")
        XCTAssert(distancerlMP == distancerlInt, "Pass")
    }
    
    func testAdvancedBy() {
        // This is an example of a functional test case.
        let lhsInt = -27
        let rhsInt = 56
        let lhsMP = IntMP(lhsInt)
        let rhsMP = IntMP(rhsInt)
        
        XCTAssert(lhsMP.advancedBy(rhsMP) == lhsInt.advancedBy(rhsInt), "Pass")
        XCTAssert(rhsMP.advancedBy(lhsMP) == rhsInt.advancedBy(lhsInt), "Pass")
    }
    
    func testAllZeros() {
        // This is an example of a functional test case.
        XCTAssert(IntMP.allZeros == 0, "Pass")
    }
    
    func testPredecessor() {
        // This is an example of a functional test case.
        let a = 3

        XCTAssert(IntMP(a).predecessor() == a.predecessor(), "Pass")
    }
    
    func testSuccessor() {
        // This is an example of a functional test case.
        let a = 3
        
        XCTAssert(IntMP(a).successor() == a.successor(), "Pass")
    }

    func testOverflow(){
        let max = IntMax.max
        let min = IntMax.min
        let maxMP = IntMP(max)
        let minMP = IntMP(min)
        
        let addResult = IntMP.addWithOverflow(maxMP, maxMP)
        let subResult = IntMP.subtractWithOverflow(minMP, maxMP)
        let mulResult = IntMP.multiplyWithOverflow(maxMP, minMP)
        let divResult = IntMP.divideWithOverflow(minMP, maxMP)
        let remResult = IntMP.remainderWithOverflow(maxMP, minMP)

        XCTAssert(addResult.0 == maxMP + maxMP, "Pass")
        XCTAssert(!addResult.overflow, "Pass")
        XCTAssert(subResult.0 == minMP - maxMP, "Pass")
        XCTAssert(!subResult.overflow, "Pass")
        XCTAssert(mulResult.0 == maxMP * minMP, "Pass")
        XCTAssert(!mulResult.overflow, "Pass")
        XCTAssert(divResult.0 == minMP / maxMP, "Pass")
        XCTAssert(!divResult.overflow, "Pass")
        XCTAssert(remResult.0 == maxMP % minMP, "Pass")
        XCTAssert(!remResult.overflow, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
