//
//  DetailRepoViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "DetailRepoViewController.h"
#import "DetailRepoCountTableViewCell.h"
#import "DetailRepoDoubleTableViewCell.h"

@interface DetailRepoViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailRepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.ownerImage.image = self.currentRepo.ownerAvatar;
    self.ownerImage.layer.cornerRadius = self.ownerImage.frame.size.height /2;
    self.ownerImage.layer.masksToBounds = YES;
    self.ownerImage.layer.borderWidth = 0;
    self.repoNameLabel.text = self.currentRepo.name;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DetailRepoCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drcountCell"];
        if(!cell) cell = [[DetailRepoCountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drcountCell"];
        
        cell.forksLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.forksCount];
        cell.watchersLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.watchersCount];
        cell.stargazersLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.stargazersCount];

        
        return cell;
    }
    else
    {
        DetailRepoDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailRepoDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        
        switch (indexPath.row) {
            case 0:
                cell.leftImage.image = [UIImage imageNamed:@"lockIcon"];
                cell.rightImage.image = [UIImage imageNamed:@"boxIcon"];
                cell.leftLabel.text = self.currentRepo.isPrivate ? @"Private" : @"Public";
                cell.rightLabel.text = self.currentRepo.language;
                break;
            case 1:
                cell.leftImage.image = [UIImage imageNamed:@"alertIcon"];
                cell.rightImage.image = [UIImage imageNamed:@"forkIcon"];
                cell.leftLabel.text = [NSString stringWithFormat:@"%li Issues", self.currentRepo.issuesCount];
                cell.rightLabel.text = [NSString stringWithFormat:@"%li Branch(es)", self.currentRepo.branchesCount];
                break;
            case 2:
                cell.leftImage.image = [UIImage imageNamed:@"calendarIcon"];
                cell.rightImage.image = [UIImage imageNamed:@"toolsIcon"];
                cell.leftLabel.text = self.currentRepo.createDate;
                cell.rightLabel.text = [NSString stringWithFormat:@"%.02f MB", self.currentRepo.size];
                break;
            case 3:
                cell.leftLabel.text = @"Owner";
                cell.rightLabel.text = self.currentRepo.ownerName;
                break;
        }
        
         return cell;
      
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
