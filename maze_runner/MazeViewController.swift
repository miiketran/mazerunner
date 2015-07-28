//
//  MazeViewController.swift
//  maze_runner
//
//  Created by Michael Tran on 7/27/15.
//  Copyright © 2015 Michael Tran. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
class MazeViewController: UIViewController {
    var timerCount = 0
    var timerRunning = false
    var timer = NSTimer()
    func Counting() {
        timerCount += 1
        timerLabel.text = "\(timerCount)"
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    var stepCount = 0
    var landscape = true
    @IBOutlet weak var scoreCount: UILabel!
    @IBAction func resetButtonPressed(sender: UIButton) {
        pedometer.stopPedometerUpdates()
        scoreCount.text = "0"
        if timerRunning == true {
            timer.invalidate()
            timerRunning = false
            timerCount = 0
            timerLabel.text = "0"
            
        }
    }
    
    @IBOutlet weak var quitButtonLabel: UIButton!
    
    @IBAction func leftArrowButton(sender: UIButton) {
        leftArrow.enabled = false
        rightArrow.enabled = false
        mainImage.image = UIImage(named: "straight_path2.png")
        landscape = true
    }
    @IBOutlet weak var leftArrow: UIButton!
    @IBAction func rightArrowButton(sender: UIButton) {
        leftArrow.enabled = false
        rightArrow.enabled = false
        mainImage.image = UIImage(named: "straight_path2.png")
        landscape = true
    }
    @IBOutlet weak var rightArrow: UIButton!
    override func viewDidAppear(animated: Bool) {
        if timerRunning == false {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("Counting"), userInfo: nil, repeats: true)
            timerRunning = true
        }
        rightArrow.hidden = false
        leftArrow.hidden = false
        leftArrow.enabled = false
        rightArrow.enabled = false
        scoreCount.text = "0"
        pedometer.startPedometerUpdatesFromDate(NSDate(), withHandler: { data, error in
            print("Update \(data!.numberOfSteps)")
            dispatch_async(dispatch_get_main_queue()) {
                self.scoreCount.text = String(stringInterpolationSegment: data!.numberOfSteps)
                self.stepCount = Int(data!.numberOfSteps)
                self.travel()
            }
        })
    }
    let pedometer: CMPedometer = CMPedometer()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var startButtonLabel: UIButton!
    func travel() {
        
        let rand = arc4random_uniform(100)
        print(rand)
        if stepCount > 100 {
            // change to finished image
            mainImage.image = UIImage(named: "door.png")
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            quitButtonLabel.setTitle("FINISH", forState: .Normal)
            rightArrow.hidden = true
            leftArrow.hidden = true
        }
        else if stepCount % 5 == 0 && landscape {
            if rand < 40 {
                // change to straight path
                mainImage.image = UIImage(named: "straight_path2.png")
                leftArrow.enabled = false
                rightArrow.enabled = false
                landscape = true
            }
            else if rand < 50 {
                // change to fork
                mainImage.image = UIImage(named: "fork.png")
                leftArrow.enabled = true
                rightArrow.enabled = true
                landscape = false
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

            }
            else if rand < 75 {
                // change to right corner
                mainImage.image = UIImage(named: "veer_right.png")
                leftArrow.enabled = false
                rightArrow.enabled = true
                landscape = false
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
            else {
                // change to left corner
                mainImage.image = UIImage(named: "veer_left.png")
                leftArrow.enabled = true
                rightArrow.enabled = false
                landscape = false
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

            }
        }
    }
}