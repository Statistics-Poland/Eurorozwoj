import Foundation


enum Value<T> {
    case value(val: T)
    case strange(val: T)
    case unknown
    
    
    func merge(with rhs: Value<T>) -> Value<T> {
        switch (self, rhs) {
        case (Value<T>.unknown, Value<T>.value(let val)):
            return Value<T>.strange(val: val)
        case (Value<T>.value(let val), Value<T>.unknown):
            return Value<T>.strange(val: val)
        default:
            fatalError()
        }
    }
    
    var value: T? {
        switch self {
        case Value<T>.value(let val):
            return val
        case Value<T>.strange(let val):
            return val
        default: return nil
        }
    }
}
