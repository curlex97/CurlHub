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
    
    
    UIView *messageFrame = [[UIView alloc] initWithFrame:CGRectMake(MESSAGE_FRAME_X, MESSAGE_FRAME_BEGIN_Y, view.frame.size.width, MESSAGE_FRAME_HEIGHT)];
    messageFrame.backgroundColor = color;
    messageFrame.alpha = MESSAGE_FRAME_ALPHA;
    messageFrame.tag = MESSAGE_FRAME_TAG;
    
    UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(LABEL_X, LABEL_Y, view.frame.size.width, LABEL_HEIGHT)];
    strLabel.text = message;
    strLabel.textColor = [UIColor whiteColor];
    strLabel.textAlignment = NSTextAlignmentCenter;
    [messageFrame addSubview:strLabel];

    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width - CLOSE_BUTTON_RIGHT_EDGE, CLOSE_BUTTON_Y, CLOSE_BUTTON_WIDTH, CLOSE_BUTTON_HEIGHT)];
    [button setTitle:@"X" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [messageFrame addSubview:button];
    
    
    
    if(indicator)
    {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(INDICATOR_X, INDICATOR_Y, INDICATOR_WIDTH, INDICATOR_HEIGHT)];
        [activityIndicator startAnimating];
        [messageFrame addSubview:activityIndicator];
    }
    
    [view addSubview:messageFrame];
    
    [UIView animateWithDuration:ANIMATION_SPEED animations:^{
        messageFrame.frame = CGRectMake(MESSAGE_FRAME_X, MESSAGE_FRAME_END_Y, view.frame.size.width, MESSAGE_FRAME_HEIGHT);
    }];
    
    if(faded)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MESSAGE_DELAY * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromView:view];
        });
    }
    
}

-(void)removeFromView:(UIView*)view
{
    for(UIView *child in [view subviews])
    {
        if(child.tag == MESSAGE_FRAME_TAG)
        {
            [UIView animateWithDuration:ANIMATION_SPEED animations:^{
                child.frame = CGRectMake(MESSAGE_FRAME_X, MESSAGE_FRAME_BEGIN_Y, view.frame.size.width, MESSAGE_FRAME_HEIGHT);
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
