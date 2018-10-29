//
//  MaterialCollectionViewCell.swift
//  project
//
//  Created by SPJ on 10/11/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework

class MaterialCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    /** Data */
    private var _data:              OrderDetailBean     = OrderDetailBean()
    /** Image */
    private var _imageView:         UIImageView         = UIImageView()
    /** Material name label */
    private var _lblName:           UILabel             = UILabel()
    /** Material price label */
    private var _lblPrice:          UILabel             = UILabel()
    /** Material original price label */
    private var _lblPriceOriginal:  UILabel             = UILabel()
    
    // MARK: Constant
    let NAME_LABEL_HEIGHT                       = GlobalConst.LABEL_H * 3
    let PRICE_LABEL_HEIGHT                      = GlobalConst.LABEL_H
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /**
     * Set data for cell
     * - parameter data:    Data of cell
     * - parameter width:   Width of cell
     * - parameter height:  Height of cell
     */
    public func setData(data: OrderDetailBean, width: CGFloat, height: CGFloat) {
        self._data = data
        // Image
        if !_data.material_image.isEmpty {
            _imageView.getImgFromUrl(link: _data.material_image, contentMode: _imageView.contentMode)
        } else {
            _imageView.setImage(imgPath: DomainConst.DEFAULT_IMG_NAME)
        }
        let xPos = GlobalConst.MARGIN_CELL_X
        let viewWidth = width - 2 * GlobalConst.MARGIN_CELL_X
        _imageView.frame = CGRect(x: xPos, y: 0,
                                  width: viewWidth,
                                  height: height - (NAME_LABEL_HEIGHT + PRICE_LABEL_HEIGHT * 2 + GlobalConst.MARGIN_CELL_X))
        _imageView.layoutMargins = UIEdgeInsets(
            top: GlobalConst.MARGIN_CELL_X,
            left: 0, bottom: 0, right: 0)
        _imageView.contentMode = .scaleAspectFit
        self.addSubview(_imageView)
        // Name
        _lblName.frame = CGRect(x: xPos, y: _imageView.frame.maxY,
                                width: viewWidth,
                                height: NAME_LABEL_HEIGHT)
        if BaseModel.shared.getDebugUseMaterialNameShort() {
            if _data.materials_name_short.isEmpty {
                _lblName.text = _data.material_name
            } else {
                _lblName.text = _data.materials_name_short
            }
            //-- BUG0076-SPJ (NguyenPT 20170506) Name of cylinder not show when open add cylinder OrderFamily
        } else {
            _lblName.text          = _data.material_name
        }
        _lblName.textColor     = GlobalConst.TEXT_COLOR_GRAY
        _lblName.font          = UIFont.systemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE_1)
        _lblName.textAlignment = .center
        _lblName.numberOfLines = 0
        _lblName.lineBreakMode = .byWordWrapping
        self.addSubview(_lblName)
        // Price label
        _lblPrice.frame = CGRect(x: xPos,
                                 y: _lblName.frame.maxY,
                                 width: viewWidth,
                                 height: PRICE_LABEL_HEIGHT)
        let priceText = _data.material_price
        if priceText == DomainConst.NUMBER_ZERO_VALUE ||
            priceText.isEmpty {
//            _lblPrice.isHidden = true
            _lblPrice.text          = DomainConst.BLANK
        } else {
//            _lblPrice.isHidden = false
            _lblPrice.text          = priceText
        }
        
//        _lblPrice.text          = priceText
        _lblPrice.textColor     = GlobalConst.BUTTON_COLOR_RED
        _lblPrice.font          = GlobalConst.BASE_FONT
        _lblPrice.textAlignment = .center
//        _lblPrice.numberOfLines = 0
//        _lblPrice.lineBreakMode = .byWordWrapping
        self.addSubview(_lblPrice)
//        self.layer.borderColor = GlobalConst.TEXT_COLOR_GRAY.cgColor
//        self.layer.borderWidth = 1.0
        
        //++ BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
        // Original price
        _lblPriceOriginal.frame  = CGRect(
            x: xPos,
            y: _lblPrice.frame.maxY,
            width: viewWidth,
            height: PRICE_LABEL_HEIGHT)
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: _data.price_original)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        _lblPriceOriginal.attributedText = attributeString
        _lblPriceOriginal.textColor     = GlobalConst.BUTTON_COLOR_GRAY
        _lblPriceOriginal.font          = GlobalConst.BASE_SMALL_FONT
        _lblPriceOriginal.textAlignment = .center
        self.addSubview(_lblPriceOriginal)
        //-- BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
        self.makeComponentsColor()
    }
    
    public func select(isSelected: Bool) {
        var color = GlobalConst.BACKGROUND_COLOR_GRAY
        let thickness: CGFloat = 1.0
        if isSelected {
//            self.layer.borderColor = GlobalConst.MAIN_COLOR_GAS_24H.cgColor
//            self.layer.borderWidth = 2.0
            color = GlobalConst.MAIN_COLOR_GAS_24H
//            thickness = 2.0
        } else {
//            self.layer.borderColor = GlobalConst.TEXT_COLOR_GRAY.cgColor
//            self.layer.borderWidth = 1.0
        }
        _imageView.layer.addBorder(edge: .top, color: color, thickness: thickness)
        _imageView.layer.addBorder(edge: .left, color: color, thickness: thickness)
        _imageView.layer.addBorder(edge: .right, color: color, thickness: thickness)
        _lblName.layer.addBorder(edge: .left, color: color, thickness: thickness)
        _lblName.layer.addBorder(edge: .right, color: color, thickness: thickness)
        //++ BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
//        _lblPrice.layer.addBorder(edge: .bottom, color: color, thickness: thickness)
        _lblPrice.layer.addBorder(edge: .left, color: color, thickness: thickness)
        _lblPrice.layer.addBorder(edge: .right, color: color, thickness: thickness)
        _lblPriceOriginal.layer.addBorder(edge: .bottom, color: color, thickness: thickness)
        _lblPriceOriginal.layer.addBorder(edge: .left, color: color, thickness: thickness)
        _lblPriceOriginal.layer.addBorder(edge: .right, color: color, thickness: thickness)
        //-- BUG0200-SPJ (NguyenPT 20180604) Gas24h - Price original
    }
}
