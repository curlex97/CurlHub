//
//  CommitsViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACRepo.h"
#import "ACCommit.h"
#import "ACCommitsViewModel.h"
#import "ActionTableViewCell.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "UIColor+ACAppColors.h"
#import "DetailRepoViewController.h"

@interface CommitsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property ACRepo* currentRepo;
@end
