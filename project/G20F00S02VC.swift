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

class G20F00S02VC: BaseParentViewController, UIPickerViewDelegate {
    @IBOutlet weak var lbltitle1: UILabel!
    @IBOutlet weak var lblConfirm: UILabel!
    @IBOutlet weak var lblDeliverydate: UILabel!
    @IBOutlet weak var lbldate: UILabel!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var viewGoldTime: UIView!
    @IBOutlet weak var pkvHours: UIPickerView!
    @IBOutlet weak var pkvDays: UIPickerView!
    
    @IBOutlet weak var lblGoldtime1: UILabel!
    @IBOutlet weak var lblGoldTime2: UILabel!
    @IBOutlet weak var lblGoldtime3: UILabel!
    @IBOutlet weak var btnConfirm: UIButton!
    internal var _data:              TimerBean  = TimerBean()
    internal var _dataTimer:              ForecastBean  = ForecastBean()
    var currentHour: Int = 0
    var day : String = "0"
    var hour : String = "0"
    var daysList = ["0","1","2","3","4"]
    var HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    var deliverDate:String = DomainConst.BLANK
    @IBAction func back(_ sender: Any) {
        if BaseModel.shared.sharedIdTimer != DomainConst.BLANK{
            //let deliveryDate = _dataTimer.schedule.date
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
    
    
    
    //@IBOutlet weak var btnDays: UIButton!
    
    //@IBOutlet weak var btnHours: UIButton!
    
//    @IBAction func setDeliveryDate(_ sender: Any) {
//        //1. Create the alert controller.
//        let alert = UIAlertController(title: "Hẹn ngày giao", message: "Chọn số ngày giao gas", preferredStyle: .alert)
//        
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.placeholder = "Số ngày"
//        }
//        
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
////            print("Text field: \(String(describing: textField?.text))")
//            self.btnDays.setTitle(textField?.text, for: UIControlState())
//            self.day = (textField?.text)!
//            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
//        }))
//        
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//    }
    
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
    
    
//    @IBAction func setDeliveryHours(_ sender: Any) {
//        //1. Create the alert controller.
//        let alert = UIAlertController(title: "Hẹn giờ giao", message: "Chọn giờ giao gas", preferredStyle: .alert)
//        
//        //2. Add the text field. You can configure it however you need.
//        alert.addTextField { (textField) in
//            textField.placeholder = "Số giờ"
//        }
//        
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
//            //            print("Text field: \(String(describing: textField?.text))")
//            self.btnHours.setTitle(textField?.text, for: UIControlState())
//            self.hour = (textField?.text)!
//            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
//        }))
//        
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//    }
    
    @IBAction func confirm(_ sender: Any) {
        btnConfirm.isUserInteractionEnabled = false
            requestData()
//        BaseModel.shared.sharedString = self.deliverDate
//        pushToViewAndClearData(name: "G20F00S03VC")
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
        //viewGoldTime.isHidden = true
         if BaseModel.shared.enable_rush_hour == 0{
            self.viewGoldTime.isHidden = true
        }
        else{
            self.viewGoldTime.isHidden = false
            lblGoldtime1.text = "GIẢM NGAY \(BaseModel.shared.rushHour)"
            //lblGoldtime2.text = "GIẢM NGAY \(BaseModel.shared.rushHour)"
            lblGoldtime3.text = BaseModel.shared.rushHourText
            self.viewGoldTime.bringSubview(toFront: lblGoldtime1)
            self.viewGoldTime.bringSubview(toFront: lblGoldTime2)
            self.viewGoldTime.bringSubview(toFront: lblGoldtime3)
        }
        //requestViewData()
        checkValueTimer()
        //++ location
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //        switch CLLocationManager.authorizationStatus() {
        //        case .denied, .notDetermined, .restricted:
        //            locationManager.requestWhenInUseAuthorization()
        //            showAlert(message: DomainConst.CONTENT00529,
        //                      okHandler: {
        //                        alert in
        //                        UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
        //            })
        //            break
        //        default:
        //            break
        //        }
        //        locationManager.startUpdatingLocation()
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        
        //--
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        checkValueTimer()
//    }
    
    private func checkValueTimer(){
        if BaseModel.shared.sharedIdTimer != DomainConst.BLANK{
            self.day = BaseModel.shared.sharedDays
            self.hour = BaseModel.shared.sharedHour
            if self.day == "0" && self.hour == "0"{
                //Get Current Hour
                let date = Date()
                let calendar = Calendar.current
                let hour  = calendar.component(.hour, from: date) + 1
                currentHour = hour - 1
//                for (index, element) in daysList.enumerated() {
//                    if(element == self.day){
//                        pkvDays.selectRow(index, inComponent: 0, animated: false)
//                    }
//                }
                if let postion = daysList.index(of: self.day){
                    pkvDays.selectRow(postion, inComponent: 0, animated: false)
                }
                self.hour = String(hour)
                self.day = "0"
                //TH1: Giờ hiện tại là 22h
                if hour == 23 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    self.hour = "0"
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                }
                    //TH2: Giờ hiện tại là 23 giờ
                else if hour >= 24 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    self.hour = "1"
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                }
                else{
                    HoursList.removeAll()
                    var hourString:Int = currentHour + 2
                    while hourString <= 23 {
                        HoursList.append(String(hourString))
                        hourString += 1 
                    }
                    pkvHours.reloadAllComponents()
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                    self.hour = HoursList[0]
                }
                getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
            }
            else{
                let deliveryDate = BaseModel.shared.sharedDate
                lblDeliverydate.text = deliveryDate
                //Get Current Hour
                let date = Date()
                let calendar = Calendar.current
                let hour  = calendar.component(.hour, from: date) + 1
                currentHour = hour - 1
                for (index, element) in daysList.enumerated() {
                    if(element == self.day){
                        pkvDays.selectRow(index, inComponent: 0, animated: false)
                    }
                }
                //TH Ngày = 0 
                if self.day == "0"{
                    HoursList.removeAll()
                    var hourString = hour
                    // TH: Giờ hiện tại là 22h
                    if hour == 23{
                        HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                        pkvDays.selectRow(1, inComponent: 0, animated: false)
                        self.day = "1"
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                    }
                    // TH: Giờ hiện tại là 23h
                    if hour >= 24{
                        HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                        pkvDays.selectRow(1, inComponent: 0, animated: false)
                        self.day = "1"
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                    }
                    else{
                        hourString += 1
                        while hourString <= 23 {
                            HoursList.append(String(hourString))
                            hourString += 1 
                        }
                        pkvHours.reloadAllComponents()
                        if Int(self.hour)! >= hourString{
                            for (index, element) in HoursList.enumerated() {
                                if(element == self.hour){
                                    pkvHours.selectRow(index, inComponent: 0, animated: false)
                                    self.hour = element
                                }
                            }
                        }
                            //Truong hop giờ đang xét nhỏ hơn giờ hiện tại
                        else{
                            pkvHours.selectRow(0, inComponent: 0, animated: false)
                            self.hour = HoursList[0]
                        }
                    }
                }
                else{
                    for (index, element) in daysList.enumerated() {
                        if(element == self.day){
                            pkvDays.selectRow(index, inComponent: 0, animated: false)
                            self.day = element
                        }
                    }
                    if hour >= 24 && self.day == "1"{
                        HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    }
                    else{
                        HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    }
                    pkvHours.reloadAllComponents()
                    for (index, element) in HoursList.enumerated() {
                        if(element == self.hour){
                            pkvHours.selectRow(index, inComponent: 0, animated: false)
                            self.hour = element
                        }
                    }
                }
            }
        }
        else{
            //++
            let date = Date()
            let calendar = Calendar.current
            let hour  = calendar.component(.hour, from: date) + 1
            //let minutes = calendar.component(.minute, from: date) 
            currentHour = hour - 1
            self.hour = String(hour)
            self.day = "0"
            //TH1: Giờ hiện tại là 22h
            if hour == 23 {
                //Chuyen sang ngay 1
                self.day = "1"
                pkvDays.selectRow(1, inComponent: 0, animated: false)
                HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                pkvHours.reloadAllComponents()
                self.hour = "0"
                pkvHours.selectRow(0, inComponent: 0, animated: false)
            }
                //TH2: Giờ hiện tại là 23 giờ
            else if hour >= 24 {
                //Chuyen sang ngay 1
                self.day = "1"
                pkvDays.selectRow(1, inComponent: 0, animated: false)
                HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                pkvHours.reloadAllComponents()
                self.hour = "1"
                pkvHours.selectRow(0, inComponent: 0, animated: false)
            }
            else{
                HoursList.removeAll()
                var hourString:Int = currentHour + 2
                while hourString <= 23 {
                    HoursList.append(String(hourString))
                    hourString += 1 
                }
                pkvHours.reloadAllComponents()
                pkvHours.selectRow(0, inComponent: 0, animated: false)
                self.hour = HoursList[0]
            }
            getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
            
        }
    }
    /**
     * Request data from server
     */
//    private func requestViewData(action: Selector = #selector(setViewData(_:))) {
//        ForecastViewRequest.request(action: action,
//                                    view: self
//        )
//    }
    
    func setViewData(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = ForecastViewResponseModel(jsonString: dataStr)
        if model.isSuccess() {
            _dataTimer = model.record
            //TH1: Có giờ hẹn
            if _dataTimer.schedule.id != DomainConst.BLANK{
                self.day = _dataTimer.schedule.days
                self.hour = _dataTimer.schedule.hour
                let deliveryDate = _dataTimer.schedule.date
                lblDeliverydate.text = deliveryDate
                //Get Current Hour
                let date = Date()
                let calendar = Calendar.current
                let hour  = calendar.component(.hour, from: date) + 1
                currentHour = hour - 1
                for (index, element) in daysList.enumerated() {
                    if(element == self.day){
                        pkvDays.selectRow(index, inComponent: 0, animated: false)
                    }
                }
                //TH Ngày = 0 
                if self.day == "0"{
                    HoursList.removeAll()
                    var hourString = hour
                    // TH: Giờ hiện tại là 22h
                    if hour == 23{
                        HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                        pkvDays.selectRow(1, inComponent: 0, animated: false)
                        self.day = "1"
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                    }
                    // TH: Giờ hiện tại là 23h
                    if hour >= 24{
                        HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                        pkvDays.selectRow(1, inComponent: 0, animated: false)
                        self.day = "1"
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                    }
                    else{
                        hourString += 1
                        while hourString <= 23 {
                            HoursList.append(String(hourString))
                            hourString += 1 
                        }
                        pkvHours.reloadAllComponents()
                        if Int(self.hour)! >= hourString{
                            for (index, element) in HoursList.enumerated() {
                                if(element == self.hour){
                                    pkvHours.selectRow(index, inComponent: 0, animated: false)
                                    self.hour = element
                                }
                            }
                        }
                            //Truong hop giờ đang xét nhỏ hơn giờ hiện tại
                        else{
                            pkvHours.selectRow(0, inComponent: 0, animated: false)
                            self.hour = HoursList[0]
                        }
                    }
                }
//                if self.hour != "0"{
//                    for (index, element) in HoursList.enumerated() {
//                        if(element == self.hour){
//                            pkvHours.selectRow(index, inComponent: 0, animated: false)
//                            self.hour = element
//                        }
//                    }
//                }
//                else{ 
//                    if(self.day == "0")
//                    pkvHours.selectRow(0, inComponent: 0, animated: false)
//                    self.hour = HoursList[0]
//                    getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
//                }
                
                //            let deliveryDate = "\(_dataTimer.hour)h - ngày \(_dataTimer.date)"
                //BaseModel.shared.sharedString = deliveryDate
                //pushToViewAndClearData(name: "G20F00S03VC") 
            }
            //TH2: Không có lịch hẹn
            else{
                //++
                let date = Date()
                let calendar = Calendar.current
                let hour  = calendar.component(.hour, from: date) + 1
                let minutes = calendar.component(.minute, from: date) 
                currentHour = hour - 1
                self.hour = String(hour)
                self.day = "0"
                //TH1: Giờ hiện tại là 22h
                if hour == 23 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    self.hour = "0"
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                }
                    //TH2: Giờ hiện tại là 23 giờ
                else if hour >= 24 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    self.hour = "1"
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                }
                else{
                    var hourString:Int = currentHour + 2
                    while hourString <= 23 {
                        HoursList.append(String(hourString))
                        hourString += 1 
                    }
                    //HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    pkvHours.selectRow(0, inComponent: 0, animated: false)
                    self.hour = HoursList[0]
                }
//                HoursList.removeAll()
//                var hourString = hour
//                if hour >= 24{
//                    pkvDays.selectRow(1, inComponent: 0, animated: false)
//                    self.day = "1"
//                    if minutes >= 30{
//                        HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
//                        pkvHours.reloadAllComponents()
//                        self.hour = "1"
//                        pkvHours.selectRow(0, inComponent: 0, animated: false)
//                    }
//                    else{
//                        HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
//                        pkvHours.reloadAllComponents()
//                        self.hour = "0"
//                        pkvHours.selectRow(0, inComponent: 0, animated: false)
//                    }
//                    
//                }
//                else{
//                    if minutes >= 30{
//                        hourString += 1
//                        self.hour = String(hourString)
//                        while hourString <= 23 {
//                            HoursList.append(String(hourString))
//                            hourString += 1 
//                        }
//                    }
//                    else{
//                        while hourString <= 23 {
//                            HoursList.append(String(hourString))
//                            hourString += 1 
//                        }
//                    }
//                    pkvHours.reloadAllComponents()
//                    pkvHours.selectRow(0, inComponent: 0, animated: false)
//                }
                //lblDeliverydate.text = ""
                getDeliveryDate(day:Int(self.day)!, hour: Int(self.hour)!)
                //--
            }
                 
        }   
        else {
            showAlert(message: model.message)
        }
        
    }
    
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
//        else if pickerView == _pkvCar{
//            return _dataCar.count
//        }
        return 0
    }
    // goes in lieu of titleForRow if customization is desired
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        if pickerView == pkvDays{
            pickerLabel.textColor = UIColor.white
            pickerLabel.textAlignment = .center
            pickerLabel.text = String(daysList[row])
            pickerLabel.font = UIFont(name:"Helvetica", size: pkvHours.frame.height - 15)
        }
        else if pickerView == pkvHours{
            pickerLabel.textColor = UIColor.white
            pickerLabel.textAlignment = .center
            pickerLabel.text = String(HoursList[row])
            pickerLabel.font = UIFont(name:"Helvetica", size: pkvHours.frame.height - 15)
        }
