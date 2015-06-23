//
//  ADCExtensionsSwift.swift
//  ADCExtensionsSwift
//
//  Created by Agustín de Cabrera on 6/1/15.
//  Copyright (c) 2015 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: dispatch

public func dispatch_async(identifier: Int, _ block: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(identifier, 0), block)
}
public func dispatch_async(block: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), block)
}

public func dispatch_after(delay: NSTimeInterval, _ queue: dispatch_queue_t, _ block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
    dispatch_after(time, queue, block)
}
public func dispatch_after(delay: NSTimeInterval, _ block: dispatch_block_t) {
    dispatch_after(delay, dispatch_get_main_queue(), block)
}

// MARK: cast helpers
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

public func cast<U, V>(x: U) -> V? {
    return x as? V
}

public func castFilter<S: SequenceType, V>(source: S) -> [V] {
    return source.flatMap {
        $0 as? V
    }
}

public func castFirst<S: SequenceType, V>(source: S) -> V? {
    return source.flatMap {
        $0 as? V
    }.first
}

public func forcedCast<U, V>(x: U) -> V {
    return x as! V
}

// MARK: NSObject

extension NSObject {
    public func performBlock(block: () -> Void) {
        block()
    }
    
    public func performAfterDelay(delay: NSTimeInterval, _ block: () -> Void) {
        dispatch_after(delay) { [weak self] in 
            self?.performBlock(block) 
        }
    }
    
    public func performInBackground(block: () -> Void) {
        dispatch_async(DISPATCH_QUEUE_PRIORITY_DEFAULT, block)
    }
    
    public func performInMainThread(block: () -> Void) {
        dispatch_async(block)
    }
    
    public var className: String {
        return self.dynamicType.className
    }
    public static var className: String {
        return stringFromClass(self)
    }
    
