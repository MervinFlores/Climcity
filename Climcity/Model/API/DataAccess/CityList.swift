//
//  CityList.swift
//  Climcity
//
//  Created by Mervin Flores on 5/18/21.
//

import Foundation
import Argo
import Curry
import Runes

// MARK: - ListOfCities
struct ListOfCities: Argo.Decodable {
    var message: String?
    var list: [City]?

    static func decode(_ json: JSON) -> Decoded<ListOfCities> {
        let listOfCities = curry(ListOfCities.init(message:list:))
        return listOfCities
            <^> json <|? "message"
            <*> json <||? "list"
    }
}

// MARK: - City
struct City {
    var name: String?
    var coord: Coord?
    var weather: [Weather]?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var clouds: Clouds?
    var id: Int?
}

extension City: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<City> {
        let cityBean = curry(City.init(name:coord:weather:main:visibility:wind:clouds:id:))
        return cityBean
            <^> json <|? "name"
            <*> json <|? "coord"
            <*> json <||? "weather"
            <*> json <|? "main"
            <*> json <|? "visibility"
            <*> json <|? "wind"
            <*> json <|? "clouds"
            <*> json <|? "id"
    }
}

// MARK: - Clouds
struct Clouds: Argo.Decodable {
    let all: Int?

    static func decode(_ json: JSON) -> Decoded<Clouds> {
        let cloudsBean = curry(Clouds.init)
        return cloudsBean
            <^> json <|? "all"
    }
}

// MARK: - Coord
struct Coord: Argo.Decodable {
    var lon, lat: Double?

    static func decode(_ json: JSON) -> Decoded<Coord> {
        let coord = curry(Coord.init(lon:lat:))
        return coord
            <^> json <|? "lon"
            <*> json <|? "lat"
    }
}

// MARK: - Main
struct Main {
    var temp: Float?
    var feels_like: Float?
    var temp_min: Float?
    var temp_max: Float?
    var pressure: Float?
    var humidity: Int?
}

extension Main: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Main> {
        let main = curry(Main.init(temp:feels_like:temp_min:temp_max:pressure:humidity:))
        return main
            <^> json <|? "temp"
            <*> json <|? "feels_like"
            <*> json <|? "temp_min"
            <*> json <|? "temp_max"
            <*> json <|? "pressure"
            <*> json <|? "humidity"
    }
}

// MARK: - Weather
struct Weather {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

extension Weather: Argo.Decodable {
    static func decode(_ json: JSON) -> Decoded<Weather> {
        let weather = curry(Weather.init(id:main:description:icon:))
        return weather
        <^> json <|? "id"
        <*> json <|? "main"
        <*> json <|? "description"
        <*> json <|? "icon"
    }
}

// MARK: - Wind
struct Wind: Argo.Decodable {
    var speed: Double?
    var deg: Int?

    static func decode(_ json: JSON) -> Decoded<Wind> {
        let wind = curry(Wind.init(speed:deg:))
        return wind
            <^> json <|? "speed"
            <*> json <|? "deg"
    }
}
