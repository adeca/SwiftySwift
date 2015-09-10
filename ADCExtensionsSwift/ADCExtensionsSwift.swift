//
//  ADCExtensionsSwift.swift
//  ADCExtensionsSwift
//
//  Created by Agustín de Cabrera on 6/1/15.
//  Copyright (c) 2015 Agustín de Cabrera. All rights reserved.
//

import Foundation

// MARK: dispatch

/// Submits a block for asynchronous execution on a global queue with the given identifier
public func dispatch_async(identifier: Int, _ block: dispatch_block_t) {
    dispatch_async(dispatch_get_global_queue(identifier, 0), block)
}
/// Submits a block for asynchronous execution on the main queue
public func dispatch_async(block: dispatch_block_t) {
    dispatch_async(dispatch_get_main_queue(), block)
}

/// Enqueue a block for execution at the specified time (given in seconds)
public func dispatch_after(delay: NSTimeInterval, _ queue: dispatch_queue_t, _ block: dispatch_block_t) {
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * NSTimeInterval(NSEC_PER_SEC)))
    dispatch_after(time, queue, block)
}
/// Enqueue a block for execution on the main queue at the specified time (given in seconds)
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
    
    public typealias RGB = (r: UInt, g: UInt, b: UInt)
    public convenience init(rgb: RGB) {
        self.init(rgba: (rgb.r, rgb.g, rgb.b, 255))
    }
    
    public convenience init(hex: UInt64) {
        let r = UInt((hex & 0xff000000) >> 24)
        let g = UInt((hex & 0x00ff0000) >> 16)
        let b = UInt((hex & 0x0000ff00) >> 8)
        let a = UInt((hex & 0x000000ff))
        
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
        return self.init(named: name)?.resizableImageWithCapInsets(UIEdgeInsetsZero)
    }
    
    public class func imageByRenderingView(view: UIView) -> UIImage {
        let oldAlpha = view.alpha
        view.alpha = 1
        let image = imageByRenderingLayer(view.layer)
        view.alpha = oldAlpha
        
        return image
    }
    
    public class func imageByRenderingLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        
        return image
    }
    
    public class func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
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
        return dequeueReusableCellWithIdentifier(T.cellIdentifier) as? T
    }
    
    public func dequeueReusableCellForIndexPath<T: UITableViewCell>(indexPath: NSIndexPath) -> T {
        return dequeueReusableCellWithIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
    }
}

// MARK: UITableViewCell

extension UITableViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell()
    }
    
    public class func dequeueReusableCellFromTableView(tableView: UITableView, indexPath: NSIndexPath) -> Self {
        return tableView.dequeueReusableCellForIndexPath(indexPath)
    }
}

// MARK: UICollectionView

extension UICollectionView {
    public var collectionViewFlowLayout: UICollectionViewFlowLayout {
        get { return collectionViewLayout as! UICollectionViewFlowLayout }
        set { collectionViewLayout = newValue }
    }
    
    public func dequeueReusableCellForIndexPath<T: UICollectionViewCell>(indexPath: NSIndexPath!) -> T {
        return dequeueReusableCellWithReuseIdentifier(T.cellIdentifier, forIndexPath: indexPath) as! T
    }
}

// MARK: UICollectionViewCell

extension UICollectionViewCell {
    public static var cellIdentifier: String {
        return className
    }
    
    public class func dequeueReusableCellFromCollectionView(collectionView: UICollectionView, indexPath: NSIndexPath) -> Self {
        return collectionView.dequeueReusableCellForIndexPath(indexPath)
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

    public class func fromNibNamed(name: String) -> Self? {  
        let bundle = NSBundle.mainBundle()
        let allObjects = bundle.loadNibNamed(name ?? className, owner: nil, options: nil) ?? []
        return castFirst(allObjects)
    }
    
