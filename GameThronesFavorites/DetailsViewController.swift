//
//  DetailsViewController.swift
//  GameThronesFavorites
//
//  Created by Yinhuan Yuan on 5/16/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import Cartography

class DetailsViewController: UIViewController {

    let charaterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "happyApple")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.blue
        return imageView
    }()
    
    let nameLbl: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 5
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    var character: Character?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(nameLbl)
        view.addSubview(charaterImageView)
        layout()
        setup()
      
    }
    
    func setup() {
        guard let character = character else {
            print("there is no value")
            return
        }
        if let url: URL = URL(string:  character.imageThumbURL) {
            if let imageData = NSData.init(contentsOf: url) {
                charaterImageView.image = UIImage(data: imageData as Data)
            }
        }
        nameLbl.text = character.name
    }
}

extension DetailsViewController {
    func layout() {
        constrain(charaterImageView) {
            $0.centerX == $0.superview!.centerX
            $0.top == $0.superview!.top + 120
            $0.width == 150
            $0.height == 150
        }
        constrain(nameLbl, charaterImageView) {
            $0.left == $1.left
            $0.right == $1.right
            $0.top == $1.bottom + 50
            $0.height == 30
        }
    }
}
