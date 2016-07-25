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

@interface WelcomeViewController ()
@property ACUserViewModel *userModel;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSString* page = [NSString stringWithContentsOfURL:[NSURL URLWithString:[ACHubDataManager verificationUrl]] encoding:NSUTF8StringEncoding error:nil];
        page = [page substringToIndex:[page rangeOfString:@"<"].location];
        
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
        
        
    });
}

@end
