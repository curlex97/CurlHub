//
//  DetailRepoViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "DetailRepoViewController.h"


@interface DetailRepoViewController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation DetailRepoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.tableView.allowsSelection = NO;
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharingPressed)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
[ACPictureManager downloadImageByUrlAsync:self.currentRepo.ownerAvatarUrl andCompletion:^(UIImage* image)
    {
        self.ownerImage.image = image;
    }];
    self.ownerImage.layer.cornerRadius = self.ownerImage.frame.size.height /2;
    self.ownerImage.layer.masksToBounds = YES;
    self.ownerImage.layer.borderWidth = 0;
    self.repoNameLabel.text = self.currentRepo.name;
}


-(void) sharingPressed
{
    NSArray *toShare = @[self.currentRepo.htmlUrl];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:toShare applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 1 : 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        DetailCountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drcountCell"];
        if(!cell) cell = [[DetailCountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drcountCell"];
        
        cell.rightLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.forksCount];
        cell.centerLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.watchersCount];
        cell.leftLabel.text = [NSString stringWithFormat:@"%li", self.currentRepo.stargazersCount];
        cell.leftImage.image = self.currentRepo.isStarring ? [UIImage imageNamed:@"starIcon_selected"] : [UIImage imageNamed:@"starIcon"];
        cell.centerImage.image = self.currentRepo.isWatching ? [UIImage imageNamed:@"binocularusIcon_selected"] : [UIImage imageNamed:@"binocularusIcon"];
        cell.rightImage.image = [UIImage imageNamed:@"forkIcon"];
        [cell.leftButton addTarget:self action:@selector(starRepo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.centerButton addTarget:self action:@selector(watchRepo:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else
    {
        DetailDoubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drdoubleCell"];
        if(!cell) cell = [[DetailDoubleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"drdoubleCell"];
        
        switch (indexPath.row) {
            case 0:
                cell.leftImage.image = [UIImage imageNamed:@"lockIcon"];
                cell.rightImage.image = [UIImage imageNamed:@"boxIcon"];
                cell.leftLabel.text = self.currentRepo.isPrivate ? @"Private" : @"Public";
                cell.rightLabel.text = ![self.currentRepo.language isKindOfClass:[NSNull class]]? self.currentRepo.language : @"Unknown";
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
                cell.leftLabel.text = ![self.currentRepo.createDate isKindOfClass:[NSNull class]] ? self.currentRepo.createDate : @"";
                cell.rightLabel.text = [NSString stringWithFormat:@"%.02f MB", self.currentRepo.size];
                break;
            case 3:
                cell.leftLabel.text = @"Owner";
                cell.rightLabel.text = ![self.currentRepo.ownerName isKindOfClass:[NSNull class]] ? self.currentRepo.ownerName : @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 4:
                cell.leftLabel.text = @"Commits";
                cell.rightLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
        }
        
         return cell;
      
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1 && indexPath.row == 3)
    {
        DetailUserViewController* ducontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUserViewController"];
        if(ducontroller)
        {
            ducontroller.currentUser = [[[ACReposViewModel alloc] init] repositoryOwner: self.currentRepo andCurrentUser:[ACUserViewModel systemUser]];
            ducontroller.navigationItem.title = ducontroller.currentUser.login;
            [self.navigationController pushViewController:ducontroller animated:YES];
        }
    }
    else if(indexPath.section == 1 && indexPath.row == 4)
    {
        CommitsViewController* cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommitsViewController"];
        if(cvc)
        {
            cvc.currentRepo = self.currentRepo;
            cvc.navigationItem.title = [NSString stringWithFormat:@"%@ commits", self.currentRepo.name];
            [self.navigationController pushViewController:cvc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (IBAction)starRepo:(id)sender {

    if(!self.currentRepo.isStarring) [[[ACReposViewModel alloc] init] starRepoAsync:self.currentRepo andUser:[ACUserViewModel systemUser] completion:^{
        self.currentRepo.isStarring = YES;
        self.currentRepo.stargazersCount ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    else [[[ACReposViewModel alloc] init] unstarRepoAsync:self.currentRepo andUser:[ACUserViewModel systemUser] completion:^{
        self.currentRepo.isStarring = NO;
        self.currentRepo.stargazersCount --;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}


- (IBAction)watchRepo:(id)sender {
    
    if(!self.currentRepo.isWatching) [[[ACReposViewModel alloc] init] watchRepoAsync:self.currentRepo andUser:[ACUserViewModel systemUser] completion:^{
        self.currentRepo.isWatching = YES;
        self.currentRepo.watchersCount ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    else [[[ACReposViewModel alloc] init] unwatchRepoAsync:self.currentRepo andUser:[ACUserViewModel systemUser] completion:^{
        self.currentRepo.isWatching = NO;
        self.currentRepo.watchersCount --;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}




- (IBAction)watchRepoTapped:(id)sender {
    
    RepoContentsViewController* rcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RepoContentsViewController"];
    
    if(rcvc)
    {
        rcvc.navigationItem.title = self.currentRepo.name;
        ACRepoDirectory *dir = [[ACRepoDirectory alloc] initWithName:@"master" andUrl:self.currentRepo.contentsUrl];
        rcvc.currentDirectory = dir;
        rcvc.navigationItem.title = dir.name;
        [self.navigationController pushViewController:rcvc animated:YES];
    }
    
}
@end
