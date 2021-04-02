//
//  MyTextLabel.swift
//  Runner
//
//  Created by rohan morris on 5/30/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

public class MyTextLabel: UILabel
{
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        numberOfLines = 0
        //backgroundColor = UIColor.blue
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 16)
        textAlignment = NSTextAlignment.center
    }
}
