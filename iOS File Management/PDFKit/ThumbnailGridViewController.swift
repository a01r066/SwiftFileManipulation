//
//  ThumbnailGridViewController.swift
//  TinyApps
//
//  Created by Thanh Minh on 11/22/17.
//  Copyright © 2017 Thanh Minh. All rights reserved.
//

import UIKit
import PDFKit

protocol ThumbnailGridViewControllerDelegate: class{
    @available(iOS 11.0, *)
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumbnailGridViewController, didSelectPage page: PDFPage)
}

@available(iOS 11.0, *)
class ThumbnailGridViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    open var pdfDocument: PDFDocument?
    weak var delegate: ThumbnailGridViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                           target: self,
                                                           action: #selector(closeBtnClick))
        
        // Register cell classes
        collectionView?.register(UINib(nibName: "ThumbnailGridCell", bundle: nil),
                                 forCellWithReuseIdentifier: "ThumbnailGridCell")
        
        
        collectionView?.backgroundColor = UIColor.gray
    }
    
    @objc func closeBtnClick(sender: UIBarButtonItem) {
        dismiss(animated: false, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocument?.pageCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ThumbnailGridCell", for: indexPath) as! ThumbnailGridCell
        
        if let page = pdfDocument?.page(at: indexPath.item) {
            let thumbnail = page.thumbnail(of: cell.bounds.size, for: PDFDisplayBox.cropBox)
            cell.image = thumbnail
            cell.pageLab.text = page.label
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let page = pdfDocument?.page(at: indexPath.item) {
            dismiss(animated: false, completion: nil)
            delegate?.thumbnailGridViewController(self, didSelectPage: page)
        }
    }
}
