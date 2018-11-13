//
//  G20F00S03VC.swift
//  project
//
//  Created by SPJ on 9/28/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class G20F00S03VC: BaseParentViewController {
    
    //@IBOutlet weak var imgReduct: UIImageView!
    
    @IBOutlet weak var imgReduct: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnDateDelivery: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblReduct: UILabel!
    @IBAction func edit(_ sender: Any) {
        pushToViewAndClearData(name: "G20F00S02VC")
    }
    
    
    @IBAction func deleteDate(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Thông báo", message: "Bạn chắc chắn muốn xoá đặt gas hẹn giờ vào \(BaseModel.shared.sharedString)?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.requestDeleteData()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(refreshAlert, animated: true, completion: nil)
        
        //pushToViewAndClearData(name: "G20F00S01VC")
    }

    /**
     * Request data from server
     */
    private func requestDeleteData(action: Selector = #selector(deleteTimer(_:))) {
        DeleteTimerRequest.request(action: action,
                                   view: self, id: BaseModel.shared.sharedIdTimer
        )
    }
    
    func deleteTimer(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = TimerResponseModel(jsonString: dataStr)
        if model.isSuccess() {
            BaseModel.shared.sharedIdTimer = DomainConst.BLANK
            BaseModel.shared.sharedDate = DomainConst.BLANK
            BaseModel.shared.sharedDays = DomainConst.BLANK
            BaseModel.shared.sharedHour = DomainConst.BLANK
            BaseModel.shared.enable_rush_hour = 0
            BaseModel.shared.enable_bank = 0
            showAlert(message: model.message,
                      okHandler: {
                        alert in
                        //self.backButtonTapped(self)
                        //G08F00S02VC._id = model.record.id
                        self.pushToViewAndClearData(name: "G20F00S01VC")
            })
        }   
        else {
            if model.code == "2247"{
                showAlert(message: model.message,
                          okHandler: {
                            alert in
                            //self.backButtonTapped(self)
                            //G08F00S02VC._id = model.record.id
                            self.pushToViewAndClearData(name: "G20F00S01VC")
                })
            }
            else{
                showAlert(message: model.message)
            }
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: DomainConst.HOTLINE)
        lblTitle.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        btnDateDelivery.contentEdgeInsets = UIEdgeInsets(top: 10, left: 25, bottom: 10, right: 25)
        btnDateDelivery.layer.borderWidth = 1
        btnDateDelivery.layer.borderColor = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
        btnDateDelivery.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnDateDelivery.isUserInteractionEnabled = false
        btnEdit.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnDelete.setTitleColor(GlobalConst.MAIN_COLOR_GAS_24H, for: UIControlState())
        btnDateDelivery.setTitle(BaseModel.shared.sharedString, for: UIControlState())
        if BaseModel.shared.enable_bank == 0{
            imgReduct.isHidden = true
        }
        else{
            lblReduct.text = "\(BaseModel.shared.bankDiscount)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        BaseModel.shared.sharedString = DomainConst.BLANK
        //BaseModel.shared.sharedIdTimer = DomainConst.BLANK
    }
    
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
