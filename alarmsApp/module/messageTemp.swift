//
//  messageTemp.swift
//  alarmsApp
//
//  Created by Weather  on 26/08/21.
//

import Foundation
struct messageTemp: Codable {
    let reminderList: [ReminderList]
   
    enum CodingKeys: String, CodingKey {
        case reminderList
         
    }
}
struct ReminderList: Codable {
    let date, title,message,groupid: String
    let id : String
    
    init(date:String, title: String ,message:String,groupid:String,id : String){
       self.title = title
       self.date = date
       self.message = message
       self.id = id
       self.groupid = groupid
  
       }
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case date = "date"
        case message = "message"
        case id = "id"
        case groupid = "groupid"


   }
    
}
    
  
 
  
