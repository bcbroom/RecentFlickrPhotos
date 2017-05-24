//
//  Photo.h
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (copy, nonatomic) NSString *photoID;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *smallPhotoUrl;
@property (copy, nonatomic) NSString *largePhotoUrl;
@property (copy, nonatomic) NSString *takenOnDate;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end
