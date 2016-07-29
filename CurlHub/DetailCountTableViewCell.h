//
//  DetailRepoCountTableViewCell.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCountTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stargazersLabel;
@property (weak, nonatomic) IBOutlet UILabel *watchersLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksLabel;

@end
