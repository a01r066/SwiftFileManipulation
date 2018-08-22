//
//  PDFViewController.swift
//  TinyApps
//
//  Created by Thanh Minh on 11/22/17.
//  Copyright © 2017 Thanh Minh. All rights reserved.
//

import UIKit
import PDFKit
import SnapKit

protocol BooksControllerDelegate {
    func didWriteToDocuments(data: Data)
}

@available(iOS 11.0, *)
class PDFViewController: UIViewController, PDFViewDelegate {
    var delegate: BooksControllerDelegate?
    
    var selectedBook: Book?
    
    var pdfdocument: PDFDocument?
    
    var pdfview: PDFView!
    var pdfthumbView: PDFThumbnailView!
    let toolView = ToolView.instanceFromNib()
    weak var observe : NSObjectProtocol?
    
    var currentPage: PDFPage!
    
    var location: URL?
    var pdfData: Data?
    var dataFile = AppFile()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        pdfview = PDFView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-50))
        
        currentPage = pdfview.currentPage
        pdfview.delegate = self
        
        pdfdocument = PDFDocument(data: pdfData!)
        
        pdfview.document = pdfdocument
        pdfview.backgroundColor = UIColor.white
        
        pdfview.autoScales = true
        pdfview.maxScaleFactor = 4.0
        pdfview.minScaleFactor = pdfview.scaleFactorForSizeToFit
        
        pdfview.displayMode = .singlePage
        pdfview.displayDirection = .horizontal
        pdfview.usePageViewController(true, withViewOptions: nil)

        self.view.addSubview(pdfview)
    }
    
    @objc func handleCancel(){
        let alert = UIAlertController(title: "Thêm vào thư viện để đọc tiếp", message: "", preferredStyle: .actionSheet)
        let agreeAction = UIAlertAction(title: "Đồng ý", style: .default) { (agreeAction) in
            print("Agree. write to documents")
            self.dismiss(animated: true, completion: {
                self.delegate?.didWriteToDocuments(data: self.pdfData!)
            })
        }
        let disagreeAction = UIAlertAction(title: "Không", style: .destructive) { (disagreeAction) in
            print("Disagree")
            self.dismiss(animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel) { (cancelAction) in
            print("Huỷ")
        }
        
        alert.addAction(agreeAction)
        alert.addAction(disagreeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
