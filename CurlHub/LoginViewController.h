//
//  LoginViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACHubDataManager.h"
#import "WelcomeViewController.h"

@interface LoginViewController : UIViewController

// сюда прислать WelcomeViewController
-(void) setWelcome:(id)welcomeController;

@end
