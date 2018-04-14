import Foundation


extension Int {
    var gus_log10: Int {
        if self <= 0 {
            return 0
        } else if self < 10 {
            return 1
        } else if self < 100 {
            return 2
        } else if self < 1000 {
            return 3
        }
        // yolo
        return 4
    }
}
