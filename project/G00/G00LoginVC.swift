//
//  ViewController.swift
//  project
//
//  Created by Lâm Phạm on 7/21/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework
import SwiftKeychainWrapper
//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00LoginVC: BaseViewController, UITextFieldDelegate {
class G00LoginVC: ChildViewController, UITextFieldDelegate {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    var bShowPassword:Bool!
    /** Logo image */
    @IBOutlet weak var imgLogo: UIImageView!
    /** Username edit text */
    @IBOutlet weak var txtAccount: UITextField!
    /** Password edit text */
    @IBOutlet weak var txtPassword: UITextField!
    /** Login button */
    @IBOutlet weak var btnLogin: UIButton!
    /** Sign in button */
    @IBOutlet weak var btnSignin: UIButton!
    /** Show password checkbox */
    //@IBOutlet weak var chbShowPassword: CheckBox!
    @IBOutlet weak var chbShowPassword: CustomCheckBox!
    /** Show password label */
    @IBOutlet weak var lblShowPassword: UILabel!
    /** Forgot password button */
    @IBOutlet weak var btnForgotPass: UIButton!
    /** Separator */
    @IBOutlet weak var btnSeparator: UIButton!
    /** Tap counter on logo */
    var imgLogoTappedCounter:Int = 0
    /** Current text field */
    private var _currentTextField: UITextField? = nil
    
    // MARK: Actions
    /**
     * Handle check/uncheck on Show password checkbox
     * - parameter sender:AnyObject
     */
    @IBAction func showPassword(_ sender: AnyObject) {
        bShowPassword = !bShowPassword
        txtPassword.isSecureTextEntry = !bShowPassword
    }
    
    /**
     * Handle tap on Login button
     * - parameter sender:AnyObject
     */
    @IBAction func Login(_ sender: AnyObject) {
        var uid : String = DomainConst.BLANK
        if let retrievedString = KeychainWrapper.standard.string(forKey: "uid"){
            if retrievedString != DomainConst.BLANK{
                uid = retrievedString
            }
        }
        if  uid == DomainConst.BLANK{
            let uuid = UUID().uuidString
            //            if let password = uuid {
            KeychainWrapper.standard.set(uuid, forKey: "uid")
            //            }
            uid = uuid
        }
        // Start login
        logw(text: "Start login")
        // Check the value of text field is empty or not
        if (((txtPassword.text?.isEmpty)! || (txtAccount.text?.isEmpty)!)){
            // Call alert
            showAlert(message: DomainConst.CONTENT00023)
        } else {
            //++ BUG0132-SPJ (NguyenPT 20170724) Remember username after login
            BaseModel.shared.setCurrentUsername(username: txtAccount.text!)
            //-- BUG0132-SPJ (NguyenPT 20170724) Remember username after login
            // Start login process
            //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
            //RequestAPI.requestLogin(username: txtAccount.text!, password: txtPassword.text!, view: self)
            LoginRequest.requestLogin(action: #selector(finishRequestHandler),
                                      view: self,
                                      username: txtAccount.text!,
                                      password: txtPassword.text!, uid : uid)
            //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
        }
    }
    
