//
//  PaymentListTableViewCell.swift
//  PaymentPlanner2
//
//  Created by ali on 17.03.2022.
//

import UIKit

class PaymentListTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!

    var isSaved: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton ) {
        if isSaved {
            isSaved = false
            favButton.setImage(UIImage(named: "1.png"), for: .normal)
        } else {
            isSaved = true
            favButton.setImage(UIImage(named: "2.png"), for: .normal)
        }
    }
}
