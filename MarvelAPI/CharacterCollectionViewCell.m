//
//  CharacterCollectionViewCell.m
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import "CharacterCollectionViewCell.h"
#import "PhotoController.h"

@implementation CharacterCollectionViewCell

- (void)setPhotoData:(NSDictionary *)photoData{
    _photoData = photoData;
    
    [PhotoController imageForPhotoData:photoData completion:^(UIImage *image) {
        self.photoView.image = image;
    }];
}

@end
