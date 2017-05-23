//
//  JsonRequestHelper.m
//  JsonRequestHelper
//
//  Created by Brian Broom on 8/25/16.
//  Copyright © 2016 Brian Broom. All rights reserved.
//

#import "JsonRequestHelper.h"

@implementation JsonRequestHelper

NSString *const APIBaseURL = @"https://example.com/api/v1/";

+ (void)getJsonWithRequest:(NSURLRequest *)request success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  
  NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (error) {
      NSLog(@"%@", [error localizedDescription]);
      
      if (failureBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{failureBlock(error);});
      }
      return;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if (httpResponse.statusCode < 200 || httpResponse.statusCode >= 300) {
      NSLog(@"Locations returned status: %ld", (long)httpResponse.statusCode);
      NSString *errorDescription = [NSString stringWithFormat:@"Server returned an error for endpoint %@", request.URL];
      NSError *httpError = [NSError errorWithDomain:@"us.foodrescue.APIRequestErrorDomain" code:httpResponse.statusCode userInfo:@{ NSLocalizedDescriptionKey : errorDescription }];
      
      if (failureBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{failureBlock(httpError);});
      }
      return;
    }
    
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
    
    // json here
    if (successBlock) {
      dispatch_async(dispatch_get_main_queue(), ^{successBlock(json);});
    }
    
  }];
  [dataTask resume];
  
}

+ (void)getJSONFromURL:(NSURL *)url success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [JsonRequestHelper getJsonWithRequest:request success:successBlock failure:failureBlock];
}

+ (void)postJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"POST";
  [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
  
  NSError *jsonEncodingError = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:&jsonEncodingError];
  
  if (jsonEncodingError) {
    dispatch_async(dispatch_get_main_queue(), ^{failureBlock(jsonEncodingError);});
    return;
  }
  
  request.HTTPBody = jsonData;
  
  [JsonRequestHelper getJsonWithRequest:request success:successBlock failure:failureBlock];
}

+ (void)putJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"PUT";
  [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
  
  NSError *jsonEncodingError = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:&jsonEncodingError];
  
  if (jsonEncodingError) {
    dispatch_async(dispatch_get_main_queue(), ^{failureBlock(jsonEncodingError);});
    return;
  }
  
  request.HTTPBody = jsonData;
  
  [JsonRequestHelper getJsonWithRequest:request success:successBlock failure:failureBlock];
}

+ (void)deleteJSONToURL:(NSURL *)url withDictionary:(NSDictionary *)info success:(void (^)(id json))successBlock failure:(void (^)(NSError *error))failureBlock {
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"DELETE";
  [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
  
  NSError *jsonEncodingError = nil;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:kNilOptions error:&jsonEncodingError];
  
  if (jsonEncodingError) {
    dispatch_async(dispatch_get_main_queue(), ^{failureBlock(jsonEncodingError);});
    return;
  }
  
  request.HTTPBody = jsonData;
  
  [JsonRequestHelper getJsonWithRequest:request success:successBlock failure:failureBlock];
}
@end
