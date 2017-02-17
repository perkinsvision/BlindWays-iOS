//
//  RZIHost.m
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

#import "RZIHost.h"
#import "OHHTTPStubs.h"
#import "RZIRoutes.h"
#import "NSURL+RZIExtensions.h"
#import "NSURLRequest+RZIExtensions.h"

@interface RZIHost ()

@property (copy, nonatomic) NSURL *baseURL;

@end

@implementation RZIHost

- (instancetype)initWithBaseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = baseURL;
    }
    return self;
}

- (void)dealloc
{
    // TODO: be more selective
    [OHHTTPStubs removeAllStubs];
}

- (void)registerRoutes:(RZIRoutes *)routes
{
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        // TODO: match on scheme too? Probably
        if ([request.URL.host isEqualToString:self.baseURL.host] && [request.URL.port intValue] == [self.baseURL.port intValue]) {
            return [self findRouteInfoFromRoutes:routes forRequest:request] != nil;
        }

        return NO;
    }
                        withStubResponse:
                            ^OHHTTPStubsResponse *(NSURLRequest *request) {
                                RZIRouteInfo *routeInfo = [self findRouteInfoFromRoutes:routes forRequest:request];
                                NSMutableDictionary *params = [NSMutableDictionary dictionary];

                                NSString *routePath = [self.baseURL.path stringByAppendingPathComponent:routeInfo.path];
                                NSDictionary *pathParams = [[NSURL URLWithString:routePath] rzi_tokenReplacedPathValuesFromPopulatedURL:request.URL];
                                if (pathParams != nil) {
                                    params[kRZIRequestPathParametersKey] = pathParams;
                                }

                                NSDictionary *queryParams = [request.URL rzi_queryParamsAsDictionary];
                                if (queryParams != nil) {
                                    params[kRZIRequestQueryParametersKey] = queryParams;
                                }

                                OHHTTPStubsResponse *stubResp = nil;
                                if (routeInfo != nil) {
                                    stubResp = routeInfo.responseBlock(request, [params copy]);
                                }

                                return stubResp;
                            }];
}

- (RZIRouteInfo *)findRouteInfoFromRoutes:(RZIRoutes *)routes forRequest:(NSURLRequest *)request
{
    RZIRouteInfo *foundRoute = nil;

    for (RZIRouteInfo *routeInfo in routes.allRoutes) {
        NSString *testPath = [self.baseURL.path stringByAppendingPathComponent:routeInfo.path];
        BOOL matchesPath = [[NSURL URLWithString:testPath] rzi_tokenReplacedPathValuesFromPopulatedURL:request.URL] != nil;

        BOOL matchesHeaders = YES;
        NSDictionary *headersToMatch = routeInfo.matchDict[kRZIRequestMatchHeadersKey];
        if (headersToMatch != nil) {
            matchesHeaders = [request rzi_containsHeaders:headersToMatch];
        }

        if (matchesPath && matchesHeaders) {
            foundRoute = routeInfo;
            break;
        }
    }

    return foundRoute;
}

@end
