////
////  old.swift
////  alarmsApp
////
////  Created by Weather  on 27/08/21.
////
//
//import Foundation
////
////  ViewController.swift
////  alarmsApp
////
////  Created by Weather  on 25/08/21.
////
//
//import UIKit
//import CoreData
//import UserNotifications
//
//let appdelegate = UIApplication.shared.delegate as! AppDelegate
//let nscontext = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
//let context = appdelegate.persistentContainer.viewContext
// var locationsDB  = [MessageTable]() // Where Locations = your NSManaged Class
//public var locArray : [String] = []
//public var filterArry : [String] = []
//
//class ViewController: UIViewController ,UNUserNotificationCenterDelegate {
//    var myTempRminder = [ReminderList]()
//    var notifications: [ReminderList] = []
//    var triggerDateString: String = ""
//    var triggerDate: Date!
//    let dateFormatter = DateFormatter()
//    let userNotificationCenter = UNUserNotificationCenter.current()
//    @IBOutlet var reminderTable: UITableView!
//    var timerCount = 0
//    var timerRunning = false
//    var cuDayTime : String = ""
//    @IBOutlet var vTitleHeader: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let currentDateTime = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:00"
//        cuDayTime = "\(dateFormatter.string(from: currentDateTime))"
//
////        self.vTitleHeader.text = ""
//        if timerCount == 0 {
//            timerRunning = false
//        }
//        if self.timerRunning == false {
//            _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.Counting), userInfo: nil, repeats: true)
//             self.timerRunning = true
//        }
//         self.timerCount = 15
//
//
//        getCoreData()
//        reminderTable.tableFooterView = UIView(frame: .zero)
//        self.userNotificationCenter.delegate = self
//        NotificationCenter.default.addObserver(self, selector: #selector(loadReminderList), name: NSNotification.Name(rawValue: "RefreshSystem"), object: nil)
//
//    }
//
//
//
//    func getCoreData()
//
//    {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MessageTable")
//        fetchRequest.returnsObjectsAsFaults = false
//        locationsDB = try! context.fetch(fetchRequest) as! [MessageTable]
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        print("-----------IMP-----------------------------")
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
//        print("----------------------------------------")
//        print(locationsDB)
//        myTempRminder.removeAll()
//        for i in locationsDB
//        {
//
//            myTempRminder.append(ReminderList.init(date: i.date!, title: i.title!, message: i.message!, groupid: i.groupid!, id: i.id!))
//
//
//        }
//        self.reminderTable.reloadData()
//        print(myTempRminder.count)
//        self.myTempRminder.sort { $0.date > $1.date }
//
//
//
//
//
//    }
//
//    @objc func loadReminderList(notification: NSNotification){
//        getCoreData()
//        DispatchQueue.main.async {
//            self.reminderTable.reloadData()
//
//        }
//    }
//
//    //--counting resolved
//    @objc func Counting() {
//        if timerCount > 0 {
//            self.vTitleHeader.text = "00:\(timerCount)"
//            timerCount -= 1
//
//
//        } else {
//
//                if timerRunning == false {
//
//                    _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.Counting), userInfo: nil, repeats: true)
//
//                    timerRunning = true
//                }
//                for ii in myTempRminder
//                {
//                    print("reminder date -",ii.date)
//                    print("current date",cuDayTime)
//                    if ii.date == cuDayTime
//                    { //yyyy-MM-dd HH:mm:ss
//                        let year = ii.date.dropLast(15)
//                        let FinalYr = (Int(year))
//
//                        let month = ii.date.dropFirst(5)
//                        let fmonth = month.dropLast(12)
//                        let FinalMo = Int(fmonth)
//
//                        let days = ii.date.dropFirst(8)
//                        let fdays = days.dropLast(9)
//                        let FinalD = Int(fdays)
//
//                        let hh = ii.date.dropFirst(11)
//                        let hr = hh.dropLast(6)
//                        let FinalHr = Int(hr)
//
//                        let mt = ii.date.dropFirst(14)
//                        let mint = mt.dropLast(3)
//                        let FinalMt = Int(mint)
//                       // year: FinalYr!, month: FinalMo!, day: FinalD!,
//
////                        simpleAddNotification(hour: FinalHr!, minute: FinalMt!, identifier: ii.groupid, title: ii.title, body: ii.message)
//
//
//                    }
//                }
//                timerCount = 15
//
//        }
//
//    }
//
//
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        getCoreData()
//
//
//
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { success, error in
//            if success {
//                // schedule test
//
//            }
//            else if error != nil {
//                print("error occurred")
//            }
//        })
//
//
//                    self.myTempRminder.sort { $0.date > $1.date }
//                    // Add below code line so viewWillAppear will auto reload table view data
//                    DispatchQueue.main.async {
//                        self.reminderTable.reloadData()
//                    }
//
//
//
//
//    } // end viewWillAppear
//
//    //year : Int, month:Int, day:Int,
//    public func simpleAddNotification(hour: Int, minute: Int, identifier: String, title: String, body: String) {
//        // Initialize User Notification Center Object
//        let center = UNUserNotificationCenter.current()
//
//        // The content of the Notification
//        let content = UNMutableNotificationContent()
//        content.title = title
//        content.body = body
//        content.sound = .default
//
//        // The selected time to notify the user
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//
//        // The time/repeat trigger
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//        // Initializing the Notification Request object to add to the Notification Center
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//
//        // Adding the notification to the center
//        center.add(request) { (error) in
//            if (error) != nil {
//                print(error!.localizedDescription)
//            }
//        }
//
//
//
//
//    }
//
//    @IBAction func btnClickAdd(_ sender: UIButton) {
//
//        let vcAddRemindList:addReminder_ViewController  = self.storyboard?.instantiateViewController(withIdentifier: "addReminder_ViewController") as! addReminder_ViewController
//        self.present(vcAddRemindList,animated :true)
//    }
//
//
//
//}
//
//
//extension ViewController: UITableViewDelegate, UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return myTempRminder.count
//
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableCell
//
//        cell.vTitle.text = myTempRminder[indexPath.row].title
//        cell.vMessage.text = myTempRminder[indexPath.row].message
//
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let date = dateFormatter.date(from: myTempRminder[indexPath.row].date)
//        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm a"
//        let dateStr = dateFormatter.string(from:date!)
//
//        cell.vDateTime.text =  dateStr
//        simpleAddNotification(hour: 1, minute: 40, identifier: "kdkf", title:"Testing", body:"asodjnsa")
//
//        DispatchQueue.main.async
//        {
//            cell.backView.layer.cornerRadius = 10.0;
//            cell.frontView.roundCorners([.topRight, .bottomRight], radius: 10)
//        }
//
//        return cell
//    }
//
//
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//
//    }
//}
//
//
//
////extra
//class tableCell : UITableViewCell
//{
//    @IBOutlet weak var backView: UIView!
//    @IBOutlet weak var frontView: UIView!
//    @IBOutlet weak var vType: UILabel!
//
//    @IBOutlet var vTitle: UILabel!
//    @IBOutlet var vMessage: UILabel!
//    @IBOutlet var vDateTime: UILabel!
//    @IBOutlet weak var vID: UILabel!
//    @IBOutlet var vExtraText: UILabel!
//    @IBOutlet var vExtraText1: UILabel!
//
//
//}
//
//extension UIView {
//
//    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        self.layer.mask = mask
//    }
//}
//
//extension UIViewController {
//
//
//
//    func errMsgs(Title : String, MessageTxt : String )
//    {
//        let alertController = UIAlertController(title: Title , message: MessageTxt, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {
//            UIAlertAction in
//
//        }
//        _ = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
//            UIAlertAction in
//        }
//        // Add the actions
//        alertController.addAction(okAction)
//        // Present the controller
//        self.present(alertController, animated: true, completion: nil)
//    }
//}
