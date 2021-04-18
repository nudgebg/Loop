//
//  ChartTableViewCell.swift
//  Naterade
//
//  Created by Nathan Racklyeft on 2/19/16.
//  Copyright © 2016 Nathan Racklyeft. All rights reserved.
//

import UIKit
import LoopUI


final class ChartTableViewCell: UITableViewCell {

    @IBOutlet weak var chartContentView: ChartContainerView!

    @IBOutlet weak var titleLabel: UILabel?

    @IBOutlet weak var subtitleLabel: UILabel?

    var overlayView: UIView?
    
    var showOverlay:Bool = false {
        didSet {
            overlayView?.isHidden = !showOverlay
        }
    }
    
    override func awakeFromNib() {
        addOverlay()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        chartContentView.chartGenerator = nil
    }

    func reloadChart() {
        chartContentView.reloadChart()
    }
    
    func addOverlay() {
        print(contentView.frame)
        overlayView = UIView(frame: contentView.frame)
        overlayView!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        overlayView?.isHidden = !showOverlay
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: contentView.frame.width, height: 130.0))
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = UIColor(white: 0.5, alpha: 1.0)
        label.text = "Not Applicable\nWhen Nuding"
        overlayView?.addSubview(label)
        contentView.addSubview(overlayView!)
    }
}
