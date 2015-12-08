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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getLikes: ^(void) {
        [tableView reloadData];
    }];
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
    return [likes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    PFObject *obj = [likes objectAtIndex: indexPath.row];
    NSString* name = [obj objectForKey:@"name"];
    cell.textLabel.text = name;
    cell.imageView.image = [UIImage imageNamed:@"loading.png"];
    
    PFFile *photoFile = [obj objectForKey:@"image"];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *photo = [UIImage imageWithData:data];
            cell.imageView.image = photo;
        }
    }];
    
    return cell;
}

@end
