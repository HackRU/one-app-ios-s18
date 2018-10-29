//
//  EventsTableViewCell.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/18/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    @IBOutlet weak var txtInfo: UITextView!

    @IBOutlet weak var txtTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
