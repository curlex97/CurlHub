//
//  NewsViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
