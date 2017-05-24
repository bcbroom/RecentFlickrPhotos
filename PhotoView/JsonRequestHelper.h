//
//  JsonRequestHelper.h
//  JsonRequestHelper
//
//  Created by Brian Broom on 8/25/16.
//  Copyright © 2016 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonRequestHelper : NSObject



+ (void)getJsonWithRequest:(NSURLRequest *)request success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
