//
//  MedicineStatus.swift
//  SafeMed
//
//  Created by Shanky(Prgm) on 1/20/19.
//  Copyright © 2019 Shashank Venkatramani. All rights reserved.
//

import Foundation
class MedicineStatus {
    var hash:String?
    var status:Bool?
    
    init(hash: String, status: Bool){
        self.hash = hash
        self.status = status
    }
}
