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
#import "ACPictureManager.h"
#import "ACColorManager.h"

@interface EventsViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceEvents;
@property NSMutableArray *tableEvents;
@property ACProgressBarDisplayer *progressBarDisplayer;
@property int pageNumber;
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
    self.pageNumber = 1;
    [self refreshTable];
}

-(void) refreshTable
{
     if(!self.sourceEvents.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[ACColorManager messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *newData = [NSMutableArray arrayWithArray:[[[ACEventsViewModel alloc] init] allEventsForUser:self.currentUser andPageNumber:self.pageNumber]];
        
       if(newData.count || self.tableEvents.count)
       {
           self.pageNumber == 1 ? self.sourceEvents = newData : [self.sourceEvents addObjectsFromArray:newData];
           
           dispatch_async(dispatch_get_main_queue(), ^{
               [self.progressBarDisplayer removeFromView:self.view];
               self.tableEvents = [NSMutableArray arrayWithArray:self.sourceEvents];
               [self.tableView reloadData];
           });
           
       }
       else
       {
           dispatch_async(dispatch_get_main_queue(), ^{
            [self.progressBarDisplayer displayOnView:self.view withMessage:@"No events" andColor:[ACColorManager alertColor]  andIndicator:NO andFaded:YES];
            });
       }
        
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
    return self.tableEvents.count ? self.tableEvents.count + 1 : 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.tableEvents.count)
    {
        ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
        if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
        
        ACEvent *event = self.tableEvents[indexPath.row];
        cell.timeLabel.text = event.time;
        cell.actionLabel.text = [event eventDescription];
        [ACPictureManager downloadImageByUrlAsync:event.avatarUrl andCompletion:^(UIImage* image){cell.avatarView.image = image;}];
        cell.avatarView.layer.cornerRadius = cell.avatarView.frame.size.height /2;
        cell.avatarView.layer.masksToBounds = YES;
        cell.avatarView.layer.borderWidth = 0;
        return cell;
    }
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"More...";
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row >= self.sourceEvents.count)
    {
        self.pageNumber ++;
        [self refreshTable];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row < self.tableEvents.count ? 85.0f : 50.0f;
    
}



@end
