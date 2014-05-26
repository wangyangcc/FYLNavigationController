FYLNavigationController
=======================

this UINavigationController Subclass Make push and Pop actions with swipe gestures, Like [网易新闻](https://itunes.apple.com/cn/app/wang-yi-xin-wen/id425349261?mt=8) 
navigationController's Transitions

***

![icon](https://github.com/wangyangcc/FYLNavigationController/blob/master/FYLNavigationController.gif)

##Usage
***
* the `UIViewController` of property `isRemovePanGestureBlack` controls the left swipe gesture
, default is `NO`, set `YES` to remove the left swipe gesture
* the `UIViewController` of property `scrollNextVC` controls the right swipe gesture, default is `nil`, set a `UIViewController` will add the right swipe gesture
* use `FYLNavigationController` just like use `UINavigationController` 

##Notes
*** 
 Current version requires `ARC` and `iOS5`

## CocoaPods
***
 `FYLNavigationController` can be installed using [CocoaPods](CocoaPods).
 
 ```
 pod `FYLNavigationController`
 ```
License
-------

This project is licensed under the [wangyangcc](LICENSE).



