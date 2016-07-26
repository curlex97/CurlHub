//
//  MenuView.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "MenuView.h"

@interface MenuView() <UITableViewDelegate, UITableViewDataSource>
@property NSDictionary *pages;
@property NSArray* keys;
@end

@implementation MenuView


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.keys = [NSArray arrayWithObjects:@"News", @"Events", @"Repos", @"Notifications", @"Search", nil];
        self.pages = @{
          self.keys[0] : @"NewsViewController",
          self.keys[1] : @"EventsViewController",
          self.keys[2] : @"ReposViewController",
          self.keys[3] : @"NotificationsViewController",
          self.keys[4] : @"SearchReposViewController"
          };
        
        
        [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.keys[indexPath.row]];
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pages.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.didSelectRow(self.pages[self.keys[indexPath.row]]);
}

-(NSString *)firstPage
{
    return self.pages[@"News"];
}

-(NSArray *)allPages
{
    return self.pages.allValues;
}




@end
