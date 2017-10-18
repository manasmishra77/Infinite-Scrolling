//
//  InfinityScrollingVC.swift
//  InfinityScrollDemoTvOS
//
//  Created by Manas Mishra on 02/10/17.
//  Copyright © 2017 Manas Mishra. All rights reserved.
//

import UIKit

class InfinityScrollingVC: UIViewController, InfinityScrollingViewDelegate {

    @IBOutlet weak var infinityScrollingViewContainer: UIView!
    
    var carouselArray: [UIImage] = [UIImage(named: "T1")!, UIImage(named: "T2")!, UIImage(named: "T3")!, UIImage(named: "T4")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        let viewForInfinityScrollings = Bundle.main.loadNibNamed("kInfinityScrollView", owner: self, options: nil)
        let viewForInfinityScrolling = viewForInfinityScrollings?.first as! InfinityScrollView
        viewForInfinityScrolling.countOfTheDataSource = carouselArray.count
        viewForInfinityScrolling.delegate = self
        viewForInfinityScrolling.canAutoRotate = true
        viewForInfinityScrolling.frame.size = infinityScrollingViewContainer.frame.size
        viewForInfinityScrolling.loadViews()
        infinityScrollingViewContainer.addSubview(viewForInfinityScrolling)
    }
    
    //Delegate method of Infinity Scrolling
    func updating(_ view: InfinityScrollView, for forImageType: CarouselImageType) {
        
        //Same functionality as UiButton background image
        view.clickableMiddleView.setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)
        view.clickableLeftView.setBackgroundImage(carouselArray[forImageType.left!], for: .normal)
        view.clickableRightView.setBackgroundImage(carouselArray[forImageType.right!], for: .normal)
        view.clickableExtraLeftView.setBackgroundImage(carouselArray[forImageType.extraLeft!], for: .normal)
        view.clickableExtraRightView.setBackgroundImage(carouselArray[forImageType.extraRight!], for: .normal)
    }
    //Delegate method for Click on middle view
    func didClickOnMiddleView(_ ofIndex: Int) {
        print(ofIndex)
    }
    


}
