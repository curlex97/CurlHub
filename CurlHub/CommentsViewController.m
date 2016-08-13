//
//  CommentsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 13.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "CommentsViewController.h"

@interface CommentsViewController() <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceComments;
@property NSMutableArray *tableComments;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
@property BOOL isRefreshing;
@end

@implementation CommentsViewController

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
    if(!self.sourceComments.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:[[[ACCommentsViewModel alloc] init] commentsForCommit:self.currentCommit andPageNumber:self.pageNumber]];
        
        if(newData.count || self.tableComments.count)
        {
            self.pageNumber == 1 ? self.sourceComments = newData : [self.sourceComments addObjectsFromArray:newData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableComments = [NSMutableArray arrayWithArray:self.sourceComments];
                [self.tableView reloadData];
            });
            
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No Comments" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
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
        self.tableComments = [NSMutableArray array];
        for(ACComment* comment in self.sourceComments)
        {
            if(comment && ([comment.body.lowercaseString containsString:searchText.lowercaseString] || [comment.userLogin.lowercaseString containsString:searchText.lowercaseString] || [comment.date.lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableComments addObject:comment];
            }
        }
        
    }
    else self.tableComments = [NSMutableArray arrayWithArray:self.sourceComments];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableComments.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
    
    ACComment *comment = self.tableComments[indexPath.row];
    cell.timeLabel.text = comment.date;
    cell.actionLabel.text = comment.body;
    if(comment.userAvatarUrl && ![comment.userAvatarUrl isKindOfClass:[NSNull class]] && comment.userAvatarUrl.length){
        [ACPictureManager downloadImageByUrlAsync:comment.userAvatarUrl andCompletion:^(UIImage* image){cell.avatarView.image = image;}];
    }
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.height /2;
    cell.avatarView.layer.masksToBounds = YES;
    cell.avatarView.layer.borderWidth = 0;
    
    if(comment.userLogin == [ACUserViewModel systemUser].login)
    {
        [cell.actionButton setImage:[UIImage imageNamed:@"trashIcon"] forState:UIControlStateNormal];
        cell.actionButton.tag = indexPath.row;
        [cell.actionButton addTarget:self action:@selector(trashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(indexPath.row == self.tableComments.count - 1 && !self.isRefreshing && !self.searchBar.text.length)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
    
    return cell;
}

- (IBAction)trashButtonTapped:(id)sender {
    if([sender isKindOfClass:[UIButton class]])
    {
        UIButton* button = (UIButton*)sender;
        ACComment *comment = self.tableComments[button.tag];
        [[[ACCommentsViewModel alloc] init] deleteCommentFromCommitAsync:comment andCommit:self.currentCommit andUser:[ACUserViewModel systemUser] completion:^{
             dispatch_async(dispatch_get_main_queue(), ^{
            self.pageNumber = 1;
            [self.sourceComments removeAllObjects];
            [self refreshTable];
             });
        }];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
    
}

- (IBAction)commentOnButtonTapped:(id)sender {
    
    if(self.messageField.text.length && self.messageField.text.length < 1000)
    {
        [[[ACCommentsViewModel alloc] init] commentOnCommitAsync:self.messageField.text andCommit:self.currentCommit andUser:[ACUserViewModel systemUser] completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view endEditing:YES];
                self.pageNumber = 1;
                self.messageField.text = @"";
                [self.sourceComments removeAllObjects];
                [self refreshTable];
            });
        }];
    }
}
@end