    //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    /**
     * Finish request login handler
     */
    func finishRequestHandler(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
        //++ BUG0058-SPJ (NguyenPT 20170414) Handle update config data after login success
        //self.popToRootView()
//        UpdateConfigurationRequest.requestUpdateConfiguration(
//            action: #selector(finishUpdateConfigRequest(_:)),
//            view: self)
        //-- BUG0058-SPJ (NguyenPT 20170414) Handle update config data after login success
        //LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let data = (notification.object as! String)
        let model = LoginRespModel(jsonString: data)
        //LoadingView.shared.hideOverlayView(className: self.theClassName)
        if model.isSuccess() {
            BaseModel.shared.loginSuccess(model.token)
            BaseModel.shared.saveTempData(loginModel: model)
            UpdateConfigurationRequest.requestUpdateConfiguration(
                action: #selector(finishUpdateConfigRequest(_:)),
                view: self)
        } else {
            showAlert(message: model.message)
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    //++ BUG0058-SPJ (NguyenPT 20170414) Handle update config data after login success
    /**
     * Finish request update config
     */
    func finishUpdateConfigRequest(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        self.popToRootView()
//        //++ BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
//        if BaseModel.shared.getNeedChangePassFlag() {
//            self.pushToView(name: G00ChangePassVC.theClassName)
//        }
//        //-- BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
        
        LoadingView.shared.showOverlay(view: self.view, className: self.theClassName)
        let data = (notification.object as! String)
        let model = LoginRespModel(jsonString: data)
        LoadingView.shared.hideOverlayView(className: self.theClassName)
        if model.isSuccess() {
            BaseModel.shared.saveTempData(loginModel: model)
            self.popToRootView()
            if BaseModel.shared.getNeedChangePassFlag() {
                self.pushToView(name: G00ChangePassVC.theClassName)
            }
        } else {
            showAlert(message: model.message)
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    //-- BUG0058-SPJ (NguyenPT 20170414) Handle update config data after login success
    
    /**
     * Handle tap on Login button
     * - parameter sender:AnyObject
     */
    @IBAction func Register(_ sender: AnyObject) {
        self.pushToView(name: DomainConst.G00_REGISTER_VIEW_CTRL)
    }
    
    /**
     * Handle tap on Forgot password button
     * - parameter sender:AnyObject
     */
    @IBAction func forgotPass(_ sender: AnyObject) {
        showAlert(message: DomainConst.CONTENT00362)
    }
    
    // MARK: Methods
    /**
     * Handle tap on Logo image
     * - parameter gestureRecognizer: UITapGestureRecognizer
     */
    func imgLogoTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        //let tappedImageView = gestureRecognizer.view!
        imgLogoTappedCounter += 1
        if imgLogoTappedCounter == DomainConst.MAXIMUM_TAPPED {
            imgLogoTappedCounter = 0
            print(imgLogoTappedCounter)
            //self.pushToView(name: DomainConst.G00_CONFIGURATION_VIEW_CTRL)
            self.pushToView(name: DomainConst.INTERNAL_VIEW_CTRL)
        }
    }
    
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.configItemTap(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override public func viewDidLoad() {
        setBackground(bkg: DomainConst.TYPE_1_BKG_IMG_NAME)
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Background
        self.view.layer.borderWidth = GlobalConst.PARENT_BORDER_WIDTH
        self.view.layer.borderColor = GlobalConst.PARENT_BORDER_COLOR_GRAY.cgColor
        
        // Get height of status bar + navigation bar
        let heigh = self.getTopHeight()
        imgLogo.image = ImageManager.getImage(named: BaseModel.shared.getMainLogo())
        imgLogo.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.LOGIN_LOGO_W) / 2,
                               y: heigh + GlobalConst.MARGIN,
                               width: GlobalConst.LOGIN_LOGO_W,
                               height: GlobalConst.LOGIN_LOGO_H)
        imgLogo.translatesAutoresizingMaskIntoConstraints = true
        imgLogo.isUserInteractionEnabled = true
        // Now you need a tap gesture recognizer
        // Note that target and action point to what happens when the action is recognized.
        let imgLogoTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(G00LoginVC.imgLogoTapped(_:)))
        // Add the recognizer to your view.
        imgLogo.addGestureRecognizer(imgLogoTappedRecognizer)
        
        // Username text field
        txtAccount.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.EDITTEXT_W) / 2,
                                  y: imgLogo.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.EDITTEXT_W,
                                  height: GlobalConst.EDITTEXT_H)
        txtAccount.placeholder = DomainConst.CONTENT00049
        txtAccount.translatesAutoresizingMaskIntoConstraints = true
        //++ BUG0132-SPJ (NguyenPT 20170724) Remember username after login
        txtAccount.text = BaseModel.shared.getCurrentUsername()
        //-- BUG0132-SPJ (NguyenPT 20170724) Remember username after login
        // Set icon
        setLeftViewForTextField(textField: txtAccount, named: DomainConst.USERNAME_IMG_NAME)
        
        // Make username textbox is focus when load view
        //self.txtAccount.becomeFirstResponder()
        
