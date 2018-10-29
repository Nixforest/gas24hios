//
//  G04F01S01VC.swift
//  project
//
//  Created by SPJ on 1/18/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G04F01S01VC: MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func setData1(_ notification: Notification) {
        if !BaseModel.shared.checkTransactionKey() {
            if BaseModel.shared.checkIsLogin() {
                OrderTransactionStartRequest.requestOrderTransactionStart(action: #selector(finishStartTransaction(_:)), view: self)
            }            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func btnOrderTapped(_ sender: AnyObject) {
        if !MapViewController._nearestAgent.isEmpty() {
            if BaseModel.shared.checkIsLogin() {
                self.pushToView(name: G04Const.G04_F01_S05_VIEW_CTRL)
            } else {
                self.pushToView(name: DomainConst.G00_LOGIN_VIEW_CTRL)
            }
            
        } else {
            self.showAlert(message: DomainConst.CONTENT00176)
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if !BaseModel.shared.checkTransactionKey() {
            if BaseModel.shared.checkIsLogin() {
                OrderTransactionStartRequest.requestOrderTransactionStart(action: #selector(finishStartTransaction(_:)), view: self)
            }
        }
    }
    //++ BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
    internal func finishStartTransaction(_ notification: Notification) {
        let data = (notification.object as! String)
        let model = OrderTransactionStartRespModel(jsonString: data)
        if model.isSuccess() {
            BaseModel.shared.setTransactionData(transaction: model.getRecord())
        } else {
            showAlert(message: model.message)
        }
    }
    //-- BUG0047-SPJ (NguyenPT 20170724) Refactor BaseRequest class
}
