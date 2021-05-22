//
//  MapViewController.swift
//  ShoppingApplication
//
//  Created by 大西玲音 on 2021/03/21.
//

import UIKit
import GoogleMaps
import GooglePlaces

final class MapViewController: UIViewController {

    private var currentLocation = CLLocationManager()
    private var mapView = GMSMapView()
    private var userLocationLat: Double = 35.6812226
    private var userLocationLng: Double = 139.7670594

    @IBOutlet private weak var mapSearchBar: UISearchBar! {
        didSet {
            mapSearchBar.backgroundImage = UIImage()
            mapSearchBar.layer.cornerRadius = mapSearchBar.bounds.height / 2
            mapSearchBar.layer.borderWidth = 2
            mapSearchBar.layer.borderColor = UIColor.white.cgColor
            mapSearchBar.layer.shadowColor = UIColor.black.cgColor
            mapSearchBar.layer.shadowOffset = CGSize(width: 3, height: 3)
            mapSearchBar.layer.shadowRadius = 4
            mapSearchBar.layer.shadowOpacity = 0.8
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapSearchBar.delegate = self
        setupMapView()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.view.backgroundColor = UIColor.white.themeColor
        mapSearchBar.backgroundColor = UIColor.white.themeColor

    }

    private func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: userLocationLat, longitude: userLocationLng, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0,
                                                   y: 0.0,
                                                   width: self.view.frame.width,
                                                   height: self.view.frame.height),
                                 camera: camera)
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        currentLocation.delegate = self
        currentLocation.requestWhenInUseAuthorization()
        currentLocation.desiredAccuracy = kCLLocationAccuracyBest
        currentLocation.startUpdatingLocation()
        self.view.addSubview(mapView)
        self.view.bringSubviewToFront(mapView)
        self.view.addSubview(mapSearchBar)
    }

}

extension MapViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        userLocationLat = Double(userLocation!.coordinate.latitude)
        userLocationLng = Double(userLocation!.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude,
                                              zoom: 17.0)
        self.mapView.animate(to: camera)
        currentLocation.stopUpdatingLocation()
    }

}

extension MapViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapSearchBar.resignFirstResponder()
        mapView.clear()

        MapAPIClient.shared.request(searchKeyword: searchBar.text!,
                                    lat: userLocationLat,
                                    lng: userLocationLng) { placeResults in
            switch placeResults {
            case .success(let placeResults):
                if placeResults.isEmpty {
                    let alert = UIAlertController(title: .resultFoundInSurrounding,
                                                  message: .searchResultIsZero,
                                                  preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: .close, style: .cancel)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true)
                } else {
                    placeResults.forEach { placeResult in
                        let latitude = placeResult.geometry.location.lat
                        let longitude = placeResult.geometry.location.lng
                        let marker = GMSMarker()
                        marker.icon = GMSMarker.markerImage(with: .red)
                        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        marker.title = placeResult.name
                        marker.snippet = placeResult.vicinity
                        marker.tracksViewChanges = true
                        marker.map = self.mapView
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
