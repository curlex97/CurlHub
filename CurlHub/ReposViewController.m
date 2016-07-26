//
//  ReposViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "ReposViewController.h"
#import "ACReposViewModel.h"
#import "ACRepo.h"
#import "RepoTableViewCell.h"
#import "DetailRepoViewController.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSArray *sourceRepos;
@property NSMutableArray *tableRepos;

@end

@implementation ReposViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sourceRepos = [[[ACReposViewModel alloc] init] allReposForUser:self.currentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableRepos = [NSMutableArray arrayWithArray:self.sourceRepos];
            [self.tableView reloadData];
        });
    });
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        self.tableRepos = [NSMutableArray array];
        for(ACRepo* repo in self.sourceRepos)
        {
            if(repo && ([repo.name.lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableRepos addObject:repo];
            }
        }
        
    }
    else self.tableRepos = [NSMutableArray arrayWithArray:self.sourceRepos];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableRepos.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownRepoCell"];
    if(!cell) cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownRepoCell"];
    
    ACRepo *repo = self.tableRepos[indexPath.row];
    
    cell.ownerImage.image = repo.ownerAvatar;
    cell.ownerImage.layer.cornerRadius = cell.ownerImage.frame.size.height /2;
    cell.ownerImage.layer.masksToBounds = YES;
    cell.ownerImage.layer.borderWidth = 0;
    cell.repoNameLabel.text = repo.name;
    cell.forksLabel.text = [NSString stringWithFormat:@"%li", repo.forksCount];
    cell.stargazersLabel.text = [NSString stringWithFormat:@"%li", repo.stargazersCount];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailRepoViewController* drcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailRepoViewController"];
    
    if(drcontroller)
    {
        drcontroller.currentRepo = self.tableRepos[indexPath.row];
        [self.navigationController pushViewController:drcontroller animated:YES];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

@end
