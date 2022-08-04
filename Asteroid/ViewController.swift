//
//  ViewController.swift
//  Asteroid
//
//  Created by Global on 03/08/22.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var endDate: UITextField!
    
    let datePicker = UIDatePicker()
    let formatter = DateFormatter()
    static var sharedStartDateString: String = ""
    static var sharedEndDateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
    }

    func createDatePicker(){
        
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        
        let toolbar1 = UIToolbar()
        let toolbar2 = UIToolbar()
        
        datePicker.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 200, width: self.view.frame.width, height: 200)
        datePicker.datePickerMode = .date
        
        let startDoneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startDateDonePressed))
        
        toolbar1.setItems([startDoneBtn], animated: true)
        toolbar1.sizeToFit()
        
        let endDateBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endDateDonePressed))
        
        toolbar2.setItems([endDateBtn], animated: true)
        toolbar2.sizeToFit()
        
        if((startDate?.text != nil ) && (endDate?.text != nil )){
            startDate.textAlignment = .center
            endDate.textAlignment = .center
            startDate.inputAccessoryView = toolbar1
            startDate.inputView = datePicker
            endDate.inputAccessoryView = toolbar2
            endDate.inputView = datePicker
        }
    }
    
    @objc func startDateDonePressed(){
        
        let dateFormatted = formattedDateFromString(dateString: formatter.string(from: datePicker.date), withFormat: "yyyy-MM-dd")
        startDate.text = dateFormatted
        ViewController.sharedStartDateString = dateFormatted ?? ""
        self.view.endEditing(true)
    }
    
    @objc func endDateDonePressed(){

        let dateFormatted = formattedDateFromString(dateString: formatter.string(from: datePicker.date), withFormat: "yyyy-MM-dd")
        endDate.text = dateFormatted
        ViewController.sharedEndDateString = dateFormatted ?? ""
        self.view.endEditing(true)
    }
    
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = format
            let resultString = dateFormatter.string(from: date)
            return resultString
        }
        
        return nil
    }
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBAction func submitPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showChart", sender: self)
    }
    

}

