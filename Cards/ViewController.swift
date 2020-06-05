//
//  ViewController.swift
//  Cards
//
//  Created by Darren Jones on 14/03/2020.
//  Copyright © 2020 Dappological Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    
    var keepgoing = true
    var results:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text       = nil
        countLabel.text     = nil
        averageLabel.text   = nil
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        if startButton.titleLabel?.text == "Start"
        {
            textView.text       = nil
            countLabel.text     = nil
            averageLabel.text   = nil
            results             = []
            startButton.setTitle("Stop", for: .normal)
            keepgoing           = true
            activityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .utility).async {
                [weak self] in
                
                var count = 0
                var str = ""
                while self?.keepgoing == true
                {
                    let result = Card.findThreeOfAKind()
//                    let result = Card.findPerfectPair()
//                    print(result)
                    self?.results.append(result)
                    str.append("\(result), ")
                    count += 1
                    
                    if count == 1
                    {
                        count = 0
                        
                        DispatchQueue.main.async {
                            self?.textView.text = "\(self?.textView.text ?? "")\n\(str)"
//                            self?.textView.text = "\(self?.textView.text ?? "")\n\(result)"
                            self?.scrollTextViewToBottom(textView: (self?.textView)!)
                            
                            self?.countLabel.text = "Wins: \(self?.results.count ?? 0)"
                            
                            let average = self?.results.average
                            let averageString = String(format:"%.1f", average ?? 0)
                            self?.averageLabel.text = "Average: \(averageString)"
                            
                            str = ""
                        }
                    }
                    
//                    usleep(20000)
                }
            }
        }
        else if startButton.titleLabel?.text == "Stop"
        {
            startButton.setTitle("Start", for: .normal)
            
            keepgoing = false
            activityIndicator.stopAnimating()
        }
    }
    
    func scrollTextViewToBottom(textView: UITextView) {
        if textView.text.count > 0 {
            let location = textView.text.count - 1
            let bottom = NSMakeRange(location, 1)
            textView.scrollRangeToVisible(bottom)
        }
    }
    
}

extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double { isEmpty ? 0 : Double(total) / Double(count) }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element { isEmpty ? 0 : total / Element(count) }
}
