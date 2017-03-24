//
//  NSURL+RZIExtensions.m
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

#import "NSURL+RZIExtensions.h"

@implementation NSURL (RZIExtensions)

- (NSDictionary *)rzi_tokenReplacedPathValuesFromPopulatedURL:(NSURL *)populatedURL
{
    NSParameterAssert(populatedURL);
    BOOL lengthMatch = self.pathComponents.count == populatedURL.pathComponents.count;
    if (!lengthMatch) {
        return nil;
    }

    NSMutableDictionary *results = [NSMutableDictionary dictionary];
    for (int i = 0; i < self.pathComponents.count; i++) {
        NSString *templateComponent = self.pathComponents[i];
        NSString *valueComponent = populatedURL.pathComponents[i];
        if ([templateComponent containsString:@":"]) {
            NSString *key = [templateComponent stringByReplacingOccurrencesOfString:@":" withString:@""];
            results[key] = valueComponent;
        }
        else if (![templateComponent isEqualToString:valueComponent]) {
            results = nil;
            break;
        }
    }

    return [results copy];
}

- (NSDictionary *)rzi_tokenReplacedQueryValuesFromPopulatedURL:(NSURL *)populatedURL
{
    __block NSMutableDictionary *results = [NSMutableDictionary dictionary];

    NSDictionary *templateParams = [self rzi_queryParamsAsDictionary];
    NSDictionary *valueParams = [populatedURL rzi_queryParamsAsDictionary];

    [templateParams enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *populatedVal = valueParams[key];
        if (populatedVal) {
            results[key] = populatedVal;
        }
        else {
            results = nil;
            *stop = YES;
        }
    }];

    return [results copy];
}

- (NSDictionary *)rzi_queryParamsAsDictionary
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    if (self.query) {
        NSArray *queryPairs = [self.query componentsSeparatedByString:@"&"];
        for (NSString *queryPair in queryPairs) {
            NSArray *queryPairArr = [queryPair componentsSeparatedByString:@"="];
            if (queryPairArr.count == 2) {
                result[queryPairArr[0]] = queryPairArr[1];
            }
        }
    }

    return [result copy];
}

@end
