//
//  AddRestaurantViewController.m
//  Muncher
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import "AddRestaurantViewController.h"

@implementation AddRestaurantViewController
@synthesize restaurantName, address, cuisine, price, phone, photo, signUp;

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [[UIColor alloc] initWithRed:.92 green:.93 blue:.95 alpha:1]; //the gray background colors
}


- (IBAction)selectPhoto:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:
(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.photo.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)submit:(id)sender {
    if (!restaurantName.hasText || !address.hasText || !cuisine.hasText || !price.hasText || !phone.hasText
        || photo.image == nil){
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Missing Restaurant Info!"
                                      message:@"Please input all fields for the new restaurant before submitting."
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action)
                                    {
                                        //Handle your yes please button action here
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                        
                                    }];
        
        
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (restaurantName.hasText == 1) {
        NSLog (@"has text");
    }
    else {
        NSLog (@"no text");
    }
    PFObject *restaurant = [PFObject objectWithClassName:@"Restaurant"];
    restaurant[@"name"] = restaurantName.text;
    restaurant[@"address"] = address.text;
    restaurant[@"cuisine"] = cuisine.text;
    restaurant[@"price"] = price.text;
    restaurant[@"phone"] = phone.text;
    
    // Convert to JPEG with 50% quality
    NSData* data = UIImageJPEGRepresentation(photo.image, 0.5f);
    PFFile *imageFile = [PFFile fileWithName: restaurantName.text data:data];
    
    // Save the image to Parse
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The image has now been uploaded to Parse. Associate it with a new object
            [restaurant setObject:imageFile forKey:@"image"];
            
            [restaurant saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Saved");
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Submitted!"
                                                  message:@"Added new restaurant. Swipe or add another!"
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action)
                                                {
                                                    //Handel your yes please button action here
                                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                }];

                    
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];


                }
                else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
                restaurantName.text = @"";
                address.text = @"";
                cuisine.text = @"";
                price.text = @"";
                phone.text = @"";
                photo.image = nil;
            }];
        }
    }];
    [restaurant saveInBackground];
    //method to clear options

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}



@end
