//
//  NSURL+RZIExtensions.h
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

/**
 *  A set of utilities for obtaining parameter values from tokenized URL paths and query strings.
 */
@interface NSURL (RZIExtensions)

/**
 *  Returns a dictionary containing key-value pairs that represent token replaced path parameters. It is assumed that sender is a templated URL or path like: /users/:id/widgets.
 *
 *  @param populatedURL A URL containing actual path values to be applied to sender.
 *
 *  @return A dictionary with token replaced key-value pairs. If nil, the passed in URL does not match sender and cannot be processed.
 */
- (NSDictionary *)rzi_tokenReplacedPathValuesFromPopulatedURL:(NSURL *)populatedURL;

/**
 *  Returns a dictionary containing key-value pairs that represent token replaced query parameters. It is assumed that sender is a templated URL or path like: /widgets?sort=:sort
 *
 *  @param populatedURL A URL containing actual query parameter values to be applied to sender.
 *
 *  @return A dictionary with token replaced key-value pairs. If nil, the passed in URL does not match sender and cannot be processed.
 */
- (NSDictionary *)rzi_tokenReplacedQueryValuesFromPopulatedURL:(NSURL *)populatedURL;

/**
 *  Produces a dictionary of sender's query parameters.
 *
 *  @return A dictionary of query parameters as key-value pairs.
 */
- (NSDictionary *)rzi_queryParamsAsDictionary;

@end
