//
//  BooksController.swift
//  iOS File Management
//
//  Created by Thanh Minh on 8/22/18.
//  Copyright © 2018 Andrew L. Jaffee. All rights reserved.
//

import UIKit
import Firebase

class BooksController: UIViewController {    
    let cellID = "CellID"
    @IBOutlet weak var tableView: UITableView!
    
    var books: [Book] = []
    var selectedBook: Book?
    
    let tempFile = AppFile()
    var isFileExist: Bool = false
    
    private var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        fetchBooks()
    }
    
    func fetchBooks(){
        Database.database().reference().child("Ebooks").child("452063C4-BA6C-4B00-A231-82E278E85C6E").observeSingleEvent(of: .value) { (snapshot) in
            guard let dicts = snapshot.value as? [String:Any] else { return }
            dicts.forEach({ (key, value) in
                guard let dict = value as? [String:Any] else { return }
                let book = Book(bookID: key, dict: dict)
                self.books.append(book)
            })
            self.tableView.reloadData()
        }
    }
    
    func setupTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 96
    }
}

extension BooksController: BooksControllerDelegate {
    func didWriteToDocuments(data: Data) {
        print("Write to file.")
        _ = tempFile.writePdfFile(data: data, to: .Documents, withName: (selectedBook?.title)!)
        _ = tempFile.list()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

extension BooksController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let book = books[indexPath.row]
        cell.textLabel?.text = "\(book.title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedBook = books[indexPath.row]
        
        guard let title = selectedBook?.title else { return }
        let filename = getDocumentsDirectory().appendingPathComponent("\(title)")
        
        isFileExist = tempFile.exists(file: filename)
        if(isFileExist){
            print("Open file.")
            let pdfData = try! Data(contentsOf: filename)
            handleOpenBook(data: pdfData)
        } else {
            print("Download book.")
            downloadBook(book: selectedBook!)
        }
    }
    
    func downloadBook(book: Book){
        let fileURLString = book.fileURLString
        createDownloadTask(fileURLString: fileURLString)
    }
}

extension BooksController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("didFinishDownloading to: \(location)")
        
        let data = try! Data(contentsOf: location)
        handleOpenBook(data: data)
    }
    
    func handleOpenBook(data: Data){
        let controller = PDFViewController()
        controller.delegate = self
        controller.isFileExist = isFileExist
        controller.pdfData = data
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    func createDownloadTask(fileURLString: String){
        let downloadRequest = URLRequest(url: URL(string: fileURLString)!)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
        downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask?.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        print("\(progress)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error?.localizedDescription ?? "")
            return
        } else {
            print("Download finished!")
            
            _ = tempFile.list()
        }
    }
}
