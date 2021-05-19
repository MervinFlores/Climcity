//
//  HomeViewController.swift
//  Climcity
//
//  Created by Mervin Flores on 5/18/21.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {
    @IBOutlet weak var viewSearchContainer: UIView!
    @IBOutlet weak var textFieldSearchBar: CustomTextField!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var customMapView: MKMapView!

    @IBOutlet weak var buttonLogout: UIButton!
    @IBOutlet weak var buttonShowSearch: UIButton!
    @IBOutlet weak var buttonCenterLocation: UIButton!

    // MARK: - View model
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.setMap()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.customMapView.showsUserLocation = true;
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.customMapView.showsUserLocation = false
    }

    @IBAction func buttonSearchTap(_ sender: UIButton) {
        guard let cityForSearch = self.textFieldSearchBar.text else {
            DispatchQueue.main.async() {
                self.present(ClimcityAlert.sharedInstance.unaryAlertWithTitle("Error", Message: "Please type the name of the city"), animated: true, completion: nil)
            }
            return
        }
        
        self.viewModel.searchCityBy(name: cityForSearch)
    }

    @IBAction func buttonShowSearchTap(_ sender: UIButton) {
        self.viewModel.toogleSearchViewContainer()
    }

    @IBAction func buttonCenterLocationTap(_ sender: UIButton) {
        self.viewModel.centerMapToUserLiveLocation()
    }

    @IBAction func buttonLogoutTap(_ sender: UIButton) {
        self.viewModel.logout()
    }
}

extension HomeViewController: CLLocationManagerDelegate, MKMapViewDelegate{
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard let annotation = annotation as? CityAnnotation else { return nil }
//        let identifier = "cityAnnotation"
//        var view: MKMarkerAnnotationView
//
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            view = MKMarkerAnnotationView(
//                annotation: annotation,
//                reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//
//        return view
//    }

        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            self.viewModel.checkLocationAuthorization(authorizationStatus: status)
        }
}


