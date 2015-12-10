//
//  ShowLikesViewController.m
//  Muncher
//
//  Created by Connie Shi on 12/8/15.
//  Copyright © 2015 Connie Shi. All rights reserved.
//

#import "ShowLikesViewController.h"

@implementation ShowLikesViewController {
    NSMutableArray *likes;
    PFUser *currentUser;
}

@synthesize tableView;


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getLikes: ^(void) {
        [tableView reloadData];
    }];
    
    NSLog(@"appeared!");
}


-(void) getLikes: (void (^) (void))completion {
    likes = [[NSMutableArray alloc] init];
    currentUser = [PFUser currentUser];
    PFRelation *likesRelation = [currentUser relationForKey:@"likes"];
    [[likesRelation query] findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            likes = [[NSMutableArray alloc] initWithArray: objects];
            completion();
        } else {
            NSLog(@"noooo :(");
        }
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    NSLog(@"%lu", (unsigned long)[likes count]);

    return [likes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    PFObject *obj = [likes objectAtIndex: indexPath.row];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag:100];
    imageView.image = [UIImage imageNamed:@"loading.png"];
    
    UILabel *name = (UILabel*)[cell viewWithTag:101];
    name.text = [obj objectForKey:@"name"];
    
    UILabel *address = (UILabel*)[cell viewWithTag:102];
    address.text = [obj objectForKey:@"address"];
    
    UILabel *cuisine = (UILabel*)[cell viewWithTag:103];
    cuisine.text = [obj objectForKey:@"cuisine"];
    
    UILabel *phone = (UILabel*)[cell viewWithTag:104];
    phone.text = [obj objectForKey:@"phone"];
    
    PFFile *photoFile = [obj objectForKey:@"image"];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            imageView.image = photo;
        }
    }];
    
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(void) tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PFObject *object = [likes objectAtIndex:indexPath.row];
        [likes removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded){
                //we had an error
                // gives the error log and also how it relates to the user.
                NSLog(@"error");
                      }
                      }];
    }
}

@end
