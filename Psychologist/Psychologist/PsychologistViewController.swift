//
//  ViewController.swift
//  Psychologist
//
//  Created by Ralbatr on 15/6/17.
//  Copyright (c) 2015年 ralbatr Yi. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 获取当前navgationview堆栈上最上边的vc
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
        }
        // 如果当前vc是happinessvc
        if let hvc = destination as? HappinessViewController {
            if let identifier = segue.identifier {
                switch identifier {
                    case "sad": hvc.happiness = 0
                    case "happy": hvc.happiness = 100
                    default : hvc.happiness = 50
                }
            }
        }
    }
}

