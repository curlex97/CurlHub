//
//  RepoContentsViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 31.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "RepoContentsViewController.h"



@interface RepoContentsViewController() <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property NSMutableArray *sourceFiles;
@property NSMutableArray *tableFiles;
@property ACProgressBarDisplayer *progressBarDisplayer;
@end

@implementation RepoContentsViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.progressBarDisplayer = [[ACProgressBarDisplayer alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    [self refreshTable];
}


-(void) refreshTable
{
    if(!self.sourceFiles.count)[self.progressBarDisplayer displayOnView:self.view withMessage:@"Downloading..." andColor:[UIColor messageColor] andIndicator:YES andFaded:NO];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.sourceFiles = [NSMutableArray arrayWithArray:[[[ACRepoContentsViewModel alloc] init]filesListFromUrl:self.currentUrl]];
        if(self.sourceFiles.count)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer removeFromView:self.view];
                self.tableFiles = [NSMutableArray arrayWithArray:self.sourceFiles];
                [self.tableView reloadData];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressBarDisplayer displayOnView:self.view withMessage:@"No Files" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
            });
        }
    });
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        self.tableFiles = [NSMutableArray array];
        for(id absfile in self.sourceFiles)
        {
            if([absfile isKindOfClass:[ACRepoDirectory class]])
            {
                ACRepoDirectory *dir = (ACRepoDirectory*)absfile;
                if(([dir.name.lowercaseString containsString:searchText.lowercaseString]))
                    [self.tableFiles addObject:dir];
            }
            if([absfile isKindOfClass:[ACRepoFile class]])
            {
                ACRepoFile *file = (ACRepoFile*)absfile;
                if(([file.name.lowercaseString containsString:searchText.lowercaseString]))
                    [self.tableFiles addObject:file];
            }
        }
        
    }
    else self.tableFiles = [NSMutableArray arrayWithArray:self.sourceFiles];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableFiles.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    ActionTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    if(!cell) cell = [[ActionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"actionCell"];
    id absfile = self.tableFiles[indexPath.row];
    if([absfile isKindOfClass:[ACRepoDirectory class]])
    {
        ACRepoDirectory *dir = (ACRepoDirectory*)absfile;
        cell.timeLabel.text = @"DIR";
        cell.actionLabel.text = dir.name;
        cell.avatarView.image = [UIImage imageNamed:@"folderIcon"];
    }
    else if([absfile isKindOfClass:[ACRepoFile class]])
    {
        ACRepoFile *file = (ACRepoFile*)absfile;
        cell.timeLabel.text = [NSString stringWithFormat:@"%li bytes", file.size];
        cell.actionLabel.text = file.name;
        cell.avatarView.image = [UIImage imageNamed:@"fileIcon"];
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0f;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id absfile = self.tableFiles[indexPath.row];
    if([absfile isKindOfClass:[ACRepoDirectory class]])
    {
        ACRepoDirectory *dir = (ACRepoDirectory*)absfile;
        RepoContentsViewController* rcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RepoContentsViewController"];
        if(rcvc)
        {
            rcvc.currentUrl = dir.url;
            rcvc.navigationItem.title = dir.name;
            [self.navigationController pushViewController:rcvc animated:YES];
        }
        
    }
    else if([absfile isKindOfClass:[ACRepoFile class]])
    {
        ACRepoFile *file = (ACRepoFile*)absfile;
        bool isImage = ([[file.name pathExtension] isEqualToString:@"png"] || [[file.name pathExtension] isEqualToString:@"jpg"]);
        
        
        if(isImage)
        {
            if(file.size < MAX_OPEN_IMAGE_FILE_SIZE && file.size > 0)
            {
                FileImageContentViewController* fcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileImageContentViewController"];
                if(fcvc)
                {
                    fcvc.file = file;
                    fcvc.navigationItem.title = file.name;
                    [self.navigationController pushViewController:fcvc animated:YES];
                }
            }
            else if(file.size == 0) [self.progressBarDisplayer displayOnView:self.view withMessage:@"File is empty" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
            else [self.progressBarDisplayer displayOnView:self.view withMessage:@"File is too large" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
        }
        
        else
        {
            if(file.size < MAX_OPEN_TEXT_FILE_SIZE && file.size > 0)
            {
                FileTextContentViewController* fcvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FileTextContentViewController"];
                if(fcvc)
                {
                    fcvc.file = file;
                    fcvc.navigationItem.title = file.name;
                    [self.navigationController pushViewController:fcvc animated:YES];
                }
            }
            else if(file.size == 0) [self.progressBarDisplayer displayOnView:self.view withMessage:@"File is empty" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
            else [self.progressBarDisplayer displayOnView:self.view withMessage:@"File is too large" andColor:[UIColor alertColor]  andIndicator:NO andFaded:YES];
        }
        
    }

}



@end
