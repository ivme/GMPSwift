/* IntMP implementation for GNU multiple precision on Switch.   -*- mode: c -*-

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

import Swift

infix operator ** {
    associativity left
    precedence 160
}

public final class IntMP: SignedIntegerType{
    private var gmpz_p = mpz_ptr.alloc(1)
    private var _bitLength: Int? = nil
    
    public var bitLength: Int {
        var value = IntMP(self)
        
        if self.gmpz_p[0]._mp_size < 0 {
            __gmpz_neg(value.gmpz_p, value.gmpz_p)
        }
        
        var check = IntMP(1)
        var n = 0
        
        while(check <= value){
            __gmpz_mul_2exp(check.gmpz_p, check.gmpz_p, 1)
            n++
        }
        
        return n + 1
    }
    
    /// A type that can represent the number of steps between pairs of
    /// values.
    typealias Distance = IntMP
    
    /// Create an instance initialized to zero.
    public init() {
        __gmpz_init(gmpz_p)
    }

    /// Create an instance initialized to `value`.
    public init(_ value: Int) {
        __gmpz_init_set_si(gmpz_p, value)
    }
    
    public init(_ value: UInt) {
        __gmpz_init_set_ui(gmpz_p, value)
    }
    
    public init(_ value: IntMax) {
        __gmpz_init_set_si(gmpz_p, Int(value))
    }

    public required init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        var int = Int(_builtinIntegerLiteral: value)
        __gmpz_init_set_si(gmpz_p, int)
    }

    public init(value: Int, bitCnt: Int){
        __gmpz_init2(gmpz_p, mp_bitcnt_t(bitCnt))
        __gmpz_set_si(gmpz_p, value)
        _bitLength = bitCnt
    }
    
    public init(value: UInt, bitCnt: Int){
        __gmpz_init2(gmpz_p, mp_bitcnt_t(bitCnt))
        __gmpz_set_ui(gmpz_p, value)
        _bitLength = bitCnt
    }
    
    public init(value: IntMax, bitcnt: Int){
        __gmpz_init2(gmpz_p, mp_bitcnt_t(bitcnt))
        __gmpz_set_si(gmpz_p, Int(value))
    }

    public init(_ rawValue: IntMP){
        __gmpz_init_set(gmpz_p, rawValue.gmpz_p)
        _bitLength = rawValue._bitLength
    }

    /// Create an instance initialized to `value`.
    public required init(integerLiteral value: IntMP){
        __gmpz_init_set(gmpz_p, value.gmpz_p)
        _bitLength = value._bitLength
    }

    public var hashValue: Int {
        var size = __gmpz_size(gmpz_p)
        var limbs: UnsafePointer<UInt> = __gmpz_limbs_read(gmpz_p)
        var result: UInt = 0
        var tmp: UInt = 0

        for val in 0 ..< size {
            tmp = limbs[val]
            result ^= tmp
        }
        
        return result.hashValue
    }

    public var description: String {
        return String.fromCString(__gmpz_get_str(nil, 10, gmpz_p))!
    }

    public var debugDescription: String {
        return "IntMP(" + description + ")"
    }
    
    var quickLookObject: QuickLookObject? {
        return QuickLookObject.Text(description)
    }

    public func description(base: Int) -> String {
        return String.fromCString(__gmpz_get_str(nil, Int32(base), gmpz_p))!
    }
    
    public func distanceTo(other: IntMP) -> IntMP {
        var value = IntMP()

        __gmpz_sub(value.gmpz_p, other.gmpz_p, gmpz_p)

        return value
    }

    public func advancedBy(n: IntMP) -> IntMP {
        var result = IntMP()
        
        __gmpz_add(result.gmpz_p, gmpz_p, n.gmpz_p)
        
        return result
    }


    public static var allZeros: IntMP {
        return IntMP()
    }

    public func successor() -> IntMP {
        var result = IntMP()
        __gmpz_add_ui(result.gmpz_p, gmpz_p, 1)
        return result
    }

    public func predecessor() -> IntMP {
        var result = IntMP()
        __gmpz_sub_ui(result.gmpz_p, gmpz_p, 1)
        return result
    }
    
    public func toIntMax() -> IntMax {
        var value: IntMax = __gmpz_get_si(gmpz_p).toIntMax()
        return value
    }

    public func toInt() -> Int {
        return Int(__gmpz_get_si(gmpz_p))
    }

    public func toUInt() -> UInt {
        return UInt(__gmpz_get_ui(gmpz_p))
    }

    public static func addWithOverflow(lhs: IntMP, _ rhs: IntMP) -> (IntMP, overflow: Bool) {
        var result = IntMP()
        
        __gmpz_add(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
        
        return (result, false)
    }
    
    public static func subtractWithOverflow(lhs: IntMP, _ rhs: IntMP) -> (IntMP, overflow: Bool) {
        var result = IntMP()
    
        __gmpz_sub(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
        return (result, false)
    }

    public static func multiplyWithOverflow(lhs: IntMP, _ rhs: IntMP) -> (IntMP, overflow: Bool) {
        var result = IntMP()
        
        __gmpz_mul(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
        
        return (result, false)
    }

    public static func divideWithOverflow(lhs: IntMP, _ rhs: IntMP) -> (IntMP, overflow: Bool) {
        var result = IntMP()
        
        __gmpz_tdiv_q(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
        
        return (result, false)
    }
    
    public static func remainderWithOverflow(lhs: IntMP, _ rhs: IntMP) -> (IntMP, overflow: Bool) {
        var result = IntMP()
        
        __gmpz_tdiv_r(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
        
        return (result, false)
    }

    deinit{
        __gmpz_clear(gmpz_p)
        gmpz_p.destroy()
    }
}

public func ==(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) == 0
}

public func ==(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) == 0
}

public func ==(lhs: UInt, rhs: IntMP) -> Bool {
    return __gmpz_cmp_ui(rhs.gmpz_p, lhs) == 0
}

public func ==(lhs: IntMP, rhs: UInt) -> Bool {
    return __gmpz_cmp_ui(lhs.gmpz_p, rhs) == 0
}

public func ==(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func <=(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) <= 0
}


public func <=(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) <= 0
}

public func <=(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) >= 0
}

public func <=(lhs: IntMP, rhs: UInt) -> Bool {
    return __gmpz_cmp_ui(lhs.gmpz_p, rhs) <= 0
}

public func <=(lhs: UInt, rhs: IntMP) -> Bool {
    return __gmpz_cmp_ui(rhs.gmpz_p, lhs) >= 0
}

public func >=(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) >= 0
}


public func >=(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) >= 0
}

public func >=(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) <= 0
}

public func >=(lhs: IntMP, rhs: UInt) -> Bool {
    return __gmpz_cmp_ui(lhs.gmpz_p, rhs) >= 0
}

public func >=(lhs: UInt, rhs: IntMP) -> Bool {
    return __gmpz_cmp_ui(rhs.gmpz_p, lhs) <= 0
}

public func <(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) < 0
}

public func <(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) < 0
}

public func <(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) > 0
}

public func <(lhs: IntMP, rhs: UInt) -> Bool {
    return __gmpz_cmp_ui(lhs.gmpz_p, rhs) < 0
}

public func <(lhs: UInt, rhs: IntMP) -> Bool {
    return __gmpz_cmp_ui(rhs.gmpz_p, lhs) > 0
}

public func >(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) > 0
}

public func >(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) > 0
}

public func >(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) < 0
}

public func >(lhs: IntMP, rhs: UInt) -> Bool {
    return __gmpz_cmp_ui(lhs.gmpz_p, rhs) > 0
}

public func >(lhs: UInt, rhs: IntMP) -> Bool {
    return __gmpz_cmp_ui(rhs.gmpz_p, lhs) < 0
}

public func &(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_and(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func &(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_and(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func &(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_and(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func &(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_and(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func &(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_and(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func |(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_ior(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func |(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_ior(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func |(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_ior(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func |(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_ior(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func |(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_ior(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func ^(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_xor(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func ^(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_xor(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func ^(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_xor(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func ^(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_xor(result.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return result
}

public func ^(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_xor(result.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return result
}

public prefix func ~(x: IntMP) -> IntMP {
    var result = IntMP()

    __gmpz_com(result.gmpz_p, x.gmpz_p)
    result._bitLength = x._bitLength
    
    return result
}

public func +(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_add(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func +(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    
    if rhs < 0 {
        __gmpz_sub_ui(result.gmpz_p, lhs.gmpz_p, UInt(-rhs))
    } else {
        __gmpz_add_ui(result.gmpz_p, lhs.gmpz_p, UInt(rhs))
    }
    
    return result
}

public func +(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    if lhs < 0 {
        __gmpz_ui_sub(result.gmpz_p, UInt(-lhs), rhs.gmpz_p)
        __gmpz_neg(result.gmpz_p, result.gmpz_p)
    } else {
        __gmpz_add_ui(result.gmpz_p, rhs.gmpz_p, UInt(lhs))
    }
    
    return result
}

public func +(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    
    __gmpz_add_ui(result.gmpz_p, lhs.gmpz_p, rhs)
    
    return result
}

public func +(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_add_ui(result.gmpz_p, rhs.gmpz_p, lhs)
    
    return result
}

public func -(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_sub(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func -(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    
    if rhs < 0 {
        __gmpz_add_ui(result.gmpz_p, lhs.gmpz_p, UInt(-rhs))
    } else {
        __gmpz_sub_ui(result.gmpz_p, lhs.gmpz_p, UInt(rhs))
    }
    
    return result
}

public func -(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    if lhs < 0 {
        __gmpz_add_ui(result.gmpz_p, rhs.gmpz_p, UInt(-lhs))
        __gmpz_neg(result.gmpz_p, result.gmpz_p)
    } else {
        __gmpz_ui_sub(result.gmpz_p, UInt(lhs), rhs.gmpz_p)
    }
    
    return result
}

public func -(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    
    __gmpz_sub_ui(result.gmpz_p, lhs.gmpz_p, rhs)
    
    return result
}

public func -(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_ui_sub(result.gmpz_p, lhs, rhs.gmpz_p)
    
    return result
}

public func *(lhs: IntMP, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_mul(result.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return result
}

public func *(lhs: IntMP, rhs: Int) -> IntMP {
    var result = IntMP()
    
    __gmpz_mul_si(result.gmpz_p, lhs.gmpz_p, rhs)
    
    return result
}

public func *(lhs: Int, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_mul_si(result.gmpz_p, rhs.gmpz_p, lhs)
    
    return result
}

public func *(lhs: IntMP, rhs: UInt) -> IntMP {
    var result = IntMP()
    
    __gmpz_mul_ui(result.gmpz_p, lhs.gmpz_p, rhs)
    
    return result
}

public func *(lhs: UInt, rhs: IntMP) -> IntMP {
    var result = IntMP()
    
    __gmpz_mul_ui(result.gmpz_p, rhs.gmpz_p, lhs)
    
    return result
}

public func /(lhs: IntMP, rhs: IntMP) -> IntMP {
    var q = IntMP()
    
    __gmpz_tdiv_q(q.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func /(lhs: IntMP, rhs: Int) -> IntMP {
    var q = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_q(q.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return q
}

public func /(lhs: Int, rhs: IntMP) -> IntMP {
    var q = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_tdiv_q(q.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func /(lhs: IntMP, rhs: UInt) -> IntMP {
    var q = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_q(q.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return q
}

public func /(lhs: UInt, rhs: IntMP) -> IntMP {
    var q = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_tdiv_q(q.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func %(lhs: IntMP, rhs: IntMP) -> IntMP {
    var q = IntMP()
    
    __gmpz_tdiv_r(q.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func %(lhs: IntMP, rhs: Int) -> IntMP {
    var q = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_r(q.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return q
}

public func %(lhs: Int, rhs: IntMP) -> IntMP {
    var q = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_tdiv_r(q.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func %(lhs: IntMP, rhs: UInt) -> IntMP {
    var q = IntMP()
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_r(q.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
    
    return q
}

public func %(lhs: UInt, rhs: IntMP) -> IntMP {
    var q = IntMP()
    var lhsMP = IntMP(lhs)
    
    __gmpz_tdiv_r(q.gmpz_p, lhsMP.gmpz_p, rhs.gmpz_p)
    
    return q
}

public func &=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_and(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func &=(inout lhs: IntMP, rhs: Int) {
    let rhsMP = IntMP(rhs)
    __gmpz_and(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func &=(inout lhs: IntMP, rhs: UInt) {
    let rhsMP = IntMP(rhs)
    __gmpz_and(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func |=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_ior(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func |=(inout lhs: IntMP, rhs: Int) {
    let rhsMP = IntMP(rhs)
    __gmpz_ior(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func |=(inout lhs: IntMP, rhs: UInt) {
    let rhsMP = IntMP(rhs)
    __gmpz_ior(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func ^=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_xor(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func ^=(inout lhs: IntMP, rhs: Int) {
    let rhsMP = IntMP(rhs)
    __gmpz_xor(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func ^=(inout lhs: IntMP, rhs: UInt) {
    let rhsMP = IntMP(rhs)
    __gmpz_xor(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func +=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_add(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func +=(inout lhs: IntMP, rhs: Int) {
    if rhs < 0 {
        __gmpz_sub_ui(lhs.gmpz_p, lhs.gmpz_p, UInt(-rhs))
    } else {
        __gmpz_add_ui(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
    }
}

public func +=(inout lhs: IntMP, rhs: UInt) {
    __gmpz_add_ui(lhs.gmpz_p, lhs.gmpz_p, rhs)
}

public func -=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_sub(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func -=(inout lhs: IntMP, rhs: Int) {
    if rhs < 0 {
        __gmpz_add_ui(lhs.gmpz_p, lhs.gmpz_p, UInt(-rhs))
    } else {
        __gmpz_sub_ui(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
    }
}

public func -=(inout lhs: IntMP, rhs: UInt) {
    __gmpz_sub_ui(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
}

public func *=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_mul(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func *=(inout lhs: IntMP, rhs: Int) {
    __gmpz_mul_si(lhs.gmpz_p, lhs.gmpz_p, rhs)
}

public func *=(inout lhs: IntMP, rhs: UInt) {
    __gmpz_mul_ui(lhs.gmpz_p, lhs.gmpz_p, rhs)
}

public func /=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_tdiv_q(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func /=(inout lhs: IntMP, rhs: Int) {
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_q(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func /=(inout lhs: IntMP, rhs: UInt) {
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_q(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func %=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_tdiv_r(lhs.gmpz_p, lhs.gmpz_p, rhs.gmpz_p)
}

public func %=(inout lhs: IntMP, rhs: Int) {
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_r(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func %=(inout lhs: IntMP, rhs: UInt) {
    var rhsMP = IntMP(rhs)
    
    __gmpz_tdiv_r(lhs.gmpz_p, lhs.gmpz_p, rhsMP.gmpz_p)
}

public func <<(lhs: IntMP, rhs: IntMP) -> IntMP {
    var q = IntMP()
    
    __gmpz_mul_2exp(q.gmpz_p, lhs.gmpz_p, UInt(rhs))
    
    return q
}

public func <<(lhs: IntMP, rhs: Int) -> IntMP {
    var q = IntMP()
    
    __gmpz_mul_2exp(q.gmpz_p, lhs.gmpz_p, UInt(rhs))
    
    return q
}

public func <<(lhs: IntMP, rhs: UInt) -> IntMP {
    var q = IntMP()
    
    __gmpz_mul_2exp(q.gmpz_p, lhs.gmpz_p, rhs)
    
    return q
}

public func >>(lhs: IntMP, rhs: IntMP) -> IntMP {
    var q = IntMP()
    
    __gmpz_fdiv_q_2exp(q.gmpz_p, lhs.gmpz_p, UInt(rhs))
    
    return q
}

public func >>(lhs: IntMP, rhs: Int) -> IntMP {
    var q = IntMP()
    
    __gmpz_fdiv_q_2exp(q.gmpz_p, lhs.gmpz_p, UInt(rhs))
    
    return q
}

public func >>(lhs: IntMP, rhs: UInt) -> IntMP {
    var q = IntMP()
    
    __gmpz_fdiv_q_2exp(q.gmpz_p, lhs.gmpz_p, rhs)
    
    return q
}

public func <<=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_mul_2exp(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
}

public func <<=(inout lhs: IntMP, rhs: Int) {
    __gmpz_mul_2exp(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
}

public func <<=(inout lhs: IntMP, rhs: UInt) {
    __gmpz_mul_2exp(lhs.gmpz_p, lhs.gmpz_p, rhs)
}

public func >>=(inout lhs: IntMP, rhs: IntMP) {
    __gmpz_fdiv_q_2exp(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
}

public func >>=(inout lhs: IntMP, rhs: Int) {
    __gmpz_fdiv_q_2exp(lhs.gmpz_p, lhs.gmpz_p, UInt(rhs))
}

public func >>=(inout lhs: IntMP, rhs: UInt) {
    __gmpz_fdiv_q_2exp(lhs.gmpz_p, lhs.gmpz_p, rhs)
}

extension IntMP: MutableSliceable {
    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        if _bitLength == nil {
            return Int.max
        } else {
            return _bitLength!
        }
    }

    func wrap(index: Int) {
        var result = __gmpz_tstbit(gmpz_p, UInt(index)) > 0 ? IntMP(-1) : IntMP(0)
        let initResult = Int(result)
        var mask = IntMP(1)
        var cmpMask = IntMP()
        var otherBits = IntMP()
        
        __gmpz_mul_2exp(mask.gmpz_p, mask.gmpz_p, UInt(index - 1))
        __gmpz_sub_ui(mask.gmpz_p, mask.gmpz_p, 1)
        
        __gmpz_com(cmpMask.gmpz_p, mask.gmpz_p)
        __gmpz_and(result.gmpz_p, result.gmpz_p, cmpMask.gmpz_p)
        __gmpz_and(otherBits.gmpz_p, self.gmpz_p, mask.gmpz_p)
        __gmpz_ior(self.gmpz_p, result.gmpz_p, otherBits.gmpz_p)
    }

    public subscript (position: Int) -> Bool? {
        get {
            if position < startIndex {
                return nil
            }
            
            if _bitLength == nil || position < _bitLength! {
                return Bool(Int(__gmpz_tstbit(gmpz_p, UInt(position))))
            } else {
                return nil
            }
        }
        
        set(newValue) {
            var value = newValue!
            let endBit = endIndex
            if position < endIndex {
                if value {
                    __gmpz_setbit(gmpz_p, UInt(position))
                } else {
                    __gmpz_clrbit(gmpz_p, UInt(position))
                }
            }
            
            if position == (endBit - 1) {
                wrap(position)
            }
        }
    }
    
    public subscript (slice: Range<Int>) -> IntMP {
        get {
            var i = slice.endIndex
            var j = slice.startIndex
            
            if i <= j {
                return 0
            }
            
            if i > endIndex {
                i = endIndex
            }
            
            if j < startIndex {
                j = startIndex
            }
            
            var val = IntMP(self)
            let delta = i - j
            
            var disp = j - self.startIndex
            
            if disp > 0 {
                __gmpz_fdiv_q_2exp(val.gmpz_p, self.gmpz_p, UInt(disp))
            } else {
                __gmpz_mul_2exp(val.gmpz_p, self.gmpz_p, UInt(-disp))
            }
            
            if delta < self.endIndex {
                var mask = IntMP(1)
                
                __gmpz_mul_2exp(mask.gmpz_p, mask.gmpz_p, UInt(delta))
                __gmpz_sub_ui(mask.gmpz_p, mask.gmpz_p, 1)
                __gmpz_and(val.gmpz_p, val.gmpz_p, mask.gmpz_p)
            }

            val._bitLength = delta

            return val
        }
        
        set(newValue) {
            var i = slice.endIndex
            var j = slice.startIndex
            
            if i > j {
                if i > endIndex {
                    i = endIndex
                }
                
                if j < startIndex {
                    j = startIndex
                }
                
                var delta = i - j
                
                var mask = IntMP(1)
                
                __gmpz_mul_2exp(mask.gmpz_p, mask.gmpz_p, UInt(delta))
                __gmpz_sub_ui(mask.gmpz_p, mask.gmpz_p, 1)
                
                var filter: IntMP = 0

                __gmpz_mul_2exp(filter.gmpz_p, mask.gmpz_p, UInt(j - self.startIndex))
                __gmpz_com(filter.gmpz_p, filter.gmpz_p)
                __gmpz_and(self.gmpz_p, self.gmpz_p, filter.gmpz_p)

                let filterInt = Int(filter)
                let filteredInt = Int(self)
                
                var value: IntMP = 0
                
                __gmpz_and(value.gmpz_p, newValue.gmpz_p, mask.gmpz_p)
                __gmpz_mul_2exp(value.gmpz_p, value.gmpz_p, UInt(j - self.startIndex))
                __gmpz_ior(self.gmpz_p, self.gmpz_p, value.gmpz_p)
                
                let newValueInt = Int(newValue)
                let valueInt = Int(value)
                let maskInt = Int(mask)
                let finalInt = Int(self)

                if i == endIndex {
                    wrap(i - 1)
                }
            }
        }
    }
    
    public func generate() -> GeneratorOf<Bool?> {
        var index = 0
        var value = IntMP(self)
        let valueInt = Int(value)
        let _endIndex = _bitLength ?? bitLength
        return GeneratorOf {
            if index < _endIndex {
                var result = Bool(Int(__gmpz_tstbit(value.gmpz_p, UInt(index))))
                index++
                return result
            } else {
                return nil
            }
        }
    }
}

public func **(base: IntMP, exp: IntMP) -> (IntMP) {
    var result = IntMP()
    
    if exp > 0 {
        if base >= 0 {
            __gmpz_pow_ui(result.gmpz_p, base.gmpz_p, UInt(exp))
        } else {
            __gmpz_pow_ui(result.gmpz_p, (-base).gmpz_p, UInt(exp))
            
            if exp & 1 == 1 {
                __gmpz_neg(result.gmpz_p, result.gmpz_p)
            }
        }
    } else if exp < 0 {
        if base == 1 {
            return IntMP(1)
        } else {
            return IntMP(0)
        }
    } else {
        return IntMP(1)
    }
    
    return result
}
