//
//  CircularView.swift
//  Architect
//
//  Created by Storybook Developer Axandre Oge on 3/24/18.
//  Copyright © 2018 oge. All rights reserved.
//

import UIKit

class CircularView: UIView {


    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = rect.height/2
    }


}
