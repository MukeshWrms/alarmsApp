//
//  extraCode.swift
//  alarmsApp
//
//  Created by Weather  on 26/08/21.
//

import Foundation
extension Date {
    
    func dateString(_ format: String = "yyyy-MM-dd HH:mm:ss") -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format

        return dateFormatter.string(from: self)
    }

    
}

