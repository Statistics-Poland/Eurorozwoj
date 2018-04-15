import UIKit


class WorkersPicker: BasicPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var maxNumer: Int = 179
    
    
    override func initialize() {
        delegate = self
        dataSource = self
    }
    
    
    
    func calculateValue() -> Int {
        var value: Int = selectedRow(inComponent: 0)
        var i: Int = 1
        while i < numberOfComponents {
            value *= 10
            value += selectedRow(inComponent: i)
            i += 1
        }
        return value
    }
    
    
    // MARK: private
    func restoreSelection(animated: Bool, selections: [Int]) {
        for i in (0 ..< numberOfComponents) {
            selectRow(selections[i], inComponent: i, animated: animated)
        }
    }
    
    
    private var maxSelection: [Int] {
        var result: [Int] = []
        
        var value: Int = maxNumer
        while value > 0 {
            result.append(value % 10)
            value /= 10
        }
        return result.reversed()
    }
    

    // MARK: UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return maxNumer.gus_log10
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component != 0 {
            return 10
        }
        
        var val: Int = maxNumer
        while val >= 10 {
            val /= 10
        }
        return val + 1
    }
    
    
    // MARK: UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if calculateValue() > maxNumer {
            restoreSelection(animated: true, selections: maxSelection)
        }
    }
}

