//
//  G04F01S03.swift
//  project
//
//  Created by SPJ on 1/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G04F01S03VC: MaterialSelectViewController {
    /** Not select promotion button */
    private var _btnNotSelect: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00238, isNotifyEnable: BaseModel.shared.checkIsLogin(), isHiddenBackBtn: false)
        createNavigationBar(title: DomainConst.CONTENT00238)
        //-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        
        // Update layout
        let maxY = self.updateLayout(bottomHeight: GlobalConst.BUTTON_H + 2 * GlobalConst.MARGIN)
        // Button Confirm
        CommonProcess.createButtonLayout(btn: self._btnNotSelect,
                                         x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                         y: maxY + GlobalConst.MARGIN,
                                         text: DomainConst.CONTENT00244.uppercased(),
                                         action: #selector(btnNotSelectTapped),
                                         target: self,
                                         img: DomainConst.CANCEL_IMG_NAME,
                                         tintedColor: UIColor.white)
        //++ BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
        self._btnNotSelect.imageEdgeInsets = UIEdgeInsets(top: GlobalConst.MARGIN,
                                                    left: GlobalConst.MARGIN,
                                                    bottom: GlobalConst.MARGIN,
                                                    right: GlobalConst.MARGIN)
        //-- BUG0038-SPJ (NguyenPT 20170222) Decrease size of icon on Button
        self.view.addSubview(self._btnNotSelect)
    }
    
    /**
     * Set data for view
     * - parameter data: List of material bean
     */
    public static func setData(data: [MaterialBean]) {
        MaterialSelectViewController.setMaterialData(data: data)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        MapViewController._promoteSelected = self.getData(index: indexPath.row)
        self.backButtonTapped(self)
    }
    
    /**
     * Handle tap on Not select button
     */
    public func btnNotSelectTapped(_ sender: AnyObject) {
        MapViewController._promoteSelected = MaterialBean.init()
        self.backButtonTapped(self)
    }
}
