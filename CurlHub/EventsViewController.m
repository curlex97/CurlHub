//
//  EventsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "EventsViewController.h"
#import "ACEventsViewModel.h"
#import "ActionTableViewCell.h"
#import "ACProgressBarDisplayer.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSArray *sourceEvents;
@property NSMutableArray *tableEvents;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
   if(!self.tableEvents.count) [self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor blueColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sourceEvents = [[[ACEventsViewModel alloc] init] allEventsForUser:self.currentUser];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!self.tableEvents.count) [self.progressBarDisplayer removeFromView:self.view];
            self.tableEvents = [NSMutableArray arrayWithArray:self.sourceEvents];
            [self.tableView reloadData];
        });
    });
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        self.tableEvents = [NSMutableArray array];
        for(ACEvent* event in self.sourceEvents)
        {
            if(event && ([event.time.lowercaseString containsString:searchText.lowercaseString] ||
                         [[event eventDescription].lowercaseString containsString:searchText.lowercaseString]))
            {
                [self.tableEvents addObject:event];
            }
        }
        
    }
    else self.tableEvents = [NSMutableArray arrayWithArray:self.sourceEvents];
    [self.tableView reloadData];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableEvents.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
    
    ACEvent *event = self.tableEvents[indexPath.row];
    cell.timeLabel.text = event.time;
    cell.actionLabel.text = [event eventDescription];
    cell.avatarView.image = event.avatar;
    cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.height /2;
    cell.avatarView.layer.masksToBounds = YES;
    cell.avatarView.layer.borderWidth = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}



@end
