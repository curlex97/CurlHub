//
//  CommentsViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACCommentsViewModel.h"
#import "ActionTableViewCell.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "UIColor+ACAppColors.h"

@interface CommentsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property ACCommit* currentCommit;
@end
