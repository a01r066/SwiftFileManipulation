//
//  ToolView.swift
//  TinyApps
//
//  Created by Thanh Minh on 11/22/17.
//  Copyright © 2017 Thanh Minh. All rights reserved.
//

import UIKit

class ToolView: UIView {
//    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var thumbnailBt: UIButton!
    @IBOutlet weak var outlineBt: UIButton!
//    @IBOutlet weak var searchBt: UIButton!
    @IBOutlet weak var editAnotationBt: UIButton!
    
    @IBOutlet weak var bookmarkBt: UIButton!
    
    class func instanceFromNib() -> ToolView {
        return UINib(nibName: "ToolView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ToolView
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
    }
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        setupViews()
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    func setupViews(){
//        Bundle.main.loadNibNamed("ToolView", owner: self, options: nil)
//        addSubview(containerView)
//        containerView.frame = self.bounds
//    }
}
