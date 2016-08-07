//
//  MenuView.m
//  CurlHub
//
//  Created by Arthur Chistyak on 25.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "MenuView.h"


#define IMAGE_SIZE 20

@interface MenuView() <UITableViewDelegate, UITableViewDataSource>
@property NSDictionary *pages;
@property NSArray* keys;
@end

@implementation MenuView


- (instancetype)initWithCoder:(NSCoder *)coder
{
   
    self = [super initWithCoder:coder];
    if (self) {
        
        self.keys = [NSArray arrayWithObjects:@"News", @"Profile", @"Events", @"Repos", @"Issues", @"Search", @"Sign out", nil];
        self.pages = @{
          self.keys[0] : @"NewsViewController",
          self.keys[1] : @"DetailUserViewController",
          self.keys[2] : @"EventsViewController",
          self.keys[3] : @"ReposViewController",
          self.keys[4] : @"IssuesViewController",
          self.keys[5] : @"SearchViewController",
          self.keys[6] : @""

          };
        
        
        [[NSBundle mainBundle] loadNibNamed:@"MenuView" owner:self options:nil];
        [self.tableView setBackgroundColor:[UIColor darkBackgroundColor]];
        [self addSubview:self.view];
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    NSString* imageName = @"";
    switch (indexPath.row) {
        case 0:imageName = @"newsIcon"; break;
        case 1:imageName = @"profileIcon"; break;
        case 2:imageName = @"eventsIcon"; break;
        case 3:imageName = @"reposIcon"; break;
        case 4:imageName = @"issuesIcon"; break;
        case 5:imageName = @"searchIcon"; break;
        case 6:imageName = @"exitIcon"; break;

    }
    cell.imageView.image = [UIImage imageWithImage:[UIImage imageNamed:imageName] scaledToSize:CGSizeMake(IMAGE_SIZE, IMAGE_SIZE)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.keys[indexPath.row]];
    cell.backgroundColor = [UIColor darkBackgroundColor];
    cell.textLabel.textColor = [UIColor foregroundColor];
    
    UIView* selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor cellSelectionColor];
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}




@end
