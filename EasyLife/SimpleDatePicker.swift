//
//  SimpleDatePicker.swift
//  EasyLife
//
//  Created by Lee Arromba on 19/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import UIKit

protocol SimpleDatePickerDelegate: class {
    func datePicker(_ picker: SimpleDatePicker, didSelectDate date: Date?)
}

class SimpleDatePicker: UIPickerView {
    fileprivate var date: Date?
    weak var datePickerDelegate: SimpleDatePickerDelegate?
    
    init(delegate: SimpleDatePickerDelegate?, date: Date?){
        self.date = date
        self.datePickerDelegate = delegate
        super.init(frame: CGRect.zero)
        self.delegate = self
        dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SimpleDatePicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DateSegment(rawValue: row)?.stringValue()
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let date = date {
            datePickerDelegate?.datePicker(self, didSelectDate: DateSegment(rawValue: row)?.increment(date: date))
        } else {
            datePickerDelegate?.datePicker(self, didSelectDate: nil)
        }
    }
}

extension SimpleDatePicker: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DateSegment.MAX.rawValue
    }
}
