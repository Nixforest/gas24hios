//
//  ChangePasswordViewController.swift
//  project
//
//  Created by Lâm Phạm on 8/19/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00ChangePassVC: BaseViewController, UITextFieldDelegate {
class G00ChangePassVC: ChildViewController, UITextFieldDelegate {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** Flag show password */
    var bShowPassword:Bool!
    /** Save button */
    @IBOutlet weak var saveButton: UIButton!
    /** Logout button */
    @IBOutlet weak var logoutButton: UIButton!
    /** Checkbox show password button */
    @IBOutlet weak var checkboxButton: CustomCheckBox!
    /** Checkbox show password label */
    @IBOutlet weak var lblCheckboxButton: UILabel!
    /** Old password textbox */
    @IBOutlet weak var txtOldPassword: UITextField!
    /** New password textbox */
    @IBOutlet weak var txtNewPassword: UITextField!
    /** Retype-New password textbox */
    @IBOutlet weak var txtNewPasswordRetype: UITextField!
    /** Current text field */
    private var _currentTextField: UITextField? = nil
    /** Avatar image */
    @IBOutlet weak var imgAvatar: UIImageView!
    
    @IBOutlet weak var imgOldPass: UIImageView!
    @IBOutlet weak var imgNewPass: UIImageView!
    @IBOutlet weak var imgNewPassconfirm: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    // MARK: Actions
    /**
     * Handle tap on checkbox button
     * - parameter sender: AnyObject
     */
    @IBAction func checkboxButtonTapped(_ sender: AnyObject) {
        bShowPassword = !bShowPassword
        txtOldPassword.isSecureTextEntry = !bShowPassword
        txtNewPassword.isSecureTextEntry = !bShowPassword
        txtNewPasswordRetype.isSecureTextEntry = !bShowPassword
    }
    
    /**
     * Handle tap on logout button
     * - parameter sender: AnyObject
     */
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
        //RequestAPI.requestLogout(view: self)
        LogoutRequest.requestLogout(action: #selector(self.finishRequestLogout(_:)), view: self)
        //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    }
    
    /**
     * Handle tap on Save button
     * - parameter sender: AnyObject
     */
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        // Validate data is filled
        if (((txtOldPassword.text?.isEmpty)! || (txtNewPassword.text?.isEmpty)! || (txtNewPasswordRetype.text?.isEmpty)!)){
            // Call alert
            showAlert(message: DomainConst.CONTENT00025)
            return
        }
        //++ BUG0080-SPJ (NguyenPT 20170509) Check if new password is equal with old password in Change Password screen
        else if (txtOldPassword.text == txtNewPassword.text) {
            showAlert(message: DomainConst.CONTENT00369)
            return
        }
        //-- BUG0080-SPJ (NguyenPT 20170509) Check if new password is equal with old password in Change Password screen
        // Check if password is correct
        if (txtNewPassword.text == txtNewPasswordRetype.text){
            self.showToast(message: "password update successfully")
            //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
//            RequestAPI.requestChangePassword(
//                oldPass: txtOldPassword.text!,
//                newPass: txtNewPassword.text!,
//                view: self)
            ChangePassRequest.requestChangePassword(action: #selector(finishRequestChangePassword),
                                                    view: self,
                                                    oldPass: txtOldPassword.text!,
                                                    newPass: txtNewPassword.text!)
            //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
        } else {
            // Call alert
            showAlert(message: DomainConst.CONTENT00026)
        }
    }
    
    //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    /**
     * Finish request change password handler
     */
    func finishRequestChangePassword(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        super.backButtonTapped(self)
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            super.backButtonTapped(self)
        } else {
            showAlert(message: model.message)
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    }
    //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(self.gasServiceItemTapped),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_GAS_SERVICE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.issueItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_ISSUE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.configItemTap(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM_CHANGEPASSVIEW),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Background
        view.backgroundColor = GlobalConst.BACKGROUND_COLOR_GRAY
        self.view.layer.borderWidth = GlobalConst.PARENT_BORDER_WIDTH
        self.view.layer.borderColor = GlobalConst.PARENT_BORDER_COLOR_GRAY.cgColor
        
        // Textfield old password
        // Get height of status bar + navigation bar
        let heigh = self.getTopHeight()
        
