//
//  G21F00S01VC.swift
//  project
//
//  Created by SPJ on 10/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import harpyframework

class G21F00S01VC: BaseParentViewController {

    @IBAction func goScanScreen(_ sender: Any) {
        pushToView(name: "G21F00S02VC")
    }
    
    @IBOutlet weak var lblQRCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: DomainConst.HOTLINE)
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if(BaseModel.shared.sharedCode != DomainConst.BLANK){
            lblQRCode.text = BaseModel.shared.sharedCode
            requestData()
        }
    }
    
    /**
     * Request data from server
     */
    private func requestData(action: Selector = #selector(setData(_:))) {
        UserProfile2Request.request(action: action,
                                    view: self, code_account: BaseModel.shared.sharedCode
        )
    }

    override func setData(_ notification: Notification) {
        let dataStr = (notification.object as! String)
        let model = UserProfile2ResModel(jsonString: dataStr)
        if model.isSuccess() {
            if(model.record.id != DomainConst.BLANK){
                showAlert(message: "Thông tin nhân viên là : \(model.record.first_name)",
                          okHandler: {
                            alert in
                })
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
