//
//  SearchReposViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "ACReposViewModel.h"
#import "ACRepo.h"
#import "ACUser.h"
#import "ContentTableViewCell.h"
#import "DetailRepoViewController.h"
#import "DetailUserViewController.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "ACUserViewModel.h"
#import "UIColor+ACAppColors.h"

@interface SearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)searchingTypeChanged:(id)sender;
@end