        imgAvatar.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.ACCOUNT_AVATAR_W) / 2,
                                 y: heigh + GlobalConst.MARGIN,
                                 width: GlobalConst.ACCOUNT_AVATAR_W,
                                 height: GlobalConst.ACCOUNT_AVATAR_H)
        imgAvatar.image = ImageManager.getImage(named: DomainConst.CONTACT_IMG_NAME)
        imgAvatar.translatesAutoresizingMaskIntoConstraints = true
        imgAvatar.isUserInteractionEnabled = true
        
        // Label name
        lblName.translatesAutoresizingMaskIntoConstraints = true
        lblName.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.EDITTEXT_W) / 2,
                               y: imgAvatar.frame.maxY + GlobalConst.MARGIN_CELL_Y,
                               width: GlobalConst.EDITTEXT_W,
                               height: GlobalConst.EDITTEXT_H)
        //++ BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
        //lblName.text = BaseModel.shared.user_info?.getName()
        if (BaseModel.shared.user_info != nil) && (!(BaseModel.shared.user_info?.getName().isEmpty)!) {
            lblName.text = BaseModel.shared.user_info?.getName()
        } else {
            lblName.text = BaseModel.shared.getUserInfoLogin(id: DomainConst.KEY_FIRST_NAME)
        }
        //-- BUG0077-SPJ (NguyenPT 20170508) Handle Flag need change pass
        lblName.textAlignment = .center
        lblName.textColor = GlobalConst.BUTTON_COLOR_RED
        
        // Image old pass
        imgOldPass.frame = CGRect(x: GlobalConst.MARGIN,
                               y: lblName.frame.maxY + GlobalConst.MARGIN,
                               width: GlobalConst.ACCOUNT_ICON_SIZE,
                               height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgOldPass.image = ImageManager.getImage(named: DomainConst.OLD_PASS_IMG_NAME)
        imgOldPass.translatesAutoresizingMaskIntoConstraints = true
        
        // Image new pass
        imgNewPass.frame = CGRect(x: GlobalConst.MARGIN,
                                  y: imgOldPass.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.ACCOUNT_ICON_SIZE,
                                  height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgNewPass.image = ImageManager.getImage(named: DomainConst.OLD_PASS_IMG_NAME)
        imgNewPass.translatesAutoresizingMaskIntoConstraints = true
        
        // Image new pass
        imgNewPassconfirm.frame = CGRect(x: GlobalConst.MARGIN,
                                  y: imgNewPass.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.ACCOUNT_ICON_SIZE,
                                  height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgNewPassconfirm.image = ImageManager.getImage(named: DomainConst.NEW_PASS_IMG_NAME)
        imgNewPassconfirm.translatesAutoresizingMaskIntoConstraints = true
        
        txtOldPassword.frame = CGRect(x: imgOldPass.frame.maxX + GlobalConst.MARGIN,
                                      y: imgOldPass.frame.minY,
                                      width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                                      height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtOldPassword.placeholder = DomainConst.CONTENT00083
        txtOldPassword.translatesAutoresizingMaskIntoConstraints = true
        txtOldPassword.delegate = self
        
        // Textfield new password
        txtNewPassword.frame = CGRect(x: imgNewPass.frame.maxX + GlobalConst.MARGIN,
                                      y: imgNewPass.frame.minY,
                                      width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                                      height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtNewPassword.placeholder = DomainConst.CONTENT00084
        txtNewPassword.translatesAutoresizingMaskIntoConstraints = true
        txtNewPassword.delegate = self
        
        // Textfield new password retype
        txtNewPasswordRetype.frame = CGRect(x: imgNewPassconfirm.frame.maxX + GlobalConst.MARGIN,
                                            y: imgNewPassconfirm.frame.minY,
                                            width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                                            height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtNewPasswordRetype.placeholder = DomainConst.CONTENT00085
        txtNewPasswordRetype.translatesAutoresizingMaskIntoConstraints = true
        txtNewPasswordRetype.delegate = self
        
        // Show password check box
        checkboxButton.frame = CGRect(x: txtOldPassword.frame.minX,
                                      y: txtNewPasswordRetype.frame.maxY + GlobalConst.MARGIN,
                                      width: GlobalConst.CHECKBOX_W,
                                      height: GlobalConst.CHECKBOX_H)
        checkboxButton.tintColor = UIColor.black
        checkboxButton.translatesAutoresizingMaskIntoConstraints = true
        
        // Show password label
        lblCheckboxButton.frame = CGRect(x: checkboxButton.frame.maxX + GlobalConst.MARGIN,
                                         y: checkboxButton.frame.minY,
                                         width: GlobalConst.LABEL_W,
                                         height: GlobalConst.LABEL_H)
        lblCheckboxButton.text = DomainConst.CONTENT00102
        lblCheckboxButton.translatesAutoresizingMaskIntoConstraints = true
        bShowPassword = false
        txtOldPassword.isSecureTextEntry = !bShowPassword
        txtNewPassword.isSecureTextEntry = !bShowPassword
        txtNewPasswordRetype.isSecureTextEntry = !bShowPassword
        
        // Save button
        CommonProcess.createButtonLayout(btn: saveButton,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: checkboxButton.frame.maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00229.uppercased(),
                                         action: #selector(saveButtonTapped(_:)),
                                         target: self,
                                         img: DomainConst.SAVE_INFO_IMG_NAME,
                                         tintedColor: UIColor.white)
        
        // Logout buton
        CommonProcess.createButtonLayout(btn: logoutButton,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: saveButton.frame.maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00090.uppercased(),
                                         action: #selector(logoutButtonTapped(_:)),
                                         target: self,
                                         img: DomainConst.LOGOUT_IMG_NAME,
                                         tintedColor: UIColor.white)
        //++ BUG0134-SPJ (NguyenPT 20170727) Change pass screen: Add logout button
        logoutButton.backgroundColor = GlobalConst.BUTTON_COLOR_YELLOW
        logoutButton.isHidden = !BaseModel.shared.getNeedChangePassFlag()
        //-- BUG0134-SPJ (NguyenPT 20170727) Change pass screen: Add logout button
        
        // Navigation Bar customize
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00089, isNotifyEnable: true)
        createNavigationBar(title: DomainConst.CONTENT00089)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    /**
     * Hide keyboard
     * - parameter sender: Gesture
     */
    func hideKeyboard(_ sender:UITapGestureRecognizer){
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
    
    /**
     * Handle when lost focus edittext
     * - parameter textField: Textfield will be focusing
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
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }) 
        }
        return true
    }


}
