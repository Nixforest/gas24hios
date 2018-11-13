//
//  G20F00S01VC.swift
//  project
//
//  Created by SPJ on 9/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
import VVWaterWaveView
import SwiftKeychainWrapper
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class G20F00S01VC: BaseParentViewController {
    @IBOutlet weak var lblGasPercent: UILabel!
    @IBOutlet weak var lblDatesForecast: UILabel!
    @IBOutlet weak var viewGasTank: UIView!
    @IBOutlet weak var lbltitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    
    @IBOutlet weak var btnOrder: UIButton!
    
    @IBOutlet weak var imgGasBody: UIImageView!
    
    @IBOutlet weak var imgGasLevel10: UIImageView!
    @IBOutlet weak var imgGasLevel9: UIImageView!
    @IBOutlet weak var imgGasLevel8: UIImageView!
    @IBOutlet weak var imgGasLevel7: UIImageView!
    @IBOutlet weak var imgGasLevel6: UIImageView!
    @IBOutlet weak var imgGasLevel5: UIImageView!
    @IBOutlet weak var imgGasLevel4: UIImageView!
    @IBOutlet weak var imgGasLevel3: UIImageView!
    @IBOutlet weak var imgGasLevel2: UIImageView!
    @IBOutlet weak var imgGasLevel1: UIImageView!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var levelOfGas: NSLayoutConstraint!
    
    @IBOutlet weak var imgWarning: UIImageView!
    @IBOutlet weak var lblWarningtitle: UILabel!
    
    @IBOutlet weak var lblWarningContent: UILabel!
    @IBOutlet weak var lblLastOrder: UILabel!
    //@IBOutlet weak var viewGasAmount: UIImageView!
    
    @IBOutlet weak var viewWave: VVWaterWaveView!
    
    @IBOutlet var superView: UIView!
    @IBOutlet weak var bottomOfViewWave: NSLayoutConstraint!
    
    @IBOutlet weak var viewGasTankTopConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var trallingOfViewWave: NSLayoutConstraint!
//    @IBOutlet weak var leadingOfViewWave: NSLayoutConstraint!
    @IBOutlet weak var widthViewWave: NSLayoutConstraint!
    internal var _data:              ForecastBean  = ForecastBean()
    internal var _dataTimer:              TimerBean  = TimerBean()
    var level: Int = 0
    var bottomConstraint: NSLayoutConstraint?
    var bottomWaveViewConstraint: NSLayoutConstraint?
    @IBAction func orderGas(_ sender: Any) {
        //requestViewData()
        //requestDataCheck()
        pushToViewAndClearData(name: "G20F00S02VC")
    }
    
    /**
     * Request data from server
     */
//    private func requestDataCheck(action: Selector = #selector(setDataCheck(_:))) {
//        ForecastViewRequest.request(action: action,
//                                    view: self
//        )
//    }
    
//    func setDataCheck(_ notification: Notification) {
//        let dataStr = (notification.object as! String)
//        let model = ForecastViewResponseModel(jsonString: dataStr)
//        if model.isSuccess() {
//            _data = model.record
//            BaseModel.shared.rushHour = _data.rushHour
//            BaseModel.shared.rushHourText = _data.rushHourText
//            BaseModel.shared.bankDiscount = _data.bankDiscount
//            if _data.schedule.id == DomainConst.BLANK {
//                pushToViewAndClearData(name: "G20F00S02VC")
//            }
//            else{
//                let deliveryDate = _data.schedule.date
//                BaseModel.shared.sharedString = deliveryDate
//                BaseModel.shared.sharedIdTimer = _dataTimer.id
//                pushToViewAndClearData(name: "G20F00S03VC")
//            }
//            
//        }
//        else{
//            showAlert(message: model.message)
//        }
//        
//    }
    
    /**
     * Request data from server
     */
//    private func requestViewData(action: Selector = #selector(setViewData(_:))) {
//        OrderViewTimerRequest.request(action: action,
//                                      view: self
//        )
//    }
    
//    func setViewData(_ notification: Notification) {
//        let dataStr = (notification.object as! String)
//        let model = TimerResponseModel(jsonString: dataStr)
//        if model.isSuccess() {
//            _dataTimer = model.record
//            let deliveryDate = _dataTimer.date
//            BaseModel.shared.sharedString = deliveryDate
//            BaseModel.shared.sharedIdTimer = _dataTimer.id
//            pushToViewAndClearData(name: "G20F00S03VC")      
//        }   
//        else {
//            pushToViewAndClearData(name: "G20F00S02VC")
//        }
//        
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.createNavigationBar(title: DomainConst.HOTLINE)
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("GAS CÒN DƯ TRỪ TIỀN", lbltitle1.font.pointSize)
            .normal(" KHI ĐẶT BÌNH GAS MỚI")
        lbltitle1.attributedText = formattedString
        lbltitle1.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lblTitle2.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lblWarningContent.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lblWarningtitle.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        imgGasLevel10.isHidden = true 
        self.viewGasTank.bringSubview(toFront: imgGasBody)
        viewNotification.layer.cornerRadius = view.frame.size.height / 20
        viewNotification.layer.borderWidth = 1
        viewNotification.layer.borderColor = UIColor.yellow.cgColor
        //setGasLevel10()
        self.viewWave.percent = 1; 
        self.viewWave.amplitude = 10.0;
        self.viewWave.waveLayerColorArray = [UIColor.red]
        self.viewWave.startWave()
        //self.viewNotification.bringSubview(toFront: lblRemain)
        
        requestData()
        // Do any additional setup after loading the view.
        // test with progress bar 
        //progressBar.isHidden = true
        //
    }
    
    func setGasLevel1(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        level = 1
    }
    
    func setGasLevel2(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        level = 2
    }
    
    func setGasLevel3(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        level = 3
    }
    
    func setGasLevel4(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        level = 4
    }
    
    func setGasLevel5(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        level = 5
    }

    func setGasLevel6(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        self.viewGasTank.bringSubview(toFront: imgGasLevel6)
        level = 6
    }
    
    func setGasLevel7(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        self.viewGasTank.bringSubview(toFront: imgGasLevel6)
        self.viewGasTank.bringSubview(toFront: imgGasLevel7)
        level = 7
    }
    
    func setGasLevel8(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        self.viewGasTank.bringSubview(toFront: imgGasLevel6)
        self.viewGasTank.bringSubview(toFront: imgGasLevel7)
        self.viewGasTank.bringSubview(toFront: imgGasLevel8)
        level = 8
    }
    
    func setGasLevel9(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        self.viewGasTank.bringSubview(toFront: imgGasLevel6)
        self.viewGasTank.bringSubview(toFront: imgGasLevel7)
        self.viewGasTank.bringSubview(toFront: imgGasLevel8)
        self.viewGasTank.bringSubview(toFront: imgGasLevel9)
        level = 9
    }
    
    func setGasLevel10(){
        self.viewGasTank.bringSubview(toFront: imgGasLevel1)
        self.viewGasTank.bringSubview(toFront: imgGasLevel2)
        self.viewGasTank.bringSubview(toFront: imgGasLevel3)
        self.viewGasTank.bringSubview(toFront: imgGasLevel4)
        self.viewGasTank.bringSubview(toFront: imgGasLevel5)
        self.viewGasTank.bringSubview(toFront: imgGasLevel6)
        self.viewGasTank.bringSubview(toFront: imgGasLevel7)
        self.viewGasTank.bringSubview(toFront: imgGasLevel8)
        self.viewGasTank.bringSubview(toFront: imgGasLevel9)
        self.viewGasTank.bringSubview(toFront: imgGasLevel10)
        imgGasLevel10.isHidden = false 
        level = 10
    }
    /**
     * Request data from server
     */
    private func requestData(action: Selector = #selector(setData(_:))) {
        ForecastViewRequest.request(action: action,
                                           view: self
                                        )
    }
    
    override func setData(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = ForecastViewResponseModel(jsonString: dataStr)
        if model.isSuccess() {
            _data = model.record
            BaseModel.shared.rushHour           = _data.rushHour
            BaseModel.shared.rushHourText       = _data.rushHourText
            BaseModel.shared.bankDiscount       = _data.bankDiscount
            BaseModel.shared.enable_bank        = _data.enable_bank
            BaseModel.shared.enable_rush_hour   = _data.enable_rush_hour
            BaseModel.shared.max_days           = _data.max_days
            BaseModel.shared.min_hour           = _data.min_hour
            BaseModel.shared.max_hour           = _data.max_hour
            if _data.schedule.id == DomainConst.BLANK {
                self.view.bringSubview(toFront: btnOrder)
                let formattedString = NSMutableAttributedString()
                formattedString
                    .bold(String(_data.gas_percent), lblGasPercent.font.pointSize)
                    .bold("%",lblGasPercent.font.pointSize * 0.75)
//                formattedString
//                    .bold("100", lblGasPercent.font.pointSize)
//                    .bold("%",lblGasPercent.font.pointSize * 0.75)
                let formattedString1 = NSMutableAttributedString()
                formattedString1
                    .bold(String(_data.days_forecast), lblDatesForecast.font.pointSize)
                    .bold(" NGÀY",lblDatesForecast.font.pointSize * 0.9)
//                formattedString1
//                    .bold("3333", lblDatesForecast.font.pointSize)
//                    .bold(" NGÀY",lblDatesForecast.font.pointSize * 0.9 )
//                formattedString1
//                    .bold("222", lblDatesForecast.font.pointSize)
//                    .small(" NGÀY",lblDatesForecast.font.pointSize * 0.85)
//                formattedString1
//                    .bold(String(1149), lblDatesForecast.font.pointSize)
//                    .small(" NGÀY",lblDatesForecast.font.pointSize * 0.85)
//                lblGasPercent.attributedText = formattedString
//                lblDatesForecast.attributedText = formattedString1
                lblGasPercent.attributedText = formattedString
                lblDatesForecast.attributedText = formattedString1
                let currentFontSize = lblLastOrder.font.pointSize
                let yourAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: currentFontSize)]
                let yourOtherAttributes = [NSForegroundColorAttributeName: GlobalConst.MAIN_COLOR_GAS_24H, NSFontAttributeName: UIFont.systemFont(ofSize: currentFontSize)]
                
                let partOne = NSMutableAttributedString(string: "Ngày đặt gas lần trước:  ", attributes: yourAttributes)
                let partTwo = NSMutableAttributedString(string: _data.last_order, attributes: yourOtherAttributes)
                
                let combination = NSMutableAttributedString()
                combination.append(partOne)
                combination.append(partTwo) 
                lblLastOrder.attributedText = combination
                // Test Gas Percent
                //_data.gas_percent = 81
                //
                if _data.can_order == 1{
                    btnOrder.isHidden = false
                    lblWarningtitle.isHidden = false
                    lblWarningContent.isHidden = false
                    imgWarning.isHidden = false
                    self.viewGasTank.bringSubview(toFront: imgWarning)
                    self.viewGasTank.bringSubview(toFront: lblWarningtitle)
                    self.viewGasTank.bringSubview(toFront: lblWarningContent)
                }
                else{
                    lbltitle1.isHidden = true
                    lblTitle2.isHidden = true
                    btnOrder.isHidden = true
                    lblWarningtitle.isHidden = true
                    lblWarningContent.isHidden = true
                    imgWarning.isHidden = true
                    viewGasTankTopConstraint.constant = -(btnOrder.frame.height)
                }
                if _data.gas_percent < 15{
                    setGasLevel1()
                }
                else if _data.gas_percent >= 15 && _data.gas_percent < 25{
                    setGasLevel2()
                }
                else if _data.gas_percent >= 25 && _data.gas_percent < 35{
                    setGasLevel3()
                }
                else if _data.gas_percent >= 35 && _data.gas_percent < 45{
                    setGasLevel4()
                }
                else if _data.gas_percent >= 45 && _data.gas_percent < 55{
                    setGasLevel5()
                }
                else if _data.gas_percent >= 55 && _data.gas_percent < 65{
                    setGasLevel6()
                }
                else if _data.gas_percent >= 65 && _data.gas_percent < 75{
                    setGasLevel7()
                }
                else if _data.gas_percent >= 75 && _data.gas_percent < 85{
                    setGasLevel8()
                }
                else if _data.gas_percent >= 85 && _data.gas_percent < 95{
                    setGasLevel9()
                }
                else if _data.gas_percent >= 95 && _data.gas_percent <= 100{
                    setGasLevel10()
                }
                if #available(iOS 9.0, *) {
                    switch level {
                    case 1:
                        levelOfGas.constant = 0
                        levelOfGas.isActive = true
                        bottomOfViewWave.isActive = true
                        //bottomWaveViewConstraint?.isActive = false
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 2:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel2.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel2.topAnchor, constant: 2)
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 3:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel3.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel3.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [GlobalConst.LEVEL_GAS_LEVER3]
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 4:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel4.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel4.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [GlobalConst.LEVEL_GAS_LEVER4]
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 5:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel5.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel5.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [UIColor.orange]      
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 6:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel6.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel6.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [GlobalConst.LEVEL_GAS_LEVER6]
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 7:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel7.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel7.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [GlobalConst.LEVEL_GAS_LEVER7]
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 8:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel8.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel8.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [UIColor.white,GlobalConst.LEVEL_GAS_LEVER8]
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 9:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel9.topAnchor, constant: view.frame.size.height / 20 - 3)
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel9.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [UIColor.white,GlobalConst.LEVEL_GAS_LEVER9]
                        //                    leadingOfViewWave.constant = 3
                        //                    trallingOfViewWave.constant = 3
                        //widthViewWave.multiplier = 0.92
                        let newConstraint = self.widthViewWave.constraintWithMultiplier(0.94)
                        self.viewGasTank.removeConstraint(self.widthViewWave)
                        self.viewGasTank.addConstraint(newConstraint)
                        let rectShape = CAShapeLayer()
                        rectShape.bounds = self.viewWave.frame
                        rectShape.position = self.viewWave.center
                        rectShape.path = UIBezierPath(roundedRect: self.viewWave.bounds, byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 30, height: 30)).cgPath
                        
                        self.viewWave.layer.backgroundColor = UIColor.white.cgColor
                        //            //Here I'm masking the textView's layer with rectShape layer
                        self.viewWave.layer.mask = rectShape
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    case 10:
                        bottomConstraint = viewNotification.bottomAnchor.constraint(equalTo: imgGasLevel10.topAnchor, constant: view.frame.size.height / 20 - 3 )
                        bottomWaveViewConstraint = viewWave.bottomAnchor.constraint(equalTo: imgGasLevel10.topAnchor, constant: 2)
                        self.viewWave.waveLayerColorArray = [UIColor.white,GlobalConst.LEVEL_GAS_LEVER10]
                        //                    leadingOfViewWave.constant = 14
                        //                    trallingOfViewWave.constant = 14
                        let newConstraint = self.widthViewWave.constraintWithMultiplier(0.818)
                        self.viewGasTank.removeConstraint(self.widthViewWave)
                        self.viewGasTank.addConstraint(newConstraint)
                        //self.viewGasTank.layoutIfNeeded()
                        //widthViewWave.constraintWithMultiplier(0.818)
                        levelOfGas.isActive = false
                        bottomConstraint?.isActive = true
                        bottomOfViewWave.isActive = false
                        bottomWaveViewConstraint?.isActive = true
                        self.viewGasTank.bringSubview(toFront: viewWave)
                        break
                    default: break
                    }
                } 
                else {
                    
                }
                self.viewGasTank.bringSubview(toFront: viewNotification)
                //++ test
                //btnOrder.isHidden = false
                //--
                BaseModel.shared.sharedString  = DomainConst.BLANK
                BaseModel.shared.sharedIdTimer = DomainConst.BLANK
                BaseModel.shared.sharedDate    = DomainConst.BLANK
                BaseModel.shared.sharedDays    = DomainConst.BLANK
                BaseModel.shared.sharedHour    = DomainConst.BLANK
            }
            else{
                //_dataTimer = _data.schedule
                let deliveryDate = _data.schedule.date
                BaseModel.shared.sharedString = deliveryDate
                BaseModel.shared.sharedIdTimer = _data.schedule.id
                BaseModel.shared.sharedDate   =  _data.schedule.date
                BaseModel.shared.sharedDays   =  _data.schedule.days
                BaseModel.shared.sharedHour   =  _data.schedule.hour
                pushToViewAndClearData(name: "G20F00S03VC")
            }
            
        }
        else{
            showAlert(message: model.message)
        }
  
    }
}
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
