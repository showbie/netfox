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
        
        bodyView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
        bodyView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        bodyView.backgroundColor = UIColor.clearColor()
        bodyView.textColor = UIColor.NFXGray44Color()
        bodyView.editable = false
        bodyView.selectable = true
        bodyView.font = UIFont.NFXFont(11)
        
        switch bodyType {
            case .REQUEST:
                self.bodyView.text = self.selectedModel.getRequestBody() as String
        default:
                self.bodyView.text = self.selectedModel.getResponseBody() as String
        }
        
        self.view.addSubview(self.bodyView)
        
    }
}