    public func attachObject(object: AnyObject) {
        objc_setAssociatedObject(self, unsafeAddressOf(object), object, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    public func detachObject(object: AnyObject) {
        objc_setAssociatedObject(self, unsafeAddressOf(object), nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

public func stringFromClass(aClass: AnyClass) -> String {
    return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
}

// MARK: NSThread

extension NSThread {
    public func objectFromThreadDictionary<T: AnyObject>(key:NSCopying, @autoclosure defaultValue: () -> T) -> T {
        
        if let result = threadDictionary[key] as? T {
            return result
        } else {
            let newObject = defaultValue()
            threadDictionary[key] = newObject
            return newObject
        }
    }
    
    public class func objectFromThreadDictionary<T: AnyObject>(key:NSCopying, @autoclosure defaultValue: () -> T) -> T {
        return currentThread().objectFromThreadDictionary(key, defaultValue: defaultValue)
    }
}

// MARK: UIColor

extension UIColor {
    public typealias RGBA = (r: UInt, g: UInt, b: UInt, a: UInt)

    public convenience init(rgba: RGBA) {        
        self.init(
            red:   CGFloat(rgba.r)/255.0, 
            green: CGFloat(rgba.g)/255.0, 
            blue:  CGFloat(rgba.b)/255.0, 
            alpha: CGFloat(rgba.a)/255.0
        )
    }
    
    public convenience init(hex: UInt) {
        let r = (hex & 0xff000000) >> 24
        let g = (hex & 0x00ff0000) >> 16
        let b = (hex & 0x0000ff00) >> 8
        let a = (hex & 0x000000ff)
        
        self.init(rgba: (r, g, b, a))
    }
}

// MARK: UIImage

extension UIImage {
    private static let imagesCache = NSCache()
    
    public class func cachedImage(contentsOfFile path: String) -> UIImage? {
        if let cached = imagesCache.objectForKey(path) as? UIImage {
            return cached
        }
        
        if let image = UIImage(contentsOfFile: path) {
            imagesCache.setObject(image, forKey: path)
            return image
        }
        
        return nil
    }
    
    public class func tiledImageNamed(name: String) -> UIImage? {
        return self(named: name)?.resizableImageWithCapInsets(UIEdgeInsetsZero)
    }
    
    public func imageWithOrientation(orientation: UIImageOrientation) -> UIImage? {
        if let cgImage = CGImage {
            return UIImage(CGImage: cgImage, scale: scale, orientation: orientation)
        } else if let ciImage = CIImage {
            return UIImage(CIImage: ciImage, scale: scale, orientation: orientation)
        } else {
            return nil
        }
    }
    
    public func verticallyMirroredImage() -> UIImage? {
        return imageWithOrientation(imageOrientation.verticallyMirrored)
    }
    
    public func horizontallyMirroredImage() -> UIImage? {
        return imageWithOrientation(imageOrientation.horizontallyMirrored)
    }
}

extension UIImageOrientation {
    public var verticallyMirrored: UIImageOrientation {
        switch (self) {
        case .Up:            return .DownMirrored;
        case .Down:          return .UpMirrored;
        case .Left:          return .LeftMirrored;
        case .Right:         return .RightMirrored;
        case .UpMirrored:    return .Down;
        case .DownMirrored:  return .Up;
        case .LeftMirrored:  return .Left;
        case .RightMirrored: return .Right;
        }
    }
    
    public var horizontallyMirrored: UIImageOrientation {
        switch (self) {
        case .Up:            return .UpMirrored;
        case .Down:          return .DownMirrored;
        case .Left:          return .RightMirrored;
        case .Right:         return .LeftMirrored;
        case .UpMirrored:    return .Up;
        case .DownMirrored:  return .Down;
        case .LeftMirrored:  return .Right;
        case .RightMirrored: return .Left;
        }
    }
}

// MARK: UIImageView

extension UIImageView {
    public convenience init?(imageNamed name: String) {
        self.init(image: UIImage(named: name))
    }
    
    public var imageOrientation: UIImageOrientation? {
        get { return image?.imageOrientation }
        set { image = newValue.flatMap { image?.imageWithOrientation($0) } }
    }
    
    public func mirrorVertically() {
        image = image?.verticallyMirroredImage()
    }
    public func mirrorHorizontally() {
        image = image?.horizontallyMirroredImage()
    }
}

// MARK: UIGestureRecognizer

extension UIGestureRecognizer {
    public func removeFromView() {
        view?.removeGestureRecognizer(self)
    }
    
    public func cancel() { 
        // used to clear pending gestures
        enabled = false
        enabled = true
    }
}

// MARK: UITableView

extension UITableView {
    public func insertSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        insertSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    public func deleteSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        deleteSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    public func reloadSection(section: Int, withRowAnimation animation: UITableViewRowAnimation) {
        reloadSections(NSIndexSet(index: section), withRowAnimation: animation)
    }
    
    public func dequeueReusableCell<T: UITableViewCell>() -> T? {
        let cell = dequeueReusableCellWithIdentifier(T.cellIdentifier)
        return cast(cell)
    }
    
    public func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        let cell = dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath)
        return cast(cell)!
    }
}

// MARK: UITableViewCell

extension UITableViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView) -> Self? {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        return cast(cell)
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView, indexPath: NSIndexPath) -> Self {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cast(cell)!
    }
}

// MARK: UICollectionView

extension UICollectionView {
    public var collectionViewFlowLayout: UICollectionViewFlowLayout {
        get { return collectionViewLayout as! UICollectionViewFlowLayout }
        set { collectionViewLayout = newValue }
    }
    
    public func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath!) -> T! {
        let cell = dequeueReusableCellWithReuseIdentifier(T.cellIdentifier, forIndexPath: indexPath)
        return cast(cell)!
    }
    
    public func dequeueReusableCellOfClass<T: UICollectionViewCell>(cellClass: T.Type, forIndexPath indexPath: NSIndexPath!) -> T {
        return dequeueReusableCellForIndexPath(indexPath)
    }
}

// MARK: UICollectionViewCell

extension UICollectionViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) -> Self {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        return cast(cell)!
    }
}

// MARK: NSLayoutConstraint

extension NSLayoutConstraint {
    class func constraintsWithVisualFormats(formats: [String], options opts: NSLayoutFormatOptions, metrics: [String : AnyObject]?, views: [String : AnyObject]) -> [NSLayoutConstraint] {
        return formats.flatMap {
            NSLayoutConstraint.constraintsWithVisualFormat($0, options: opts, metrics: metrics, views: views)
        }
    }
}

// MARK: UIView

extension UIView {
    public func removeSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }

    public class func fromNib(name: String = className, bundle: NSBundle = NSBundle.mainBundle()) -> Self? {  
        let allObjects = bundle.loadNibNamed(name, owner: nil, options: nil) ?? []
        return castFirst(allObjects)
    }
    
    public func applyContainedViewConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraints(containedViewConstraints())
    }
    
    public func containedViewConstraints() -> [NSLayoutConstraint] {
        let views = ["self": self]
        let formats = ["V:|[self]|", "H:|[self]|"]
        
        return NSLayoutConstraint.constraintsWithVisualFormats(formats, options: [], metrics: nil, views: views)
    }
    
    public func containedViewConstraintsWithHeight(height: CGFloat) -> [NSLayoutConstraint] {
        let views = ["self": self]
        let metrics = ["height": height]
        let formats = ["V:|[self(height)]", "H:|[self]|"]

        return NSLayoutConstraint.constraintsWithVisualFormats(formats, options: [], metrics: metrics, views: views)
    }
}

