//
//  EditUserViewController.m
//  CurlHub
//
//  Created by Arthur Chistyak on 12.08.16.
//  Copyright © 2016 ArthurChistyak. All rights reserved.
//

#import "EditUserViewController.h"

@interface EditUserViewController() <UITextFieldDelegate>

@end

@implementation EditUserViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    ACUser* user = [ACUserViewModel systemUser];
    [ACPictureManager downloadImageByUrlAsync:user.avatarUrl andCompletion:^(UIImage* image)
     {
         self.avatarImage.image = image;
         self.avatarImage.layer.cornerRadius = self.avatarImage.frame.size.height /2;
         self.avatarImage.layer.masksToBounds = YES;
         self.avatarImage.layer.borderWidth = 0;
     }];
    
    if(self.property && ![self.property isKindOfClass:[NSNull class]]) self.nameLabel.text = self.property;
    if(self.value && ![self.value isKindOfClass:[NSNull class]]) self.nameField.text = self.value;

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

-(void) doneButtonPressed
{
    if(self.nameField.text.length > 0 && self.nameField.text.length < 256)
    {
        [[[ACUserViewModel alloc] init] updateUserAsync:@{self.nameLabel.text.lowercaseString : self.nameField.text} andUser:[ACUserViewModel systemUser] completion:nil];
        if([self.property.lowercaseString  isEqual: @"name"]) ACUserViewModel.systemUser.name = self.nameField.text;
        if([self.property.lowercaseString  isEqual: @"company"]) ACUserViewModel.systemUser.company = self.nameField.text;
        if([self.property.lowercaseString  isEqual: @"location"]) ACUserViewModel.systemUser.location = self.nameField.text;
        if([self.property.lowercaseString  isEqual: @"email"]) ACUserViewModel.systemUser.email = self.nameField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self animateTextField: textField up: YES];
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self animateTextField: textField up: NO];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80;
    const float movementDuration = 0.3f;
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
