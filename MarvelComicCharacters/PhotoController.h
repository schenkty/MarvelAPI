//
//  PhotoController.h
//  MarvelAPI
//
//  Created by Ty Schenk on 08/18/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoController : NSObject

+ (void)imageForPhotoData:(NSDictionary*)photoData completion:(void(^)(UIImage *image))completion;

@end
