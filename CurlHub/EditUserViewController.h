//
//  EditUserViewController.h
//  CurlHub
//
//  Created by Arthur Chistyak on 12.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACUser.h"
#import "ACUserViewModel.h"
#import "ACPictureManager.h"

@interface EditUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property NSString* property;
@property NSString* value;
@property ACUser* currentUser;
@end
