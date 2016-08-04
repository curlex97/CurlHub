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
#import "ACUser.h"
#import "ContentTableViewCell.h"
#import "DetailRepoViewController.h"
#import "DetailUserViewController.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "ACUserViewModel.h"
#import "UIColor+ACAppColors.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *tableContent;
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
        [self.tableContent removeAllObjects];
        [self.tableView reloadData];
    }
}


-(void) refreshSearch
{
    self.isRefreshing = true;
    if(!self.tableContent.count) [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor]  andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = nil;
        
        newData = self.segmentControl.selectedSegmentIndex ? [NSMutableArray arrayWithArray:[[[ACUserViewModel alloc] init] allUsersForQuery:self.query andPageNumber:self.pageNumber]] : [NSMutableArray arrayWithArray:[[[ACReposViewModel alloc] init] allReposForQuery:self.query andPageNumber:self.pageNumber]];
        
        if(newData.count || self.tableContent.count)
        {
            self.pageNumber == 1 ? self.tableContent = newData : [self.tableContent addObjectsFromArray:[[[ACReposViewModel alloc] init] allReposForQuery:self.query andPageNumber:self.pageNumber]];
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
    return self.tableContent.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ContentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownContentCell"];
    if(!cell)
        cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownContentCell"];
    
    if([self.tableContent[indexPath.row] isKindOfClass:[ACRepo class]])
    {
        ACRepo *repo = self.tableContent[indexPath.row];
        [ACPictureManager downloadImageByUrlAsync:repo.ownerAvatarUrl andCompletion:^(UIImage* image)
         {
             cell.mainImage.image = image;
         }];
        cell.mainImage.layer.cornerRadius = cell.mainImage.frame.size.height /2;
        cell.mainImage.layer.masksToBounds = YES;
        cell.mainImage.layer.borderWidth = 0;
        cell.mainLabel.text = repo.name;
        cell.rightLabel.text = [NSString stringWithFormat:@"%li", repo.forksCount];
        cell.leftLabel.text = [NSString stringWithFormat:@"%li", repo.stargazersCount];
        cell.leftImage.image = [UIImage imageNamed:@"starIcon"];
        cell.rightImage.image = [UIImage imageNamed:@"forkIcon"];
        cell.type = RepositoryContentType;
    }
    
    else if([self.tableContent[indexPath.row] isKindOfClass:[ACUser class]])
    {
        ACUser *user = self.tableContent[indexPath.row];
        [ACPictureManager downloadImageByUrlAsync:user.avatarUrl andCompletion:^(UIImage* image)
         {
             cell.mainImage.image = image;
         }];
        cell.mainImage.layer.cornerRadius = cell.mainImage.frame.size.height /2;
        cell.mainImage.layer.masksToBounds = YES;
        cell.mainImage.layer.borderWidth = 0;
        cell.mainLabel.text = user.login;
        cell.type = UserContentType;
    }
    
    
    if(indexPath.row == self.tableContent.count - 1 && !self.isRefreshing)
    {
        self.pageNumber ++;
        [self refreshSearch];
    }

    return cell;
    
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.tableContent[indexPath.row] isKindOfClass:[ACRepo class]])
    {
        DetailRepoViewController* drcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailRepoViewController"];
        if(drcontroller)
        {
            drcontroller.currentRepo = self.tableContent[indexPath.row];
            [self.navigationController pushViewController:drcontroller animated:YES];
        }
    }
    else if([self.tableContent[indexPath.row] isKindOfClass:[ACUser class]])
    {
        DetailUserViewController* drcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUserViewController"];
        if(drcontroller)
        {
            drcontroller.currentUser = self.tableContent[indexPath.row];
            [self.navigationController pushViewController:drcontroller animated:YES];
        }
    }
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 75.0f;
}

- (IBAction)searchingTypeChanged:(id)sender {
    
    if(self.query && self.query.length)
    {
        [self.tableContent removeAllObjects];
        [self.tableView reloadData];
        self.pageNumber = 1;
        [self refreshSearch];
    }
    
}
@end
