//
//  PaymentDetailTableViewCell.swift
//  PaymentPlanner
//
//  Created by ali on 10.03.2022.
//
import UIKit

class PaymentDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var priceTypeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
