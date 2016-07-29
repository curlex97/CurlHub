//
//  DetailUserViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 29.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "DetailUserViewController.h"
#import "ACPictureManager.h"
#import "DetailCountTableViewCell.h"
#import "DetailDoubleTableViewCell.h"

@interface DetailUserViewController()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation DetailUserViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [ACPictureManager downloadImageByUrlAsync:self.currentUser.avatarUrl andCompletion:^(UIImage* image)
    {
        self.userAvatar.image = image;
        self.userAvatar.layer.cornerRadius = self.userAvatar.frame.size.height /2;
        self.userAvatar.layer.masksToBounds = YES;
        self.userAvatar.layer.borderWidth = 0;
    }];
    self.userName.text = self.currentUser.login;
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
        DetailDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        cell.leftLabel.text = [NSString stringWithFormat:@"%@ Followers", self.currentUser.followers];
        cell.rightLabel.text = [NSString stringWithFormat:@"%@ Following", self.currentUser.following];
        return cell;
    }
    else
    {
        DetailDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        
        switch (indexPath.row) {
            case 0:
//                cell.leftImage.image = [UIImage imageNamed:@"lockIcon"];
                cell.leftLabel.text = @"Name";
                cell.rightLabel.text = ![self.currentUser.name isKindOfClass:[NSNull class]] ? self.currentUser.name : @"No name";
                break;
            case 1:
//                cell.leftImage.image = [UIImage imageNamed:@"alertIcon"];
                cell.leftLabel.text = @"Company";
                cell.rightLabel.text = ![self.currentUser.company isKindOfClass:[NSNull class]] ? self.currentUser.company : @"No company";
                break;
            case 2:
//                cell.leftImage.image = [UIImage imageNamed:@"calendarIcon"];
                cell.leftLabel.text = @"Location";
                cell.rightLabel.text = ![self.currentUser.location isKindOfClass:[NSNull class]] ? self.currentUser.location : @"No location" ;
                break;
            case 3:
//              cell.leftImage.image = [UIImage imageNamed:@"calendarIcon"];
                cell.leftLabel.text = @"Email";
                cell.rightLabel.text = ![self.currentUser.email isKindOfClass:[NSNull class]] ? self.currentUser.email : @"No email";
                break;
        }
        
        return cell;
        
    }
}





@end
