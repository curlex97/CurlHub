//
//  FileImageContentViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACProgressBarDisplayer.h"
#import "ACColorManager.h"
#import "ACPictureManager.h"

@interface FileImageContentViewController : UIViewController
@property NSString* url;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end
