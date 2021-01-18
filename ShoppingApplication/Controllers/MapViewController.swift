
import UIKit
import GoogleMaps
import GooglePlaces
import Alamofire

final class MapViewController: UIViewController {
    
    private enum Parameter: String {
        case apiKey = "AIzaSyA6zhP2dUBGYTQl1dJ8pjSJoyk67KnQil8"
        case baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
    }
    private var themeColor: UIColor {
        guard let themeColorString = UserDefaults.standard.string(forKey: "themeColorKey") else {
            return .white
        }
        return UIColor(code: themeColorString)
    }
    private var currentLocation = CLLocationManager()
    private var mapView = GMSMapView()
    private var placeResults = [PlaceResults]()
    private var userLocationLat: Double = 35.6812226
    private var userLocationLng: Double = 139.7670594
    @IBOutlet weak var mapSearchBar: UISearchBar! {
        didSet {
            mapSearchBar.delegate = self
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
        setupMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = themeColor
        mapSearchBar.backgroundColor = themeColor
    }
    
    private func setupMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: 35.6812226, longitude: 139.7670594, zoom: 17.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0.0, y: 0, width: self.view.frame.width, height: self.view.frame.height), camera: camera)
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
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 17.0)
        self.mapView.animate(to: camera)
        currentLocation.stopUpdatingLocation()
    }
}

extension MapViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapSearchBar.resignFirstResponder()
        mapView.clear()
        let searchKeyword: String = searchBar.text!
        let urlString = "\(Parameter.baseURL.rawValue)?location=\(userLocationLat),\(userLocationLng)&language=ja&radius=2000&keyword=\(searchKeyword)&key=\(Parameter.apiKey.rawValue)"
        print(Parameter.apiKey)
        guard let encodeUrlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let request = AF.request(encodeUrlString)
        request.responseJSON { [self] (response) in
            guard let data = response.data else { return }
            let decoder = JSONDecoder()
            let place = try! decoder.decode(Place.self, from: data)
            placeResults = place.results
            if placeResults.count != 0 {
                for n in 0...placeResults.count - 1 {
                    let latitude = placeResults[n].geometry.location.lat
                    let longitude = placeResults[n].geometry.location.lng
                    let marker = GMSMarker()
                    marker.icon = GMSMarker.markerImage(with: .red)
                    marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    marker.title = placeResults[n].name
                    marker.snippet = placeResults[n].vicinity
                    marker.tracksViewChanges = true
                    marker.map = mapView
                }
            }else {
                let alert = UIAlertController(title: "周辺で探した結果", message: "検索結果は0です", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "閉じる", style: .cancel)
                alert.addAction(cancelAction)
                present(alert, animated: true)
            }
        }
    }
}
