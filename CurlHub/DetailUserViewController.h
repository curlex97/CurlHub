//
//  DetailUserViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "ACPictureManager.h"
#import "DetailCountTableViewCell.h"
#import "DetailDoubleTableViewCell.h"
#import "ReposViewController.h"

@interface DetailUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property ACUser* currentUser;
- (IBAction)watchRepositoriesAction:(id)sender;
@end
