//
//  JsonRequestHelper.m
//  JsonRequestHelper
//
//  Created by Brian Broom on 8/25/16.
//  Copyright © 2016 Brian Broom. All rights reserved.
//

#import "JsonRequestHelper.h"

@implementation JsonRequestHelper

// executes the failure block if
//    1. NSURLSession returns an error - not sure when this happens
//    2. API returns a status code >= 400
//    3. Response data fails to convert to JSON
// executes success block otherwise

// parameter blocks are called on main thread, as they will usually have UI interactions

+ (void)getJsonWithRequest:(NSURLRequest *)request success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    // OS error
    
    if (error) {
      NSLog(@"%@", [error localizedDescription]);
      
      if (failureBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{failureBlock(error);});
      }
      return;
    }
    
    // API returns error code
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode >= 400) {
      NSLog(@"Locations returned status: %ld", (long)httpResponse.statusCode);
      NSString *errorDescription = [NSString stringWithFormat:@"Server returned an error for endpoint %@", request.URL];
      NSError *httpError = [NSError errorWithDomain:@"net.learningobjective.APIRequestErrorDomain" code:httpResponse.statusCode userInfo:@{ NSLocalizedDescriptionKey : errorDescription }];
      
      if (failureBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{failureBlock(httpError);});
      }
      return;
    }
    
    // convert response data to JSON
    
    NSError *jsonError = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
    
    if (jsonError) {
      NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      NSLog(@"%@", returnString);
      
      if (failureBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{failureBlock(jsonError);});
      }
      return;
    }
    
    // valid JSON at this point
    if (successBlock) {
      dispatch_async(dispatch_get_main_queue(), ^{successBlock(json);});
    }
    
  }];
  [dataTask resume];
  
}

@end
