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
#import "ACColorManager.h"

@interface WelcomeViewController ()
@property ACUserViewModel *userModel;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton.alpha = 0.0f;
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.userModel = [[ACUserViewModel alloc] init];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[ACColorManager lightBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [ACColorManager foregroundColor]}];
    [bar setTintColor:[ACColorManager foregroundColor]];
    
    
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
    [UIButton animateWithDuration:.2 animations:^{self.loginButton.alpha = 0.0f;}];
    [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"Logging..." andColor:[ACColorManager messageColor] andIndicator:YES andFaded:NO];
    
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
            else{
                dispatch_async(dispatch_get_main_queue(), ^{[UIButton animateWithDuration:.2 animations:^{self.loginButton.alpha = 1.0f;}];
});
            }
        }
        else
        {dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"No internet" andColor:[ACColorManager alertColor] andIndicator:NO andFaded:YES];
        });
        }
        
    });

}

@end
