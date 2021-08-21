// SPDX-License-Identifier: MIT
// Copyright © 2018-2021 WireGuard LLC. All Rights Reserved.

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet private weak var _statusText: UILabel!
    @IBOutlet private weak var _layzText: UILabel!
    @IBOutlet private weak var _routeText: UILabel!

    @IBOutlet weak var _statusImage: UIImageView!
    @IBOutlet weak var _singalImage: UIImageView!

    public var itemModel: RouterItemModel? {
        didSet{
            guard let model = itemModel else { return }

            _routeText.text = model.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
