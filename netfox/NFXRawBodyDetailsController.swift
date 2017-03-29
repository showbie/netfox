//
//  NFXRawBodyDetailsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//

import Foundation
import UIKit

class NFXRawBodyDetailsController: NFXGenericBodyDetailsController
{
    var bodyView: UITextView = UITextView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Body details"
        
        bodyView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        bodyView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        bodyView.backgroundColor = UIColor.clear
        bodyView.textColor = UIColor.NFXGray44Color()
        bodyView.isEditable = false
        bodyView.isSelectable = true
        bodyView.font = UIFont.NFXFont(11)
        
        switch bodyType {
            case .request:
                self.bodyView.text = self.selectedModel.getRequestBody() as String
        default:
                self.bodyView.text = self.selectedModel.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
        
    }
}
