//
//  RepoContentsViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACRepoContentsViewModel.h"
#import "ACProgressBarDisplayer.h"
#import "UIColor+ACAppColors.h"
#import "ActionTableViewCell.h"
#import "FileTextContentViewController.h"
#import "FileImageContentViewController.h"

#define MAX_OPEN_TEXT_FILE_SIZE 100000
#define MAX_OPEN_IMAGE_FILE_SIZE 5000000

@interface RepoContentsViewController : UIViewController
@property ACRepoDirectory* currentDirectory;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
