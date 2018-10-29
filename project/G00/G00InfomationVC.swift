//
//  InfomationViewController.swift
//  project
//
//  Created by Lâm Phạm on 9/19/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps

//++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//class G00InfomationVC: UIViewController {
class G00InfomationVC: ChildViewController {
//-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    // MARK: Properties
    //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//    /** Navigation bar */
//    @IBOutlet weak var infomationNavBar: UINavigationItem!
//    /** Back button */
//    @IBOutlet weak var backButton: UIButton!
    //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    /** Version */
    var lblVersion: UILabel = UILabel()
    var lblVersionValue: UILabel = UILabel()
    /** Email */
    var lblEmail: UILabel = UILabel()
    //++ BUG0048-SPJ (NguyenPT 20170309) Use UIButton
    //var lblEmailValue: UILabel = UILabel()
    var btnEmail: UIButton = UIButton()
    //-- BUG0048-SPJ (NguyenPT 20170309) Use UIButton
    /** Website */
    var lblWebsite: UILabel = UILabel()
    var lblWebsiteValue: UILabel = UILabel()
    /** Logo */
    var imgLogo: UIImageView = UIImageView()
    /** Tap counter on logo */
    var imgLogoTappedCounter: Int = 0
    
    // MARK: Actions
    //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//    /**
//     * Handle back buton tapped
//     * - parameter sender:AnyObject
//     */
//    @IBAction func backButtonTapped(_ sender: AnyObject) {
//        _ = self.navigationController?.popViewController(animated: true)
//    }
    //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
    
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
            //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//            let view = mainStoryboard.instantiateViewController(withIdentifier: DomainConst.INTERNAL_VIEW_CTRL)
//            self.navigationController?.pushViewController(view, animated: true)
            self.pushToView(name: DomainConst.INTERNAL_VIEW_CTRL)
            //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        }
    }
    
    /**
     * View did load
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //++ BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
//        infomationNavBar.title = DomainConst.CONTENT00072
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: GlobalConst.BUTTON_COLOR_RED]
//
//        let backOrigin = ImageManager.getImage(named: DomainConst.BACK_IMG_NAME)
//        let tintedBackLogo = backOrigin?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        backButton.setImage(tintedBackLogo, for: UIControlState())
//        backButton.tintColor = GlobalConst.BUTTON_COLOR_RED
//        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        //menuButton.addTarget(self, action: #selector(showPopOver), forControlEvents: .TouchUpInside)
//        backButton.setTitle("", for: UIControlState())
//        let backNavBar = UIBarButtonItem()
//        backNavBar.customView = backButton
//        infomationNavBar.setLeftBarButton(backNavBar, animated: false)
        createNavigationBar(title: DomainConst.CONTENT00072)
        //-- BUG0048-SPJ (NguyenPT 20170309) Create slide menu view controller
        let heigh = self.navigationController!.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.size.height
        var offset: CGFloat = heigh + GlobalConst.MARGIN
        
        // Setup content
        // Version label
        lblVersion.translatesAutoresizingMaskIntoConstraints = true
        lblVersion.frame = CGRect(
            x: GlobalConst.MARGIN,
            y: offset,
            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN,
            height: GlobalConst.LABEL_HEIGHT)
        lblVersion.text               = DomainConst.CONTENT00198
        lblVersion.textAlignment      = NSTextAlignment.left
        lblVersion.font               = UIFont.boldSystemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE)
        lblVersion.textColor          = GlobalConst.INFOR_TITLE_COLOR
        offset += GlobalConst.LABEL_HEIGHT
        // Version value
        lblVersionValue.translatesAutoresizingMaskIntoConstraints = true
        lblVersionValue.frame = CGRect(
            x: GlobalConst.MARGIN * 2,
            y: offset,
            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN * 2,
            height: GlobalConst.LABEL_HEIGHT / 2)
        lblVersionValue.text          = DomainConst.VERSION_CODE_FULL_NAME
        lblVersionValue.textAlignment = NSTextAlignment.left
        lblVersionValue.font          = UIFont.systemFont(ofSize: GlobalConst.TEXTFIELD_FONT_SIZE)
        offset += GlobalConst.LABEL_HEIGHT / 2
        
        // Email
        lblEmail.translatesAutoresizingMaskIntoConstraints = true
        lblEmail.frame = CGRect(
            x: GlobalConst.MARGIN,
            y: offset,
            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN,
            height: GlobalConst.LABEL_HEIGHT)
        lblEmail.text               = DomainConst.CONTENT00199
        lblEmail.textAlignment      = NSTextAlignment.left
        lblEmail.font               = UIFont.boldSystemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE)
        lblEmail.textColor          = GlobalConst.INFOR_TITLE_COLOR
        offset += GlobalConst.LABEL_HEIGHT
        //++ BUG0048-SPJ (NguyenPT 20170309) Use UIButton
        // Email value
//        lblEmailValue.translatesAutoresizingMaskIntoConstraints = true
//        lblEmailValue.frame = CGRect(
//            x: GlobalConst.MARGIN * 2,
//            y: offset,
//            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN * 2,
//            height: GlobalConst.LABEL_HEIGHT / 2)
//        lblEmailValue.text          = DomainConst.EMAIL
//        lblEmailValue.textAlignment = NSTextAlignment.left
//        lblEmailValue.font          = UIFont.systemFont(ofSize: GlobalConst.TEXTFIELD_FONT_SIZE)
        btnEmail.frame = CGRect(x: GlobalConst.MARGIN * 2, y: offset,
                                width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN * 2,
                                height: GlobalConst.LABEL_HEIGHT / 2)
        btnEmail.setTitle(DomainConst.EMAIL, for: UIControlState())
        btnEmail.setTitleColor(UIColor.blue, for: UIControlState())
        btnEmail.contentHorizontalAlignment = .left
        btnEmail.addTarget(self, action: #selector(sendEmail(_:)), for: .touchUpInside)
        btnEmail.titleLabel?.font = UIFont.systemFont(ofSize: GlobalConst.TEXTFIELD_FONT_SIZE)
        //-- BUG0048-SPJ (NguyenPT 20170309) Use UIButton
        offset += GlobalConst.LABEL_HEIGHT / 2
        
        // Website
        lblWebsite.translatesAutoresizingMaskIntoConstraints = true
        lblWebsite.frame = CGRect(
            x: GlobalConst.MARGIN,
            y: offset,
            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN,
            height: GlobalConst.LABEL_HEIGHT)
        lblWebsite.text               = DomainConst.CONTENT00200
        lblWebsite.textAlignment      = NSTextAlignment.left
        lblWebsite.font               = UIFont.boldSystemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE)
        lblWebsite.textColor          = GlobalConst.INFOR_TITLE_COLOR
        offset += GlobalConst.LABEL_HEIGHT
        // Website value
        lblWebsiteValue.translatesAutoresizingMaskIntoConstraints = true
        lblWebsiteValue.frame = CGRect(
            x: GlobalConst.MARGIN * 2,
            y: offset,
            width: GlobalConst.SCREEN_WIDTH - GlobalConst.MARGIN * 2,
            height: GlobalConst.LABEL_HEIGHT / 2)
        lblWebsiteValue.text          = DomainConst.WEBSITE
        lblWebsiteValue.textAlignment = NSTextAlignment.left
        lblWebsiteValue.font          = UIFont.systemFont(ofSize: GlobalConst.TEXTFIELD_FONT_SIZE)
        offset += GlobalConst.LABEL_HEIGHT / 2 + GlobalConst.MARGIN
        
        // Logo
        imgLogo.image = ImageManager.getImage(named: BaseModel.shared.getMainLogo())
        imgLogo.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.LOGIN_LOGO_W) / 2,
                               y: offset,
                               width: GlobalConst.LOGIN_LOGO_W,
                               height: GlobalConst.LOGIN_LOGO_H)
        imgLogo.contentMode = .scaleAspectFit
        imgLogo.translatesAutoresizingMaskIntoConstraints = true
        imgLogo.isUserInteractionEnabled = true
        let imgLogoTappedRecognizer = UITapGestureRecognizer(target: self, action: #selector(imgLogoTapped(_:)))
        imgLogo.addGestureRecognizer(imgLogoTappedRecognizer)
        offset += imgLogo.frame.height + GlobalConst.MARGIN
        
        self.view.addSubview(lblVersion)
        self.view.addSubview(lblVersionValue)
        self.view.addSubview(lblEmail)
        //++ BUG0048-SPJ (NguyenPT 20170309) Use UIButton
        //self.view.addSubview(lblEmailValue)
        self.view.addSubview(btnEmail)
        //-- BUG0048-SPJ (NguyenPT 20170309) Use UIButton
        self.view.addSubview(lblWebsite)
        self.view.addSubview(lblWebsiteValue)
        self.view.addSubview(imgLogo)
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let lat: CLLocationDegrees = 10.7964088
        let long: CLLocationDegrees = 106.705768
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect(x: GlobalConst.MARGIN,
                                                       y: offset,
                                                       width:GlobalConst.SCREEN_WIDTH - 2 * GlobalConst.MARGIN,
                                                       height:GlobalConst.SCREEN_HEIGHT - offset - GlobalConst.MARGIN),
                                     camera: camera)
        //view = mapView
        //self.view.insertSubview(mapView, at: 0)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "Công ty Cổ Phần Dầu Khí Miền Nam"
        marker.snippet = "86 Nguyễn Cửu Vân - Bình Thạnh - TP HCM"
        marker.map = mapView
        self.view.addSubview(mapView)
    }
    //++ BUG0048-SPJ (NguyenPT 20170309) Use UIButton
    /**
     * Handle send email
     */
    internal func sendEmail(_ sender: AnyObject) {
        self.makeEmail(email: DomainConst.EMAIL)
    }
    //-- BUG0048-SPJ (NguyenPT 20170309) Use UIButton
    
    /**
     * Did receive memory warning
     */
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func loadView() {
//    }
}
