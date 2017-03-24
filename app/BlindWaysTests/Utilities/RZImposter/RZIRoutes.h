//
//  RZIRoutes.h
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 4/12/16.
//  Copyright© 2016 Perkins School for the Blind
//
//  All "Perkins Bus Stop App" Software is licensed under Apache Version 2.0.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@import Foundation;
#import <OHHTTPStubs/OHHTTPStubs.h>

typedef OHHTTPStubsResponse * (^RZItubRouteResponseBlock)(NSURLRequest *request, NSDictionary *requestInfo);

// MATCHER KEYS

/**
 *  Use this key in the "match" parameter of a route in order to match on HTTP header key-value pairs.
 */
OBJC_EXTERN NSString *const kRZIRequestMatchHeadersKey;

// REQUEST PARAMS

/**
 *  Used to lookup the token replaced path parameters in a requestInfo dictionary.
 */
OBJC_EXTERN NSString *const kRZIRequestPathParametersKey;
/**
 *  Used to lookup the query parameters in a requestInfo dictionary.
 */
OBJC_EXTERN NSString *const kRZIRequestQueryParametersKey;

@interface RZIRouteInfo : NSObject

@property (copy, nonatomic) NSString *path;
@property (copy, nonatomic) NSString *HTTPMethod;
@property (copy, nonatomic) NSDictionary *matchDict;
@property (copy, nonatomic) RZItubRouteResponseBlock responseBlock;

@end

/**
 *  A set of routes that define HTTP request mocking behavior based on HTTP method, path, query, and other match items.
 */
@interface RZIRoutes : NSObject

/**
 *  A list of all individual route info objects for this route set.
 */
@property (strong, nonatomic, readonly) NSArray *allRoutes;

/**
 *  Mock an HTTP GET for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param block The response block to invoke on match.
 */
- (void)get:(NSString *)path do:(RZItubRouteResponseBlock)block;
/**
 *  Mock an HTTP GET for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param matchDict  Additional match conditions such as HTTP header matching.
 *  @param block The response block to invoke on match.
 */
- (void)get:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block;

/**
 *  Mock an HTTP HEAD for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param block The response block to invoke on match.
 */
- (void)head:(NSString *)path do:(RZItubRouteResponseBlock)block;
/**
 *  Mock an HTTP HEAD for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param matchDict  Additional match conditions such as HTTP header matching.
 *  @param block The response block to invoke on match.
 */
- (void)head:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block;

/**
 *  Mock an HTTP POST for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param block The response block to invoke on match.
 */
- (void)post:(NSString *)path do:(RZItubRouteResponseBlock)block;
/**
 *  Mock an HTTP POST for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param matchDict  Additional match conditions such as HTTP header matching.
 *  @param block The response block to invoke on match.
 */
- (void)post:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block;

/**
 *  Mock an HTTP PUT for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param block The response block to invoke on match.
 */
- (void)put:(NSString *)path do:(RZItubRouteResponseBlock)block;
/**
 *  Mock an HTTP PUT for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param matchDict  Additional match conditions such as HTTP header matching.
 *  @param block The response block to invoke on match.
 */
- (void)put:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block;

/**
 *  Mock an HTTP DELETE for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param block The response block to invoke on match.
 */
- (void) delete:(NSString *)path do:(RZItubRouteResponseBlock)block;
/**
 *  Mock an HTTP DELETE for the given path by responding with block.
 *
 *  @param path  The relative path to match.
 *  @param matchDict  Additional match conditions such as HTTP header matching.
 *  @param block The response block to invoke on match.
 */
- (void) delete:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block;

@end