// MARK: UIViewController

extension UIViewController {
    
    public class func fromStoryboardNamed(name: String, identifier: String) -> UIViewController? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil), identifier: identifier)
    }
    public class func fromStoryboard(storyboard: UIStoryboard, identifier: String) -> UIViewController? {
        return storyboard.instantiateViewControllerWithIdentifier(identifier)
    }
    
    public class func fromStoryboardNamed(name: String) -> Self? {
        return fromStoryboard(UIStoryboard(name: name, bundle: nil))
    }
    public class func fromStoryboard(storyboard: UIStoryboard) -> Self? {
        return cast(fromStoryboard(storyboard, identifier: className))
    }
}

// MARK: NSCoding

extension NSCoding {
    public func archive() -> NSData {
        return NSKeyedArchiver.archivedDataWithRootObject(self)
    }
}

extension NSData {
    public func unarchive() -> AnyObject? {
        return NSKeyedUnarchiver.unarchiveObjectWithData(self)
    }
    
    public func unarchive<T>() -> T? {
        return unarchive() as? T
    }
}

// MARK: OptionalConvertible

/// A type that can be represented as an `Optional`
public protocol OptionalConvertible {
    typealias SomeValue
    
    var optionalValue: SomeValue? { get }
}

extension Optional: OptionalConvertible {
    public var optionalValue: T? { return self }
}

// MARK: SequenceType

extension SequenceType where Self.Generator.Element : OptionalConvertible {
    /// return an `Array` containing the non-nil values in `self`
    public func flatMap() -> [Self.Generator.Element.SomeValue] {
        return flatMap { $0.optionalValue }
    }
}

extension SequenceType {
    public func each(@noescape action: (Self.Generator.Element) -> Void) -> Void {
        for element in self {
            action(element)
        } 
    }
    
    public func all(@noescape condition: (Self.Generator.Element) -> Bool) -> Bool {
        return reduce(false) { (old, new) in 
            old && condition(new) 
        }
    }
    
    public func any(@noescape condition: (Self.Generator.Element) -> Bool) -> Bool {
        return reduce(false) { (old, new) in 
            old || condition(new) 
        }
    }
}

extension SequenceType {
    public func mapToDictionary<Key: Hashable, Value>(@noescape transform: (Self.Generator.Element) -> (Key, Value)?) -> [Key: Value] {
        
        let elements = flatMap(transform)
        return Dictionary(elements: elements)
    }
    
    public func group<Key: Hashable, Value>(@noescape transform: (Self.Generator.Element) -> (Key, Value)?) -> [Key: [Value]] {
        
        let elements = flatMap(transform)
        let keys = Set(elements.map { $0.0 })
        
        let grouped = keys.map { key in
            (key, elements.filter{ $0.0 == key }.map { $0.1 })
        }
        
        return Dictionary(elements: grouped)
    }
}

extension Dictionary {
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(elements: S) {
        self.init()
        
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}

// MARK: CollectionType

extension RangeReplaceableCollectionType {
    mutating public func remove(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        return indexOf(predicate).map { removeAtIndex($0) }
    }
}

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    mutating public func remove(element: Self.Generator.Element) -> Self.Generator.Element? {
        return indexOf(element).map { removeAtIndex($0) }
    }
}

// MARK: Sliceable

extension Sliceable {
    public func dropFirst() -> Self.SubSlice {
        return Swift.dropFirst(self)
    }
    
    public func decompose() -> (Self.Generator.Element, Self.SubSlice)? {
        return first.map { ($0, dropFirst()) }
    }
}
 
extension Sliceable where Self.Index : BidirectionalIndexType {
    public func dropLast() -> Self.SubSlice {
        return Swift.dropLast(self)
    }
}

// MARK: Dictionary

extension Dictionary {
    mutating func extend<S: SequenceType where S.Generator.Element == Generator.Element>(newElements: S) -> [Value] {
        return newElements.flatMap { 
            (k, v) in updateValue(v, forKey: k) 
        }
    }
}

public func + <K, V, S: SequenceType where S.Generator.Element == (K, V)>(lhs: [K: V], rhs: S) -> [K: V] {
    var result = lhs
    result.extend(rhs)
    return result
}
public func += <K, V>(inout lhs: [K: V], rhs: [K: V]) {
    lhs = lhs + rhs
}

