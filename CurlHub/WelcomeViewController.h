//
//  WelcomeViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "ACUserViewModel.h"
#import "ACHubDataManager.h"
#import "NavigateViewController.h"
#import "ACProgressBarDisplayer.h"
#import "UIColor+ACAppColors.h"

@interface WelcomeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

-(void) login;
-(void) signOut;

@end
