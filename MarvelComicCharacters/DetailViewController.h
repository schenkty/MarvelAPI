//
//  DetailViewController.h
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@interface DetailViewController : UIViewController <SFSafariViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) NSDictionary *characterData;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end

