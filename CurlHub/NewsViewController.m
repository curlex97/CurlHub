//
//  NewsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "NewsViewController.h"


@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *tableNews;
@property NSMutableArray *sourceNews;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.allowsSelection = NO;

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
   if(!self.sourceNews.count) [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor]  andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        
        self.sourceNews = [NSMutableArray arrayWithArray: [[[ACNewsViewModel alloc] init] allNews]];
        self.tableNews = [NSMutableArray arrayWithArray:self.sourceNews];
        
        if(self.sourceNews.count){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBarDisplayer removeFromView:self.view];
            [self.tableView reloadData];
        });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No news" andColor:[UIColor alertColor] andIndicator:NO andFaded:YES];
            });
        }
        
        
    });
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView * sb in self.view.subviews){
        if ([sb isKindOfClass:[UISearchBar class]] && [sb isFirstResponder]) {
            [sb resignFirstResponder];
        }
    }
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
        self.tableNews = [NSMutableArray array];
        for(ACNews* news in self.sourceNews)
        {
            if(news && ([news.date.lowercaseString containsString:searchText.lowercaseString] ||
                         [news.actionText.lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableNews addObject:news];
            }
        }
        
    }
    else self.tableNews = [NSMutableArray arrayWithArray:self.sourceNews];
    [self.tableView reloadData];
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableNews.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
    
    ACNews *news = self.tableNews[indexPath.row];
    cell.timeLabel.text = news.date;
    cell.actionLabel.text = [news actionText];
    [ACPictureManager downloadImageByUrlAsync:news.ownerUrl andCompletion:^(UIImage* image){cell.avatarView.image = image;}];
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.height /2;
    cell.avatarView.layer.masksToBounds = YES;
    cell.avatarView.layer.borderWidth = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
}


@end
