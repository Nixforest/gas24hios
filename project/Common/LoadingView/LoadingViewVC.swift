//
//  LoadingViewVC.swift
//  project
//
//  Created by SPJ on 9/5/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class LoadingViewVC: BaseChildViewController, NVActivityIndicatorViewable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.self.view.backgroundColor = UIColor(red: CGFloat(237 / 255.0), green: CGFloat(85 / 255.0), blue: CGFloat(101 / 255.0), alpha: 1)
        
        let cols = 4
        let rows = 8
        let cellWidth = Int(GlobalConst.SCREEN_WIDTH / CGFloat(cols))
        let cellHeight = Int((GlobalConst.SCREEN_HEIGHT - getTopHeight()) / CGFloat(rows))
        
        (NVActivityIndicatorType.ballPulse.rawValue ... NVActivityIndicatorType.audioEqualizer.rawValue).forEach {
            let x = ($0 - 1) % cols * cellWidth
            let y = ($0 - 1) / cols * cellHeight + Int(getTopHeight())
            let frame = CGRect(x: x, y: y, width: cellWidth, height: cellHeight)
            let activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                                type: NVActivityIndicatorType(rawValue: $0)!)
            let animationTypeLabel = UILabel(frame: frame)
            
            animationTypeLabel.text = String($0)
            animationTypeLabel.sizeToFit()
            animationTypeLabel.textColor = UIColor.white
            animationTypeLabel.frame.origin.x += 5
            animationTypeLabel.frame.origin.y += CGFloat(cellHeight) - animationTypeLabel.frame.size.height
            
            activityIndicatorView.padding = 20
            if $0 == NVActivityIndicatorType.orbit.rawValue {
                activityIndicatorView.padding = 0
            }
            self.view.addSubview(activityIndicatorView)
            self.view.addSubview(animationTypeLabel)
            activityIndicatorView.startAnimating()
            
            let button: UIButton = UIButton(frame: frame)
            button.tag = $0
            button.addTarget(self,
                             action: #selector(buttonTapped(_:)),
                             for: UIControlEvents.touchUpInside)
            CommonProcess.setBorder(view: button)
            self.view.addSubview(button)
            self.view.addSubview(activityIndicatorView)
        }
        
        // Navigation
        self.createNavigationBar(title: "Thử nghiệm Loading view")
    }
    
    func buttonTapped(_ sender: UIButton) {
        let size = CGSize(width: 30, height: 30)
        
        startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: sender.tag)!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
            NVActivityIndicatorPresenter.sharedInstance.setMessage("Authenticating...")
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            self.stopAnimating()
        }
    }
}
