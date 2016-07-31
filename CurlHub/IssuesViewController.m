//
//  NotificationsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "IssuesViewController.h"
#import "ACIssuesViewModel.h"
#import "ACIssuesViewModel.h"
#import "IssueTableViewCell.h"
#import "ACProgressBarDisplayer.h"
#import "ACPictureManager.h"
#import "ACIssue.h"
#import "ACColorManager.h"

@interface IssuesViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceIssues;
@property NSMutableArray *tableIssues;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property NSString* issuesFilter;
@end

@implementation IssuesViewController

- (void)viewDidLoad {
    self.issuesFilter = @"all";
    [super viewDidLoad];
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
    [self refreshTable];
}

-(void) refreshTable
{
    if(!self.sourceIssues.count) [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[ACColorManager messageColor]  andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sourceIssues =  [NSMutableArray arrayWithArray:[[[ACIssuesViewModel alloc] init] allIssuesForUser:self.currentUser andFilter:self.issuesFilter]];
        if(self.sourceIssues.count){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableIssues = [NSMutableArray arrayWithArray:self.sourceIssues];
                [self.tableView reloadData];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No issues" andColor:[ACColorManager alertColor] andIndicator:NO andFaded:YES];
            });
        }
        
        
    });
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        self.tableIssues = [NSMutableArray array];
        for(ACIssue* issue in self.sourceIssues)
        {
            if(issue && ([issue.createDate.lowercaseString containsString:searchText.lowercaseString] ||
                         [issue.title.lowercaseString containsString:searchText.lowercaseString]||
                         [issue.state.lowercaseString containsString:searchText.lowercaseString]||
                         [[NSString stringWithFormat:@"%li", issue.issueNumber].lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableIssues addObject:issue];
            }
        }
        
    }
    else self.tableIssues = [NSMutableArray arrayWithArray:self.sourceIssues];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableIssues.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    IssueTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"issueCell"];
    if(!cell) cell = [[IssueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"issueCell"];
    
    ACIssue *issue = self.tableIssues[indexPath.row];
    cell.numberLabel.text = [NSString stringWithFormat:@"#%li", issue.issueNumber];
    cell.titleLabel.text = issue.title;
    cell.stateLabel.text = issue.state;
    cell.dateLabel.text = issue.createDate;
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}

- (IBAction)onFilterChanged:(id)sender {
    [self.sourceIssues removeAllObjects];
    [self.tableIssues removeAllObjects];
    [self.tableView reloadData];
    self.issuesFilter = [self.segmentControl titleForSegmentAtIndex:self.segmentControl.selectedSegmentIndex].lowercaseString;
    [self refreshTable];
}
@end
