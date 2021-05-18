//
//  GeneralManager.swift
//  Climcity
//
//  Created by Mervin Flores on 5/18/21.
//

import Foundation

class GeneralManager {

    //MARK: - Get List of cities
    enum getCitiesAroundCallback {
        case success([City])
        case empty
        case error
    }

    typealias getCitiesAroundCallbacks = (getCitiesAroundCallback) -> Void

    static func getCitiesAround(lat: Float, lon: Float, cityLimints: Int, callback: @escaping getCitiesAroundCallbacks){
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.getDataFromCitiesAround(lat: lat, lon: lon, cityLimits: cityLimints))) { (res: ListOfCities?, _) in
            guard let cities = res?.list else { callback(.error); return }

            if cities.isEmpty{
                callback(.empty)
            } else {
                callback(.success(cities))
            }
        } onError: { (error, _) in
            callback(.error)
        }
    }

    //MARK: - Get city information
    enum getDataFromCityCallback {
        case success(City)
        case error
    }
    
    typealias getDataFromCityCallbacks = (getDataFromCityCallback) -> Void

    static func getDataFromCity(name: String, callback: @escaping getDataFromCityCallbacks){
        APIClient.executeRequest(req: APIClient.request(GeneralRouter.getDataFromCity(name: name))) { (res: City?, _) in
            guard let city = res else { callback(.error); return }
            callback(.success(city))
        } onError: { (error, _) in
            callback(.error)
        }
    }
}

