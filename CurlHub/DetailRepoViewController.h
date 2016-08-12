//
//  DetailRepoViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACRepo.h"
#import "DetailCountTableViewCell.h"
#import "DetailDoubleTableViewCell.h"
#import "ACPictureManager.h"
#import "RepoContentsViewController.h"
#import "DetailUserViewController.h"
#import "ACReposViewModel.h"
#import "ACUserViewModel.h"
@interface DetailRepoViewController : UIViewController
@property ACRepo *currentRepo;
@property (weak, nonatomic) IBOutlet UIImageView *ownerImage;
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)watchRepoTapped:(id)sender;

@end
