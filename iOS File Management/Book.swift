//
//  Book.swift
//  iOS File Management
//
//  Created by Thanh Minh on 8/22/18.
//  Copyright © 2018 Andrew L. Jaffee. All rights reserved.
//

import Foundation

struct Book {
    let bookID: String
    let title: String
    let fileURLString: String
    
    init(bookID: String, dict: [String:Any]) {
        self.bookID = bookID
        self.title = dict["title"] as? String ?? "Title"
        self.fileURLString = dict["fileURLString"] as? String ?? ""
    }
}
