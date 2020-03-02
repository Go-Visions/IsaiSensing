//
//  BluetoothDeviceTableViewCell.swift
//  IsaiSensing
//
//  Created by nishi kosei on 2020/01/21.
//  Copyright © 2020 nishi kosei. All rights reserved.
//

import UIKit

class BluetoothDeviceTableViewCell: UITableViewCell {
    @IBOutlet weak var deviceIdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDeviceLabel(deviceId: String){
        self.deviceIdLabel.text = deviceId
    }
    
}
