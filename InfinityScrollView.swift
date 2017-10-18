//
//  InfinityScrollView.swift
//  InfinityScrollDemoTvOS
//
//  Created by Manas Mishra on 20/09/17.
//  Copyright © 2017 Manas Mishra. All rights reserved
//

import UIKit

//Carousel imagetype
struct CarouselImageType {
    var extraLeft: Int?
    var left: Int?
    var middle: Int?
    var right: Int?
    var extraRight: Int?
    
}


protocol InfinityScrollingViewDelegate : class
{
    func updating(_ view: InfinityScrollView, for imageType: CarouselImageType)
    func didClickOnMiddleView(_ ofIndex: Int)
}


class InfinityScrollView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet weak var widthConstraintOfMiddleView: NSLayoutConstraint!
    @IBOutlet weak var clickableExtraLeftView: CarouselView!
    @IBOutlet weak var clickableExtraRightView: CarouselView!
    @IBOutlet weak var clickableLeftView: CarouselView!
    @IBOutlet weak var clickableRightView: CarouselView!
    @IBOutlet weak var clickableMiddleView: CarouselView!
    var currentMiddle = 1
    var isNewImageLoaded = true
    var myPreferredFocuseView: UIView? = nil
    weak var delegate : InfinityScrollingViewDelegate?
    
    //Size of the views and distance in between them
    var sizeOfTheView: Float = (1600/1920) // sizeoftheview/containerview
    var separationBetweenTheViews: Float = 50 // separation in Float
    
    //Autorotate feature
    var canAutoRotate = false
    var autoRotateTimeInterval = 5 //Time in seconds in Int
    
    //Duration of the animation
    var durationOfAnimation = 0.7 // Minmium 0.5
    
    //Alpha of the views
    var alphaOfTheViews = 1.0
    
    //DataSource Count
    var countOfTheDataSource: Int? = nil //Count must be grater than or equal to 3
    
    
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var extraLeftView: UIView!
    @IBOutlet weak var extraRightView: UIView!
    @IBOutlet weak var leftView: UIView!
    override func awakeFromNib() {
        if countOfTheDataSource == nil || countOfTheDataSource! < 3 {
            return
        }
    }
    
    func loadViews() {
        if canAutoRotate{
            _ = Timer.scheduledTimer(timeInterval:TimeInterval(autoRotateTimeInterval), target: self, selector: #selector(InfinityScrollView.autoRotate), userInfo: nil, repeats: true)
        }
        
        //Setting the frames of the views
        widthConstraintOfMiddleView.constant = self.frame.size.width * CGFloat(sizeOfTheView)
        extraLeftView.frame.origin.x = leftView.frame.origin.x - CGFloat(separationBetweenTheViews) - middleView.frame.size.width
        extraRightView.frame.origin.x = rightView.frame.origin.x + middleView.frame.size.width + CGFloat(separationBetweenTheViews)

        //Setting Alpha of buttons
        self.clickableMiddleView.alpha = CGFloat(alphaOfTheViews)
        self.clickableLeftView.alpha = CGFloat(alphaOfTheViews)
        self.clickableRightView.alpha = CGFloat(alphaOfTheViews)
        self.clickableExtraLeftView.alpha = CGFloat(alphaOfTheViews)
        self.clickableExtraRightView.alpha = CGFloat(alphaOfTheViews)
        
        
        clickableExtraLeftView.isUserInteractionEnabled = false
        clickableLeftView.isUserInteractionEnabled = false
        clickableMiddleView.isUserInteractionEnabled = true
        clickableRightView.isUserInteractionEnabled = false
        clickableExtraRightView.isUserInteractionEnabled = false

        let newImage = nextImage(currentMiddle: 0)
        //Sending message to the delegate for updating the views
        currentMiddle = newImage.middle!
        self.delegate?.updating(self, for: newImage)
        
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment]
    {
        return [myPreferredFocuseView!]
    }
    
    func autoRotate()
    {
        let leftSwipe = UISwipeGestureRecognizer()
        leftSwipe.direction = .left
        horizontallySwipped(leftSwipe)
    }
    
    @IBAction func horizontallySwipped(_ sender: UISwipeGestureRecognizer) {
        if isNewImageLoaded == false{
            return
        }
        self.isNewImageLoaded = false
        let extraLeftFrame = self.extraLeftView.frame
        let leftFrame = self.leftView.frame
        let middelFrame = self.middleView.frame
        let rightFrame = self.rightView.frame
        let extraRightFrame = self.extraRightView.frame
        
        //Towards right-end from left-end
        if sender.direction == .right{
            UIView.animateKeyframes(withDuration: durationOfAnimation, delay: 0.0, options: .calculationModePaced, animations: {
                self.middleView.frame = rightFrame
                self.leftView.frame = middelFrame
                self.extraLeftView.frame = leftFrame
                self.rightView.frame = extraRightFrame
                
            }, completion: { (finished: Bool) -> Void in
                let previousImage = self.previousImage(currentMiddle: self.currentMiddle)
                self.currentMiddle = previousImage.middle!
                
                //Sending message to the delegate for updating the views
                self.delegate?.updating(self, for: previousImage)
                self.leftView.frame = leftFrame
                self.extraLeftView.frame = extraLeftFrame
                self.rightView.frame = rightFrame
                self.middleView.frame = middelFrame
                self.myPreferredFocuseView = self.clickableMiddleView
                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
                self.isNewImageLoaded = true
            })
            
        }
         //Towards left-end from right-end
        else if sender.direction == .left {
            UIView.animateKeyframes(withDuration: durationOfAnimation, delay: 0.0, options: .calculationModeLinear, animations: {
                self.middleView.frame = leftFrame
                self.rightView.frame = middelFrame
                self.extraRightView.frame = rightFrame
                self.leftView.frame = extraLeftFrame
                
            }, completion: { (finished: Bool) -> Void in
                let nextImage = self.nextImage(currentMiddle: self.currentMiddle)
                self.currentMiddle = nextImage.middle!
                
                //Sending message to the delegate for updating the views
                self.delegate?.updating(self, for: nextImage)
                
                //CallToChangeTheFocusOfTheButton
                self.leftView.frame = leftFrame
                self.rightView.frame = rightFrame
                self.middleView.frame = middelFrame
                self.extraRightView.frame = extraRightFrame
                
                self.myPreferredFocuseView = self.clickableMiddleView
                self.setNeedsFocusUpdate()
                self.updateFocusIfNeeded()
                self.isNewImageLoaded = true
            })
            
        }
    }
    
    //Sending message to delegate on click on the middle view
    @IBAction func didClickOnMiddleButton(_ sender: Any) {
        self.delegate?.didClickOnMiddleView(currentMiddle)
    }
    
    //Next Images for swipping towards left-end from right-end
    //Current is the index number from carousel array for the middle button
    func nextImage(currentMiddle: Int) -> CarouselImageType {
        var nextImageType = CarouselImageType()
        let countAccordingToArrayIndex =  countOfTheDataSource! - 1
        nextImageType.left = currentMiddle
        if nextImageType.left! - 1 > -1 {
            nextImageType.extraLeft = nextImageType.left! - 1
        }else{
            nextImageType.extraLeft = countAccordingToArrayIndex
        }
        
        if nextImageType.left! + 1 < (countAccordingToArrayIndex + 1){
            nextImageType.middle = nextImageType.left! + 1
        }else{
            nextImageType.middle = 0
        }
        if nextImageType.middle! + 1 < (countAccordingToArrayIndex + 1){
            nextImageType.right = nextImageType.middle! + 1
        }else{
            nextImageType.right = 0
        }
        if nextImageType.right! + 1 < (countAccordingToArrayIndex + 1){
            nextImageType.extraRight = nextImageType.right! + 1
        }else{
            nextImageType.extraRight = 0
        }
        return nextImageType
    }
    
    
    //Previous Image for swipping towards right-end from left-end
    func previousImage(currentMiddle: Int) -> CarouselImageType {
        var nextImageType = CarouselImageType()
        let countAccordingToArrayIndex =  countOfTheDataSource! - 1
        nextImageType.right = currentMiddle
        if nextImageType.right! + 1 < (countAccordingToArrayIndex + 1){
            nextImageType.extraRight = nextImageType.right! + 1
        }else{
            nextImageType.extraRight = 0
        }
        if nextImageType.right! - 1 > -1{
            nextImageType.middle = nextImageType.right! - 1
        }else{
            nextImageType.middle = countAccordingToArrayIndex
        }
        if nextImageType.middle! - 1 > -1{
            nextImageType.left = nextImageType.middle! - 1
        }else{
            nextImageType.left = countAccordingToArrayIndex
        }
        if nextImageType.left! - 1 > -1{
            nextImageType.extraLeft = nextImageType.left! - 1
        }else{
            nextImageType.extraLeft = countAccordingToArrayIndex
        }
        return nextImageType
    }

    
}

//Clickable CarouselView Button
class CarouselView: UIButton {
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)
    {
        if (context.nextFocusedView == self)
        {
            self.alpha = 1.0
            self.transform = CGAffineTransform.init(scaleX: 1.03, y: 1.05)
        }
        else
        {
            self.alpha = 1.0
            self.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }
        
    }
    
}