// MARK: math

public func clamp<T: Comparable>(x: T, _ low: T, _ high: T) -> T {
    return (x < low) ? low : (x > high) ? high : x
}

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

// MARK: CGGeometry

extension CGPoint {
    public func pointByClamping(rect: CGRect) -> CGPoint {
        return CGPoint(
            x: clamp(x, rect.minX, rect.maxX), 
            y: clamp(y, rect.minY, rect.maxY)
        )
    }
    
    public init(_ vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
}

extension CGRect {
    public func rectByClamping(rect: CGRect) -> CGRect {
        if size.width > rect.size.width || size.height > rect.size.height {
            return CGRect.nullRect
        }
        
        let newRect = CGRect(origin: rect.origin, size: rect.size - size)
        let newOrigin = origin.pointByClamping(newRect)
        
        return CGRect(origin: newOrigin, size: size)
    }
}

/// Add the given point to the rect's origin
public func + (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin + rhs, size: lhs.size)
}
/// Add the given vector to the rect's origin
public func + (lhs: CGRect, rhs: CGVector) -> CGRect {
    return lhs + CGPoint(rhs)
}
/// Add the given size to the rect's size
public func + (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size + rhs)
}

/// Substract the given point to the rect's origin
public func - (lhs: CGRect, rhs: CGPoint) -> CGRect {
    return CGRect(origin: lhs.origin - rhs, size: lhs.size)
}
/// Substract the given vector to the rect's origin
public func - (lhs: CGRect, rhs: CGVector) -> CGRect {
    return lhs - CGPoint(rhs)
}
/// Substract the given size to the rect's size
public func - (lhs: CGRect, rhs: CGSize) -> CGRect {
    return CGRect(origin: lhs.origin, size: lhs.size - rhs)
}

/// Type that can be serialized to a pair of CGFloat values
public typealias CGFloatTuple = (CGFloat, CGFloat)
public protocol CGFloatTupleConvertible {    
    var tuple: CGFloatTuple { get }
    init(tuple: CGFloatTuple)
}

/// Functional methods used to apply transforms to a pair of floats
extension CGFloatTupleConvertible {
    public func map(@noescape transform: CGFloat -> CGFloat) -> Self {
        let t = self.tuple
        let result = (transform(t.0), transform(t.1))
        return Self(tuple: result)
    }
    
    public func merge<T: CGFloatTupleConvertible>(rhs: T, @noescape _ transform: CGFloatTuple -> CGFloat) -> Self {
        let t0 = self.tuple
        let t1 = rhs.tuple
        let result = (transform(t0.0, t1.0), transform(t0.1, t1.1))
        return Self(tuple: result)
    }
}

/// Operators that can be applied to a pair of CGFloatTupleConvertible objects
/// Each operation will work on an element-by-element basis

public func + <T: CGFloatTupleConvertible>(lhs: T, rhs: T) -> T {
    return lhs.merge(rhs, +)
}
public func += <T: CGFloatTupleConvertible>(inout lhs: T, rhs: T) {
    lhs = lhs + rhs
}

public func - <T: CGFloatTupleConvertible>(lhs: T, rhs: T) -> T {
    return lhs.merge(rhs, -)
}
public func -= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: T) {
    lhs = lhs - rhs
}

public func * <T: CGFloatTupleConvertible>(lhs: T, rhs: CGFloat) -> T {
    return lhs.map { $0 * rhs }
}
public func *= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: CGFloat) {
    lhs = lhs * rhs
}

public func / <T: CGFloatTupleConvertible>(lhs: T, rhs: CGFloat) -> T {
    return lhs.map { $0 / rhs }
}
public func /= <T: CGFloatTupleConvertible>(inout lhs: T, rhs: CGFloat) {
    lhs = lhs / rhs
}

/// CGPoint, CGVector and CGSize can be converted to a pair of floats.
/// Conforming to CGFloatTupleConvertible allows using the operators defined above. 

extension CGPoint: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (x, y) }
    
    public init(tuple: CGFloatTuple) {
        self.init(x: tuple.0, y: tuple.1)
    }
}

extension CGSize: CGFloatTupleConvertible {    
    public var tuple: CGFloatTuple { return (width, height) }
    
    public init(tuple: CGFloatTuple) {
        self.init(width: tuple.0, height: tuple.1)
    }
}

extension CGVector: CGFloatTupleConvertible {
    public var tuple: CGFloatTuple { return (dx, dy) }
    
    public init(tuple: CGFloatTuple) {
        self.init(dx: tuple.0, dy: tuple.1)
    }
}