        // Password textfield
        txtPassword.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.EDITTEXT_W) / 2,
                                   y: txtAccount.frame.maxY + GlobalConst.MARGIN,
                                   width: GlobalConst.EDITTEXT_W,
                                   height: GlobalConst.EDITTEXT_H)
        txtPassword.translatesAutoresizingMaskIntoConstraints = true
        txtPassword.placeholder = DomainConst.CONTENT00050
        
        // Set icon
        setLeftViewForTextField(textField: txtPassword, named: DomainConst.PASSWORD_IMG_NAME)
        
        // Show password check box
        chbShowPassword.frame = CGRect(x: txtPassword.frame.minX,
                                       y: txtPassword.frame.maxY + GlobalConst.MARGIN,
                                       //++ BUG0084-SPJ (NguyenPT 20170515) Show "Show password" checkbox on Login screen
                                       //width: GlobalConst.CHECKBOX_W + GlobalConst.LABEL_W,
                                       width: GlobalConst.SCREEN_WIDTH,
                                       //-- BUG0084-SPJ (NguyenPT 20170515) Show "Show password" checkbox on Login screen
                                       height: GlobalConst.CHECKBOX_H)
        chbShowPassword.tintColor = UIColor.black
        chbShowPassword.translatesAutoresizingMaskIntoConstraints = true
        chbShowPassword.setTitle(DomainConst.CONTENT00102, for: UIControlState())
        chbShowPassword.imageView?.contentMode = .scaleAspectFit
        chbShowPassword.setTitleColor(UIColor.black, for: UIControlState())
        
        // Show password label
        lblShowPassword.frame = CGRect(x: chbShowPassword.frame.maxX + GlobalConst.MARGIN,
                                       y: txtPassword.frame.maxY + GlobalConst.MARGIN,
                                       width: GlobalConst.LABEL_W,
                                       height: GlobalConst.LABEL_H)
        lblShowPassword.text = DomainConst.CONTENT00102
        lblShowPassword.translatesAutoresizingMaskIntoConstraints = true
        // Check box status
        bShowPassword = false
        
        // Login button
        btnLogin.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                y: chbShowPassword.frame.maxY + GlobalConst.MARGIN,
                                width: GlobalConst.BUTTON_W,
                                height: GlobalConst.BUTTON_H)
        btnLogin.backgroundColor = GlobalConst.BUTTON_COLOR_RED
        btnLogin.setTitle(DomainConst.CONTENT00051.uppercased(), for: UIControlState())
        btnLogin.setTitleColor(UIColor.white, for: UIControlState())
        btnLogin.addTarget(self, action: #selector(Login), for: .touchUpInside)
        btnLogin.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        //self.view.addSubview(btnLogin)
        btnLogin.translatesAutoresizingMaskIntoConstraints = true
        btnLogin.setImage(ImageManager.getImage(named: DomainConst.LOGIN_IMG_NAME), for: UIControlState())
        btnLogin.imageView?.contentMode = .scaleAspectFit
        
        // Sign in button
        btnSignin.frame = CGRect(x: GlobalConst.SCREEN_WIDTH / 2 + GlobalConst.MARGIN / 2,
                                 y: btnLogin.frame.maxY,
                                 width: (GlobalConst.BUTTON_W - GlobalConst.MARGIN) / 2,
                                 height: GlobalConst.BUTTON_H)
        btnSignin.setTitle(DomainConst.CONTENT00228, for: UIControlState())
        //self.view.addSubview(btnSignin)
        btnSignin.translatesAutoresizingMaskIntoConstraints = true
        
        // Forgot password button
        btnForgotPass.translatesAutoresizingMaskIntoConstraints = true
        btnForgotPass.frame = CGRect(x: btnLogin.frame.minX,
                                     y: btnLogin.frame.maxY,
                                     width: (GlobalConst.BUTTON_W - GlobalConst.MARGIN) / 2,
                                     height: GlobalConst.BUTTON_H)
        
        btnForgotPass.setTitle(DomainConst.CONTENT00227, for: UIControlState())
        btnForgotPass.titleLabel?.textAlignment = .right
        //self.view.addSubview(btnForgotPass)
        
        // Separator
        btnSeparator.translatesAutoresizingMaskIntoConstraints = true
        btnSeparator.frame = CGRect(x: btnForgotPass.frame.maxX,
                                     y: btnLogin.frame.maxY,
                                     width: btnSignin.frame.minX - btnForgotPass.frame.maxX,
                                     height: GlobalConst.BUTTON_H)
        
        //btnSeparator.setTitle(DomainConst.CONTENT00226, for: UIControlState())
        btnSeparator.titleLabel?.textAlignment = .right
        //self.view.addSubview(btnForgotPass)
        
        // Navigation bar
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00051, isNotifyEnable: false)
        createNavigationBar(title: DomainConst.CONTENT00051)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        
        txtAccount.delegate     = self
        txtPassword.delegate    = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(G00LoginVC.hideKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        
        // Fill data in training mode
        if BaseModel.shared.checkTrainningMode() {
            txtAccount.text = "0976994876"
            txtPassword.text = "123123"
        }
        // Handle waiting register code confirm
        if !BaseModel.shared.getTempToken().isEmpty {
            self.processInputConfirmCode(message: DomainConst.BLANK)
        }
        self.view.makeComponentsColor()
    }
    
    /**
     * Set left image for text field
     * - parameter textField:   Text field object
     * - parameter named:       Image name
     */
    func setLeftViewForTextField(textField: UITextField, named: String) {
        textField.leftViewMode = .always
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                width: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X,
                                                height: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X))
        let img = ImageManager.getImage(named: named)
        imgView.image = img
        textField.leftView = imgView
    }
    
    /**
     * Handle when leave focus edittext
     * - parameter textField: Textfield is focusing
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        //textField.resignFirstResponder()
        let nextTag = textField.tag + 1
        // Try to find next responder
        let nextResponder = textField.superview?.viewWithTag(nextTag) as UIResponder!
        
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
            hideKeyboard()
            //Login(_)
        }
        return true
    }
    
    /**
     * Handle memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     * Hide keyboard
     * - parameter sender: Gesture
     */
    func hideKeyboard(_ sender:UITapGestureRecognizer){
        hideKeyboard()
    }
    
    /**
     * Hide keyboard
     */
    func hideKeyboard() {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        })
        isKeyboardShow = false
    }
    
    /**
     * Handle when focus edittext
     * - parameter textField: Textfield will be focusing
     */
    internal func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if isKeyboardShow == false {            
            isKeyboardShow = true
        }
        return true
    }
    
    /**
     * Handle when focus edittext
     * - parameter textField: Textfield will be focusing
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self._currentTextField = textField
    }
    
    /**
     * Handle move textfield when keyboard overloading
     */
    override func keyboardWillShow(_ notification: Notification) {
        super.keyboardWillShow(notification)
        if self._currentTextField != nil {
            let delta = (self._currentTextField?.frame.maxY)! - self.keyboardTopY
            if delta > 0 {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - delta, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }

}

