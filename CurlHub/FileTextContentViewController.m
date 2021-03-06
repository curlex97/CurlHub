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

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharingPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* text = [[[ACRepoContentsViewModel alloc] init] textContentWithFile:self.file];
        if(text && text.length)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.contentView.text = text;
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No File Content" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
            });
        }
    });
}

-(void) sharingPressed
{
    NSArray *toShare = @[self.file.downloadUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:toShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
