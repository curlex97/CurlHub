//
//  RepoTableViewCell.h
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ownerImage;
@property (weak, nonatomic) IBOutlet UILabel *repoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stargazersLabel;
@property (weak, nonatomic) IBOutlet UILabel *forksLabel;

@end
