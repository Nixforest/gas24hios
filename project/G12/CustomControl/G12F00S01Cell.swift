//
//  G12F00S01Cell.swift
//  project
//
//  Created by SPJ on 10/17/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class G12F00S01Cell: UITableViewCell {
    // MARK: Properties
    /** Status icon */
    var _statusIcon:            UIImageView     = UIImageView()
    /** Date label */
    var _lblDate:               UILabel         = UILabel()
    /** Time label */
    var _lblTime:               UILabel         = UILabel()
    /** Code label */
    var _lblCode:               UILabel         = UILabel()
    /** Address label */
    var _lblAddress:            UILabel         = UILabel()
    /** Money label */
    var _lblMoney:              UILabel         = UILabel()
    /** Left view */
    var _leftView:              UIView          = UIView()
    /** Right view */
    var _rightView:             UIView          = UIView()
    
    // MARK: Const
    var LEFT_VIEW_RATE:         CGFloat         = 1/3
    var RIGHT_VIEW_RATE:        CGFloat         = 2/3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Left view
        createLeftView()
        
        // Right view
        createRightView()
        
        self.contentView.addSubview(_leftView)
        self.contentView.addSubview(_rightView)
        self.makeComponentsColor()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Logic
    /**
     * Get status icon size
     * - returns: Size of status icon
     */
    private func getStatusIconSize() -> CGFloat {
        var retVal: CGFloat = 0.0
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            retVal = GlobalConst.STATUS_ICON_SIZE * BaseViewController.H_RATE_HD
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                retVal = GlobalConst.STATUS_ICON_SIZE * BaseViewController.H_RATE_FHD
            case .landscapeLeft, .landscapeRight:       // Landscape
                retVal = GlobalConst.STATUS_ICON_SIZE * BaseViewController.H_RATE_FHD_L
            default:
                break
            }
            
            break
        default:
            break
        }
        return retVal
    }
    
    /**
     * Get status icon image path
     * - parameter status: Value of status
     * - returns: Image path of status icon
     */
    private func getStatusIcon(status: String) -> String {
        var retVal = DomainConst.STATUS_FINISH_SMALL_IMG_NAME
        switch status {
        case DomainConst.ORDER_STATUS_NEW:
            retVal = DomainConst.STATUS_WAITING_SMALL_IMG_NAME
            break
        case DomainConst.ORDER_STATUS_PROCESSING:
            retVal = DomainConst.STATUS_NEW_SMALL_IMG_NAME
            break
        case DomainConst.ORDER_STATUS_COMPLETE:
            retVal = DomainConst.STATUS_FINISH_SMALL_IMG_NAME
            break
        case DomainConst.ORDER_STATUS_CANCEL:
            retVal = DomainConst.STATUS_CANCEL_SMALL_IMG_NAME
            break
        default:
            break
        }
        return retVal
    }
    
    /**
     * Set data for cell
     * - parameter bean: OrderListBean
     */
    public func setData(bean: OrderListBean) {
        _statusIcon.image = ImageManager.getImage(named: getStatusIcon(status: bean.status_number))
        setValueForDateTime(dateTime: bean.created_date)
        _lblCode.text = bean.code_no
        _lblMoney.text = bean.grand_total
        _lblAddress.text = bean.address
        if bean.status_number == DomainConst.ORDER_STATUS_CANCEL {
            let cancelColor = UIColor.gray
            _lblCode.textColor = cancelColor
            _lblMoney.textColor = cancelColor
            _lblAddress.textColor = cancelColor
        } else {
            _lblCode.textColor = UIColor.black
            _lblMoney.textColor = GlobalConst.MAIN_COLOR_GAS_24H
            _lblAddress.textColor = UIColor.black
        }
    }
    
    /**
     * Set value for date-time label
     * - parameter dateTime: Datetime string
     */
    private func setValueForDateTime(dateTime: String) {
        var time: String = DomainConst.BLANK
        var date: String = DomainConst.BLANK
        var dateTimeArr = dateTime.components(separatedBy: DomainConst.SPACE_STR)
        if dateTimeArr.count == 2 {
            time = dateTimeArr[1]
            date = dateTimeArr[0]
        } else {
            time = DomainConst.DEFAULT_TIME_VALUE
            date = dateTime
        }
        _lblTime.text = time
        _lblDate.text = date
    }
    
    // MARK: Layout
    /**
     * Create left view
     */
    private func createLeftView() {
        _leftView.frame = CGRect(x: (UIScreen.main.bounds.width - self.contentView.frame.width) / 2,
                                 y: 0,
                                 width: self.contentView.frame.width * LEFT_VIEW_RATE,
                                 height: self.contentView.frame.height)
        // Status icon
        createStatusIcon()
        
        // Date label
        createDateLabel()
        
        // Time label
        createTimeLabel()
        
        _leftView.addSubview(_statusIcon)
        _leftView.addSubview(_lblDate)
        _leftView.addSubview(_lblTime)
    }
    
    /**
     * Create Status icon
     */
    private func createStatusIcon() {
        _statusIcon.frame = CGRect(x: GlobalConst.MARGIN_CELL_X,
                                   y: 0,
                                   width: getStatusIconSize(),
                                   height: _leftView.frame.height)
        _statusIcon.contentMode = .scaleAspectFit
        _statusIcon.setImage(imgPath: DomainConst.STATUS_FINISH_SMALL_IMG_NAME)
    }
    
    /**
     * Create date label
     */
    private func createDateLabel() {
        _lblDate.frame = CGRect(x: _statusIcon.frame.maxX + GlobalConst.MARGIN_CELL_X,
                                y: 0,
                                width: _leftView.frame.width - _statusIcon.frame.width,
                                height: GlobalConst.LABEL_H)
        _lblDate.text = "12/07/2017"
        _lblDate.textAlignment = .left
        _lblDate.font = GlobalConst.BASE_FONT
    }
    
    /**
     * Create time label
     */
    private func createTimeLabel() {
        _lblTime.frame = CGRect(
            x: _lblDate.frame.minX,
            y: _lblDate.frame.maxY,
            width: _lblDate.frame.width,
            height: GlobalConst.LABEL_H)
        _lblTime.text = "16:20"
        _lblTime.textAlignment = .left
        _lblTime.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
    }
    
    /**
     * Create right view
     */
    private func createRightView() {
        _rightView.frame = CGRect(x: _leftView.frame.maxX + GlobalConst.MARGIN_CELL_X,
                                  y: 0,
                                  width: self.contentView.frame.width * RIGHT_VIEW_RATE - GlobalConst.MARGIN_CELL_X,
                                  height: self.contentView.frame.height)
        
        // Code label
        createCodeLabel()
        
        // Money label
        createMoneyLabel()
        
        // Address label
        createAddressLabel()
        
        _rightView.addSubview(_lblCode)
        _rightView.addSubview(_lblMoney)
        _rightView.addSubview(_lblAddress)
    }
    
    /**
     * Create code label
     */
    private func createCodeLabel() {
        _lblCode.frame = CGRect(x: GlobalConst.MARGIN_CELL_X,
                                y: 0,
                                width: _rightView.frame.width / 2 - GlobalConst.MARGIN_CELL_X,
                                height: GlobalConst.LABEL_H)
        _lblCode.textAlignment = .left
        _lblCode.text = "MDKFC2"
        _lblCode.font = GlobalConst.BASE_FONT
    }
    
    /**
     * Create money label
     */
    private func createMoneyLabel() {
        _lblMoney.frame = CGRect(x: _lblCode.frame.maxX,
                                y: 0,
                                width: _rightView.frame.width / 2 - GlobalConst.MARGIN_CELL_X,
                                height: GlobalConst.LABEL_H)
        _lblMoney.textAlignment = .right
        _lblMoney.text = "330.000"
        _lblMoney.font = GlobalConst.BASE_FONT
        _lblMoney.textColor = GlobalConst.MAIN_COLOR_GAS_24H
    }
    
    /**
     * Create address label
     */
    private func createAddressLabel() {
        _lblAddress.frame = CGRect(x: GlobalConst.MARGIN_CELL_X,
                                y: _lblCode.frame.maxY,
                                width: _rightView.frame.width - GlobalConst.MARGIN_CELL_X,
                                height: GlobalConst.LABEL_H * 2)
        _lblAddress.textAlignment = .left
        _lblAddress.text = "MDKFC2"
        _lblAddress.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        _lblAddress.lineBreakMode = .byWordWrapping
        _lblAddress.numberOfLines = 0
    }
}
