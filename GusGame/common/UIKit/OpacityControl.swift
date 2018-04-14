import UIKit


class OpacityControl: BasicControl {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let result = super.beginTracking(touch, with: event)
        if result {
            self.alpha = CGFloat(0.7)
        }
        return result
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        alpha = CGFloat(1.0)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        alpha = CGFloat(1.0)
    }
}
