//
//  ViewController.swift
//  Boxee Remote iOS
//
//  Created by Taylor Glaeser on 1/14/16.
//  Copyright © 2016 Taylor Glaeser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  let notification : UILabel = UILabel()

  let username : String = "boxee" // Default: boxee
  let password : String = "boxee" // Default: boxee
  let host : String = "127.0.0.1" // Default: 127.0.0.1
  let port : String = "8080"      // Default: 8080

  override func viewDidLoad() {
    super.viewDidLoad()

    notification.frame = CGRectMake(0, 50, view.frame.width, 75)
    notification.backgroundColor = UIColor.blackColor()
    notification.textAlignment = .Center
    notification.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 100)
    view.addSubview(notification)

    let appName : UILabel = UILabel()

    appName.frame = CGRectMake(0, view.frame.height - 75, view.frame.width, 75)
    appName.backgroundColor = UIColor.blackColor()
    appName.textAlignment = .Center
    appName.font = UIFont.init(name: "HelveticaNeue-UltraLight", size: 40)
    appName.text = "Boxee Remote"
    appName.textColor = UIColor.whiteColor()

    view.addSubview(appName)


    let buttons : [String:[String:AnyObject]] = [
      "UP": [
        "position": 1,
        "button": UIButton(type: .System)
      ],
      "DOWN": [
        "position": 7,
        "button": UIButton(type: .System)
      ],
      "LEFT": [
        "position": 3,
        "button": UIButton(type: .System)
      ],
      "RIGHT": [
        "position": 5,
        "button": UIButton(type: .System)
      ],
      "SELECT": [
        "position": 4,
        "button": UIButton(type: .System)
      ],
      "BACK": [
        "position": 6,
        "button": UIButton(type: .System)
      ],
      "PAUSE": [
        "position": 8,
        "button": UIButton(type: .System)
      ],
      "REWIND": [
        "position": 0,
        "button": UIButton(type: .System)
      ],
      "FF": [
        "position": 2,
        "button": UIButton(type: .System)
      ]
    ]

    for (name, data) in buttons {
      if let btn = data["button"] as? UIButton {

        let pos = data["position"] as! CGFloat

        let maxWidth : CGFloat = view.frame.width

        let width : CGFloat = round(maxWidth / 3) - 20
        let height : CGFloat = width

        let x = ((pos % 3) * width) + ((pos % 3) * 25) + 5 // Why 5!?
        let y = (floor(pos / 3) * height) + (floor(pos / 3) * 25) + (view.frame.width / 2)

        btn.frame = CGRectMake(x, y, width, height)
        btn.setTitle(name, forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.backgroundColor = UIColor.grayColor()

        btn.addTarget(self, action: Selector("sendMessage:"), forControlEvents: .TouchUpInside)

        view.addSubview(btn)
      }
    }
  }

  func sendMessage(sender: UIButton) {
    if let button = sender.titleLabel!.text {
      var command : String
      switch button {
      case "UP": command = "SendKey(270)"
      case "DOWN": command = "SendKey(271)"
      case "LEFT": command = "SendKey(272)"
      case "RIGHT": command = "SendKey(273)"
      case "SELECT": command = "SendKey(256)"
      case "BACK": command = "SendKey(257)"
      case "PLAY/PAUSE": command = "Pause()"
      case "REWIND": command = "SeekPercentageRelative(-5)"
      case "FAST FORWARD": command = "SeekPercentageRelative(5)"
      default: return
      }

      let request = NSMutableURLRequest(URL: NSURL(string: "http://\(host):\(port)/xbmcCmds/xbmcHttp?command=" + command)!)

      let authStr : String = "\(username):\(password)"
      let authData : NSData = authStr.dataUsingEncoding(NSUTF8StringEncoding)!
      let authValue : String = "Basic " + authData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.init(rawValue: 0))
      request.setValue(authValue, forHTTPHeaderField: "Authorization")

      let task : NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (d, r, e) in
        if let httpResponse = r as? NSHTTPURLResponse {
          let status = httpResponse.statusCode

          if status == 200 {
            self.setNotificationColor(true, str: button)
          } else {
            self.setNotificationColor(false, str: button)
          }
        }

      }

      task.resume()
    }
  }

  func setNotificationColor(good: Bool, str: String) -> Void {
    if good {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), { () -> Void in
        self.notification.text = str
        self.notification.textColor = UIColor.greenColor()
        //        self.notification.backgroundColor = UIColor.greenColor()
      })
    } else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), { () -> Void in
        self.notification.text = str
        self.notification.textColor = UIColor.redColor()
        //        self.notification.backgroundColor = UIColor.redColor()
      })
    }

    // NOTE: This triggers after 1/10th of a second.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100_000_000), dispatch_get_main_queue(), { () -> Void in
      self.notification.text = ""
      self.notification.textColor = UIColor.blackColor()
      //      self.notification.backgroundColor = UIColor.blackColor()
    })
  }
}

