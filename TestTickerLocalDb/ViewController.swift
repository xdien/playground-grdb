//
//  ViewController.swift
//  TestTickerLocalDb
//
//  Created by xdien on 17/11/2023.
//

import GRDB
import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try LocalDbManager.shared.write { db in
                // TODO: sample record
                try Chat(id: 1, name: "channel 1").insert(db)
                    try Chat(id: 2, name: "channel 2" ).insert(db)
                    try Chat(id: 3, name: "channel 3").insert(db)
                    try Chat(id: 4, name: "channel 4").insert(db)
                    
                    try Message(id: 1, chatID: 1, date: Date(timeIntervalSince1970: 0), text: "message 0").insert(db)
                    try Message(id: 2, chatID: 1, date: Date(timeIntervalSince1970: 2), text: "message 2").insert(db) // latest
                    try Message(id: 3, chatID: 1, date: Date(timeIntervalSince1970: 1), text: "message 1").insert(db)
                    
                    try Message(id: 4, chatID: 2, date: Date(timeIntervalSince1970: 1), text: "message 1").insert(db)
                    try Message(id: 5, chatID: 2, date: Date(timeIntervalSince1970: 0), text: "message 0").insert(db)
                    try Message(id: 6, chatID: 2, date: Date(timeIntervalSince1970: 2), text: "message 2").insert(db) // latest
                    
                    try Message(id: 7, chatID: 3, date: Date(timeIntervalSince1970: 1), text: "message 1").insert(db) // latest
            }
        } catch {
            print(error)
        }
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            let chatInfos: [AuthorInfo]? = try LocalDbManager.shared.dbQueue.read { db in
                let request = Author
                    .including(all: Author.books)
                    .asRequest(of: AuthorInfo.self)
                let aaa = try request.fetchAll(db)
                print(aaa.map({ $0.books.count }))
                return aaa
            }

        } catch {
            print("error \(error)")
        }
    }
}
