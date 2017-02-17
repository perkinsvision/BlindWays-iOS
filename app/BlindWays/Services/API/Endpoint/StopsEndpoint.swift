//
//  StopsEndpoint.swift
//  BlindWays
//
//  Created by Nicholas Bonatsakis on 3/8/16.
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

import Foundation
import Alamofire
import CoreLocation

// MARK: Endpoint

enum Stops {

    case nearby(location: CLLocation)
    case detail(stopID: Int64)
    case track(stopID: Int64)

    case saved
    case save(stopID: Int64)
    case removeSave(stopID: Int64)

    case confirmClue(stopID: Int64, clueID: Int64)
    case rateHelpfulClue(stopID: Int64, clueID: Int64)
    case updateClueSet(stopID: Int64, clueSet: [String: Any])
    case updateStopLocation(stopID: Int64, location: CLLocation)

    case clueTypes

    struct Constants {

        struct Nearby {
            static let defaultDistanceMeters: Double = 2000
            static let defaultResultsLimit: Int = 3
        }

    }

}

extension Stops: APIEndpoint {

    var encoding: Alamofire.ParameterEncoding {
        switch self {
        case .updateClueSet, .updateStopLocation: return Alamofire.JSONEncoding.default
        default: break
        }

        return Alamofire.URLEncoding.default
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .save, .confirmClue, .rateHelpfulClue, .updateClueSet, .updateStopLocation: return .post
        case .removeSave: return .delete
        default: return .get
        }
    }

    var path: String {
        switch self {
        case .nearby: return "/stops/search"
        case .detail(let stopID): return "/stops/\(stopID)"
        case .track(let stopID): return "/stops/\(stopID)/track_view"
        case .saved: return "/saved/stops"
        case .save(let stopID): return "/saved/stops/\(stopID)"
        case .removeSave(let stopID): return "/saved/stops/\(stopID)"
        case .confirmClue(let stopID, let clueID): return "/stops/\(stopID)/clueset/clues/\(clueID)/confirm"
        case .rateHelpfulClue(let stopID, let clueID): return "/stops/\(stopID)/clueset/clues/\(clueID)/ratehelpful"
        case .updateClueSet(let stopID, _): return "/stops/\(stopID)/clueset"
        case .updateStopLocation(let stopID, _): return "/stops/\(stopID)/userlocation"
        case .clueTypes: return "/stops/cluetypes"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .nearby(let location): return [
                "lat": location.coordinate.latitude,
                "lng": location.coordinate.longitude,
                "distance": Stops.Constants.Nearby.defaultDistanceMeters,
                "limit": Stops.Constants.Nearby.defaultResultsLimit,
            ]
        case .updateClueSet(_, let clueSet): return clueSet
        case .updateStopLocation(_, let location): return [
                "lat": location.coordinate.latitude,
                "lng": location.coordinate.longitude,
                "accuracy": location.horizontalAccuracy,
            ]
        default:
            return nil
        }
    }

    var prependAgency: Bool {
        switch self {
        case .clueTypes: return false
        default: return true
        }
    }

}

// MARK: Client

extension APIClient {

    typealias NearbyStopsCompletion = (Alamofire.Result<[Stop]>) -> Void

    @discardableResult func nearbyStops(location: CLLocation, completion: @escaping NearbyStopsCompletion) -> DataRequest {
        let endpoint = Stops.nearby(location: location)
        let request = self.request(endpoint)
        request.responseImportedCollection(completion)

        return request
    }

    typealias StopDetailCompletion = (Alamofire.Result<Stop>) -> Void

    func stopDetail(_ stopID: Int64, completion: @escaping StopDetailCompletion) -> DataRequest {
        let endpoint = Stops.detail(stopID: stopID)
        let request = self.request(endpoint)
        request.responseImportedObject(completion)

        return request
    }

    @discardableResult func trackStop(_ stopID: Int64, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = Stops.track(stopID: stopID)
        return update(endpoint, completion: completion)
    }

    typealias SavedStopsCompletion = (Alamofire.Result<[Stop]>) -> Void

    @discardableResult func savedStops(_ completion: @escaping SavedStopsCompletion) -> DataRequest {
        let endpoint = Stops.saved
        let request = self.request(endpoint)
        request.responseImportedCollection(completion)

        return request
    }

    @discardableResult func saveStop(_ stopID: Int64, saved: Bool, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = saved ? Stops.save(stopID: stopID) : Stops.removeSave(stopID: stopID)
        return update(endpoint, completion: completion)
    }

    @discardableResult func confirmClueForStop(_ stopID: Int64, clueID: Int64, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = Stops.confirmClue(stopID: stopID, clueID: clueID)
        return update(endpoint, completion: completion)
    }

    @discardableResult func rateHelpfulClueForStop(_ stopID: Int64, clueID: Int64, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = Stops.rateHelpfulClue(stopID: stopID, clueID: clueID)
        return update(endpoint, completion: completion)
    }

    func updateClueSetForStop(_ stopID: Int64, clueSet: [String: Any], completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = Stops.updateClueSet(stopID: stopID, clueSet: clueSet)
        return update(endpoint, completion: completion)
    }

    @discardableResult func updateLocationForStop(_ stopID: Int64, location: CLLocation, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let endpoint = Stops.updateStopLocation(stopID: stopID, location: location)
        return update(endpoint, completion: completion)
    }

    struct ClueTypeResult {
        let landmark: [ClueType]
        let busStopSign: [ClueType]
    }

    typealias ClueTypesCompletion = (Alamofire.Result<ClueTypeResult>) -> Void

    @discardableResult func clueTypes(_ completion: @escaping ClueTypesCompletion) -> DataRequest {
        let endpoint = Stops.clueTypes
        let request = self.request(endpoint)
        request.responseJSON { (response) in
            if let error = response.result.error {
                completion(.failure(error))
                return
            }

            guard let value = response.result.value,
                let jsonDict = value as? [String: Any],
                let landmarkArr = jsonDict["landmarks"] as? [[String: Any]],
                let busStopArr = jsonDict["bus_stop_sign"] as? [[String: Any]]  else {
                    completion(.failure(ServiceError.error(with: .invalidResponseContent)))
                return
            }

            if let landmarks = ClueType.rzi_objects(from: landmarkArr) as? [ClueType],
                let busStopSign = ClueType.rzi_objects(from: busStopArr) as? [ClueType] {
                let clueTypeResult = ClueTypeResult(landmark: landmarks, busStopSign: busStopSign)
                completion(.success(clueTypeResult))
            } else {
                completion(.failure(ServiceError.error(with: .invalidResponseContent)))
            }
        }

        return request
    }

    // MARK: Common

    typealias UpdateActionCompletion = (Alamofire.Result<Any>) -> Void

    func update(_ endpoint: Stops, completion: @escaping UpdateActionCompletion) -> DataRequest {
        let request = self.request(endpoint)
        request.responseJSON { (response) in
            completion(response.result)
        }

        return request
    }

}
