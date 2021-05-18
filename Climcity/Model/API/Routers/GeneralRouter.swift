//
//  GeneralRouter.swift
//  Climcity
//
//  Created by Mervin Flores on 5/18/21.
//

import Foundation
import Alamofire

enum GeneralRouter: URLRequestConvertible {
    case getDataFromCity(name: String)
    case getDataFromCitiesAround(lat: Float, lon: Float, cityLimits: Int)

    var method: HTTPMethod {
        switch self {
        case .getDataFromCity:
            return .get
        case .getDataFromCitiesAround:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getDataFromCity:
            return "data/2.5/weather"
        case .getDataFromCitiesAround:
            return "data/2.5/find"
        }
    }

    func asURLRequest() throws -> URLRequest {
        let url = try APIConst.baseURL.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue


        switch self {
        default:
            break
        }

        switch self {
        case .getDataFromCity(let name):
            let searchParams = ["q": name, "appid": APIConst.appID]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
        case .getDataFromCitiesAround(let lat, let lon, let cityLimits):
            let searchParams = ["lat": lat, "lon": lon, "cnt": cityLimits, "appid": APIConst.appID] as [String : Any]
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: searchParams)
        }

        return urlRequest
    }

}

