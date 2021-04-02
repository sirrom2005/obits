//
//  MyButton.swift
//  Runner
//
//  Created by rohan morris on 5/30/20.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

public class MyButton: UIButton
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        
    }
}
