//
//  ReposViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"

@interface ReposViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property ACUser* currentUser;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;


- (IBAction)onFilterChanged:(id)sender;

@end
