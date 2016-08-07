//
//  NotificationsViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "ACIssuesViewModel.h"
#import "ACIssuesViewModel.h"
#import "IssueTableViewCell.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "ACIssue.h"
#import "UIColor+ACAppColors.h"
#import "DetailIssueViewController.h"

@interface IssuesViewController : UIViewController
@property ACUser* currentUser;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)onFilterChanged:(id)sender;

@end
