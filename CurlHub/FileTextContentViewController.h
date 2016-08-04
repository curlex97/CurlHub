//
//  FileContentViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACProgressBarDisplayer.h"
#import "UIColor+ACAppColors.h"

@interface FileTextContentViewController : UIViewController
@property NSString* url;
@property (weak, nonatomic) IBOutlet UITextView *contentView;
@property ACProgressBarDisplayer *progressBarDisplayer;

@end
