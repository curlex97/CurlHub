//
//  progressBarDisplayer.m
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ACProgressBarDisplayer.h"

@implementation ACProgressBarDisplayer


-(void)displayOnView:(UIView *)view withMessage:(NSString *)message andColor:(UIColor*)color andIndicator:(BOOL)indicator andFaded:(BOOL)faded
{
    [self removeFromView:view];
    
    

    
    UIView *messageFrame = [[UIView alloc] initWithFrame:CGRectMake(0, -50, view.frame.size.width, 50)];
    messageFrame.backgroundColor = color;
    messageFrame.alpha = .7;
    messageFrame.tag = 4400;
    
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 50)];
    strLabel.text = message;
    strLabel.textColor = [UIColor whiteColor];
    strLabel.textAlignment = NSTextAlignmentCenter;
    [messageFrame addSubview:strLabel];

    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - 47, 3, 44, 44)];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [messageFrame addSubview:button];
    
    
    
    if(indicator)
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [activityIndicator startAnimating];
        [messageFrame addSubview:activityIndicator];
    }
    
    [view addSubview:messageFrame];
    
    [UIView animateWithDuration:0.2 animations:^{
        messageFrame.frame = CGRectMake(0, 0, view.frame.size.width, 50);
    }];
    
    if(faded)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromView:view];
        });
    }
    
}

-(void)removeFromView:(UIView*)view
{
    for(UIView *child in [view subviews])
    {
        if(child.tag == 4400)
        {
            [UIView animateWithDuration:0.2 animations:^{
                child.frame = CGRectMake(0, -50, view.frame.size.width, 50);
            } completion:^(BOOL finished)
             {
                 [child removeFromSuperview];
             }];
        }
    }
}

-(void)buttonPressed:(UIView*)view
{
    UIView* parent = view.superview.superview;
    [self removeFromView:parent];
}


@end
