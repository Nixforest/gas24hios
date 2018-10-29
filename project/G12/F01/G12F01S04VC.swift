//
//  G12F01S04VC.swift
//  project
//
//  Created by SPJ on 9/26/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G12F01S04VC: G12F01S03VC {
    // MARK: Properties
    // MARK: Constant
    let PROMOTE_TITLE_LABEL_HEIGHT                  = GlobalConst.LABEL_H * 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        G12F01S01VC._promoteSelected = _data[indexPath.row]
        self.backButtonTapped(self)
    }
    
    public override func handleSelectCell(cell: MaterialCollectionViewCell, id: String) {
        cell.select(isSelected: (G12F01S01VC._promoteSelected.material_id == id))
    }
    
    // MARK: Title label
    public override func createTitleLabel() {
        _lblTitle.frame = CGRect(x: 0,
                                 y: getTopHeight(),
                                 width: UIScreen.main.bounds.width,
                                 height: PROMOTE_TITLE_LABEL_HEIGHT)
        _lblTitle.text = DomainConst.CONTENT00525
        _lblTitle.textAlignment = .center
        _lblTitle.textColor = UIColor.black
        _lblTitle.font = GlobalConst.BASE_FONT
        _lblTitle.lineBreakMode = .byWordWrapping
        _lblTitle.numberOfLines = 0
    }
    
    public override func updateTitleLabel() {
        CommonProcess.updateViewPos(
            view: _lblTitle,
            x: 0, y: getTopHeight(),
            w: UIScreen.main.bounds.width,
            h: PROMOTE_TITLE_LABEL_HEIGHT)
    }
    
//    /**
//     * Handle tap on Not select button
//     */
//    override func btnNotSelectTapped(_ sender: AnyObject) {
//        G12F01S01VC._promoteSelected = MaterialBean.init()
//        self.backButtonTapped(self)
//    }
}
