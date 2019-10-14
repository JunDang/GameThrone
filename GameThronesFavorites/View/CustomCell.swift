//
//  CustomCell.swift
//  GameThronesFavorites
//
//  Created by Yinhuan Yuan on 5/16/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class CustomCell: UITableViewCell {
    
    let charaterImageView: UIImageView = {
        let imageView = UIImageView()
        //imageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        imageView.image = UIImage(named: "happyApple")
        //imageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    
    var didSetupConstraints = false
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let starButton = UIButton(type: .system)
        starButton.setImage(UIImage(named: "star"), for: .normal)
        starButton.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        starButton.tintColor = .blue
        starButton.addTarget(self, action: #selector(handleMark), for: .touchUpInside)
        accessoryView = starButton
        setup()
        layoutView()
    }
    
    let nameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 15)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let houseNameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 12)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
    func setup() {
        addSubview(charaterImageView)
        addSubview(nameLbl)
        addSubview(houseNameLbl)
    }
    
    func layoutView() {
        constrain(charaterImageView) {
            $0.left == $0.superview!.left + 5
            $0.top == $0.superview!.top + 2
            $0.bottom == $0.superview!.bottom - 2
            $0.width == 80
            $0.height == 80
        }
        constrain(nameLbl, charaterImageView) {
            $0.left == $1.right + 2
            $0.top == $1.top
            $0.right == $0.superview!.right - 100
        }
        constrain(houseNameLbl, nameLbl) {
            $0.left == $1.left
            $0.right == $1.right
            $0.top == $1.bottom
            $0.bottom == $0.superview!.bottom - 2
        }
        
        
        
    }
    
    weak var delegate: HandleButtonDelegate?
    
    @objc private func handleMark() {
        delegate?.handleMark(cell: self as UITableViewCell)
    }
    
    func configureCell(_ character: Character) {
        self.nameLbl.text = character.name
        self.houseNameLbl.text = character.houseName
        
        if let url: URL = URL(string: character.imageThumbURL) {
                if let imageData = NSData.init(contentsOf: url) {
                    self.charaterImageView.image = UIImage(data: imageData as Data)
                }
            }
        self.accessoryView?.tintColor = character.hasFavorited ? .blue : .lightGray
    }
}
