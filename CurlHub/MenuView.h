//
//  MenuView.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuView : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) void (^didSelectRow)(NSString *page);

-(NSString*) firstPage;
-(NSArray*) allPages;

@end
