//
//  DetailIssueViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 05.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "DetailIssueViewController.h"
#import "ACPictureManager.h"
#import "DetailCountTableViewCell.h"
#import "DetailDoubleTableViewCell.h"
#import "EventTableViewCell.h"
#import "DetailUserViewController.h"
#import "DetailRepoViewController.h"
#import "ACIssueEvent.h"

@interface DetailIssueViewController() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation DetailIssueViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [ACPictureManager downloadImageByUrlAsync:self.currentIssue.user.avatarUrl andCompletion:^(UIImage* image)
     {
         self.userImage.image = image;
     }];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height /2;
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.borderWidth = 0;
    self.titleLabel.text = self.currentIssue.title;
    self.dateLabel.text = self.currentIssue.createDate;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) return 1;
    if(section == 1) return 2;
    return self.currentIssue.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        DetailDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        cell.leftLabel.text = [NSString stringWithFormat:@"%lu Labels", self.currentIssue.labelsCount];
        cell.rightLabel.text = [NSString stringWithFormat:@"%i Events", self.currentIssue.events.count];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        DetailDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        
        switch (indexPath.row) {
            case 0:
                cell.leftLabel.text = @"Repository";
                cell.rightLabel.text = self.currentIssue.repo.name;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.leftLabel.text = @"Created by";
                cell.rightLabel.text = [NSString stringWithFormat:@"%@", self.currentIssue.user.login];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
        
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        EventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dreventCell"];
        if(!cell) cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dreventCell"];
        ACIssueEvent* issueEvent = self.currentIssue.events[indexPath.row];
        [ACPictureManager downloadImageByUrlAsync:issueEvent.user.avatarUrl andCompletion:^(UIImage* image)
         {
             cell.mainImage.image = image;
         }];
        cell.mainLabel.text = issueEvent.user.login;
        cell.addLabel.text = issueEvent.date;
        cell.eventLabel.text = [NSString stringWithFormat:@"%@ this issue", issueEvent.event];
        return cell;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 1)
    {
        DetailUserViewController* ducontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUserViewController"];
        if(ducontroller)
        {
            ducontroller.currentUser = self.currentIssue.user;
            ducontroller.navigationItem.title = ducontroller.currentUser.login;
            [self.navigationController pushViewController:ducontroller animated:YES];
        }
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        DetailRepoViewController* ducontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailRepoViewController"];
        if(ducontroller)
        {
            ducontroller.currentRepo = self.currentIssue.repo;
            ducontroller.navigationItem.title = ducontroller.currentRepo.name;
            [self.navigationController pushViewController:ducontroller animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section < 2 ? 44.0f : 75.0f;
}


@end
