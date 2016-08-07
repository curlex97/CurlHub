//
//  progressBarDisplayer.h
//  CurlHub
//
//  Created by Arthur Chistyak on 28.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define MESSAGE_FRAME_X 0
#define MESSAGE_FRAME_BEGIN_Y -50
#define MESSAGE_FRAME_HEIGHT 50
#define MESSAGE_FRAME_TAG 4400
#define MESSAGE_FRAME_ALPHA 0.7
#define LABEL_X 0
#define LABEL_Y 0
#define LABEL_HEIGHT 50
#define CLOSE_BUTTON_RIGHT_EDGE 47
#define CLOSE_BUTTON_Y 3
#define CLOSE_BUTTON_WIDTH 44
#define CLOSE_BUTTON_HEIGHT 44
#define INDICATOR_X 0
#define INDICATOR_Y 0
#define INDICATOR_WIDTH 50
#define INDICATOR_HEIGHT 50
#define ANIMATION_SPEED 0.2
#define MESSAGE_FRAME_END_Y 0
#define MESSAGE_DELAY 3


@interface ACProgressBarDisplayer : NSObject

// показать сообщение
-(void) displayOnView:(UIView*)view withMessage:(NSString*)message andColor:(UIColor*)color andIndicator:(BOOL)indicator andFaded:(BOOL)faded;

// скрыть сообщение
-(void) removeFromView:(UIView*)view;


@end
