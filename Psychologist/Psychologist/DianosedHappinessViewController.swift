//
//  DianosedHappinessViewController.swift
//  Psychologist
//
//  Created by Ralbatr on 15/6/18.
//  Copyright (c) 2015年 ralbatr Yi. All rights reserved.
//

import UIKit

class DianosedHappinessViewController: HappinessViewController ,UIPopoverPresentationControllerDelegate {
    
    override var happiness: Int {
        didSet {
            diagnosticHistory += [happiness]
        }
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var diagnosticHistory:[Int] {
        get {
            return defaults.objectForKey(History.DefaultsKey) as? [Int] ?? []
        }
        set {
            defaults.setObject(newValue, forKey:History.DefaultsKey)
        }
    }
    
    private struct History {
        static let SegueIdentifier = "ShowDiagnosticHistiory"
        static let DefaultsKey = "DiagnoseHappiness"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifer = segue.identifier {
            switch identifer {
            case History.SegueIdentifier:
                if let tvc = segue.destinationViewController as? TextViewController {
                    if let ppc = tvc.popoverPresentationController {
                        ppc.delegate = self
                    }
                    tvc.text = "\(diagnosticHistory)"
                }
            default : break
            }
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
