//
//  APIRouter.h
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRouter : NSObject

+ (NSURLRequest *)recentPhotosRequestForPage:(NSInteger)page;

@end