    public class func fromNib() -> Self? {
        return fromNibNamed(className)
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
        return controllerFromStoryboard(storyboard)
    }
}

private func controllerFromStoryboard<T: UIViewController>(storyboard: UIStoryboard) -> T? {
    return T.fromStoryboard(storyboard, identifier: T.className) as? T
}

// MARK: NSDate

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
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

// MARK: Comparable

extension Comparable {
    public func compare(other: Self) -> NSComparisonResult {
        return self < other ? .OrderedAscending : 
            self == other ? .OrderedSame : 
            .OrderedDescending
    }
}

// MARK: Optional

extension Optional {
    /// If `self != nil` executes `f(self!)`.
    public func unwrap(@noescape f: (Wrapped) throws -> ()) rethrows {
        if let value = self { 
            try f(value) 
        }
    }
}

// MARK: OptionalConvertible

/// A type that can be represented as an `Optional`
public protocol OptionalConvertible {
    typealias SomeValue
    
    var optionalValue: SomeValue? { get }
}

extension Optional: OptionalConvertible {
    public var optionalValue: Wrapped? { return self }
}

// MARK: SequenceType

extension SequenceType where Self.Generator.Element : OptionalConvertible {
    /// return an `Array` containing the non-nil values in `self`
    public func flatMap() -> [Self.Generator.Element.SomeValue] {
        return flatMap { $0.optionalValue }
    }
}

extension SequenceType where Generator.Element : Equatable {
    /// Return `true` iff all elements of `other` are contained in `self`.
    public func contains<S: SequenceType where S.Generator.Element == Generator.Element>(other: S) -> Bool {
        return other.all { self.contains($0) }
    }
}

extension SequenceType {
    @available(*, deprecated, message="use 'forEach'")
    public func each(@noescape action: (Self.Generator.Element) -> Void) -> Void {
        forEach(action)
    }
    
    public func all(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        for element in self {
            guard predicate(element) else { return false }
        }
        return true
    }
    
    public func any(@noescape predicate: (Self.Generator.Element) -> Bool) -> Bool {
        for element in self {
            if predicate(element) { return true }
        }
        return false
    }

    /// Return nil is `self` is empty, otherwise return the result of repeatedly 
    /// calling `combine` with each element of `self`, in turn.
    /// i.e. return `combine(combine(...combine(combine(self[0], self[1]),
    /// self[2]),...self[count-2]), self[count-1])`.
    public func reduce(@noescape combine: (Self.Generator.Element, Self.Generator.Element) -> Self.Generator.Element) -> Self.Generator.Element? {
        
        var generator = self.generate()
        guard let first = generator.next() else { 
            return nil 
        }
        
        var result = first
        while let element = generator.next() {
            result = combine(result, element)
        }
        
        return result
    }
}

extension CollectionType {
    public func find(@noescape predicate: (Self.Generator.Element) -> Bool) -> Self.Generator.Element? {
        return indexOf(predicate).map { self[$0] }
    }
}

extension CollectionType where Generator.Element : Equatable {
    public func find(element: Self.Generator.Element) -> Self.Generator.Element? {        
        return indexOf(element).map { self[$0] }
    }
}

extension CollectionType where Index == Int {
    public func randomElement() -> Self.Generator.Element {
        let idx = Int(arc4random_uniform(UInt32(count)))
        return self[idx]
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
        
        let grouped = keys.map { (key: Key) -> (Key, [Value]) in
            let keyElements = elements.filter { $0.0 == key }
            let values = keyElements.map { $0.1 }
            
            return (key, values)
        }
        
        return Dictionary(elements: grouped)
    }
}

extension Dictionary {
    public init<S: SequenceType where S.Generator.Element == (Key, Value)>(elements: S) {
        self.init()
        extend(elements)
    }
    
