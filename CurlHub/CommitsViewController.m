//
//  CommitsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "CommitsViewController.h"

@interface CommitsViewController() <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceCommits;
@property NSMutableArray *tableCommits;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property BOOL isRefreshing;
@end

@implementation CommitsViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isRefreshing = false;
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if(!self.sourceCommits.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:[[[ACCommitsViewModel alloc] init] commitsForRepo:self.currentRepo andPageNumber:self.pageNumber]];
        
        if(newData.count || self.tableCommits.count)
        {
            self.pageNumber == 1 ? self.sourceCommits = newData : [self.sourceCommits addObjectsFromArray:newData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableCommits = [NSMutableArray arrayWithArray:self.sourceCommits];
                [self.tableView reloadData];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No Commits" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
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
        self.tableCommits = [NSMutableArray array];
        for(ACCommit* commit in self.sourceCommits)
        {
            if(commit && ([commit.message.lowercaseString containsString:searchText.lowercaseString] || [commit.commiterLogin.lowercaseString containsString:searchText.lowercaseString] || [commit.date.lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableCommits addObject:commit];
            }
        }
        
    }
    else self.tableCommits = [NSMutableArray arrayWithArray:self.sourceCommits];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableCommits.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
    
    ACCommit *commit = self.tableCommits[indexPath.row];
    cell.timeLabel.text = commit.date;
    cell.actionLabel.text = commit.message;
    if(commit.commiterAvatarUrl && ![commit.commiterAvatarUrl isKindOfClass:[NSNull class]] && commit.commiterAvatarUrl.length){
        [ACPictureManager downloadImageByUrlAsync:commit.commiterAvatarUrl andCompletion:^(UIImage* image){cell.avatarView.image = image;}];
    }
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.height /2;
    cell.avatarView.layer.masksToBounds = YES;
    cell.avatarView.layer.borderWidth = 0;
    
    if(indexPath.row == self.tableCommits.count - 1 && !self.isRefreshing && !self.searchBar.text.length)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ACCommit *commit = self.tableCommits[indexPath.row];
    if(commit)
    {
        CommentsViewController* comvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommentsViewController"];
        
        if(comvc)
        {
            comvc.currentCommit = commit;
            comvc.navigationItem.title = @"Comments";
            [self.navigationController pushViewController:comvc animated:YES];
        }
    }
    self.pageNumber = 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
    
}

@end
