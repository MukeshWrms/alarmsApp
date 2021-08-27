
//
//  ViewController.swift
//  alarmsApp
//
//  Created by Weather  on 25/08/21.
//
import Foundation
import UIKit
import CoreData
import UserNotifications

let appdelegate = UIApplication.shared.delegate as! AppDelegate
let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
let context = appdelegate.persistentContainer.viewContext
 var locationsDB  = [MessageTable]() // Where Locations = your NSManaged Class
public var locArray : [String] = []
public var filterArry : [String] = []

class ViewController: UIViewController,UNUserNotificationCenterDelegate  {
    var myTempRminder = [ReminderList]()
    var notifications: [ReminderList] = []
    var triggerDateString: String = ""
    var triggerDate: Date!
    let dateFormatter = DateFormatter()
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    @IBOutlet var timeD: UILabel!
    @IBOutlet var reminderTable: UITableView!
    var timerCount = 0
    var timerRunning = false
    var cuDayTime : String = ""
    @IBOutlet var vTitleHeader: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDateTime = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "dd HH:mm:ss"
        cuDayTime = "\(dateFormatter.string(from: currentDateTime))"
        UNUserNotificationCenter.current().delegate = self
        print("ctime",cuDayTime)
 
        
       
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self,
        selector: #selector(updateLabel), userInfo: nil, repeats: true)

      
     
        
        getCoreData()
        reminderTable.tableFooterView = UIView(frame: .zero)
        self.userNotificationCenter.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderList), name: NSNotification.Name(rawValue: "RefreshSystem"), object: nil)

        
        
      
        
    }
    @objc func updateLabel() {
        var monthData :String = ""
        let date = Date()
       
    
        let calendar = Calendar.current
        
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
         let days = String(day)
       
        let years = String(year)
        
        if month == 8
        {
            monthData = "08"
        }else if month == 9
        {
            monthData = "09"
        }else if month == 10
        {
            monthData = "10"
        }else if month == 11
        {
            monthData = "11"
        }else if month == 12
        {
            monthData = "12"
        }else if month == 1
        {
            monthData = "01"
        }else if month == 2
        {
            monthData = "02"
        }else if month == 3
        {
            monthData = "03"
        }else if month == 4
        {
            monthData = "04"
        }
        else if month == 5
        {
            monthData = "05"
        }else if month == 6
        {
            monthData = "06"
        }
        else if month == 7
        {
            monthData = "07"
        }
        let hourString = String(hour)
        let minutesString = String(minutes)
        
        timeD.text = years + "-" + monthData + "-" + days + " " + hourString + ":" + minutesString + ":00" //+ secondString
        
        for ii in myTempRminder
        {

            let getdate = ii.date
            print("get date-",getdate)
            if getdate == vTitleHeader.text
            {
                let hh = ii.date.dropFirst(11)
                let hr = hh.dropLast(6)
                let FinalHr = Int(hr)

                let mt = ii.date.dropFirst(14)
                let mint = mt.dropLast(3)
                let FinalMt = Int(mint)
                
                
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { [self] success, error in
                    if success {
                        // schedule test
                        simpleAddNotification(hour: FinalHr!, minute: FinalMt!, identifier: ii.groupid, title: ii.title, body: ii.message)
                    }
                    else if error != nil {
                        print("error occurred")
                    }
                })
                
                


            }
        }
    }


    func getCoreData()

    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageTable")
        fetchRequest.returnsObjectsAsFaults = false
        locationsDB = try! context.fetch(fetchRequest) as! [MessageTable]
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        print("-----------IMP-----------------------------")
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        print("----------------------------------------")
        print(locationsDB)
        myTempRminder.removeAll()
        for i in locationsDB
        {

            myTempRminder.append(ReminderList.init(date: i.date!, title: i.title!, message: i.message!, groupid: i.groupid!, id: i.id!))


        }
        self.reminderTable.reloadData()
        print(myTempRminder.count)
        self.myTempRminder.sort { $0.date > $1.date }





    }

    @objc func loadReminderList(notification: NSNotification){
        getCoreData()
        DispatchQueue.main.async {
            self.reminderTable.reloadData()

        }
    }
 
    

    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }

            completionHandler(success)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {

        getCoreData()
              self.myTempRminder.sort { $0.date > $1.date }
                    // Add below code line so viewWillAppear will auto reload table view data
                    DispatchQueue.main.async {
                        self.reminderTable.reloadData()
                    }




    } // end viewWillAppear

     
    public func simpleAddNotification(hour: Int, minute: Int, identifier: String, title: String, body: String) {
        // Initialize User Notification Center Object
        let center = UNUserNotificationCenter.current()

        // The content of the Notification
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        // The selected time to notify the user
       
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.hour = hour
        dateComponents.minute = minute

        // The time/repeat trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // Initializing the Notification Request object to add to the Notification Center
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        // Adding the notification to the center
//        center.add(request) { (error) in
//            if (error) != nil {
//                print(error!.localizedDescription)
//            }
//        }
 
    }

    @IBAction func btnClickAdd(_ sender: UIButton) {

        let vcAddRemindList:addReminder_ViewController  = self.storyboard?.instantiateViewController(withIdentifier: "addReminder_ViewController") as! addReminder_ViewController
        self.present(vcAddRemindList,animated :true)
    }



}


extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return myTempRminder.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableCell

        cell.vTitle.text = myTempRminder[indexPath.row].title
        cell.vMessage.text = myTempRminder[indexPath.row].message


        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: myTempRminder[indexPath.row].date)
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
        let dateStr = dateFormatter.string(from:date!)

        cell.vDateTime.text =  dateStr
       
        DispatchQueue.main.async
        {
            cell.backView.layer.cornerRadius = 10.0;
            cell.frontView.roundCorners([.topRight, .bottomRight], radius: 10)
        }

        return cell
    }
 
}



//extra
class tableCell : UITableViewCell
{
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var vType: UILabel!

    @IBOutlet var vTitle: UILabel!
    @IBOutlet var vMessage: UILabel!
    @IBOutlet var vDateTime: UILabel!
    @IBOutlet weak var vID: UILabel!
    @IBOutlet var vExtraText: UILabel!
    @IBOutlet var vExtraText1: UILabel!


}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

 
