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
        
        self.keys = [NSArray arrayWithObjects:@"News", @"Profile", @"Events", @"Repos", @"Issues", @"Search", nil];
        self.pages = @{
          self.keys[0] : @"NewsViewController",
          self.keys[1] : @"DetailUserViewController",
          self.keys[2] : @"EventsViewController",
          self.keys[3] : @"ReposViewController",
          self.keys[4] : @"IssuesViewController",
          self.keys[5] : @"SearchReposViewController"
          };
        
        
        [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
        [self.tableView setBackgroundColor:[UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0]];
        [self addSubview:self.view];
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.keys[indexPath.row]];
    cell.backgroundColor = [UIColor colorWithRed:34.0/255.0 green:34.0/255.0 blue:34.0/255.0 alpha:1.0];
    cell.textLabel.textColor = [UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
    
    UIView* selectedView = [[UIView alloc] init];
    selectedView.backgroundColor =[UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    cell.selectedBackgroundView = selectedView;
    
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pages.count;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.didSelectRow(self.pages[self.keys[indexPath.row]], self.keys[indexPath.row]);
}

-(NSString *)firstPage
{
    return self.pages[@"News"];
}

-(NSString *)firstTitle
{
    return @"News";
}

-(NSArray *)allPages
{
    return self.pages.allValues;
}




@end
