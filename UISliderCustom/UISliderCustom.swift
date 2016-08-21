//
//  UISliderCustom.swift
//  UISliderCustom
//
//  Created by Lucy on 8/21/16.
//  Copyright © 2016 cy. All rights reserved.
//

import UIKit

class UISliderCustom: UISlider {

  lazy var vwTrackLeft: UIView = UIView()
  lazy var vwTrackRight: UIView = UIView()
  
  lazy var vwMaskLeft: UIView = UIView()
  lazy var vwMaskRight: UIView = UIView()
  lazy var layerMaskRight: CALayer = CALayer()
  lazy var layerMaskLeft: CALayer = CALayer()
  
  var colorUnfilled: UIColor = UIColor.grayColor()
  var colorStatic: UIColor = UIColor.clearColor()
  
  var lblIndicator: UILabel = UILabel()
  
  var floatHeight:CGFloat = 4.0
  
  private let floatGap:CGFloat = 2.0
  private var rectThumb: CGRect = CGRectMake(0, 0, 50, 50)
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.vwTrackLeft.backgroundColor = UIColor.redColor()
    self.vwTrackRight.backgroundColor = UIColor.blueColor()
    
    self.vwMaskRight.backgroundColor = colorUnfilled
    self.vwMaskLeft.backgroundColor = colorUnfilled
    self.layerMaskLeft.backgroundColor = UIColor.blackColor().CGColor
    self.layerMaskRight.backgroundColor = UIColor.blackColor().CGColor

    self.addSubview(self.vwTrackLeft)
    self.addSubview(self.vwTrackRight)
    self.addSubview(self.vwMaskLeft)
    self.addSubview(self.vwMaskRight)
    
    self.setMinimumTrackImage(UIImage(), forState: UIControlState.Normal)
    self.setMaximumTrackImage(UIImage(), forState: UIControlState.Normal)
    self.continuous = true
    
    self.tintColor = self.colorStatic
    
    self.addTarget(self, action: #selector(self.sliderValueChange), forControlEvents: UIControlEvents.ValueChanged)
    self.addTarget(self, action: #selector(self.hideLabelIndicator), forControlEvents: UIControlEvents.TouchUpInside)
    self.lblIndicator.textColor = UIColor.blackColor()
    self.lblIndicator.font = UIFont.systemFontOfSize(11)
    self.lblIndicator.hidden = true
    
    self.addSubview(self.lblIndicator)
    
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    var rect: CGRect = CGRect(x: self.floatGap, y: self.frame.size.height/2 - 1, width: self.frame.size.width/2, height: self.floatHeight)
    self.vwTrackLeft.frame = rect
    
    rect.origin.x = self.vwTrackLeft.frame.origin.x + self.vwTrackLeft.frame.size.width - self.floatGap
    rect.size.width = self.vwTrackLeft.frame.size.width - self.floatGap
    self.vwTrackRight.frame = rect
    
    self.vwMaskLeft.frame = self.vwTrackLeft.frame
    self.vwMaskRight.frame = self.vwTrackRight.frame
    
    
    //debugPrint("layout subviews")
  }
  
  func hideLabelIndicator() {
    
    self.lblIndicator.hidden = true
  }
  
  func prepareMask() {
    
    self.layerMaskLeft.frame = CGRectMake(0, 0, self.vwTrackLeft.frame.size.width, self.vwTrackLeft.frame.size.height)
    self.layerMaskRight.frame = CGRectMake(0, 0, self.vwTrackLeft.frame.size.width, self.vwTrackLeft.frame.size.height)
    
    self.vwMaskLeft.layer.mask = self.layerMaskLeft
    self.vwMaskRight.layer.mask = self.layerMaskRight
    
    var rect: CGRect = CGRectZero
    rect.origin.y = self.vwTrackLeft.frame.origin.y - 35
    rect.size.height = 14
    rect.size.width = 100
    self.lblIndicator.frame = rect
    
  }
  func sliderValueChange() {
    
    self.rectThumb = self.thumbRectForBounds(self.bounds, trackRect: self.frame, value: self.value)
    self.lblIndicator.text = String(format: "%d", Int(self.value))
    
    self.lblIndicator.hidden = false
    var point: CGPoint = self.lblIndicator.center
    point.x = self.rectThumb.origin.x + self.rectThumb.size.width
    
    self.lblIndicator.center = point
    
    let floatx: CGFloat = self.rectThumb.origin.x - self.frame.origin.x + floatGap
  
    if floatx > self.vwTrackLeft.frame.size.width {
      var rect: CGRect = self.layerMaskLeft.frame
      rect.size.width = self.vwTrackLeft.frame.size.width
      self.layerMaskLeft.frame = rect
      
      rect = self.layerMaskRight.frame
      rect.origin.x = floatx - self.vwMaskRight.frame.size.width
      self.layerMaskRight.frame = rect
  
    } else {
      
      var rect: CGRect = self.layerMaskRight.frame
      rect.origin.x = 0
      self.layerMaskRight.frame = rect
      
      rect = self.layerMaskLeft.frame
      rect.size.width = floatx
      self.layerMaskLeft.frame = rect
    }
  }
  //
  
  /* for custom its height
 override func trackRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectMake(0, 0, 100, 10)
 }
 */
}
