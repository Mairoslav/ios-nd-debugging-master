//
//  BreakpointBugViewController.swift
//  SoManyBugs
//
//  Created by Jarrod Parkes on 4/16/15.
//  Copyright (c) 2015 Jarrod Parkes. All rights reserved.
//

import UIKit

// MARK: - BreakpointBugViewController: UIViewController

class BreakpointBugViewController: UIViewController {

    // MARK: Properties
    
    let bugFactory = BugFactory.sharedInstance()
    let maxBugs = 100 // changed from 0 to 100
    let moveDuration = 3.0
    let disperseDuration = 1.0    
    var bugs = [UIImageView]()

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        view.addGestureRecognizer(singleTapRecognizer)
    }

    // MARK: Bug Functions
    
    func addBugToView() {
        if bugs.count < maxBugs {
            let newBug = bugFactory.createBug()
            bugs.append(newBug)
            view.addSubview(newBug) // added in lesson 7. Stepping Through Code
            moveBugsAnimation()
        }
    }

    func emptyBugsFromView() {
        for bug in self.bugs {
            bug.removeFromSuperview()
        }
        self.bugs.removeAll(keepingCapacity: true)
    }
    
    // MARK: View Animations
    
    func moveBugsAnimation() {
        UIView.animate(withDuration: moveDuration) {
            for bug in self.bugs {
                let randomPosition = CGPoint(x: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxX - bug.frame.size.width))) + UInt32(bug.frame.size.width/2)), y: CGFloat(arc4random_uniform(UInt32(UInt(self.view.bounds.maxY - bug.frame.size.height))) + UInt32(bug.frame.size.height/2)))
                bug.frame = CGRect(x: randomPosition.x - bug.frame.size.width/1.5, y: randomPosition.y - bug.frame.size.height/1.5, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
        }
        // addBugToView() // extra call, so we delete that, see "4. Fix the breakpoint scene"
    }
    
    func disperseBugsAnimation() {
        UIView.animate(withDuration: disperseDuration, animations: { () -> Void in
            for bug in self.bugs {
                let offScreenPosition = CGPoint(x: (bug.center.x - self.view.center.x) * 20, y: (bug.center.y - self.view.center.y) * 20)
                bug.frame = CGRect(x: offScreenPosition.x, y: offScreenPosition.y, width: BugFactory.bugSize.width, height: BugFactory.bugSize.height)
            }
        }, completion: { (finished) -> Void in
            if finished { self.emptyBugsFromView() }
        })
    }
    
    // MARK: Actions
    
    @IBAction func popToMasterView() {
        let _ = navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - BreakpointBugViewController (UIResponder)

extension BreakpointBugViewController {
    override var canBecomeFirstResponder: Bool { return true }
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake { disperseBugsAnimation() }
    }
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        addBugToView()
        // addBugToView() // extra call, comment out
    }
}

extension BreakpointBugViewController { // : CustomStringConvertible, CustomDebugStringConvertible {
    override var description: String {
        return "Hello from CustomStringConvertible"
    } /*
    override var debugDescription: String {
        return "Hello from CustomDebugStringConvertible"
    } // is more specific debug protocol, therefore this only one is printed */
}
