# Infinite-Swiping
only applicable for tvOS


Guide


Step A: 

Add InfinityScrollView.swift and kInfinityScrollView.xib file in your project.

Step B: 

Implement the protocol InfinityScrollingViewDelegate and two of its method in the viewController 

(1- func updating(_ view: InfinityScrollView, for imageType: CarouselImageType), 2- func didClickOnMiddleView(_ ofIndex: Int))

Step 3:

Initiating the View:

In your view controller, make a normal container UiView infinityScrollingViewContainer  = UiView() , where you will perform infinity scrolling and create its outlet(if done by storyboard).
  
Step 4: 

In viewDidAppear (or any) initiate a view from the method using 

viewForInfinityScrolling= Bundle.main.loadNibNamed("kInfinityScrollView", owner: self, options: nil).first as! InfinityScrollView

Step 5:

Give the count of the array, which to be looped infinitely, 

viewForInfinityScrolling.countOfTheDataSource = array.count

Step 6:

Make its delegate to the self

Step 7:

You can autoRotate it by changing in (canAutoRotate property) (optional)

Step 8:

Give the frame size of the view (needed)

viewForInfinityScrolling.frame.size = infinityScrollingViewContainer.frame.size

You can give timing for autoRotateTimeInterval = 5.0 (optional)

You can give separation between the views by the property separationBetweenTheViews = 50 (optional)

You can give the size of the one displaying view by fraction of the main container view,
sizeOfTheView = (1600/1920) (optional)

Can give animation duration of the swipe by durationOfAnimation = 10 (optional)

Can give alpha of the views, alphaOfTheViews  = 1.0 (optional)

Step 9:

viewForInfinityScrolling.loadViews() – For Loading the views with property

Step 10:

Add viewForInfinityScrolling view to the infinityScrollingViewContainer 

step 11:

Updating the views with delegate methods:

Step 11.1:

Updating the delegate call for updating the views on each swipe, 
Functionality same as UiButton

func updating(_ view: InfinityScrollView, for imageType: CarouselImageType),

Here update the view.clickableMiddleView. setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)

view.clickableLeftView. setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)

view.clickableRightView. setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)

view.clickableExtraLeftView. setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)

view.clickableExtraRightView. setBackgroundImage(carouselArray[forImageType.middle!], for: .normal)

Step 11.2:

Delegate method for clicking on the middle View, arrays index number will be provided in that method 

func didClickOnMiddleView(_ ofIndex: Int))
