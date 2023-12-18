//
//  AudioCell.swift
//  AudioProject
//
//  Created by ahmed rajib on 18/12/23.
//

import UIKit

class AudioCell: UITableViewCell {

    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var playPauseIcon: UIImageView!
    @IBOutlet weak var downloadIcon: UIImageView!
    @IBOutlet weak var audioSubTitle: UILabel!
    @IBOutlet weak var audioTitle: UILabel!
    @IBOutlet weak var musciTypeIcon: UIImageView!
    @IBOutlet weak var playPauseBackGround: UIView!
    @IBOutlet weak var downloadBackGround: UIView!
    @IBOutlet weak var musicTypeBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        musicTypeBackground.layer.cornerRadius = 22
        playPauseBackGround.layer.cornerRadius = 22
        downloadBackGround.layer.cornerRadius = 22
        
        contentView.layer.cornerRadius = 8
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()

        mainBackgroundView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        
       
    }
    
}
