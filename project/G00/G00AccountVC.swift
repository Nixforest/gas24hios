//
//  AccountViewController.swift
//  project
//
//  Created by Lâm Phạm on 8/18/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00AccountVC: BaseViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
class G00AccountVC: ParentViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    /** Save button */
    @IBOutlet weak var saveButton: UIButton!
    /** Change password button */
    @IBOutlet weak var changePasswordButton: UIButton!
    /** Logout button */
    @IBOutlet weak var logoutButton: UIButton!
    /** Avatar image */
    @IBOutlet weak var imgAvatar: UIImageView!
    /** Name image */
    @IBOutlet weak var imgName: UIImageView!
    /** Phone image */
    @IBOutlet weak var imgPhone: UIImageView!
    /** Address image */
    @IBOutlet weak var imgAddress: UIImageView!
    /** Name textbox */
    @IBOutlet weak var txtName: UITextField!
    /** Phone textbox */
    @IBOutlet weak var txtPhone: UITextField!
    /** Address textbox */
    @IBOutlet weak var txtAddress: UITextField!
    /** User avatar picker */
    var userAvatarPicker = UIImagePickerController()
    /** Current text field */
    private var _currentTextField: UITextField? = nil
    
    // MARK: Actions
    /**
     * Handle when tap on image to select from library
     * - parameter sender: Tap gesture
     */
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        let imgPickerController         = UIImagePickerController()
        imgPickerController.sourceType  = .photoLibrary
        imgPickerController.delegate    = self
        present(imgPickerController, animated: true, completion: nil)
    }
    
    /**
     * Handle cancel select image
     * - parameter picker: ImagePickerController
     */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Handle select image from library
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImgAvatar = info[UIImagePickerControllerOriginalImage] as! UIImage
        imgAvatar.image = selectedImgAvatar
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Handle tap on Save button
     * - parameter sender:AnyObject
     */
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        // Check the value of text field
        if (((txtName.text?.isEmpty)! || (txtPhone.text?.isEmpty)!
            || (txtAddress.text?.isEmpty)!)) {
            // Call alert
            showAlert(message: DomainConst.CONTENT00025)
        } else {
            self.showToast(message: "Save successfully")
        }
    }
    
    /**
     * Handle tap on Change password button
     * - parameter sender:AnyObject
     */
    @IBAction func changePasswordTapped(_ sender: AnyObject) {
        self.pushToView(name: DomainConst.G00_CHANGE_PASS_VIEW_CTRL)
    }
    
    /**
     * Handle tap on Logout button
     * - parameter sender:AnyObject
     */
    @IBAction func logoutButtonTapped(_ sender: AnyObject) {
        //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
//        RequestAPI.requestLogout(view: self.view)
//        _ = self.navigationController?.popViewController(animated: true)
        LogoutRequest.requestLogout(action: #selector(self.finishRequestLogout(_:)), view: self)
        //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
    }
    
    //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//    /**
//     * Handle when tap menu item
//     */
//    func asignNotifyForMenuItem() {
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.gasServiceItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_GAS_SERVICE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.issueItemTapped(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_ISSUE_ITEM),
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(super.configItemTap(_:)),
//                                               name:NSNotification.Name(rawValue: DomainConst.NOTIFY_NAME_COFIG_ITEM_ACCOUNTVIEW),
//                                               object: nil)
//    }
    //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        //++ BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
//        // Menu item tap
//        asignNotifyForMenuItem()
        //-- BUG0043-SPJ (NguyenPT 20170301) Change how to menu work
        
        // Background
        self.view.backgroundColor   = GlobalConst.BACKGROUND_COLOR_GRAY
        self.view.layer.borderWidth = GlobalConst.PARENT_BORDER_WIDTH
        self.view.layer.borderColor = GlobalConst.PARENT_BORDER_COLOR_GRAY.cgColor
        
        // Get height of status bar + navigation bar
        let heigh = self.getTopHeight()
        imgAvatar.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.ACCOUNT_AVATAR_W) / 2,
                                 y: heigh + GlobalConst.MARGIN,
                                 width: GlobalConst.ACCOUNT_AVATAR_W,
                                 height: GlobalConst.ACCOUNT_AVATAR_H)
        imgAvatar.image = ImageManager.getImage(named: DomainConst.CONTACT_IMG_NAME)
        imgAvatar.translatesAutoresizingMaskIntoConstraints = true
        imgAvatar.isUserInteractionEnabled = true
        
        // Image name
        imgName.frame = CGRect(x: GlobalConst.MARGIN,
                               y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
                               width: GlobalConst.ACCOUNT_ICON_SIZE,
                               height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgName.image = ImageManager.getImage(named: DomainConst.USER_NAME_IMG_NAME)
        imgName.translatesAutoresizingMaskIntoConstraints = true
        
        // Image phone
        imgPhone.frame = CGRect(x: GlobalConst.MARGIN,
                                y: imgName.frame.maxY + GlobalConst.MARGIN,
                                width: GlobalConst.ACCOUNT_ICON_SIZE,
                                height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgPhone.image = ImageManager.getImage(named: DomainConst.USER_PHONE_IMG_NAME)
        imgPhone.translatesAutoresizingMaskIntoConstraints = true
        
        // Image address
        imgAddress.frame = CGRect(x: GlobalConst.MARGIN,
                                  y: imgPhone.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.ACCOUNT_ICON_SIZE,
                                  height: GlobalConst.ACCOUNT_ICON_SIZE)
        imgAddress.image = ImageManager.getImage(named: DomainConst.ADDRESS_IMG_NAME)
        imgAddress.translatesAutoresizingMaskIntoConstraints = true
        
        // Name Textfield customize
        txtName.frame = CGRect(x: imgName.frame.maxX + GlobalConst.MARGIN,
                               y: imgAvatar.frame.maxY + GlobalConst.MARGIN,
                               width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                               height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtName.placeholder = DomainConst.CONTENT00055
        txtName.translatesAutoresizingMaskIntoConstraints = true
        txtName.delegate = self
        txtName.isUserInteractionEnabled = false
        
        // Phone textfield
        txtPhone.frame = CGRect(x: txtName.frame.minX,
                                y: txtName.frame.maxY + GlobalConst.MARGIN,
                                width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                                height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtPhone.placeholder = DomainConst.CONTENT00054
        txtPhone.translatesAutoresizingMaskIntoConstraints = true
        txtPhone.textColor = GlobalConst.BUTTON_COLOR_RED
        txtPhone.delegate = self
        txtPhone.isUserInteractionEnabled = false
        
        // Address textfield
        txtAddress.frame = CGRect(x: txtName.frame.minX,
                                  y: txtPhone.frame.maxY + GlobalConst.MARGIN,
                                  width: GlobalConst.SCREEN_WIDTH - (GlobalConst.MARGIN * 3 + GlobalConst.ACCOUNT_ICON_SIZE),
                                  height: GlobalConst.ACCOUNT_ICON_SIZE)
        txtAddress.placeholder = DomainConst.CONTENT00088
        txtAddress.translatesAutoresizingMaskIntoConstraints = true
        txtAddress.delegate = self
        txtAddress.isUserInteractionEnabled = false
        
        // Save Button customize
        CommonProcess.createButtonLayout(btn: saveButton,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: txtAddress.frame.maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00229.uppercased(),
                                         action: #selector(saveButtonTapped(_:)),
                                         target: self,
                                         img: DomainConst.SAVE_INFO_IMG_NAME,
                                         tintedColor: UIColor.white)
        
        // Change password button
        CommonProcess.createButtonLayout(btn: changePasswordButton,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: saveButton.frame.maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00089,
                                         action: #selector(changePasswordTapped(_:)),
                                         target: self,
                                         img: DomainConst.CHANGE_PASS_IMG_NAME,
                                         tintedColor: UIColor.white)
        
        // Logout button
        CommonProcess.createButtonLayout(btn: logoutButton,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: changePasswordButton.frame.maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00090,
                                         action: #selector(logoutButtonTapped(_:)),
                                         target: self,
                                         img: DomainConst.LOGOUT_IMG_NAME,
                                         tintedColor: UIColor.white)
        logoutButton.backgroundColor = GlobalConst.BUTTON_COLOR_YELLOW
        
        // Navigation Bar customize
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00100, isNotifyEnable: true)
        createNavigationBar(title: DomainConst.CONTENT00100)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller

        // Do any additional setup after loading the view.
        let gesture = UITapGestureRecognizer(target: self, action: #selector(G00AccountVC.hideKeyboard(_:)))
        self.view.addGestureRecognizer(gesture)
        
        // Load data from server?
        if BaseModel.shared.user_info == nil {
            // User information does not exist
            //++ BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
            //RequestAPI.requestUserProfile(action: #selector(setData(_:)), view: self)
            UserProfileRequest.requestUserProfile(action: #selector(setData(_:)), view: self)
            //-- BUG0046-SPJ (NguyenPT 20170301) Use action for Request server completion
        } else {
            txtName.text    = BaseModel.shared.user_info?.getName()
            txtPhone.text   = BaseModel.shared.user_info?.getPhone()
            txtAddress.text = BaseModel.shared.user_info?.getAddress()
//            if let url      = NSURL(string: String(BaseModel.shared.getServerURL() + (BaseModel.shared.user_info?.getAvatarImage())!)!) {
//                if let data = NSData(contentsOf: url as URL) {
//                    imgAvatar.image = UIImage(data: data as Data)
//                }
//            }
            imgAvatar.getImgFromUrl(link: (BaseModel.shared.user_info?.getAvatarImage())!, contentMode: imgAvatar.contentMode)
        }
        self.view.makeComponentsColor()
    }
    
    /**
     * Set data for controls
     */
    override func setData(_ notification: Notification) {
        //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
        let data = (notification.object as! String)
        let model = UserProfileRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setUserInfo(userInfo: model.record)
        } else {
            showAlert(message: model.message)
            return
        }
        //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
        txtName.text    = BaseModel.shared.user_info?.getName()
        txtPhone.text   = BaseModel.shared.user_info?.getPhone()
        txtAddress.text = BaseModel.shared.user_info?.getAddress()
        // Load image
//        if let url = NSURL(string: String(BaseModel.shared.getServerURL() + (BaseModel.shared.user_info?.getAvatarImage())!)!) {
//            if let data = NSData(contentsOf: url as URL) {
//                imgAvatar.image = UIImage(data: data as Data)
//            }        
//        }
        imgAvatar.getImgFromUrl(link: (BaseModel.shared.user_info?.getAvatarImage())!, contentMode: imgAvatar.contentMode)
    }

    /**
     * Memory warning handler
     */
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
     */
    func hideKeyboard(_ sender:UITapGestureRecognizer){
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }) 
        isKeyboardShow = false
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
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }) 
        }
        return true
    }
    
    //++ BUG0123-SPJ (NguyenPT 20170711) Handle update Agent id after change on Account screen
    override func viewDidAppear(_ animated: Bool) {
        if BaseModel.shared.user_info == nil {
            // User information does not exist
            UserProfileRequest.requestUserProfile(action: #selector(setData(_:)), view: self)
        }
    }
    //-- BUG0123-SPJ (NguyenPT 20170711) Handle update Agent id after change on Account screen
}
