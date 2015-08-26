//
//  BigInt.swift
//  TestGMP
//
//  Created by José María Gómez Cama on 21/8/15.
//  Copyright (c) 2015 José María Gómez Cama. All rights reserved.
//

import Swift

public final class IntMP: SignedIntegerType{
    var gmpz_p = mpz_ptr.alloc(1)
    
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
    
    public init(_ value: IntMax) {
        __gmpz_init_set_si(gmpz_p, Int(value))
    }

    public required init(_builtinIntegerLiteral value: _MaxBuiltinIntegerType) {
        var int = Int(_builtinIntegerLiteral: value)
        __gmpz_init_set_si(gmpz_p, int)
    }

    public init(value: IntMax, bitcnt: Int){
        __gmpz_init2(gmpz_p, mp_bitcnt_t(bitcnt))
        __gmpz_set_si(gmpz_p, Int(value))
    }

    public init(rawValue: IntMP){
        __gmpz_init_set(gmpz_p, rawValue.gmpz_p)
    }

    /// Create an instance initialized to `value`.
    public required init(integerLiteral value: IntMP){
        __gmpz_init_set(gmpz_p, value.gmpz_p)
    }

    public var hashValue: Int {
        var size = __gmpz_size(gmpz_p)
        var limbs: UnsafePointer<UInt> = __gmpz_limbs_read(gmpz_p)
        var result: UInt = 0

        for val in 0 ..< size {
            result ^= limbs[val]
        }
        
        return Int(result)
    }

    public var description: String {
        return String.fromCString(__gmpz_get_str(nil, 10, gmpz_p))!
    }

    public func description(base: Int) -> String {
        return String.fromCString(__gmpz_get_str(nil, Int32(base), gmpz_p))!
    }
    
    public func distanceTo(other: IntMP) -> IntMP {
        var value = IntMP()
        __gmpz_sub(value.gmpz_p, self.gmpz_p, other.gmpz_p)

        return value
    }

    public func advancedBy(n: IntMP) -> Self {
        return self
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

public func ==(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func <=(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) == 0
}


public func <=(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) == 0
}

public func <=(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func >=(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) == 0
}


public func >=(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) == 0
}

public func >=(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func <(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) == 0
}


public func <(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) == 0
}

public func <(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func >(lhs: IntMP, rhs: IntMP) -> Bool {
    return __gmpz_cmp(lhs.gmpz_p, rhs.gmpz_p) == 0
}


public func >(lhs: IntMP, rhs: Int) -> Bool {
    return __gmpz_cmp_si(lhs.gmpz_p, rhs) == 0
}

public func >(lhs: Int, rhs: IntMP) -> Bool {
    return __gmpz_cmp_si(rhs.gmpz_p, lhs) == 0
}

public func &(lhs: IntMP, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func &(lhs: IntMP, rhs: Int) -> IntMP {
    return IntMP(0)
}

public func &(lhs: Int, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func |(lhs: IntMP, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func |(lhs: IntMP, rhs: Int) -> IntMP {
    return IntMP(0)
}

public func |(lhs: Int, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func ^(lhs: IntMP, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func ^(lhs: Int, rhs: IntMP) -> IntMP {
    return IntMP(0)
}

public func ^(lhs: IntMP, rhs: Int) -> IntMP {
    return IntMP(0)
}

public prefix func ~(x: IntMP) -> IntMP {
    return IntMP(0)
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
        __gmpz_add_ui(result.gmpz_p, rhs.gmpz_p, UInt(lhs))
        __gmpz_neg(result.gmpz_p, result.gmpz_p)
    } else {
        __gmpz_ui_sub(result.gmpz_p, UInt(lhs), rhs.gmpz_p)
    }
    
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
