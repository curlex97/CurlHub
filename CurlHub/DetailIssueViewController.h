//
//  DetailIssueViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACIssue.h"
#import "ACPictureManager.h"
#import "DetailCountTableViewCell.h"
#import "DetailDoubleTableViewCell.h"
#import "EventTableViewCell.h"
#import "DetailUserViewController.h"
#import "DetailRepoViewController.h"
#import "ACIssueEvent.h"

@interface DetailIssueViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ACIssue* currentIssue;
@end
