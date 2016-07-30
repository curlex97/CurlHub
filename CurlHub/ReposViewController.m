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
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "ACColorManager.h"

@interface ReposViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceRepos;
@property NSMutableArray *tableRepos;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property NSString* reposFilter;
@end

@implementation ReposViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    NSLog(@"%@", self.reposFilter);
    if(!self.sourceRepos.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[ACColorManager messageColor]  andIndicator:YES andFaded:NO];
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No repos" andColor:[ACColorManager alertColor] andIndicator:NO andFaded:YES];
            });
        }
        
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
    return self.tableRepos.count ? self.tableRepos.count + 1 : self.tableRepos.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.tableRepos.count)
    {
        RepoTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownRepoCell"];
        if(!cell) cell = [[RepoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownRepoCell"];
        
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
        
        return cell;
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"More...";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.sourceRepos.count)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
    else
    {
        DetailRepoViewController* drcontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailRepoViewController"];
        
        if(drcontroller)
        {
            drcontroller.currentRepo = self.tableRepos[indexPath.row];
            [self.navigationController pushViewController:drcontroller animated:YES];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.tableRepos.count ? 75.0f : 50.0f;
}

- (IBAction)onFilterChanged:(id)sender
{
    [self.sourceRepos removeAllObjects];
    [self.tableRepos removeAllObjects];
        [self.tableView reloadData];
    self.reposFilter = [self.segmentControl titleForSegmentAtIndex:self.segmentControl.selectedSegmentIndex].lowercaseString;
    [self refreshTable];
}


@end
