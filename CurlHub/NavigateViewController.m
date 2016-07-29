//
//  ViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 24.07.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "NavigateViewController.h"
#import "MenuView.h"
#import "EventsViewController.h"
#import "ReposViewController.h"
#import "SearchReposViewController.h"
#import "DetailUserViewController.h"
#import "IssuesViewController.h"
#import "UIImage+ACImageResizing.h"
#import "ACColorManager.h"

#define SLIDE_WIDTH 200

@interface NavigateViewController ()
@property (weak, nonatomic) IBOutlet MenuView<UITableViewDelegate, UITableViewDataSource> *menu;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property NSMutableDictionary* viewControllers;
@end

@implementation NavigateViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    UINavigationBar *bar = [self.navigationController navigationBar];
    [bar setBarTintColor:[ACColorManager lightBackgroundColor]];
    [bar setTitleTextAttributes:@{NSForegroundColorAttributeName : [ACColorManager foregroundColor]}];
    [bar setTintColor:[ACColorManager foregroundColor]];
    
    self.menu.tableView.delegate = _menu;
    self.menu.tableView.dataSource = _menu;
    self.menu.didSelectRow = ^(NSString* selection, NSString* title){
        [self closeMenu];
        [self displayViewController: selection andTitle:title];
    };
    
    [self setupViewControllers];
    [self displayViewController:[self.menu firstPage] andTitle: [self.menu firstTitle]];

    
    UIImage *image = [UIImage imageWithImage:[UIImage imageNamed:@"menuIcon"] scaledToSize:CGSizeMake(36, 36)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_mainView addGestureRecognizer:panGestureRecognizer];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    
}

-(void) setupViewControllers
{
    self.viewControllers = [NSMutableDictionary dictionary];
    for(NSString* identifier in [self.menu allPages])
    {
        [self.viewControllers setObject:[self.storyboard instantiateViewControllerWithIdentifier:identifier] forKey:identifier];
    }
}

- (void) displayViewController:(NSString*)identifier andTitle:(NSString*) title
{
    self.navigationItem.title = title;
    
    UIViewController *vc = [self.childViewControllers lastObject];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    
    [self.view sendSubviewToBack:self.menu];
    UIViewController *subController = [self.viewControllers objectForKey:identifier];
    
    if([subController isKindOfClass:[EventsViewController class]])
    {
        EventsViewController* evc = (EventsViewController*)subController;
        evc.currentUser = self.currentUser;
    }
    
    if([subController isKindOfClass:[ReposViewController class]])
    {
        ReposViewController* rvc = (ReposViewController*)subController;
        rvc.currentUser = self.currentUser;
    }
    
    if([subController isKindOfClass:[DetailUserViewController class]])
    {
        DetailUserViewController* duvc = (DetailUserViewController*)subController;
        duvc.currentUser = self.currentUser;
    }
    
    if([subController isKindOfClass:[IssuesViewController class]])
    {
        IssuesViewController* ivc = (IssuesViewController*)subController;
        ivc.currentUser = self.currentUser;
    }
    
    [self addChildViewController:subController];
    [subController.view setFrame:CGRectMake(0.0f, 0.0f, self.mainView.frame.size.width, self.mainView.frame.size.height)];
    
    [self.mainView addSubview:subController.view];
    [subController didMoveToParentViewController:self];
}

-(void) closeMenu
{
    CGRect destination = self.mainView.frame;
    destination.origin.x = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = destination;
    }];

}

-(void)buttonPressed:(id)sender {
    
    CGRect destination = self.mainView.frame;
    
    if (destination.origin.x > 0) {
        destination.origin.x = 0;
    } else {
        destination.origin.x = SLIDE_WIDTH;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.frame = destination;
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    static CGPoint originalCenter;
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        originalCenter = self.mainView.center;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [recognizer translationInView:self.view];
        
        if(originalCenter.x + translation.x > self.mainView.frame.size.width / 2 &&
           originalCenter.x + translation.x < self.mainView.frame.size.width / 2 + SLIDE_WIDTH){
           self.mainView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled || recognizer.state == UIGestureRecognizerStateFailed)
    {
        if (self.mainView.frame.origin.x > 80) {
            [UIView animateWithDuration:0.25 animations:^{
               self.mainView.center = CGPointMake(self.mainView.frame.size.width / 2 + SLIDE_WIDTH, self.mainView.center.y);
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
               self.mainView.center = CGPointMake(self.mainView.frame.size.width / 2, self.mainView.center.y);
            }];
        }
    }

}



@end
