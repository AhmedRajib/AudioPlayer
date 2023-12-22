//
//  UIViewExtensions.swift
//  AudioProject
//
//  Created by Ahmed Rajib on 21/12/23.
//

import UIKit

extension UIView {

  func dropShadow() {
      layer.masksToBounds = true
      layer.shadowColor = UIColor.black.cgColor
      layer.shadowOpacity = 0.5
      layer.shadowOffset = CGSize(width: -1, height: 1)
      layer.shadowRadius = 1
      layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
      layer.shouldRasterize = true
      layer.rasterizationScale = UIScreen.main.scale
  }
}
