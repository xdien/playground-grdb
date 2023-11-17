//
//  ViewController.swift
//  TestTickerLocalDb
//
//  Created by xdien on 17/11/2023.
//

import UIKit
import GRDB

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        do {
            try LocalDbManager.shared.write { db in
                // TODO: sample record
                var authorInfo = AuthorInfo(author: Author(id: 1, name: "John Doe"), books: [
                    Book(id: 1, title: "Book 1", authorId: 1),
                    Book(id: 2, title: "Book 2", authorId: 1),
                    Book(id: 3, title: "Book 3", authorId: 1),
                ])
                try authorInfo.upsert(db)
            }
        } catch {
            print(error)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do {
            try LocalDbManager.shared.read { db in
                // Lấy tất cả danh sách sách của tác giả John Doe
                let request = Author
                        .including(all: Author.books)
                        .asRequest(of: AuthorInfo.self)
                    let authorInfos = try request.fetchAll(db)
                    for authorInfo in authorInfos {
                        print("\(authorInfo.author.name) wrote \(authorInfo.books.count) books")
                    }
            }
        } catch {
            print(error)
        }
    }
}
