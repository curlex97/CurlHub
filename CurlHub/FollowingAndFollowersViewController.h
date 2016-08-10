//
//  FollowingAndFollowersViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 10.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "ACUserViewModel.h"
#import "ContentTableViewCell.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "UIColor+ACAppColors.h"
#import "DetailUserViewController.h"

@interface FollowingAndFollowersViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ACUser* currentUser;
- (IBAction)onSegmentControlValueChanged:(id)sender;

@end
