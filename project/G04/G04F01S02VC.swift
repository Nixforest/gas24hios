//
//  G04F01S02VC.swift
//  project
//
//  Created by SPJ on 1/22/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G04F01S02VC: MaterialSelectViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // NavBar setup
        //++ BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
        //setupNavigationBar(title: DomainConst.CONTENT00237, isNotifyEnable: BaseModel.shared.checkIsLogin(), isHiddenBackBtn: false)
        createNavigationBar(title: DomainConst.CONTENT00237)
        //-- BUG0048-SPJ (NguyenPT 20170313) Create slide menu view controller
    }
    
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
        MapViewController._gasSelected = self.getData(index: indexPath.row)
        self.backButtonTapped(self)
    }
}
