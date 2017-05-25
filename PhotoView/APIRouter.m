//
//  APIRouter.m
//  PhotoView
//
//  Created by Brian Broom on 5/23/17.
//  Copyright © 2017 Learning Objective. All rights reserved.
//

#import "APIRouter.h"

@implementation APIRouter

// rest?method=flickr.photos.getRecent&api_key=89d67241ccf87a60cf2b2b11b6217741&format=json&nojsoncallback=1

static NSString *const APIBaseURL = @"https://api.flickr.com/services/";

+ (NSURLComponents *)baseComponents {
  NSURLComponents *components = [NSURLComponents new];
  
  components.scheme = @"https";
  components.host = @"api.flickr.com";
  
  components.path = @"/services/rest";
  
  NSURLQueryItem *keyItem = [NSURLQueryItem queryItemWithName:@"api_key" value:@"6933b25fd227586003ecc5001ff16b95"];
  NSURLQueryItem *formatItem = [NSURLQueryItem queryItemWithName:@"format" value:@"json"];
  NSURLQueryItem *callbackItem = [NSURLQueryItem queryItemWithName:@"nojsoncallback" value:@"1"];
  components.queryItems = @[ keyItem, formatItem, callbackItem];
  
  return components;
}

+ (NSURLRequest *)recentPhotosRequest {
  
  NSURLComponents *components = [APIRouter baseComponents];
  
  NSURLQueryItem *methodItem = [NSURLQueryItem queryItemWithName:@"method" value:@"flickr.photos.getRecent"];
  NSURLQueryItem *extraItem = [NSURLQueryItem queryItemWithName:@"extras" value:@"url_q,url_l,date_taken"];
  components.queryItems = [components.queryItems arrayByAddingObjectsFromArray:@[methodItem, extraItem]];
  
  return [NSMutableURLRequest requestWithURL:components.URL];
}

//+ (NSURLRequest *)examplePostRequestWithModel:(NSObject *)model jsonEncodingError:(NSError *)error {
//  NSString *urlString = @"/posts";
//  NSURL *url = [NSURL URLWithString:urlString relativeToURL:[NSURL URLWithString:@"http://jsonplaceholder.typicode.com"]];
//  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//  
//  request.HTTPMethod = @"POST";
//  [request addValue:@"application/json" forHTTPHeaderField:@"content-type"];
//  
//  // convert model to NSDictionary
//  // either here or with a conversion class
//  NSDictionary *modelInfo = @{};
//  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:modelInfo options:kNilOptions error:&error];
//  
//  if (error) {
//    return nil;
//  }
//  
//  request.HTTPBody = jsonData;
//  return request;
//}

@end
