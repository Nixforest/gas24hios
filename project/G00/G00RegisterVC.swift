//
//  RegisterViewController.swift
//  project
//
//  Created by Lâm Phạm on 8/15/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00RegisterVC: BaseViewController, UITextFieldDelegate {
class G00RegisterVC: ChildViewController, UITextFieldDelegate {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** Logo image */
    @IBOutlet weak var imgCenter: UIImageView!
    /** Name edit text */
    @IBOutlet weak var txtName: UITextField!
    /** Phone edit text */
    @IBOutlet weak var txtPhone: UITextField!
    /** Register button */
    @IBOutlet weak var registerButton: UIButton!
    /** Current text field */
    private var _currentTextField: UITextField? = nil
    
    // MARK: Actions
    /**
     * Handle tap on register button
     * - parameter sender:AnyObject
     */
    @IBAction func registerButtonTapped(_ sender: AnyObject) {
        // Check the value of text field
        if (((txtName.text?.isEmpty)! || (txtPhone.text?.isEmpty)!)){
            // Call alert
            showAlert(message: DomainConst.CONTENT00025)
        } else {
            //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
//            RequestAPI.requestRegister(name: txtName.text!, phone: txtPhone.text!, view: self)
            RegisterRequest.requestRegister(action: #selector(finishRequestRegister(_:)),
                                            view: self,
                                            name: txtName.text!,
                                            phone: txtPhone.text!)
            //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
        }
    }
    
    //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    /**
     * Finish request register handler
     */
    internal func finishRequestRegister(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
//        let obj = (notification.object as! BaseRespModel)
//        self.processInputConfirmCode(message: obj.message)
        let data = (notification.object as! String)
        let model = BaseRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setTempToken(token: model.token)
            self.processInputConfirmCode(message: model.message)
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
//                                               selector: #selector(super.configItemTap(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM_REGISTERVIEW),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override func viewDidLoad() {
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
        imgCenter.image = ImageManager.getImage(named: BaseModel.shared.getMainLogo()
        )
        imgCenter.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.LOGIN_LOGO_W) / 2,
                               y: heigh + GlobalConst.MARGIN,
                               width: GlobalConst.LOGIN_LOGO_W,
                               height: GlobalConst.LOGIN_LOGO_H)
        imgCenter.translatesAutoresizingMaskIntoConstraints = true
        imgCenter.isUserInteractionEnabled = true
        
        // Name text field
        txtName.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.EDITTEXT_W) / 2,
                                  y: imgCenter.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.EDITTEXT_W,
                                  height: GlobalConst.EDITTEXT_H)
        txtName.placeholder = DomainConst.CONTENT00055
        txtName.autocapitalizationType = .words
        txtName.translatesAutoresizingMaskIntoConstraints = true
        // Set icon
        setLeftViewForTextField(textField: txtName, named: DomainConst.USERNAME_IMG_NAME)
        txtName.delegate = self
        
        // Phone text field
        txtPhone.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.EDITTEXT_W) / 2,
                               y: txtName.frame.maxY + GlobalConst.MARGIN,
                               width: GlobalConst.EDITTEXT_W,
                               height: GlobalConst.EDITTEXT_H)
        txtPhone.placeholder = DomainConst.CONTENT00054
        txtPhone.translatesAutoresizingMaskIntoConstraints = true
        txtPhone.keyboardType = .numberPad
        // Set icon
        setLeftViewForTextField(textField: txtPhone, named: DomainConst.PHONE_IMG_NAME)
        txtPhone.delegate = self
        
        // Register button
        registerButton.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                y: txtPhone.frame.maxY + GlobalConst.MARGIN * 2 + GlobalConst.CHECKBOX_H,
                                width: GlobalConst.BUTTON_W,
                                height: GlobalConst.BUTTON_H)
        registerButton.backgroundColor = GlobalConst.BUTTON_COLOR_RED
        registerButton.setTitle(DomainConst.CONTENT00052.uppercased(), for: UIControlState())
        registerButton.setTitleColor(UIColor.white, for: UIControlState())
        registerButton.layer.cornerRadius = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        //self.view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = true
        registerButton.setImage(ImageManager.getImage(named: DomainConst.SAVE_INFO_IMG_NAME), for: UIControlState())
        registerButton.imageView?.contentMode = .scaleAspectFit
                
        //Navigation Bar customize
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00052, isNotifyEnable: false)
        createNavigationBar(title: DomainConst.CONTENT00052)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(G00RegisterVC.hideKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
