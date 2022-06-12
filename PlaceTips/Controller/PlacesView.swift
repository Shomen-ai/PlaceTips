import CoreLocation
import MapKit
import PanModal
import UIKit
import Firebase

final class PlacesView: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupNavigationBar()
        view.addSubview(mapView)
        view.addSubview(addButton)
        view.addSubview(showUser)
        
        setupMapConstraints()
        setUpAddButtonConstraints()
        setUpShowUserButtonConstraints()
        
        checkLocationServices()
        checkAuthorizationForLocation()
    }
    
    // MARK: - Some Data

    func getCity(location: CLLocation) {
        location.getCity { [weak self] city, error in
            guard let city = city, error == nil else { return }
            guard let self = self else { return }
            self.cityName = String(city)
        }
    }
    
    // Название города
    var cityName: String = "" {
        didSet {
            DBManager.shared.getPlacesData(cityName: cityName) { places in
                self.places = places
                DBManager.shared.places = places
            }
            
        }
    }
    
    
    var places: [Place] = [] {
        didSet {
            for place in places {
                let location = CLLocationCoordinate2D(latitude: place.lat, longitude: place.lon)
                DispatchQueue.main.async {
                    self.setPinUsingMKPointAnnotation(location: location, description: place.placeName, id: place.id)
                }
            }
            DispatchQueue.main.async {
                self.zoomToUserLocation()
            }
        }
    }

    private func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Map

    lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.showsUserLocation = true
        map.delegate = self
        return map
    }()

    // MARK: - SetUp Map constaints

    func setupMapConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func zoomToUserLocation() {
        let userLocation = CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0,
                                                  longitude: locationManager.location?.coordinate.longitude ?? 0.0)
        let viewRegion = MKCoordinateRegion(center: userLocation, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
    }

    // подумать как сделать цвет у пинов разный
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D, description: String, id: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = description
        annotation.subtitle = id
        let coordinateRegion = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.addAnnotation(annotation)
    }

    private let reuseIdentifier = "MyIdentifier"

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.tintColor = .green // do whatever customization you want
            annotationView?.canShowCallout = false // but turn off callout
        } else {
            annotationView?.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let vc = PinInfoViewController()
        for i in 0 ..< places.count {
            if view.annotation?.subtitle == places[i].id {
                vc.placeName = places[i].placeName
                vc.other = places[i].other ?? "-"
                vc.id = places[i].id
                vc.cityName = cityName
                break
            }
        }
        presentPanModal(vc)
    }

    // MARK: - Add Button

    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 50/2
        button.clipsToBounds = true
        button.backgroundColor = .white
        
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        return button
    }()

    @objc func addTap(_: UITapGestureRecognizer) {
        let vc = AddViewController()
        vc.cityName = cityName
        vc.lat = locationManager.location?.coordinate.latitude ?? 0.0
        vc.lon = locationManager.location?.coordinate.longitude ?? 0.0
        vc.count = places.count
        presentPanModal(vc)
    }
    
    func setUpAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0)
        ])
    }
    
    // MARK: - Show Users Location button
    
    private let showUser: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 50/2
        button.clipsToBounds = true
        button.backgroundColor = .white
        
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.addTarget(self, action: #selector(showUserAction), for: .touchUpInside)
        return button
    }()

    @objc func showUserAction(_: UITapGestureRecognizer) {
        zoomToUserLocation()
    }
    
    func setUpShowUserButtonConstraints() {
        showUser.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            showUser.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10.0),
            showUser.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0)
        ])
    }
    
    // MARK: - Loacation Manager

    private let locationManager = CLLocationManager()

    let location = CLLocation(latitude: CLLocationManager().location?.coordinate.latitude ?? 0.0,
                              longitude: CLLocationManager().location?.coordinate.longitude ?? 0.0)

    private func checkLocationServices() {
        guard CLLocationManager.locationServicesEnabled() else {
            // Here we must tell user how to turn on location on device
            return
        }

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    @objc func goBack(_: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }

    private func checkAuthorizationForLocation() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            // Here we must tell user how to turn on location on device
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Here we must tell user that the app is not authorize to use location services
            break
        @unknown default:
            break
        }
    }
}

// MARK: - Extension for CLLLocationManager

extension PlacesView: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationForLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            getCity(location: location)
            DBManager.shared.getUserData(userUID: Auth.auth().currentUser!.uid) { userData in
                DBManager.shared.userData = userData
            }
        }
    }
}

extension CLLocation {
    func getCity(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self,
                                            preferredLocale: .init(identifier: "en_US"),
                                            completionHandler: { completion($0?.first?.locality, $1) })
    }
}

extension PlacesView: MKMapViewDelegate {}
