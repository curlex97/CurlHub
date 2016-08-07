//
//  FileImageContentViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACProgressBarDisplayer.h"
#import "UIColor+ACAppColors.h"
#import "ACPictureManager.h"
#import "ACRepoFile.h"

@interface FileImageContentViewController : UIViewController
@property ACRepoFile* file;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end
