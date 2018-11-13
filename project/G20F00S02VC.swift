//
//  G20F00S02VC.swift
//  project
//
//  Created by SPJ on 9/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps
//++ BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
class G20F00S02VC: BaseParentViewController, UIPickerViewDelegate {
    @IBOutlet weak var lbltitle1:           UILabel!
    @IBOutlet weak var lblConfirm:          UILabel!
    @IBOutlet weak var lblDeliverydate:     UILabel!
    @IBOutlet weak var lbldate:             UILabel!
    @IBOutlet weak var lblHours:            UILabel!
    @IBOutlet weak var viewGoldTime:        UIView!
    @IBOutlet weak var pkvHours:            UIPickerView!
    @IBOutlet weak var pkvDays:             UIPickerView!
    @IBOutlet weak var lblGoldtime1:        UILabel!
    @IBOutlet weak var lblGoldTime2:        UILabel!
    @IBOutlet weak var lblGoldtime3:        UILabel!
    @IBOutlet weak var btnConfirm:          UIButton!
    internal var _data:                     TimerBean  = TimerBean()
    internal var _dataTimer:                ForecastBean  = ForecastBean()
    var currentHour:                        Int = 0
    var day :                               String = "0"
    var hour :                              String = "0"
    var daysList  = ["0","1","2","3","4"]
    var HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var deliverDate:                        String = DomainConst.BLANK
    var max_days =                          BaseModel.shared.max_days
    var min_hour =                          BaseModel.shared.min_hour
    var max_hour =                          BaseModel.shared.max_hour
    var min_days =                          0
    @IBAction func back(_ sender: Any) {
        if BaseModel.shared.sharedIdTimer != DomainConst.BLANK{
            let deliveryDate = BaseModel.shared.sharedDate
            BaseModel.shared.sharedString = deliveryDate
            pushToViewAndClearData(name: "G20F00S03VC")
        }
        else{
            pushToViewAndClearData(name: "G20F00S01VC")
        }
    }
    /** Location */
    let locationManager:    CLLocationManager   = CLLocationManager()
    /** Current position of map view */
    public static var _currentPos       = CLLocationCoordinate2D.init()
    
