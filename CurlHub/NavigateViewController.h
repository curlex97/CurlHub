//
//  ViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 24.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "WelcomeViewController.h"
#import "MenuView.h"
#import "EventsViewController.h"
#import "ReposViewController.h"
#import "SearchViewController.h"
#import "DetailUserViewController.h"
#import "IssuesViewController.h"
#import "UIImage+ACImageResizing.h"
#import "UIColor+ACAppColors.h"


@interface NavigateViewController : UIViewController
@property ACUser* currentUser;

// сюда прислать WelcomeViewController
-(void) setParent:(id)parentController;
@end

