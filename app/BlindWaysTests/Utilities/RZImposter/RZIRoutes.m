//
//  RZIRoutes.m
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


#import "RZIRoutes.h"

NSString *const kRZIRequestMatchHeadersKey = @"RZIRequestMatchHeadersKey";

NSString *const kRZIRequestPathParametersKey = @"RZIRequestPathParametersKey";
NSString *const kRZIRequestQueryParametersKey = @"RZIRequestQueryParametersKey";

@implementation RZIRouteInfo
@end

@interface RZIRoutes ()

@property (strong, nonatomic) NSMutableArray *routes;

@end

@implementation RZIRoutes

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.routes = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)allRoutes
{
    return [self.routes copy];
}

- (void)HTTPMethod:(NSString *)HTTPMethod path:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    NSParameterAssert(HTTPMethod);
    NSParameterAssert(path);
    NSParameterAssert(block);

    RZIRouteInfo *routeInfo = [[RZIRouteInfo alloc] init];
    routeInfo.HTTPMethod = HTTPMethod;
    routeInfo.path = path;
    routeInfo.matchDict = matchDict;
    routeInfo.responseBlock = block;

    [self.routes addObject:routeInfo];
}

- (void)get:(NSString *)path do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"GET" path:path match:nil do:block];
}

- (void)get:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"GET" path:path match:matchDict do:block];
}

- (void)head:(NSString *)path do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"HEAD" path:path match:nil do:block];
}

- (void)head:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"HEAD" path:path match:matchDict do:block];
}

- (void)post:(NSString *)path do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"POST" path:path match:nil do:block];
}

- (void)post:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"POST" path:path match:matchDict do:block];
}

- (void)put:(NSString *)path do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"PUT" path:path match:nil do:block];
}

- (void)put:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"PUT" path:path match:matchDict do:block];
}

- (void) delete:(NSString *)path do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"DELETE" path:path match:nil do:block];
}

- (void) delete:(NSString *)path match:(NSDictionary *)matchDict do:(RZItubRouteResponseBlock)block
{
    [self HTTPMethod:@"DELETE" path:path match:matchDict do:block];
}

@end