    func getDeliveryDate(day:Int, hour: Int){
        var dayFromNow: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .day, value: day, to: Date(), options: [])!
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let dayFromNowString = dateFormatter.string(from: dayFromNow)
        let deliveryDate:String = "\(self.hour)h - Ngày \(dayFromNowString)"
        lblDeliverydate.text = deliveryDate
        self.deliverDate = deliveryDate
    }
    
    @IBAction func confirm(_ sender: Any) {
        btnConfirm.isUserInteractionEnabled = false
        requestData()
    }
    
    /**
     * Request data from server
     */
    private func requestData(action: Selector = #selector(setData(_:))) {
        SetTimerRequest.request(action: action,
                                view: self, days: day, hour: hour, latitude: String(G20F00S02VC._currentPos.latitude), longitude: String(G20F00S02VC._currentPos.latitude)
        )
    }
    
    override func setData(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = TimerResponseModel(jsonString: dataStr)
        if model.isSuccess() {
            _data = model.record
            let deliveryDate = _data.date
            BaseModel.shared.sharedString = deliveryDate
            BaseModel.shared.sharedIdTimer = _data.id
            BaseModel.shared.sharedDate   =  _data.date
            BaseModel.shared.sharedDays   =  _data.days
            BaseModel.shared.sharedHour   =  _data.hour
            pushToViewAndClearData(name: "G20F00S03VC")
            btnConfirm.isUserInteractionEnabled = true
        }   
        else {
            showAlert(message: model.message)
            btnConfirm.isUserInteractionEnabled = true
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //test
        self.createNavigationBar(title: DomainConst.HOTLINE)
        lblConfirm.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lblDeliverydate.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lbldate.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        lblHours.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        let formattedString = NSMutableAttributedString()
        formattedString
            .bold("GAS CÒN DƯ TRỪ TIỀN", lbltitle1.font.pointSize)
            .normal(" KHI ĐẶT BÌNH GAS MỚI")
        lbltitle1.attributedText = formattedString
        lbltitle1.textColor = GlobalConst.MAIN_COLOR_GAS_24H
        pkvDays.delegate = self
        pkvHours.delegate = self
        if BaseModel.shared.enable_rush_hour == 0{
            self.viewGoldTime.isHidden = true
        }
        else{
            self.viewGoldTime.isHidden = false
            lblGoldtime1.text = "GIẢM NGAY \(BaseModel.shared.rushHour)"
            lblGoldtime3.text = BaseModel.shared.rushHourText
            self.viewGoldTime.bringSubview(toFront: lblGoldtime1)
            self.viewGoldTime.bringSubview(toFront: lblGoldTime2)
            self.viewGoldTime.bringSubview(toFront: lblGoldtime3)
        }
        //++
        //set list Days
        if self.max_days < 1 {
            self.max_days = 4
        }
        //set list Hours
        if self.min_hour >= self.max_hour || self.min_hour < 0 || self.max_hour < 0{
            self.min_hour = 0
            self.max_hour = 23
        }
        //--
        //requestViewData()
        checkValueTimer()
        //++ location
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        //--
    }
    
    private func checkValueTimerV2(){
        let date = Date()
        let calendar = Calendar.current
        let hour  = calendar.component(.hour, from: date) + 2
        //get minDay
        if hour > self.max_hour{
            self.min_days = 1
        }
        else{
            self.min_days = 0
        }
        // Set picker date
        self.daysList.removeAll()
        var minday = self.min_days
        while  minday <= self.max_days {
            daysList.append(String(minday))
            minday += 1 
        }
        pkvDays.reloadAllComponents()
        if let postion = daysList.index(of: self.day){
            pkvDays.selectRow(postion, inComponent: 0, animated: false)
            self.day = daysList[postion]
        }else{
            pkvDays.selectRow(0, inComponent: 0, animated: false)
            self.day = daysList[0]
        }
        // handle TH1 + TH2
        var minHour = hour % 24
        if minHour > self.min_hour && minHour <= self.max_hour{
        }
        else{
            minHour = self.min_hour
        }
        //set picker hour
        self.HoursList.removeAll()
        var iMinhour = self.min_hour
        if self.day == String(self.min_days){
            iMinhour = minHour
            if Int(self.hour)! < minHour{
                self.hour = String(minHour)
            }
        }
        while  iMinhour <= self.max_hour {
            HoursList.append(String(iMinhour))
            iMinhour += 1 
        }
        pkvHours.reloadAllComponents()
        if let postion = HoursList.index(of: self.hour){
            pkvHours.selectRow(postion, inComponent: 0, animated: false)
            self.hour = HoursList[postion]
        }
        getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
    }
    
    
    private func checkValueTimer(){
//        //Get Current Hour
//        let date = Date()
//        let calendar = Calendar.current
//        currentHour = calendar.component(.hour, from: date)
//        let hour  = currentHour + 2
//        //TH:Có lịch hẹn giao ngay
//        if BaseModel.shared.sharedIdTimer != DomainConst.BLANK{
//            self.day = BaseModel.shared.sharedDays
//            self.hour = BaseModel.shared.sharedHour
//            if self.day == "0" && self.hour == "0"{
//                setTime(hour: hour)
//            }
//                //TH:Có lịch hẹn giờ giao gas
//            else{
//                //++
//                let deliveryDate = BaseModel.shared.sharedDate
//                lblDeliverydate.text = deliveryDate
//                if let postion = daysList.index(of: self.day){
//                    pkvDays.selectRow(postion, inComponent: 0, animated: false)
//                }
//                setTimeHasTimer(hour: hour)
//                //--
//            }
//        }
//        else{
//            setTime(hour: hour)
//        }
        if BaseModel.shared.sharedIdTimer != DomainConst.BLANK{
            self.day = BaseModel.shared.sharedDays
            self.hour = BaseModel.shared.sharedHour
        }
        checkValueTimerV2()
    }
    
//    func setTimeHasTimer(hour: Int){
//        //TH Ngày = 0 
//        HoursList.removeAll()
//        if self.day == "0"{
//            var remain = hour / self.max_hour + self.min_hour 
//            if hour > self.max_hour{
//                self.day = "1"
//                pkvDays.selectRow(1, inComponent: 0, animated: false)
//            } 
//            else{
//                remain = hour
//                if self.min_hour > hour{
//                    remain = self.min_hour
//                }
//            }
//            while remain <= self.max_hour {
//                HoursList.append(String(remain))
//                remain += 1 
//            }
//        }
//        else{
//            var remain = hour
//            if self.min_hour < hour{
//                remain = self.min_hour
//            } 
//            if hour > self.max_hour && self.day == "1"{
//                remain = hour / self.max_hour + self.min_hour
//            }
//            while remain <= self.max_hour {
//                HoursList.append(String(remain))
//                remain += 1 
//            }
//        }
//        pkvHours.reloadAllComponents()
//        if let postion = HoursList.index(of: self.hour){
//            pkvHours.selectRow(postion, inComponent: 0, animated: false)
//            self.hour = HoursList[postion]
//        }
//        else{
//            pkvHours.selectRow(0, inComponent: 0, animated: false)
//            self.hour = HoursList[0]
//        }
//        getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
//    }
    
    //TH Có lịch hẹn giao ngay hoặc trường hợp không có lịch hẹn
//    func setTime(hour: Int){
//        HoursList.removeAll()
//        var remain = hour / self.max_hour + self.min_hour
//        if hour > self.max_hour{
//            self.day = "1"   
//        }
//        else{
//            self.day = "0"
//            remain = currentHour + 2
//        }
//        while remain <= self.max_hour {
//            HoursList.append(String(remain))
//            remain += 1 
//        }
//        if let postion = daysList.index(of: self.day){
//            pkvDays.selectRow(postion, inComponent: 0, animated: false)
//        }
//        pkvHours.reloadAllComponents()
//        pkvHours.selectRow(0, inComponent: 0, animated: false)
//        self.hour = HoursList[0]
//        getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
//    }    
    
    // MARK: - Picker View Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView)->Int{
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        if pickerView == pkvDays{
            return daysList.count
        }
        if pickerView == pkvHours{
            return HoursList.count
        }
        return 0
    }
    // goes in lieu of titleForRow if customization is desired
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = .center
        pickerLabel.font = UIFont(name:"Helvetica", size: pkvHours.frame.height - 15)
        if pickerView == pkvDays{
            pickerLabel.text = String(daysList[row])
        }
        else if pickerView == pkvHours{
            pickerLabel.text = String(HoursList[row])
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pkvHours.frame.height
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pkvDays{
            self.day = daysList[row]
//            let hour = currentHour + 2
//            setTimeHasTimer(hour: hour)
            checkValueTimerV2()
        }
        else if pickerView == pkvHours{
            self.hour = HoursList[row]
            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
        }
    }
}

// MARK: Protocol - CLLocationManagerDelegate
extension G20F00S02VC: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let location: CLLocation = locations.last {
            // Save current location
            G20F00S02VC._currentPos = location.coordinate
        }
    }
    
    /**
     * Tells the delegate that the authorization status for the application changed.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    /**
     * Tells the delegate that the location manager was unable to retrieve a location value.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}
//-- BUG0223-SPJ (KhoiVT 20180930) Gas24h - Forecast and set Timer Order Gas
