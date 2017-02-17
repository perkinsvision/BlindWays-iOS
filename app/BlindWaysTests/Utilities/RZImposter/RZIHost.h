//
//  RZIHost.h
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

@class RZIRoutes;

/**
 Represents an instance of a mocked HTTP host. All registered routes are relative to the host, in this way, multiple hosts for different
 environments can be conditionally created and serve the same set of routes.
 */
@interface RZIHost : NSObject

/**
 *  Create a new host instance with baseURL.
 *
 *  @param baseURL The baseURL for all routes.
 *
 *  @return A new host instance.
 */
- (instancetype)initWithBaseURL:(NSURL *)baseURL;

/**
 *  Register this set of routes with sender. Registering routes will activate these routes via OHHTTPStubs.
 *
 *  @param routes Routes to register.
 */
- (void)registerRoutes:(RZIRoutes *)routes;

@end
