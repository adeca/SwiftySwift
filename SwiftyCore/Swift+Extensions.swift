//
//  SwiftySwift.swift
//  SwiftySwift
//
//  Created by Agustín de Cabrera on 6/1/15.
//  Copyright (c) 2015 Agustín de Cabrera. All rights reserved.
//

// MARK: - cast helpers

/**
The following methods can be used to perform a cast without being explicit 
about the class the object is being cast to, relying instead on the type-inferrence
features of the compiler.

This allows creating class methods that return an instance of the subclass they are called on.

e.g.

    class A {
     class func factoryMethod() -> Self? {
      let instance = createNewInstance()
      return cast(instance)
     }
    }
    
    class B : A {
    }
    
    A.factoryMethod()  // type is inferred as A?
    B.factoryMethod()  // type is inferred as B?
**/

/// Optional cast of `x` as type `V`
public func cast<U, V>(x: U) -> V? {
    return x as? V
}

/// Return all values of `source` that were successfully casted to type `V`
public func castFilter<S: SequenceType, V>(source: S) -> [V] {
    return source.flatMap {
        $0 as? V
    }
}

/// Return the first value of `source` that was successfully casted to type `V`
public func castFirst<S: SequenceType, V>(source: S) -> V? {
    return source.flatMap {
        $0 as? V
    }.first
}

/// Forced cast of `x` as type `V`
public func forcedCast<U, V>(x: U) -> V {
    return x as! V
}

public func stringFromClass(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
}

// MARK: - Equatable

public func == <T: Equatable>(lhs: (T, T), rhs: (T, T)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

// MARK: - math

/// Formal protocol to encapsulate the operations that are available to many floating point types
public protocol FloatingPointArithmeticType : FloatingPointType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
}
extension Double : FloatingPointArithmeticType {}
extension Float : FloatingPointArithmeticType {}
extension CGFloat: FloatingPointArithmeticType {}

/// Linear interpolation between two values
public func lerp<T: FloatingPointArithmeticType>(from: T, _ to: T, _ progress: T) -> T {
    return from * (T(1) - progress) + to * progress
}

public func sign<T: SignedNumberType>(x: T) -> T {
    return x == 0 ? 0 : x == abs(x) ? 1 : -1
}

public func sign<T: UnsignedIntegerType>(x: T) -> T {
    return x == 0 ? 0 : 1
}

public func mod(lhs: Int, _ rhs: Int) -> Int {
    return (lhs % rhs + rhs) % rhs
}

public func min<T : Comparable>(t: (T, T)) -> T {
    return min(t.0, t.1)
}

public func max<T : Comparable>(t: (T, T)) -> T {
    return max(t.0, t.1)
}

public func clamp<T: Comparable>(x: T, _ low: T, _ high: T) -> T {
    return (x < low) ? low : (x > high) ? high : x
}
