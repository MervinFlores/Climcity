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

    @IBOutlet weak var viewMyLocationContainer: UIView!
    @IBOutlet weak var labelMyLocationTitle: UILabel!
    @IBOutlet weak var labelMyLocationInfo: UILabel!

    // MARK: - View model
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel(viewController: self)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.setMap()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.viewModel.shapeViews()
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.viewModel.checkLocationAuthorization(authorizationStatus: status)
    }
}


