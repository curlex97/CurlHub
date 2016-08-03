//
//  FileImageContentViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "FileImageContentViewController.h"

@implementation FileImageContentViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharingPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[ACColorManager messageColor] andIndicator:YES andFaded:NO];
    
    [ACPictureManager downloadImageByUrlAsync:self.url andCompletion:^(UIImage* image){
        if(image)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(0,0, image.size.width, image.size.height);
            
            imageView.center = CGPointMake(self.view.frame.size.width / 2 - imageView.frame.size.width / 2, self.view.frame.size.height / 2 - imageView.frame.size.height / 2);
            
            if(imageView.frame.size.width > self.view.frame.size.width ||
               imageView.frame.size.height > self.view.frame.size.height)
            {
                imageView.frame = CGRectMake(0,0, self.view.frame.size.width / 2, image.size.width / 2);
                imageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            [self.view addSubview:imageView];
        }
        else
        {
            [self.progressBarDisplayer displayOnView:self.view withMessage:@"No File Content" andColor:[ACColorManager alertColor]  andIndicator:NO andFaded:YES];
        }
    }];
    
}

-(void) sharingPressed
{
    NSArray *toShare = @[self.url];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:toShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}


@end
