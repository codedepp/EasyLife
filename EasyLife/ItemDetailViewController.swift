//
//  ItemDetailViewController.swift
//  EasyLife
//
//  Created by Lee Arromba on 12/04/2017.
//  Copyright © 2017 Pink Chicken Ltd. All rights reserved.
//

import UIKit

class ItemDetailViewController : UIViewController, ResponderSelection {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var repeatsTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var responders: [UIResponder]!
    var dataManager: DataManager!
    var item: TodoItem?
    var dateFormatter: DateFormatter
    var now: Date
    var date: Date? {
        didSet {
            if let date = date {
                dateTextField.text = dateFormatter.string(from: date)
            } else {
                dateTextField.text = nil
            }
        }
    }
    var repeatState: RepeatState? {
        didSet {
            if let repeatState = repeatState {
                repeatsTextField.text = repeatState.stringValue()
            } else {
                repeatsTextField.text = nil
            }
        }
    }
   
    lazy var origContentSize: CGSize = {
        return self.scrollView.contentSize
    }()
    
    lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 44))
        toolbar.barStyle = .default
        let prev = UIBarButtonItem(image: UIImage(named:"backward_arrow"), style: .plain, target: self, action: #selector(prevPressed(_:)))
        let next = UIBarButtonItem(image: UIImage(named:"forward_arrow"), style: .plain, target: self, action: #selector(nextPressed(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spacer.width = 10.0
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(_:)))
        toolbar.setItems([prev, spacer, next, flexSpace, spacer, done], animated: false)
        return toolbar
    }()

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.minimumDate = self.now
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dateTapped(_:)))
        tap.numberOfTapsRequired = 2
        tap.cancelsTouchesInView = false
        tap.delaysTouchesEnded = false
        datePicker.addGestureRecognizer(tap)
        return datePicker
    }()
   
    lazy var simpleDatePicker: SimpleDatePicker = {
        let datePicker = SimpleDatePicker(delegate: self, date: self.now)
        return datePicker
    }()
    
    lazy var repeatPicker: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        dataManager = DataManager.shared
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE dd/MM/yyyy"
        now = Date()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        responders = [
            titleTextField,
            dateTextField,
            repeatsTextField,
            textView
        ]
        
        repeatsTextField.inputView = repeatPicker
        repeatsTextField.inputAccessoryView = toolbar
        dateTextField.inputView = simpleDatePicker
        dateTextField.inputAccessoryView = toolbar
        dateTextField.readonly = true
        titleTextField.inputAccessoryView = toolbar
        titleTextField.readonly = true
        textView.inputAccessoryView = toolbar
        textView.applyTextFieldStyle()
        textView.dataDetectorTypes = .all
        textView.isEditable = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(textViewTapped(_:)))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        tap.delaysTouchesEnded = false
        textView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNotifications()
        loadItem(item)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let item = item {
            writeItem(item)
            dataManager.save()
        }
        tearDownNotifications()
    }
    
    // MARK: - private
    
    fileprivate func loadItem(_ item: TodoItem?) {
        guard let item = item else {
            // load empty state
            titleTextField.text = nil
            date = nil
            repeatState = nil
            textView.text = nil
            setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePressed(_:))))
            return
        }
        // load item
        titleTextField.text = item.name
        date = item.date as Date?
        repeatState = item.repeatState
        textView.text = item.notes
        setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deletePressed(_:))))
    }
    
    fileprivate func writeItem(_ item: TodoItem) {
        item.name = titleTextField.text
        item.notes = textView.text
        item.date = date as NSDate?
        item.repeatState = repeatState
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    private func setRightBarButtonItem(_ item: UIBarButtonItem) {
        saveButton = item
        navigationItem.rightBarButtonItem = item
    }
    
    fileprivate func makeFirstResponder(_ responder: UIResponder?) {
        if responder == textView {
            textView.isEditable = true
        }
        responder?.becomeFirstResponder()
    }
    
    // MARK: - action
    
    @IBAction private func savePressed(_ sender: UIBarButtonItem?) {
        guard let item = dataManager.insert(entityClass: TodoItem.self) else {
            return
        }
        writeItem(item)
        dataManager.save(success: { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction private func deletePressed(_ sender: UIBarButtonItem?) {
        guard let item = item else {
            return
        }
        dataManager.delete(item)
        dataManager.save(success: { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        })
    }
    
    @objc private func prevPressed(_ sender: UIBarButtonItem) {
        makeFirstResponder(previousResponder)
    }
    
    @objc private func nextPressed(_ sender: UIBarButtonItem) {
        makeFirstResponder(nextResponder)
    }
    
    @objc private func donePressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        date = sender.date as Date?
    }
    
    @objc private func dateTapped(_ sender: UIDatePicker) {
        date = sender.date as Date?
    }
    
    @objc private func textViewTapped(_ sender: UIDatePicker) {
        makeFirstResponder(textView)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let height = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        scrollView.contentSize.height = origContentSize.height + height.cgRectValue.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize.height = origContentSize.height
    }
}

// MARK: - UIPickerViewDelegate

extension ItemDetailViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return RepeatState.display[row].stringValue()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        repeatState = RepeatState.display[row]
    }
}

// MARK: - UIPickerViewDataSource

extension ItemDetailViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RepeatState.display.count
    }
}

// MARK: - UITextFieldDelegate

extension ItemDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        makeFirstResponder(nextResponder)
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case dateTextField:
            if let _ = date {
                textField.inputView = datePicker
            } else  {
                textField.inputView = simpleDatePicker
            }
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case dateTextField:
            if textField.inputView == datePicker, let date = date {
                datePicker.setDate(date, animated: true)
            } else if textField.inputView == simpleDatePicker {
                simpleDatePicker.selectRow(0, inComponent: 0, animated: true)
            }
        case repeatsTextField:
            if let repeatState = repeatState {
                repeatPicker.selectRow(repeatState.rawValue, inComponent: 0, animated: true)
            } else {
                repeatPicker.selectRow(0, inComponent: 0, animated: true)
            }
        default:
            break
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField {
        case dateTextField:
            date = nil
        case repeatsTextField:
            repeatState = nil
        default:
            break
        }
        return true
    }
}

// MARK: - UITextViewDelegate

extension ItemDetailViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.isEditable = false
    }
}

// MARK: - SimpleDatePickerDelegate

extension ItemDetailViewController: SimpleDatePickerDelegate {
    func datePicker(_ picker: SimpleDatePicker, didSelectDate date: Date?) {
        self.date = date
    }
}