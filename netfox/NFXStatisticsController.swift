//
//  NFXStatisticsController.swift
//  netfox
//
//  Copyright © 2015 kasketis. All rights reserved.
//


import Foundation
import UIKit

class NFXStatisticsController: NFXGenericController
{
    var scrollView: UIScrollView = UIScrollView()
    var textLabel: UILabel = UILabel()

    var totalModels: Int = 0

    var successfulRequests: Int = 0
    var failedRequests: Int = 0
    
    var totalRequestSize: Int = 0
    var totalResponseSize: Int = 0
    
    var totalResponseTime: Float = 0
    
    var fastestResponseTime: Float = 999
    var slowestResponseTime: Float = 0

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Statistics"
        
        generateStatics()
        
        self.scrollView = UIScrollView()
        self.scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.scrollView.autoresizesSubviews = true
        self.scrollView.backgroundColor = UIColor.clear
        self.view.addSubview(self.scrollView)

        self.textLabel = UILabel()
        self.textLabel.frame = CGRect(x: 20, y: 20, width: scrollView.frame.width - 40, height: scrollView.frame.height - 20);
        self.textLabel.font = UIFont.NFXFont(13)
        self.textLabel.textColor = UIColor.NFXGray44Color()
        self.textLabel.numberOfLines = 0
        self.textLabel.attributedText = getReportString()
        self.textLabel.sizeToFit()
        self.scrollView.addSubview(self.textLabel)
        
        self.scrollView.contentSize = CGSize(width: scrollView.frame.width, height: self.textLabel.frame.maxY)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NFXGenericController.reloadData),
            name: NSNotification.Name(rawValue: "NFXReloadData"),
            object: nil)
        
    }
    
    func getReportString() -> NSAttributedString
    {
        var tempString: String
        tempString = String()
        
        tempString += "[Total requests] \n\(self.totalModels)\n\n"
        
        tempString += "[Successful requests] \n\(self.successfulRequests)\n\n"
        tempString += "[Failed requests] \n\(self.failedRequests)\n\n"
        
        tempString += "[Total request size] \n\(Float(self.totalRequestSize/1024)) KB\n\n"
        if self.totalModels == 0 {
            tempString += "[Avg request size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg request size] \n\(Float((self.totalRequestSize/self.totalModels)/1024)) KB\n\n"
        }
        
        tempString += "[Total response size] \n\(Float(self.totalResponseSize/1024)) KB\n\n"
        if self.totalModels == 0 {
            tempString += "[Avg response size] \n0.0 KB\n\n"
        } else {
            tempString += "[Avg response size] \n\(Float((self.totalResponseSize/self.totalModels)/1024)) KB\n\n"
        }

        if self.totalModels == 0 {
            tempString += "[Avg response time] \n0.0s\n\n"
            tempString += "[Fastest response time] \n0.0s\n\n"
        } else {
            tempString += "[Avg response time] \n\(Float(self.totalResponseTime/Float(self.totalModels)))s\n\n"
            if self.fastestResponseTime == 999 {
                tempString += "[Fastest response time] \n0.0s\n\n"
            } else {
                tempString += "[Fastest response time] \n\(self.fastestResponseTime)s\n\n"
            }
        }
        tempString += "[Slowest response time] \n\(self.slowestResponseTime)s\n\n"

        return formatNFXString(tempString)
    }
    
    func generateStatics()
    {
        let models = NFXHTTPModelManager.sharedInstance.getModels()
        totalModels = models.count
        
        for model in models {
            
            if model.isSuccessful() {
                successfulRequests += 1
            } else  {
                failedRequests += 1
            }
            
            if let requestBodyLength = model.requestBodyLength {
                totalRequestSize += requestBodyLength
            }
            
            if let responseBodyLength = model.responseBodyLength {
                totalResponseSize += responseBodyLength
            }
            
            if let timeInterval = model.timeInterval {
                totalResponseTime += timeInterval
                
                if timeInterval < self.fastestResponseTime {
                    self.fastestResponseTime = model.timeInterval!
                }
                
                if timeInterval > self.slowestResponseTime {
                    self.slowestResponseTime = model.timeInterval!
                }
            }
        }
    }
    
    func clearStatistics()
    {
        self.totalModels = 0
        self.successfulRequests = 0
        self.failedRequests = 0
        self.totalRequestSize = 0
        self.totalResponseSize = 0
        self.totalResponseTime = 0
        self.fastestResponseTime = 999
        self.slowestResponseTime = 0
    }
    
    override func reloadData()
    {
        clearStatistics()
        generateStatics()
        DispatchQueue.main.async { () -> Void in
            self.textLabel.attributedText = self.getReportString()
        }
    }
}
