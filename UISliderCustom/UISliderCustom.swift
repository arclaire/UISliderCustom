//
//  UISliderCustom.swift
//  UISliderCustom
//
//  Created by Lucy on 8/21/16.
//  Copyright © 2016 cy. All rights reserved.
//

import UIKit

let COLOR_OPTION_BG = UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
let COLOR_OPTION_TEXT = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
let COLOR_DUMMY = UIColor(red: 174.0/255.0, green: 94.0/255.0, blue: 24.0/255.0, alpha: 5.0)

let IOS_VERSION: CGFloat = CGFloat((UIDevice.currentDevice().systemVersion as NSString).floatValue)

protocol DelegateUISliderCustom: NSObjectProtocol {
  func valueDidChanged(value: Float)
}

class UISliderCustom: UISlider {

  lazy var vwTrackLeft: UIView = UIView()
  lazy var vwTrackRight: UIView = UIView()
  
  lazy var vwMaskLeft: UIView = UIView()
  lazy var vwMaskRight: UIView = UIView()
  lazy var vwDummy: UIView = UIView()
  lazy var layerMaskRight: CALayer = CALayer()
  lazy var layerMaskLeft: CALayer = CALayer()
  
  var colorUnfilled: UIColor = UIColor.grayColor()
  var colorStatic: UIColor = UIColor.clearColor()
  
  weak var delUISlidercustom: DelegateUISliderCustom?
  var lblIndicator: UILabel = UILabel()
  
  var floatHeight:CGFloat = 4.0
  var floatDefaultValue: Float = 0
  
  private let floatGap:CGFloat = 2.0
  private var rectThumb: CGRect = CGRectMake(0, 0, 50, 50)
  
  override var value: Float {
    didSet {
      self.sliderValueChange()
      self.hideLabelIndicator()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.vwTrackLeft.backgroundColor = COLOR_OPTION_TEXT
    self.vwTrackRight.backgroundColor = COLOR_OPTION_TEXT
    
    self.vwMaskRight.backgroundColor = UIColor.redColor() //colorUnfilled
    self.vwMaskLeft.backgroundColor = UIColor.blueColor() //colorUnfilled
    //self.vwDummy.backgroundColor = COLOR_DUMMY
    self.layerMaskLeft.backgroundColor = UIColor.blackColor().CGColor
    self.layerMaskRight.backgroundColor = UIColor.blackColor().CGColor
    
    self.thumbTintColor = COLOR_OPTION_TEXT
    if IOS_VERSION < 9 {
       self.setThumbImage(getImageWithColor(COLOR_OPTION_TEXT, size: CGSizeMake(20, 20)), forState: UIControlState.Normal)
    }
   
    self.addSubview(self.vwTrackLeft)
    self.addSubview(self.vwTrackRight)
    self.addSubview(self.vwMaskLeft)
    self.addSubview(self.vwMaskRight)
    self.addSubview(self.vwDummy)
    self.setMinimumTrackImage(UIImage(), forState: UIControlState.Normal)
    self.setMaximumTrackImage(UIImage(), forState: UIControlState.Normal)
    self.continuous = true
    
    self.tintColor = self.colorStatic
    
    self.addTarget(self, action: #selector(self.sliderValueChange), forControlEvents: UIControlEvents.ValueChanged)
    self.addTarget(self, action: #selector(self.hideLabelIndicator), forControlEvents: UIControlEvents.TouchUpInside)
    self.lblIndicator.textColor = UIColor.blackColor()
    self.lblIndicator.font = UIFont.systemFontOfSize(11)
    self.lblIndicator.hidden = true
    self.lblIndicator.textAlignment = NSTextAlignment.Center
    
    self.addSubview(self.lblIndicator)
    
    self.minimumValue = -0.5
    self.maximumValue = 0.5
    self.value = 0
    self.floatDefaultValue = 0
    
    
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    var rect: CGRect = CGRect(x: self.floatGap, y: self.frame.size.height/2 - 1, width: self.frame.size.width/2, height: self.floatHeight)
    self.vwTrackLeft.frame = rect
    
    rect.origin.x = self.vwTrackLeft.frame.origin.x + self.vwTrackLeft.frame.size.width - self.floatGap - 2
    rect.size.width = self.vwTrackLeft.frame.size.width - self.floatGap
    self.vwTrackRight.frame = rect
    
    self.vwMaskLeft.frame = self.vwTrackLeft.frame
    self.vwMaskRight.frame = self.vwTrackRight.frame
    
    //debugPrint("layout subviews")
    
  }
  
  func hideLabelIndicator() {
    
    if self.value > (self.floatDefaultValue - 0.05) && self.value < (self.floatDefaultValue + 0.05) && self.value != floatDefaultValue {
      self.value = self.floatDefaultValue
    }
   
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
  
  override func setValue(value: Float, animated: Bool) {
    
    super.setValue(value, animated: animated)
  }
  
  func sliderValueChange() {
    
    self.rectThumb = self.thumbRectForBounds(self.bounds, trackRect: self.frame, value: self.value)
    
    //self.vwDummy.frame = rectThumb
    
    self.lblIndicator.hidden = false
    var point: CGPoint = self.lblIndicator.center
    point.x = self.rectThumb.origin.x 
    
    self.lblIndicator.center = point
    
    let floatx: CGFloat = self.rectThumb.origin.x - self.frame.origin.x + floatGap
    debugPrint(floatx)
  
    if floatx > self.vwTrackLeft.frame.size.width {
      var rect: CGRect = self.layerMaskLeft.frame
      rect.size.width = self.vwTrackLeft.frame.size.width
      self.layerMaskLeft.frame = rect
      
      rect = self.layerMaskRight.frame
      rect.origin.x = floatx - self.vwMaskRight.frame.size.width
      self.layerMaskRight.frame = rect
      
      //debugPrint("MASK LEFT", self.layerMaskLeft.frame)
      //debugPrint("MASK RIGHT", self.layerMaskRight.frame)
  
    } else {
      
      var rect: CGRect = self.layerMaskRight.frame
      rect.origin.x = 0
      self.layerMaskRight.frame = rect
      
      rect = self.layerMaskLeft.frame
      rect.size.width = floatx
      self.layerMaskLeft.frame = rect
      
       //debugPrint("MASK LEFT", self.layerMaskLeft.frame)
       //debugPrint("MASK RIGHT", self.layerMaskRight.frame)
    }
    
    self.delUISlidercustom?.valueDidChanged(self.value)
    
    self.lblIndicator.text = String(format:"%d",Int(self.value))
  }
  
  func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
   
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width , size.height), false, 0)
    let ctx = UIGraphicsGetCurrentContext()
    CGContextSaveGState(ctx)
    
    let rect = CGRectMake(0, 0, size.width, size.height)
    CGContextSetFillColorWithColor(ctx, color.CGColor)
    CGContextFillEllipseInRect(ctx, rect)
    
    CGContextRestoreGState(ctx)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return img
  }

  //
  
  /* for custom its height
 override func trackRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectMake(0, 0, 100, 10)
 }
 */
}
