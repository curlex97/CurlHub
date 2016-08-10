//
//  FollowingAndFollowersViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 10.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "FollowingAndFollowersViewController.h"

@interface FollowingAndFollowersViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceUsers;
@property NSMutableArray *tableUsers;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property BOOL isRefreshing;
@end


@implementation FollowingAndFollowersViewController


- (void)viewDidLoad {
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
    if(!self.sourceUsers.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData;
        if(self.segmentControl.selectedSegmentIndex){
            newData = [NSMutableArray arrayWithArray:[[[ACUserViewModel alloc] init] userFollowing:self.currentUser andPageNumber:self.pageNumber]];
        }
        
        else{
            newData = [NSMutableArray arrayWithArray:[[[ACUserViewModel alloc] init] userFollowers:self.currentUser andPageNumber:self.pageNumber]];
        }
        
        if(newData.count || self.tableUsers.count)
        {
            self.pageNumber == 1 ? self.sourceUsers = newData : [self.sourceUsers addObjectsFromArray:newData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableUsers = [NSMutableArray arrayWithArray:self.sourceUsers];
                [self.tableView reloadData];
            });
            
        }
        else
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(self.sourceUsers.count == 0)
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No users" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
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
        self.tableUsers = [NSMutableArray array];
        for(ACUser* user in self.sourceUsers)
        {
            if(user && ([user.login.lowercaseString containsString:searchText]))
            {
                [self.tableUsers addObject:user];
            }
        }
        
    }
    else self.tableUsers = [NSMutableArray arrayWithArray:self.sourceUsers];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableUsers.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContentTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ownContentCell"];
    if(!cell)
        cell = [[ContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ownContentCell"];
    
    ACUser *user = self.tableUsers[indexPath.row];
    [ACPictureManager downloadImageByUrlAsync:user.avatarUrl andCompletion:^(UIImage* image)
     {
         cell.mainImage.image = image;
     }];
    cell.mainImage.layer.cornerRadius = cell.mainImage.frame.size.height /2;
    cell.mainImage.layer.masksToBounds = YES;
    cell.mainImage.layer.borderWidth = 0;
    cell.mainLabel.text = user.login;
    
    if(indexPath.row == self.tableUsers.count - 1 && !self.isRefreshing)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailUserViewController* ducontroller = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailUserViewController"];
    if(ducontroller)
    {
        ducontroller.currentUser = self.tableUsers[indexPath.row];
        ducontroller.navigationItem.title = ducontroller.currentUser.login;
        [self.navigationController pushViewController:ducontroller animated:YES];
    }
}


- (IBAction)onSegmentControlValueChanged:(id)sender {
    [self.tableUsers removeAllObjects];
    [self.sourceUsers removeAllObjects];
    [self.tableView reloadData];
    self.pageNumber = 1;
    [self refreshTable];
}



@end
