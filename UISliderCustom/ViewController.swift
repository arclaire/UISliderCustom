//
//  ViewController.swift
//  UISliderCustom
//
//  Created by Lucy on 8/21/16.
//  Copyright © 2016 cy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var slider: UISliderCustom!
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
   
  }
  
  override func viewDidAppear(animated: Bool) {
    self.slider.prepareMask()
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  
}

