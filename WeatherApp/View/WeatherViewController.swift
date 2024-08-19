//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Manpreet Kaur on 8/16/24.
//

import UIKit
import SwiftUI

class WeatherViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let weatherView = WeatherView()
        let hostingController = UIHostingController(rootView: weatherView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.frame = view.bounds
        hostingController.didMove(toParent: self)
    }
}
