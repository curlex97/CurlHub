//
//  LoginViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "LoginViewController.h"
#import "ACHubDataManager.h"

@interface LoginViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[ACHubDataManager verificationUrl]]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *path = [request.URL absoluteString];
    if([path containsString:[ACHubDataManager callbackUrl]])
    {
        [self.welcomeController login];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}

@end
