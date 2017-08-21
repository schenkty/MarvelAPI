//
//  CollectionViewController.h
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>

@property (nonatomic) NSArray *charactersArray;
@property (nonatomic) NSInteger apiPage;

@end