//        else if pickerView == _pkvCar{
//            pickerLabel.textColor = .darkGray
//            pickerLabel.textAlignment = .center
//            pickerLabel.text = String(_dataCar[row].name)
//            pickerLabel.font = UIFont(name:"Helvetica", size: 17)
//        }
        return pickerLabel
    }
    /*func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     if pickerView == _pkvDriver{
     pickerLabel.text = String(self.degrees[row])
     pickerLabel.font = UIFont(name:"Helvetica", size: 28)
     return _dataDriver[row].name
     }
     else if pickerView == _pkvCar{
     return _dataCar[row].name
     }
     return ""
     }*/
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return pkvHours.frame.height
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pkvDays{
            //_driverId = _dataDriver[row].id
            self.day = daysList[row]
            if day == "0" {
                let date = Date()
                let calendar = Calendar.current
                let minutes = calendar.component(.minute, from: date) 
                let hour = currentHour + 1
                HoursList.removeAll()
                //TH1: Giờ hiện tại là 22h
                if hour == 23 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    for (index, element) in HoursList.enumerated() {
                        if(element == self.hour){
                            pkvHours.selectRow(index, inComponent: 0, animated: false)
                            self.hour = element
                        }
                    }
                }
                //TH2: Giờ hiện tại là 23 giờ
                else if hour >= 24 {
                    //Chuyen sang ngay 1
                    self.day = "1"
                    pkvDays.selectRow(1, inComponent: 0, animated: false)
                    HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    if(self.hour == "0"){
                        self.hour = "1"
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                    }
                    else{
                        for (index, element) in HoursList.enumerated() {
                            if(element == self.hour){
                                pkvHours.selectRow(index, inComponent: 0, animated: false)
                                self.hour = element
                            }
                        }
                    }
                }
                else{
                    var hourString:Int = currentHour + 2
                    while hourString <= 23 {
                        HoursList.append(String(hourString))
                        hourString += 1 
                    }
                    //HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                    pkvHours.reloadAllComponents()
                    //Kiem tra xem giờ dang xét có nằm trong danh sách giờ hiện tại hay ko
                    if Int(self.hour)! >= currentHour + 2{
                        for (index, element) in HoursList.enumerated() {
                            if(element == self.hour){
                                pkvHours.selectRow(index, inComponent: 0, animated: false)
                                self.hour = element
                            }
                        }
                    }
                    //Truong hop giờ đang xét nhỏ hơn giờ hiện tại
                    else{
                        pkvHours.selectRow(0, inComponent: 0, animated: false)
                        self.hour = HoursList[0]
                    }
                    
                }
                
//                pkvHours.selectRow(0, inComponent: 0, animated: true)
                //self.hour = HoursList[0]
            }
                //TH ngày khác 0
            else{
                let date = Date()
                let calendar = Calendar.current
                let minutes = calendar.component(.minute, from: date) 
                var hour = currentHour + 1
                HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
                pkvHours.reloadAllComponents()
                for (index, element) in HoursList.enumerated() {
                    if(element == self.hour){
                        pkvHours.selectRow(index, inComponent: 0, animated: false)
                        self.hour = element
                    }
                }
//                if hour >= 24{
//                    HoursList.removeAll()
//                    pkvDays.selectRow(1, inComponent: 0, animated: false)
//                    self.day = "1"
//                    if minutes >= 30{
//                        HoursList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
//                        pkvHours.reloadAllComponents()
////                        pkvHours.selectRow(0, inComponent: 0, animated: false)
////                        self.hour = "1"
//                        if(self.hour == "0"){
//                            self.hour = "1"
//                            pkvHours.selectRow(0, inComponent: 0, animated: false)
//                        }
//                        else{
//                            for (index, element) in HoursList.enumerated() {
//                                if(element == self.hour){
//                                    pkvHours.selectRow(index, inComponent: 0, animated: false)
//                                    self.hour = element
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        HoursList = ["0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
//                        pkvHours.reloadAllComponents()
////                        pkvHours.selectRow(0, inComponent: 0, animated: false)
////                        self.hour = "0"
//                        for (index, element) in HoursList.enumerated() {
//                            if(element == self.hour){
//                                pkvHours.selectRow(index, inComponent: 0, animated: false)
//                                self.hour = element
//                            }
//                        }
//                    }
//                }
//                else{
//                    HoursList.removeAll()
//                    if minutes >= 30{
//                        hour += 1
//                    }
//                    while hour <= 23 {
//                        HoursList.append(String(hour))
//                        hour += 1 
//                    }
//                    pkvHours.reloadAllComponents()
//                    if Int(self.hour)! > currentHour + 1{
//                        for (index, element) in HoursList.enumerated() {
//                            if(element == self.hour){
//                                pkvHours.selectRow(index, inComponent: 0, animated: false)
//                                self.hour = element
//                            }
//                        }
//                    }
//                    else{
//                        pkvHours.selectRow(0, inComponent: 0, animated: false)
//                        self.hour = HoursList[0]
//                    }
//                    
//                    //pkvHours.selectRow(0, inComponent: 0, animated: false)
////                    if currentHour >= Int(self.hour)!{
////                        self.hour = String(currentHour + 1)
////                    }
//                }
            }
            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
        }
        else if pickerView == pkvHours{
            //_driverId = _dataDriver[row].id
            self.hour = HoursList[row]
            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
//            let iHour = Int(hour)
//            if day == "0" && iHour! <= currentHour{
//                showAlert(message: "Hiện tại hơn \(currentHour)h, bạn không thể đặt Gas sớm hơn giờ hiện tại cùng ngày",
//                          okHandler: {
//                            alert in
//                            self.hour = String(self.currentHour + 1)
//                            self.pkvHours.selectRow(Int(self.hour)!, inComponent: 0, animated: true)
//                            self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
//                })
//            }
//            else{
//                self.getDeliveryDate(day: Int(self.day)!, hour: Int(self.hour)!)
//            }
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
            //            G12F01S01VC._currentPos = CLLocationCoordinate2D(latitude: 10.819258114124, longitude: 106.724750036821)
//            self.startLogic()
//            GMSGeocoder().reverseGeocodeCoordinate(location.coordinate, completionHandler: {
//                (response, error) in
//                if error != nil, response == nil {
//                    return
//                }
//                // Get Address
//                if let result = response?.firstResult() {
//                    if let lines = result.lines {
//                        self.addressText = lines.joined(separator: DomainConst.ADDRESS_SPLITER)
//                    }
//                }
//            })
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
