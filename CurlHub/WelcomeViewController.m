//
//  WelcomeViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "WelcomeViewController.h"


@interface WelcomeViewController ()
@property ACUserViewModel *userModel;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"CurlHub";
    self.loginButton.alpha = 0.0f;
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.userModel = [[ACUserViewModel alloc] init];
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[UIColor lightBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor foregroundColor]}];
    [bar setTintColor:[UIColor foregroundColor]];
    
    
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
            [destVc setWelcome: self];
        }
    }
}

-(void)login
{
    [UIButton animateWithDuration:.2 animations:^{self.loginButton.alpha = 0.0f;}];
    [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"Logging..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSString* page = [ACHubDataManager pageWithVerificationUrl];
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
                        [navigateViewController setParent: self];
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:navigateViewController];
                        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
                        [self presentViewController:navigationController animated:YES completion:nil];
                        
                    });

                
                }];

            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"Please sign in" andColor:[UIColor alertColor] andIndicator:NO andFaded:YES];
                    [UIButton animateWithDuration:.2 animations:^{self.loginButton.alpha = 1.0f;}];
});
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBarDisplayer displayOnView:self.mainView withMessage:@"No internet" andColor:[UIColor alertColor] andIndicator:NO andFaded:YES];});
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self login];
            });
        
        }
        
    });

}


-(void) signOut
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[[ACUserViewModel alloc] init] logout];
    [self login];
}


@end
