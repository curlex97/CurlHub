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
#import "ContentTableViewCell.h"
#import "DetailRepoViewController.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "UIColor+ACAppColors.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceRepos;
@property NSMutableArray *tableRepos;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property NSString* reposFilter;
@property BOOL isRefreshing;
@end

@implementation ReposViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRefreshing = false;
    self.reposFilter = @"all";
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
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
    self.pageNumber = 1;
    [self refreshTable];
}

-(void) refreshTable
{
    self.isRefreshing = true;
    if(!self.sourceRepos.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor]  andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:[[[ACReposViewModel alloc] init] allReposForUser:self.currentUser andPageNumber:self.pageNumber andFilter:self.reposFilter]];
        
        if(newData.count || self.sourceRepos.count)
        {
            self.pageNumber == 1 ? self.sourceRepos = newData : [self.sourceRepos addObjectsFromArray:newData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableRepos = [NSMutableArray arrayWithArray:self.sourceRepos];
                [self.tableView reloadData];
            });
        }
        
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.sourceRepos.count == 0)[self.progressBarDisplayer displayOnView:self.view withMessage:@"No repos" andColor:[UIColor alertColor] andIndicator:NO andFaded:YES];
            });
        }
        
    });
    self.isRefreshing = false;
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
    ContentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownContentCell"];
    if(!cell) cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownContentCell"];
    
    ACRepo *repo = self.tableRepos[indexPath.row];
    
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
    
    if(indexPath.row == self.tableRepos.count - 1 && !self.isRefreshing)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailRepoViewController* drcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailRepoViewController"];
    
    if(drcontroller)
    {
        drcontroller.currentRepo = self.tableRepos[indexPath.row];
        drcontroller.navigationItem.title = drcontroller.currentRepo.name;
        [self.navigationController pushViewController:drcontroller animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (IBAction)onFilterChanged:(id)sender
{
    self.pageNumber = 1;
    [self.sourceRepos removeAllObjects];
    [self.tableRepos removeAllObjects];
        [self.tableView reloadData];
    self.reposFilter = [self.segmentControl titleForSegmentAtIndex:self.segmentControl.selectedSegmentIndex].lowercaseString;
    [self refreshTable];
}


@end
