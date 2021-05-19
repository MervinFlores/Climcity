//
//  HomeViewModel.swift
//  Climcity
//
//  Created by Mervin Flores on 5/18/21.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewModel{

    private var viewController: HomeViewController?

    var locationManager: CLLocationManager?
    var myLocation: CLLocationCoordinate2D?
    var lastCitySearched: City?

    init(viewController: HomeViewController) {
        self.viewController = viewController
        return
    }

    func centerMapToUserLiveLocation(){
        guard let homeViewController = self.viewController else { return }
        guard let userLatitude = self.locationManager?.location?.coordinate.latitude else { return }
        guard let userLongitude = self.locationManager?.location?.coordinate.longitude else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: userLatitude, longitude: userLongitude), span: span)

        homeViewController.customMapView.setRegion(region, animated: true)

        guard let cities = self.citiesAround else { self.getCitiesAround(lat: Float(userLatitude), lon: Float(userLongitude)); return }
        if cities.isEmpty{
            self.getCitiesAround(lat: Float(userLatitude), lon: Float(userLongitude))
        }

    }

    var citiesAround: [City]?
    private func getCitiesAround(lat: Float, lon: Float){
        guard let homeViewController = self.viewController else { return }
        homeViewController.view.showLoading()
        GeneralManager.getCitiesAround(lat: lat, lon: lon, cityLimints: 30) { (response) in
            homeViewController.view.dismissLoading()
            switch response{
            case .success(let cities):
                self.citiesAround = cities
                self.loadMarks()
            case .empty:
                DispatchQueue.main.async() {
                    homeViewController.present(ClimcityAlert.sharedInstance.unaryAlertWithTitle("Not found", Message: "Not city found with this name"), animated: true, completion: nil)
                }
            case .error:
                DispatchQueue.main.async() {
                    homeViewController.present(ClimcityAlert.sharedInstance.unaryAlertWithTitle("Error", Message: "An error has occurred, please try again later"), animated: true, completion: nil)
                }
                break
            }
        }
    }

    private func loadMarks(){
        guard let homeViewController = self.viewController else { return }
        guard let cities = self.citiesAround else { return }

        for city in cities {
            if let lat = city.coord?.lat,
               let lon = city.coord?.lon,
               let name = city.name{
                let artwork = CityAnnotation(
                    title: name,
                    subtitle: "🌡\(city.main?.getStringTempInCelsius() ?? "??")C \n☁️\(city.clouds?.all ?? 30)% \n💧\(city.main?.humidity ?? 60)% \n💨\(city.main?.pressure ?? 940)hPa",
                    coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                homeViewController.customMapView.addAnnotation(artwork)
            }
        }
    }

    func searchCityBy(name: String){
        guard let homeViewController = self.viewController else { return }
        homeViewController.view.showLoading()
        GeneralManager.getDataFromCity(name: name) { (response) in
            homeViewController.view.dismissLoading()
            switch response{
            case .success(let city):
                self.centerMapToLocation(lat: Float(city.coord?.lat ?? 0.0), lon: Float(city.coord?.lon ?? 0.0), city: city)
            case .error:
                DispatchQueue.main.async() {
                    homeViewController.present(ClimcityAlert.sharedInstance.unaryAlertWithTitle("Not found", Message: "Not city found with this name"), animated: true, completion: nil)
                }
                return
            }
        }
    }

    func centerMapToLocation(lat: Float, lon: Float, city: City?){
        guard let homeViewController = self.viewController else { return }

        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon)), span: span)

        homeViewController.customMapView.setRegion(region, animated: true)
        guard let searchedCity = city else { return }
        self.manageCenteredPin(citySearched: searchedCity)
    }

    func manageCenteredPin(citySearched: City) {
        guard let homeViewController = self.viewController else { return }
        let allAnnotationsOfMap = homeViewController.customMapView.annotations

        if self.lastCitySearched != nil{
            for cityAnnotation in allAnnotationsOfMap{
                if cityAnnotation.title == self.lastCitySearched?.name {
                    homeViewController.customMapView.removeAnnotation(cityAnnotation)
                }
            }
        }

        if let lat = citySearched.coord?.lat,
           let lon = citySearched.coord?.lon,
           let name = citySearched.name{

            let artwork = CityAnnotation(
                title: name,
                subtitle: "🌡\(citySearched.main?.getStringTempInCelsius() ?? "??")C \n☁️\(citySearched.clouds?.all ?? 30)% \n💧\(citySearched.main?.humidity ?? 60)% \n💨\(citySearched.main?.pressure ?? 940)hPa",
                coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))

            homeViewController.customMapView.addAnnotation(artwork)
            self.lastCitySearched = citySearched
        }
    }

    func checkLocationAuthorization(authorizationStatus: CLAuthorizationStatus? = nil) {
        guard let homeViewController = self.viewController else { return }
        switch (authorizationStatus ?? CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            homeViewController.customMapView.showsUserLocation = true
        case .notDetermined:
            if locationManager == nil {
                locationManager = CLLocationManager()
                locationManager!.delegate = homeViewController
            }
            locationManager!.requestWhenInUseAuthorization()
        default:
            print("Location Servies: Denied / Restricted")
        }
    }

    func setMap(){
        guard let homeViewController = self.viewController else { return }
        self.locationManager = CLLocationManager()
        // Ask for Authorisation from the User.
        self.locationManager?.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            self.locationManager?.delegate = homeViewController
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager?.startUpdatingLocation()
        }

        homeViewController.customMapView.delegate = homeViewController
        homeViewController.customMapView.mapType = .standard
        homeViewController.customMapView.isZoomEnabled = true
        homeViewController.customMapView.isScrollEnabled = true

        if let coor = homeViewController.customMapView.userLocation.location?.coordinate{
            homeViewController.customMapView.setCenter(coor, animated: true)
        }

        self.centerMapToUserLiveLocation()
    }

    func logout(){
        let container = try! Container()

        try! container.write { transaction in
            transaction.deleteAll()
        }

        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appdelegate.setLoginScreen()
    }

    func toogleSearchViewContainer(){
        guard let homeViewController = self.viewController else { return }

        UIView.animate(withDuration: 1.0) {
            homeViewController.viewSearchContainer.alpha = (homeViewController.viewSearchContainer.alpha == 1.0 ? 0.0 : 1.0)
        }
    }
}
