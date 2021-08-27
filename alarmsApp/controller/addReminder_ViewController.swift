//
//  addReminder_ViewController.swift
//  alarmsApp
//
//  Created by Weather  on 26/08/21.
//

import UIKit
import CoreData
import GrowingTextView
import Toaster





 

class addReminder_ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var vTitle: UITextField!
    
    @IBOutlet var vScheduleDate: UITextField!
    @IBOutlet var vReminderMessageTxt: GrowingTextView!
    
    
  //  var myReminderArray = [MessageTable]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        vReminderMessageTxt.layer.borderWidth = 1
        vReminderMessageTxt.layer.borderColor = UIColor.gray.cgColor
        
        vTitle.layer.borderWidth = 1
        vTitle.layer.borderColor = UIColor.gray.cgColor
        vScheduleDate.layer.borderWidth = 1
        vScheduleDate.layer.borderColor = UIColor.gray.cgColor
        vScheduleDate.inputView = UIView()
        self.vScheduleDate.inputAccessoryView = UIView()
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if (touch.view == self.view) {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
 
  
    
    @IBAction func dateChnage(_ sender: Any) {
        
       
    }
    
    @IBAction func dateAction(_ sender: Any) {
        RPicker.selectDate(title: "Select Date and Time", cancelText: "Cancel", datePickerMode: .dateAndTime, style: .Inline, didSelectDate: {[weak self] (selectedDate) in
       
                   print("date",selectedDate)
                   let myOutPut = selectedDate.dateString()
       
                   print("output-",myOutPut)
       
                   self?.vScheduleDate.text = selectedDate.dateString()
       
               })
        
    }
    
    
    @IBAction func addReminder(_ sender: UIButton) {
        
            let entity = NSEntityDescription.insertNewObject(forEntityName: "MessageTable", into: nscontext)
            
            entity.setValue(self.vTitle.text, forKey: "title")
            entity.setValue(self.vReminderMessageTxt.text, forKey: "message")
            entity.setValue(self.vScheduleDate.text, forKey: "date")
            entity.setValue("9807608488", forKey: "groupid")
            let uniqueId = ProcessInfo().globallyUniqueString
            print(uniqueId)
            entity.setValue(uniqueId, forKey: "id")
            
        do {
            try nscontext.save()
              Toast(text: "SaveData Sucess.", delay: 1, duration: 3).show()
           
            
            DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                
                let deadlineTime = DispatchTime.now() + .seconds(3)
                DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshSystem"), object: nil)
                    OperationQueue.main.addOperation {
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
            
            
            
            
            
        } catch {
            print("CoreData error is : ->>>>>>>> \(error)")
        }
        
 
    }
    
    
    
    
}
