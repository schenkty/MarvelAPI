//
//  CharacterCollectionViewCell.h
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterCollectionViewCell : UICollectionViewCell

@property (nonnull) IBOutlet UIImageView *photoView;
@property (nonnull, nonatomic) NSDictionary *photoData;

@end
