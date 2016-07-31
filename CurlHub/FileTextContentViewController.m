//
//  FileContentViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "FileTextContentViewController.h"

@implementation FileTextContentViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[ACColorManager messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* text = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.url] encoding:NSUTF8StringEncoding error:nil];
        if(text.length)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.contentView.text = text;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No File Content" andColor:[ACColorManager alertColor]  andIndicator:NO andFaded:YES];
            });
        }
    });
}

@end
