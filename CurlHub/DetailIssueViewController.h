//
//  DetailIssueViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACIssue.h"

@interface DetailIssueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ACIssue* currentIssue;
@end