    public init<C: CollectionType where C.Generator.Element == (Key, Value), C.Index.Distance == Int>(elements: C) {
        self.init(minimumCapacity: elements.count)
        extend(elements)
    }
}

extension SequenceType {
    public func mapFirst<T>(@noescape transform: (Self.Generator.Element) -> T?) -> T? {        
        for value in self {
            if let result = transform(value) { return result }
        }
        return nil
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func minElement(values: ((Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult)...) -> Self.Generator.Element? {
        return minElement(values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func minElement(values: [(Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult]) -> Self.Generator.Element? {
        guard values.count > 0 else { return nil }
        return minElement(orderedBefore(values))
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sort(values: ((Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult)...) -> [Self.Generator.Element] {
        return sort(values)
    }
    
    /// Use the given closures to extract the values for comparison. If the values 
    /// are equal compare using the next closure in the list until they are all exhausted
    public func sort(values: [(Self.Generator.Element, Self.Generator.Element) -> NSComparisonResult]) -> [Self.Generator.Element] {
        return sort(orderedBefore(values))
    }
}

/// Merge a list of comparison blocks into a single block used for sorting a sequence.
///
/// Use the given closures to extract the values for comparison. If the values 
/// are equal compare using the next closure in the list until they are all exhausted
private func orderedBefore<T>(comparisons: [(T, T) -> NSComparisonResult]) ->  (T, T) -> Bool {
    return { (lhs, rhs) -> Bool in
        for compare in comparisons {
            let result = compare(lhs, rhs)
            if result != .OrderedSame { 
                return result == .OrderedAscending 
            }
        }
        return true
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

extension CollectionType {    
    public func decompose() -> (Self.Generator.Element, Self.SubSequence)? {
        return first.map { ($0, dropFirst()) }
    }
}

// MARK: Dictionary

extension Dictionary {
    /// Update the values stored in the dictionary with the given key-value pairs, or, if a key does not exist, add a new entry.
    public mutating func extend<S: SequenceType where S.Generator.Element == Generator.Element>(newElements: S) -> [Value] {
        return newElements.flatMap { 
            (k, v) in updateValue(v, forKey: k) 
        }
    }
}

/// Return a new dictionary created by extending the lef-side dictionary with the elements of the right-side dictionary
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

// MARK: UIGeometry

extension UIEdgeInsets {
    public var topLeft: CGPoint { 
        return CGPoint(x: left, y: top) 
    }
    public var bottomRight: CGPoint {
        return CGPoint(x: right, y: bottom) 
    }
    
    public static var zero = UIEdgeInsetsZero
}

// MARK: CGGeometry

extension CGPoint {
    public func pointByClamping(rect: CGRect) -> CGPoint {
        return CGPoint(
            x: clamp(x, rect.minX, rect.maxX), 
            y: clamp(y, rect.minY, rect.maxY)
        )
    }
    
    public var length: CGFloat {
        return sqrt((x * x) + (y * y))
    }
    
    public func distance(point: CGPoint) -> CGFloat {
        return sqrt(distanceSquared(point))
    }
    
    public func distanceSquared(point: CGPoint) -> CGFloat {
        return pow((x - point.x), 2) + pow((y - point.y), 2)
    }
}

extension CGRect {
    public func rectByClamping(rect: CGRect) -> CGRect {
        if size.width > rect.size.width || size.height > rect.size.height {
            return CGRect.null
        }
        
        let newRect = CGRect(origin: rect.origin, size: rect.size - size)
        let newOrigin = origin.pointByClamping(newRect)
        
        return CGRect(origin: newOrigin, size: size)
    }
    
    public init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(x: origin.x, y: origin.y, width: width, height: height)
    }
    
    public init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }
    
    public var center: CGPoint {
        return CGPoint(x: midX, y: midY)
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

// MARK: CGFloatTuple

/// Type that can be serialized to a pair of CGFloat values
public typealias CGFloatTuple = (CGFloat, CGFloat)
public protocol CGFloatTupleConvertible {    
    var tuple: CGFloatTuple { get }
    init(tuple: CGFloatTuple)
    
    // methods with default implementations
    init(_ other: CGFloatTupleConvertible)
}

extension CGFloatTupleConvertible {
    public init(_ other: CGFloatTupleConvertible) {
        self.init(tuple: other.tuple)
    }
    
    public func generate() -> AnyGenerator<CGFloat> {
        return anyGenerator([tuple.0, tuple.1].generate())
    }
    
    public func minElement() -> CGFloat {
        let t = tuple
        return min(t.0, t.1)
    }
    
    public func maxElement() -> CGFloat {
        let t = tuple
        return max(t.0, t.1)
    }
}

public func max(x: CGFloatTupleConvertible) -> CGFloat {
    return x.maxElement()
}

public func min(x: CGFloatTupleConvertible) -> CGFloat {
    return x.minElement()
}

/// Functional methods used to apply transforms to a pair of floats
extension CGFloatTupleConvertible {
    public func map(@noescape transform: CGFloat -> CGFloat) -> Self {
        let t = self.tuple
        let result = (transform(t.0), transform(t.1))
        return Self(tuple: result)
    }
    
    public func merge<T: CGFloatTupleConvertible>(rhs: T, @noescape _ transform: CGFloatTuple -> CGFloat) -> Self {
        let (t0, t1) = (self.tuple, rhs.tuple)
        let result = (transform(t0.0, t1.0), transform(t0.1, t1.1))
        return Self(tuple: result)
    }
    
    public func merge<T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(a: T, _ b: U, @noescape _ transform: (CGFloat, CGFloat, CGFloat) -> CGFloat) -> Self {
        let (t0, t1, t2) = (self.tuple, a.tuple, b.tuple)
        let result = (transform(t0.0, t1.0, t2.0), transform(t0.1, t1.1, t2.1))
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

public func * <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, *)
}
public func *= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs * rhs
}

public func / <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, /)
}
public func /= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs / rhs
}

public func + <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, +)
}
public func += <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs + rhs
}

public func - <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(lhs: T, rhs: U) -> T {
    return lhs.merge(rhs, -)
}
public func -= <T: CGFloatTupleConvertible, U: CGFloatTupleConvertible>(inout lhs: T, rhs: U) {
    lhs = lhs - rhs
}

public prefix func + <T: CGFloatTupleConvertible>(rhs: T) -> T {
    return rhs
}
public prefix func - <T: CGFloatTupleConvertible>(rhs: T) -> T {
    return rhs.map { -$0 }
}

public func abs<T: CGFloatTupleConvertible>(x: T) -> T {
    return x.map { abs($0) }
}

public func clamp<T: CGFloatTupleConvertible, U: CGFloatTupleConvertible, V: CGFloatTupleConvertible>(x: T, _ low: U, _ high: V) -> T {
    return x.merge(low, high, clamp)
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

// MARK: MultiRange

/**
Useful methods to iterate over a grid

These methods return a sequence that can be iterated over, and will provide a 
tuple for each combination between the start and end tuples

e.g.: (1,1)...(2,2) will generate (1,1), (1,2), (2,1), (2,2)
**/

public func ..< <T : ForwardIndexType>(start: (T, T), end: (T, T)) -> MultiRange<T> {
    return MultiRange(
        rows:    start.0 ..< end.0, 
        columns: start.1 ..< end.1
    )
}

public func ... <T : ForwardIndexType>(start: (T, T), end: (T, T)) -> MultiRange<T> {
    return MultiRange(
        rows:    start.0 ... end.0, 
        columns: start.1 ... end.1
    )
}

public struct MultiRange<T: ForwardIndexType> : Equatable, SequenceType, CustomStringConvertible, CustomDebugStringConvertible {
    private let rows: Range<T>
    private let columns: Range<T>
        
    init(rows: Range<T>, columns: Range<T>) {
        self.rows = rows
        self.columns = columns
    }
    
    public func generate() -> AnyGenerator<(T, T)> {
        return multiRangeGenerator(rows, columns)
    }
    
    public func contains(element: (T, T)) -> Bool {
        return any { $0 == element }
    }
 
    public func underestimateCount() -> Int {
        return rows.underestimateCount() * columns.underestimateCount()
    }
    
    public var description: String {
        return "(\(rows.startIndex), \(columns.startIndex))..<(\(rows.endIndex), \(columns.endIndex))"
    }
    
    public var debugDescription: String {
        return "MultiRange(\(description))"
    }
}

public func == <T: Equatable>(lhs: (T, T), rhs: (T, T)) -> Bool {
    return lhs.0 == rhs.0 && lhs.1 == rhs.1
}

public func == <T>(lhs: MultiRange<T>, rhs: MultiRange<T>) -> Bool {
    return lhs.rows == rhs.rows && lhs.columns == rhs.columns
}

private func multiRangeGenerator<T>(rows: Range<T>, _ columns: Range<T>) -> AnyGenerator<(T, T)> {    
    // lazy generators for each row and column
    var rowGenerators = rows.lazy.map { r in 
        columns.lazy.map { c in 
            (r, c) 
            }.generate()
        }.generate()
    
    var current = rowGenerators.next()
    return anyGenerator {
        if let next = current?.next() {
            return next
        } else {
            current = rowGenerators.next()
            return current?.next()
        }
    }
}

