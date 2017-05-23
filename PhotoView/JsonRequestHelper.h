//
//  JsonRequestHelper.h
//  JsonRequestHelper
//
//  Created by Brian Broom on 8/25/16.
//  Copyright © 2016 Brian Broom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonRequestHelper : NSObject

extern NSString *const APIBaseURL;

+ (void)getJsonWithRequest:(NSURLRequest *)request success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)getJSONFromURL:(NSURL *)url success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)postJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)putJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;
+ (void)deleteJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock;

@end
