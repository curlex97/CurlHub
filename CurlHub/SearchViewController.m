//
//  SearchReposViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 26.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "SearchViewController.h"
#import "ACReposViewModel.h"
#import "ACRepo.h"
#import "RepoTableViewCell.h"
#import "DetailRepoViewController.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "UIColor+ACAppColors.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *tableRepos;
@property NSString *query;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property BOOL isRefreshing;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.isRefreshing = false;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* query = searchBar.text;
    [self.view endEditing:YES];

    if(query && query.length > 0)
    {
        self.pageNumber = 1;
        self.query = query;
        [self refreshSearch];
    }
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length == 0)
    {
        [self.tableRepos removeAllObjects];
        [self.tableView reloadData];
    }
}


-(void) refreshSearch
{
    self.isRefreshing = true;
    if(!self.tableRepos.count) [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor]  andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:[[[ACReposViewModel alloc] init] allReposForQuery:self.query andPageNumber:self.pageNumber]];
        
        if(newData.count || self.tableRepos.count)
        {
            self.pageNumber == 1 ? self.tableRepos = newData : [self.tableRepos addObjectsFromArray:[[[ACReposViewModel alloc] init] allReposForQuery:self.query andPageNumber:self.pageNumber]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                [self.tableView reloadData];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No internet" andColor:[UIColor alertColor] andIndicator:NO andFaded:YES];
            });
        }

    });
    self.isRefreshing = false;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableRepos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    RepoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownRepoCell"];
    if(!cell)
        cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownRepoCell"];
    ACRepo *repo = self.tableRepos[indexPath.row];
    [ACPictureManager downloadImageByUrlAsync:repo.ownerAvatarUrl andCompletion:^(UIImage* image)
     {
         cell.ownerImage.image = image;
     }];
    cell.ownerImage.layer.cornerRadius = cell.ownerImage.frame.size.height /2;
    cell.ownerImage.layer.masksToBounds = YES;
    cell.ownerImage.layer.borderWidth = 0;
    cell.repoNameLabel.text = repo.name;
    cell.forksLabel.text = [NSString stringWithFormat:@"%li", repo.forksCount];
    cell.stargazersLabel.text = [NSString stringWithFormat:@"%li", repo.stargazersCount];

    if(indexPath.row == self.tableRepos.count - 1 && !self.isRefreshing)
    {
        self.pageNumber ++;
        [self refreshSearch];
    }

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
