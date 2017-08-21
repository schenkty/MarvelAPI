//
//  DetailViewController.m
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import "DetailViewController.h"
#import "PhotoController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [PhotoController imageForPhotoData:[_characterData valueForKey:@"thumbnail"] completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    self.nameLabel.text = [self.characterData valueForKey:@"name"];
    self.descriptionLabel.text = [self.characterData valueForKey:@"description"];
    
    [self setupGestures];
}

- (void)setupGestures {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [longPressGestureRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer*)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.transform = CGAffineTransformMakeTranslation(0, -self.view.frame.size.height);
        self.nameLabel.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, 0);
        self.descriptionLabel.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        NSArray *urls = [self.characterData valueForKey:@"urls"];
        NSString *urlString = [urls[0] valueForKey:@"url"];
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        SFSafariViewController *svc = [[SFSafariViewController alloc] initWithURL:url];
        svc.delegate = self;
        [self presentViewController:svc animated:true completion:nil];
    }
}

@end
