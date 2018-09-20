//
//  MenuVC.swift
//  project
//
//  Created by SPJ on 9/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class MenuVC: BaseMenuViewController {
    // MARK: Properties
    /** Label name */
    var lblName:            UILabel     = UILabel()
    /** Label phone */
    var lblPhone:           UILabel     = UILabel()
    /** Label address */
    var lblAddress:         UILabel     = UILabel()
    /** Button edit */
    var btnEdit:            UIButton    = UIButton()
    /** Label separator */
    var lblSeparator:       UILabel     = UILabel()
    
    // MARK: Const
    let ADDRESS_WIDTH:      CGFloat     = GlobalConst.POPOVER_WIDTH - 2 * GlobalConst.MARGIN - GlobalConst.LABEL_H
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        let topOffset = getTopPartHeight()
        updateTopPartHeight(value: topOffset + GlobalConst.LABEL_H * 6)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createLabel(lbl: lblName, text: "-", offset: topOffset, isBold: true)
        createLabel(lbl: lblPhone, text: "-", offset: lblName.frame.maxY)
        createLabel(lbl: lblAddress, text: "-",
                    offset: lblPhone.frame.maxY,
                    isBold: false,
                    height: GlobalConst.LABEL_H * 3,
                    width: ADDRESS_WIDTH)
        createLabel(lbl: lblSeparator, text: "-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------", offset: lblAddress.frame.maxY)
        createEditBtn()
        
        
        self.view.addSubview(lblName)
        self.view.addSubview(lblPhone)
        self.view.addSubview(lblAddress)
        self.view.addSubview(lblSeparator)
        self.view.addSubview(btnEdit)
        self.view.makeComponentsColor()
    }
    
    override func createBackground() {
        self.view.layer.contents = ImageManager.getImage(named: DomainConst.MENU_BKG_BODY_NEW_IMG_NAME)?.cgImage
    }
    
    override func createTopPart() {
        // Setting top image
        createTopView(topImgPath: DomainConst.MENU_BKG_TOP_NEW_IMG_NAME)
        // Setting logo
        createTopLogo(logo: DomainConst.LOGO_LOGIN_ICON_IMG_NAME)
    }
    
    //++ BUG0165-SPJ (NguyenPT 20171123) Override select home menu
    override func openHome() {
        // Get current view controller
        if let currentView = BaseViewController.getCurrentViewController() {
            // Check if current view controller is G12F01S01VC
            if currentView.theClassName == G12F01S01VC.theClassName {
                // Start new request Transaction Status
                (currentView as! G12F01S01VC).requestNewTransactionStatus()
            } else {
                // Pop to root view controller
                currentView.clearData()
                currentView.popToRootView()
            }
        }
    }
    //-- BUG0165-SPJ (NguyenPT 20171123) Override select home menu

    override func openLogin() {
        let loginView = G00LoginExtVC(nibName: G00LoginExtVC.theClassName, bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.present(loginView, animated: true, completion: finishOpenLogin)
        }
    }
    
    override func openPromotion() {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
//        promotionView.activeQRCode()
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
        }
    }
    
    override func openPromotionActiveQR() {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        promotionView.activeQRCode()
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
        }
    }
    
    //++ BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    override func openPromotionActiveUsingCode(code: String) {
        let promotionView = G13F00S01VC(nibName: G13F00S01VC.theClassName, bundle: nil)
        promotionView.activeUsingCode(code: code)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(promotionView, animated: true)
        }
    }
    //-- BUG0187-SPJ (NguyenPT 20180202) Gas24h  - Add data for Bottom message view, Add popup promotion
    
    override func openListOrder() {
        let g12f00s01 = G12F00S01VC(nibName: G12F00S01VC.theClassName,
                                    bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(g12f00s01, animated: true)
        }
    }
    
    override func openUserProfile() {
        let view = G00AccountExtVC(nibName: G00AccountExtVC.theClassName,
                                    bundle: nil)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    //++ BUG0171-SPJ (NguyenPT 20171127) Add new menu
    override func openPromotionPolicy() {
        let bundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        let view = BaseNewsViewController(nibName: BaseNewsViewController.theClassName,
                                          bundle: bundle)
        view.setData(title: DomainConst.CONTENT00536, id: DomainConst.MENU_PROMOTION_POLICY_ID)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    override func openAppGuide() {
        let bundle = Bundle(identifier: DomainConst.HARPY_FRAMEWORK_BUNDLE_NAME)
        let view = BaseNewsViewController(nibName: BaseNewsViewController.theClassName,
                                          bundle: bundle)
        view.setData(title: DomainConst.CONTENT00537, id: DomainConst.MENU_APP_GUIDE_ID)
        if let controller = BaseViewController.getCurrentViewController() {
            controller.navigationController?.pushViewController(view, animated: true)
        }
    }
    //-- BUG0171-SPJ (NguyenPT 20171127) Add new menu
    //++ BUG0195-SPJ (NguyenPT 20180411) Add function announce
    /**
     * Handle open announce list
     */
    override func openAnnounce() {
        let view = G15F00S01VC(nibName: G15F00S01VC.theClassName,
                               bundle: nil)
        self.push(view, animated: true)
    }
    
    /**
     * Handle open announce detail
     * - parameter id: Id of announce
     */
    override func openAnnounceDetail(id: String) {
        let view = G15F00S02VC(nibName: G15F00S02VC.theClassName, bundle: nil)
        view.setData(id: id)
        self.push(view, animated: true)
    }
    //-- BUG0195-SPJ (NguyenPT 20180411) Add function announce
    
    //++ BUG0196-SPJ (NguyenPT 20180511) Gas24h - Add new function: Map agent
    override func openMapAgent() {
        let vc = MapAgentViewController(nibName: MapAgentViewController.theClassName, bundle: nil)
        self.push(vc, animated: true)
    }
    //-- BUG0196-SPJ (NguyenPT 20180511) Gas24h - Add new function: Map agent
    
    override func update() {
        super.update()
        
        if BaseModel.shared.checkIsLogin() {
            //if let userInfo = BaseModel.shared.user_info {
            if !BaseModel.shared.getUserInfo().isEmpty() {
                //setUserInfo(info: userInfo)
                setUserInfo(info: BaseModel.shared.getUserInfo())
            } else {
                UserProfileRequest.requestUserProfile(action: #selector(finishUpdateUserInfo(_:)), view: self)
            }
        } else {
            setUserInfo(info: UserInfoBean())
        }
        btnEdit.isHidden = !BaseModel.shared.checkIsLogin()
    }
    
    // MARK: Event handler
    /**
     * Handle when tap on edit button
     */
    internal func btnEditTapped(_ sender: AnyObject) {
        if let controller = BaseViewController.getCurrentViewController() {
            if let root = BaseViewController.getRootController() {
                root.closeLeft()
            }
            let view = G00AccountEditVC(nibName: G00AccountEditVC.theClassName,
                                        bundle: nil)
            controller.navigationController?.pushViewController(view,
                                                                animated: true)
        }
    }
    
    /**
     * Handle when finish update user information
     */
    internal func finishUpdateUserInfo(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = UserProfileRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setUserInfo(userInfo: model.record)
            setUserInfo(info: model.record)
        }
    }
    
    /**
     * Handle when finish open login screen
     */
    internal func finishOpenLogin() -> Void {
        print("finishOpenLogin")
    }
    
    // MARK: Utilities
    /**
     * Set user info
     * - parameter info: User info bean
     */
    private func setUserInfo(info: UserInfoBean) {
        lblName.text = info.getName()
        if info.getPhone().isEmpty {
            lblPhone.text = BaseModel.shared.getCurrentUsername()
        } else {
            lblPhone.text = info.getPhone()
        }
        lblAddress.text = info.getAddress()
        
        updateLayout()
    }
    
    /**
     * Create label
     * - parameter lbl:     UILabel
     * - parameter text:    Text content
     * - parameter offset:  Y offset
     * - parameter isBold:  Flag if need use bold font
     * - parameter height:  Height of UILabel
     * - parameter width:   Width of UILabel
     */
    private func createLabel(lbl: UILabel, text: String,
                             offset: CGFloat,
                             isBold: Bool = false,
                             height: CGFloat = GlobalConst.LABEL_H,
                             width: CGFloat = GlobalConst.POPOVER_WIDTH - 2 * GlobalConst.MARGIN) {
        lbl.frame = CGRect(x: GlobalConst.MARGIN, y: offset,
                               width: width,
                               height: height)
        lbl.text = text
        lbl.textColor = UIColor.white
        lbl.lineBreakMode = .byWordWrapping
        lbl.numberOfLines = 0
        if isBold {
            lbl.font = GlobalConst.BASE_BOLD_FONT
        } else {
            lbl.font = GlobalConst.BASE_FONT
        }
    }
    
    /**
     * Get height of address need
     * - returns: Height of address field
     */
    private func getHeightOfAddress() -> CGFloat {
        let address = BaseModel.shared.getUserInfo().getAddress()
        return address.heightWithConstrainedWidth(
            width: ADDRESS_WIDTH,
            font: GlobalConst.BASE_FONT)
    }
    
    /**
     * Create edit button
     */
    private func createEditBtn() {
        let btnSize = GlobalConst.LABEL_H
        btnEdit.frame = CGRect(x: GlobalConst.POPOVER_WIDTH - btnSize - GlobalConst.MARGIN,
                               y: lblSeparator.frame.minY - btnSize,
                               width: btnSize, height: btnSize)
        btnEdit.setImage(ImageManager.getImage(named: DomainConst.EDIT_BUTTON_ICON_IMG_NAME),
                         for: UIControlState())
        btnEdit.imageView?.contentMode = .scaleAspectFit
        btnEdit.addTarget(self, action: #selector(btnEditTapped(_:)),
                          for: .touchUpInside)
    }
    
    private func updateLayout() {
//        CommonProcess.updateViewPos(
//            view: lblName,
//            x: GlobalConst.MARGIN,
//            y: getTopPartHeight(),
//            w: GlobalConst.POPOVER_WIDTH - 2 * GlobalConst.MARGIN,
//            h: GlobalConst.LABEL_H)
//        CommonProcess.updateViewPos(
//            view: lblPhone,
//            x: GlobalConst.MARGIN,
//            y: lblName.frame.maxY,
//            w: GlobalConst.POPOVER_WIDTH - 2 * GlobalConst.MARGIN,
//            h: GlobalConst.LABEL_H)
//        CommonProcess.updateViewPos(
//            view: lblAddress,
//            x: GlobalConst.MARGIN,
//            y: lblPhone.frame.maxY,
//            w: ADDRESS_WIDTH,
//            h: getHeightOfAddress())
    }
}
