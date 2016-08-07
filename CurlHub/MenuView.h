//
//  MenuView.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+ACImageResizing.h"
#import "UIColor+ACAppColors.h"

@interface MenuView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void (^didSelectRow)(NSString *page, NSString* title);

// первая страница (открывается при запуске)
-(NSString*) firstPage;

// первый заголовок (при запуске)
-(NSString*) firstTitle;

// список всех страниц
-(NSArray*) allPages;

@end
