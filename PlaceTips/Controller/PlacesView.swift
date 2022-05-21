import CoreLocation
import MapKit
import PanModal
import UIKit

final class PlacesView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(mapView)
        view.addSubview(addButton)
        setupMapConstraints()
        checkLocationServices()
        zoomToUserLocation()
        getCity(location: location)
        getPlaces(city: cityName)
        print(places)
        print(cityName)
//        setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D(latitude: locationManager.location?.coordinate.latitude ?? 0.0,
//                                                                      longitude: locationManager.location?.coordinate.longitude ?? 0.0),
//                                     description: "Here")
    }

    // Название города

    func getPlaces(city: String) {
        DataBaseService.shared.getData(city: city) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                self.places = response
            case .failure(let error):
                print(error)
            }
        }
    }

    func getCity(location: CLLocation) {
        location.getCity { [weak self] city, error in
            guard let city = city, error == nil else { return }
            guard let self = self else { return }
            self.cityName = String(city)
        }
    }

    // Название города
    var cityName: String = ""

//    // Зарос на получение данных с бд
    var places: [Places] = []

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
    func setPinUsingMKPointAnnotation(location: CLLocationCoordinate2D, description: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = description // короче, сюда надо забивать то, как пользователь назвал место
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
        presentPanModal(PinInfoViewController())
    }

    // MARK: - Add Button

    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: 58, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 10.0, height: 10.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 1.0
        button.setImage(UIImage(systemName: "plus"), for: .normal) // заменить на плюсик, хз как он называется в поле systemName
        button.addTarget(self, action: #selector(addTap), for: .touchUpInside)
        return button
    }()

    @objc func addTap(_: UITapGestureRecognizer) {
        presentPanModal(AddViewController())
    }

    // хз как сдлетаь кнопку констрейнтами
//    func setUpAddButtonconstraints() {
//        addButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
//            addButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10.0)
//        ])
//    }

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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
}

extension CLLocation {
    func getCity(completion: @escaping (_ city: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self,
                                            preferredLocale: .init(identifier: "en_US"),
                                            completionHandler: { completion($0?.first?.locality, $1) })
    }
}

extension PlacesView: MKMapViewDelegate {}
