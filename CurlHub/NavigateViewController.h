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

@interface NavigateViewController : UIViewController
@property ACUser* currentUser;
@property WelcomeViewController *parentController;

@end

