//
//  G21F00S03VC.swift
//  project
//
//  Created by SPJ on 11/7/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class G21F00S03VC: BaseChildViewController {

    @IBOutlet weak var imgEmployee: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblJob: UILabel!
    
    @IBOutlet weak var lblIdEmployee: UILabel!
    
    var id = DomainConst.BLANK
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: DomainConst.CONTENT00551)
        imgEmployee.layer.cornerRadius = imgEmployee.frame.width / 2
        imgEmployee.layer.borderWidth  = 2
        imgEmployee.layer.borderColor  = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
        if(BaseModel.shared.sharedCode != DomainConst.BLANK){
            let fullName : String = BaseModel.shared.sharedCode
            let fullNameArr : [String] = fullName.components(separatedBy: "/")
                id = fullName
            if fullNameArr.count > 0 {
                id = fullNameArr[fullNameArr.count - 1]
            }
            // And then to access the individual words:
            
            id = fullNameArr[fullNameArr.count - 1]
            
            //var lastName : String = fullNameArr[fullNameArr.count - 2]
            requestData()
        }
    }
    
    /**
     * Request data from server
     */
    private func requestData(action: Selector = #selector(setData(_:))) {
        UserProfile2Request.request(action: action,
                                    view: self, code_account: id
        )
    }
    
    override func setData(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = UserProfile2ResModel(jsonString: dataStr)
        if model.isSuccess() {
            if(model.record.id != DomainConst.BLANK){
                lblName.text = model.record.first_name
                lblJob.text  = model.record.role_id
                lblIdEmployee.text = "ID:\(model.record.code_account)"
                imgEmployee.getImgFromUrl(link: model.record.link_image, contentMode: imgEmployee.contentMode)
            }
            else{
                showAlert(message: "Không tìm thấy thông tin nhân viên",
                          okHandler: {
                            alert in
                })
            }
            
        }
        else{
            showAlert(message: model.message)
        }
        
    }


}
