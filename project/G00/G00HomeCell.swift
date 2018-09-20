//
//  HomeTableViewCell.swift
//  project
//
//  Created by Lâm Phạm on 10/26/16.
//  Copyright © 2016 admin. All rights reserved.
//

import UIKit

class G00HomeCell: UITableViewCell {
    /** Image view */
    @IBOutlet weak var homeCellImageView: UIImageView!
    /** Title of cell */
    @IBOutlet weak var titleLbl: UILabel!

    /**
     * Awake from nib
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    /**
     * Handle when select cell
     */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
