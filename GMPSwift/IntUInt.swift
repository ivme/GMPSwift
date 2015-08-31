/* Int and UInt extensions for GNU multiple precision on Switch.   -*- mode: c -*-

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

extension Int {
    public init(_ value:IntMP) {
        self = value.toInt()
    }
}

extension Int: MutableSliceable {
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        if self.value is Int8 {
            return 8
        } else if self.value is Int16 {
            return 16
        } else if self.value is Int32 {
            return 32
        } else {
            return 64
        }
    }

    public subscript (position: Int) -> Bool? {
        get {
            if position >= endIndex || position < startIndex{
                return nil
            }
            
            return Bool((self >> position) & 1)
        }
        
        set(newValue) {
            var value = newValue!
            if value {
                self |= (1 << position)
            } else {
                self &= ~(1 << position)
            }
        }
    }

    public subscript (slice: Range<Int>) -> Int {
        get {
            var i = slice.endIndex
            var j = slice.startIndex

            if i <= j {
                return 0
            }

            if i > self.endIndex {
                i = self.endIndex
            }
            
            if j < self.startIndex {
                j = self.startIndex
            }

            var val = self
            let delta = i - j
            
            var disp = j - self.startIndex
            
            if disp > 0 {
                val = self >> disp
            } else {
                val = self << -disp
            }
            
            if delta < self.endIndex {
                return val & ((1 << delta) - 1)
            } else {
                return val
            }
        }
        
        set(newValue) {
            var i = slice.endIndex
            var j = slice.startIndex
            
            if i > j {
                if i > self.endIndex {
                    i = self.endIndex
                }
                
                if j < self.startIndex {
                    j = self.startIndex
                }
                
                var delta = i -  j
                
                var mask = delta < self.endIndex ? (1 << delta) - 1 : ~0
                
                self &= ~(mask << (j - self.startIndex))
                self |= ((newValue & mask) << (j - self.startIndex))
            }
        }
    }

    public func generate() -> GeneratorOf<Bool?> {
        var index = 0
        var value = Int(self.value)
        return GeneratorOf {
            if index < self.endIndex {
                var result = Bool(value & 1)
                value >>= 1
                index++
                return result
            }
            return nil
        }
    }
}

public func **(base: Int, exp: Int) -> (Int) {
    var result: Int

    if exp > 0 {
        var gmpz_p = mpz_ptr.alloc(1)
        
        __gmpz_init(gmpz_p)
        
        if base >= 0 {
            __gmpz_ui_pow_ui(gmpz_p, UInt(base), UInt(exp))
        } else {
            __gmpz_ui_pow_ui(gmpz_p, UInt(-base), UInt(exp))
            
            if exp & 1 == 1 {
                __gmpz_neg(gmpz_p, gmpz_p)
            }
        }
        
        result = Int(__gmpz_get_si(gmpz_p))
        
        __gmpz_clear(gmpz_p)
        
        return result
    } else if exp < 0 {
        if base == 1 {
            return 1
        } else {
            return 0
        }
    } else {
        return 1
    }
}

extension UInt {
    public init(_ value:IntMP) {
        self = value.toUInt()
    }
}

extension UInt: CollectionType {
    public var startIndex: Int {
        return 0
    }
    
    public var endIndex: Int {
        if self.value is UInt8 {
            return 8
        } else if self.value is UInt16 {
            return 16
        } else if self.value is UInt32 {
            return 32
        } else {
            return 64
        }
    }
    
    public subscript (position: Int) -> Bool? {
        get {
            if position >= endIndex || position < startIndex{
                return nil
            }
            
            return Bool((self >> UInt(position)) & 1)
        }
        
        set(newValue) {
            var value = newValue!
            if value {
                self |= (1 << UInt(position))
            } else {
                self &= ~(1 << UInt(position))
            }
        }
    }
    
    public subscript (slice: Range<Int>) -> UInt {
        get {
            var i = slice.endIndex
            var j = slice.startIndex
            
            if i <= j {
                return 0
            }
            
            if i > self.endIndex {
                i = self.endIndex
            }
            
            if j < self.startIndex {
                j = self.startIndex
            }
            
            var val = self
            let delta = i - j
            
            var disp = j - self.startIndex
            
            if disp > 0 {
                val = self >> UInt(disp)
            } else {
                val = self << UInt(-disp)
            }
            
            if delta < self.endIndex {
                return val & ((1 << UInt(delta)) - 1)
            } else {
                return val
            }
        }
        
        set(newValue) {
            var i = slice.endIndex
            var j = slice.startIndex
            
            if i > j {
                if i > self.endIndex {
                    i = self.endIndex
                }
                
                if j < self.startIndex {
                    j = self.startIndex
                }
                
                var delta = i - j
                
                var mask = UInt(delta < self.endIndex ? (1 << delta) - 1 : ~0)
                
                self &= ~(mask << UInt(j - self.startIndex))
                self |= ((newValue & mask) << UInt(j - self.startIndex))
            }
        }
    }
    
    public func generate() -> GeneratorOf<Bool?> {
        var index = 0
        var value = Int(self.value)
        return GeneratorOf {
            if index < self.endIndex {
                var result = Bool(value & 1)
                value >>= 1
                index++
                return result
            }
            return nil
        }
    }
}

public func **(base: UInt, exp: UInt) -> (UInt) {
    var gmpz_p = mpz_ptr.alloc(1)

    __gmpz_init(gmpz_p)
    __gmpz_ui_pow_ui(gmpz_p, base, exp)
    
    var result = UInt(__gmpz_get_ui(gmpz_p))

    __gmpz_clear(gmpz_p)

    return result
}

