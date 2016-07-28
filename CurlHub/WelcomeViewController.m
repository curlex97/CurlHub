//
//  WelcomeViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "ACUserViewModel.h"
#import "ACHubDataManager.h"
#import "NavigateViewController.h"
#import "ACProgressBarDisplayer.h"

@interface WelcomeViewController ()
@property ACUserViewModel *userModel;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.userModel = [[ACUserViewModel alloc] init];
    [self login];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual: @"toLogin"])
    {
        if([segue.destinationViewController isKindOfClass:[LoginViewController class]])
        {
            LoginViewController *destVc = (LoginViewController*) segue.destinationViewController;
            destVc.welcomeController = self;
        }
    }
}

-(void)login
{
    [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"Logging..." andColor:[UIColor blueColor] andIndicator:YES andFaded:NO];
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:[ACHubDataManager verificationUrl]] encoding:NSUTF8StringEncoding  error:nil];
        if(page)
        {
            page = [page substringToIndex:[page rangeOfString:@"<"].location];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.mainView];
            });
            if(page.length > 10)
            {
                [self.userModel loginWithCode:page completion:^(ACUser* user){
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                    NavigateViewController *navigateViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigateViewController"];
                        navigateViewController.currentUser = user;
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:navigateViewController];
                        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                        [self presentViewController:navigationController animated:YES completion:nil];
                        
                    });

                
                }];

            }
        }
        else
        {dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"No internet" andColor:[UIColor redColor] andIndicator:NO andFaded:YES];
        });
        }
        
    });

}

@end
