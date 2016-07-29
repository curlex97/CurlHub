//
//  progressBarDisplayer.h
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ACProgressBarDisplayer : NSObject


-(void) displayOnView:(UIView*)view withMessage:(NSString*)message andColor:(UIColor*)color andIndicator:(BOOL)indicator andFaded:(BOOL)faded;
-(void) removeFromView:(UIView*)view;
@end
