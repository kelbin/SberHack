//
//  ViewController.swift
//  SberInnovation
//
//  Created by Maxim Savchenko on 17.12.2021.
//

import UIKit
import Pulsator
import FittedSheets
import GoogleMaps
import CoreLocation

final class FeatureViewController: UIViewController {

    struct Places {
        let image: UIImage
        let text: String
        let width: Double
    }
    
    struct Ships {
        let image: UIImage
        let text: String
        let price: Double
    }
    
    enum States {
        case firstScreen
        case secondScreen
        case thirdScreen
        case fourthScreen
    }
    
    @IBOutlet private var pulsatorView: UIView!
    
    private lazy var pulsator = Pulsator()
    private let controller = PullUpController()
    private lazy var mapView = GMSMapView()
    private var sheetController: SheetViewController?
    
    // MARK: - Section 1
    
    private lazy var titleFirstScreen: UILabel = {
        $0.text = "Чем займёмся?"
        $0.font = .boldSystemFont(ofSize: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var taxiImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapToTaxiButton), for: .touchUpInside)
        $0.setImage(UIImage(named: "taxi"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var exImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "ex"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var rentImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "rent"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var cruiseImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "cruise"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var pulsatorViewer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        return $0
    }(UIView())
    
    // MARK: - Section 2
    
    private lazy var createOwnRoutesButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "routesButton"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var westPortImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapToWestPortButton), for: .touchUpInside)
        $0.setImage(UIImage(named: "westPort"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var heartPortImageButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "heartPort"), for: .normal)
        return $0
    }(UIButton())
    
    // MARK: - Section 3
    
    private lazy var applePayButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named: "applePay"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var orderButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(tapToOrderButton), for: .touchUpInside)
        $0.setImage(UIImage(named: "order"), for: .normal)
        return $0
    }(UIButton())
    
    private lazy var placesScrollView = UIScrollView()
    private lazy var shipsScrollView = UIScrollView()
    
    var locationManager = CLLocationManager()
    
    private lazy var myLocationButton: UIButton = {
        $0.setImage(UIImage(named: "locationButton"), for: .normal)
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.addTarget(self, action: #selector(tapToLocationButton), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let buttonPadding: CGFloat = 10
    private var xOffset: CGFloat = 10
    private var shipsOffset: CGFloat = 10
    
    private var arrayOfPlaces: [FeatureViewController.Places] = [FeatureViewController.Places(image: UIImage(named: "anchor")!, text: "Причалы", width: 108), FeatureViewController.Places(image: UIImage(named: "bank")!, text: "Интересные места", width: 173), FeatureViewController.Places(image: UIImage(named: "cutlery")!, text: "Еда", width: 80)]
    
    private var arrayOfShips: [FeatureViewController.Ships] = [FeatureViewController.Ships(image: UIImage(named: "firstShip")!, text: "Прогулочный", price: 2350), FeatureViewController.Ships(image: UIImage(named: "secondShip")!, text: "Вместительный", price: 5421), FeatureViewController.Ships(image: UIImage(named: "thirdShip")!, text: "Яхта", price: 9200)]
    
    private var arrayOfMarkers: [GMSMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGoogleMaps()
        settingsSheet()
        
        self.view.addSubview(placesScrollView)
        self.view.addSubview(myLocationButton)
        self.view.addSubview(pulsatorViewer)
        
        pulsatorViewer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 10).isActive = true
        pulsatorViewer.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 10).isActive = true
        pulsatorViewer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pulsatorViewer.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        pulsatorViewer.layer.insertSublayer(pulsator, below: self.view.layer)
        
        setConstraints()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showBottomSheet()
        }
    }
    
    @objc func tapToLocationButton() {
        locationManager.startUpdatingLocation()
    }
    
    @objc func tapToTaxiButton() {
        bottomSheetStates(.secondScreen)
    }
    
    @objc func tapToWestPortButton() {
        bottomSheetStates(.thirdScreen)
    }
    
    @objc func tapToOrderButton() {
        bottomSheetStates(.fourthScreen)
    }
    
    @objc func tapToChooseShip(sender: AnyObject?) {
        let tapGesture = sender as! UITapGestureRecognizer
        tapGesture.view?.layer.borderColor = UIColor(red: 0.047, green: 0.416, blue: 0.824, alpha: 1).cgColor
    }
    
    private func addMarker(latitude: Double, longitude: Double, iconImage: UIImage?, title: String? = nil, description: String? = nil) {
        let position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let marker = GMSMarker(position: position)
        if iconImage != nil {
            marker.icon = iconImage
        } else {
            marker.opacity = 0
        }
        
        marker.title = title
        marker.snippet = description
        marker.map = mapView
        arrayOfMarkers.append(marker)
    }
    
    private func setConstraints() {
        
        placesScrollView.translatesAutoresizingMaskIntoConstraints = false
        myLocationButton.translatesAutoresizingMaskIntoConstraints = false
        
        placesScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        placesScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        placesScrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -418).isActive = true
        placesScrollView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        myLocationButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        myLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        myLocationButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        myLocationButton.bottomAnchor.constraint(equalTo: placesScrollView.topAnchor).isActive = true
    }
    
    private func addPlacesToScrollView() {
        
        for i in arrayOfPlaces {
            let button = UIButton()
            button.setTitle("  \(i.text)", for: .normal)
            button.setImage(i.image, for: .normal)
            button.backgroundColor = .white
            button.titleLabel?.font = .systemFont(ofSize: 14)
            button.setTitleColor(.black, for: .normal)
            button.frame = CGRect(x: xOffset, y: CGFloat(buttonPadding),
                                  width: i.width,
                                  height: 30)
            button.layer.cornerRadius = 8

            xOffset = xOffset + CGFloat(buttonPadding) + button.frame.size.width
            placesScrollView.addSubview(button)
        }
        
        placesScrollView.contentSize = CGSize(width: xOffset + 100, height: 50)
        placesScrollView.showsHorizontalScrollIndicator = false
        placesScrollView.showsVerticalScrollIndicator = false
    }
    
    private func addShipsToScrollView() {
        
        for (index, i) in arrayOfShips.enumerated() {
            let view = UIView()
            view.frame = CGRect(x: shipsOffset, y: CGFloat(buttonPadding),
                                  width: 128,
                                  height: 152)
        
            view.tag = index
            let innerImage = UIImageView()
            let titleLabel = UILabel()
            let priceLabel = UILabel()
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToChooseShip(sender:)))
            view.addGestureRecognizer(tapGesture)
            
            view.addSubview(priceLabel)
            view.addSubview(titleLabel)
            view.addSubview(innerImage)
            
            innerImage.image = i.image
            
            innerImage.translatesAutoresizingMaskIntoConstraints = false
            
            innerImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
            innerImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            innerImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
            innerImage.widthAnchor.constraint(equalToConstant: 120).isActive = true
            
            titleLabel.text = i.text
            titleLabel.font = .systemFont(ofSize: 14)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            titleLabel.topAnchor.constraint(equalTo: innerImage.bottomAnchor, constant: 8).isActive = true
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            
            priceLabel.text = "\(Int(i.price))₽"
            priceLabel.font = .boldSystemFont(ofSize: 14)
            
            priceLabel.translatesAutoresizingMaskIntoConstraints = false
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
            
            shipsOffset = shipsOffset + CGFloat(buttonPadding) + view.frame.size.width
            shipsScrollView.addSubview(view)
        }
        
        shipsScrollView.contentSize = CGSize(width: shipsOffset + 100, height: 50)
        shipsScrollView.showsHorizontalScrollIndicator = false
        shipsScrollView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        pulsator.position = pulsatorViewer.layer.position
    }
    
    private func settingsSheet() {
        var options = SheetOptions(useFullScreenMode: false, useInlineMode: true)
        options.transitionVelocity = 0.3
        options.transitionDampening = 1
        options.transitionDuration = 0.3
        
        sheetController = SheetViewController(controller: controller, sizes: [.fixed(410), .fullscreen], options: options)
        sheetController?.overlayColor = .clear
        sheetController?.minimumSpaceAbovePullBar = 44
        sheetController?.allowGestureThroughOverlay = true
        sheetController?.dismissOnPull = false
        sheetController?.dismissOnOverlayTap = false
        sheetController?.cornerRadius = 24
    }
    
    private func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 55.747338, longitude: 37.544980, zoom: 16)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.isMyLocationEnabled = true
        
        self.locationManager.delegate = self
        
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        
        addMarker(latitude: 55.74630137, longitude: 37.544877, iconImage: UIImage(named: "anchorMap")!)
        addMarker(latitude: 55.747395, longitude: 37.546819, iconImage: nil)
        addMarker(latitude: 55.749377, longitude: 37.551247, iconImage: nil)
        addMarker(latitude: 55.752910, longitude: 37.556248, iconImage: UIImage(named: "anchorMap")!)
    }
    
    
    private func bottomSheetStates(_ states: States) {
        setStatesConstraints(states)
    }
    
    private func setStatesConstraints(_ states: States) {
        
        guard let sheetController = sheetController else {
            return
        }
        
        switch states {
        case .firstScreen:
            
            sheetController.contentViewController.view.addSubview(taxiImageButton)
            sheetController.contentViewController.view.addSubview(exImageButton)
            sheetController.contentViewController.view.addSubview(cruiseImageButton)
            sheetController.contentViewController.view.addSubview(rentImageButton)
            sheetController.contentViewController.view.addSubview(titleFirstScreen)

            
            titleFirstScreen.topAnchor.constraint(equalTo: sheetController.contentViewController.view.topAnchor, constant: 33).isActive = true
            titleFirstScreen.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 18).isActive = true
            
            taxiImageButton.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 18).isActive = true
            taxiImageButton.topAnchor.constraint(equalTo: titleFirstScreen.bottomAnchor, constant: 16).isActive = true
            taxiImageButton.heightAnchor.constraint(equalToConstant: 160).isActive = true
            taxiImageButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
            
            exImageButton.leadingAnchor.constraint(equalTo: taxiImageButton.trailingAnchor, constant: 8).isActive = true
            exImageButton.topAnchor.constraint(equalTo: titleFirstScreen.bottomAnchor, constant: 16).isActive = true
            exImageButton.heightAnchor.constraint(equalToConstant: 160).isActive = true
            exImageButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
            
            rentImageButton.leadingAnchor.constraint(equalTo: taxiImageButton.leadingAnchor, constant: 0).isActive = true
            rentImageButton.topAnchor.constraint(equalTo: taxiImageButton.bottomAnchor, constant: 8).isActive = true
            rentImageButton.heightAnchor.constraint(equalToConstant: 160).isActive = true
            rentImageButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
            
            cruiseImageButton.leadingAnchor.constraint(equalTo: exImageButton.leadingAnchor, constant: 0).isActive = true
            cruiseImageButton.topAnchor.constraint(equalTo: exImageButton.bottomAnchor, constant: 8).isActive = true
            cruiseImageButton.heightAnchor.constraint(equalToConstant: 160).isActive = true
            cruiseImageButton.widthAnchor.constraint(equalToConstant: 165).isActive = true
            
        case .secondScreen:
        
            titleFirstScreen.removeFromSuperview()
            taxiImageButton.removeFromSuperview()
            exImageButton.removeFromSuperview()
            rentImageButton.removeFromSuperview()
            cruiseImageButton.removeFromSuperview()
            
            sheetController.setSizes([.fixed(200)], animated: true)
            
            sheetController.contentViewController.view.addSubview(createOwnRoutesButton)
            sheetController.contentViewController.view.addSubview(westPortImageButton)
            sheetController.contentViewController.view.addSubview(heartPortImageButton)
            
            createOwnRoutesButton.topAnchor.constraint(equalTo: sheetController.contentViewController.view.topAnchor, constant: 33).isActive = true
            createOwnRoutesButton.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 17).isActive = true
            createOwnRoutesButton.trailingAnchor.constraint(equalTo: sheetController.contentViewController.view.trailingAnchor, constant: -17).isActive = true
            createOwnRoutesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            westPortImageButton.topAnchor.constraint(equalTo: createOwnRoutesButton.bottomAnchor, constant: 12).isActive = true
            westPortImageButton.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 18).isActive = true
            
            heartPortImageButton.topAnchor.constraint(equalTo: createOwnRoutesButton.bottomAnchor, constant: 12).isActive = true
            heartPortImageButton.trailingAnchor.constraint(equalTo: sheetController.contentViewController.view.trailingAnchor, constant: -18).isActive = true
            
            placesScrollView.transform = CGAffineTransform(translationX: 0, y: 220)
            myLocationButton.transform = CGAffineTransform(translationX: 0, y: 220)
            
            addMarker(latitude: 55.744641, longitude: 37.540911, iconImage: UIImage(named: "taxiPoint"), title: "Мост Багратион", description: "Подача от 14 мин")
            
            let camera = GMSCameraPosition.camera(withLatitude: 55.744641, longitude: 37.540911, zoom: 16)
            
            self.mapView.animate(to: camera)
            
            self.view.layoutIfNeeded()
            
        case .thirdScreen:
            
            createOwnRoutesButton.removeFromSuperview()
            westPortImageButton.removeFromSuperview()
            heartPortImageButton.removeFromSuperview()
            
            addMarker(latitude: 55.74464695543836, longitude: 37.53951609134674, iconImage: UIImage(named: "point"))
            addMarker(latitude: 55.7450819547983, longitude: 37.53170449286699, iconImage: UIImage(named: "point"))
            
            sheetController.setSizes([.fixed(330)], animated: true)
            
            let path = GMSMutablePath()
            
            path.add(arrayOfMarkers[arrayOfMarkers.count - 1].position)
            path.add(arrayOfMarkers[arrayOfMarkers.count - 2].position)
            
            self.mapView.addPath(path, strokeColor: .black, strokeWidth: 5)
            
            sheetController.contentViewController.view.addSubview(shipsScrollView)
            sheetController.contentViewController.view.addSubview(orderButton)
            sheetController.contentViewController.view.addSubview(applePayButton)
            
            shipsScrollView.translatesAutoresizingMaskIntoConstraints = false
            
            shipsScrollView.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor).isActive = true
            shipsScrollView.trailingAnchor.constraint(equalTo: sheetController.contentViewController.view.trailingAnchor).isActive = true
            shipsScrollView.topAnchor.constraint(equalTo: sheetController.contentViewController.view.topAnchor, constant: 33).isActive = true
            shipsScrollView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            addShipsToScrollView()
            
            applePayButton.translatesAutoresizingMaskIntoConstraints = false

            applePayButton.topAnchor.constraint(equalTo: shipsScrollView.bottomAnchor, constant: 12).isActive = true
            applePayButton.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 18).isActive = true
            applePayButton.trailingAnchor.constraint(equalTo: sheetController.contentViewController.view.trailingAnchor, constant: -18).isActive = true

            orderButton.translatesAutoresizingMaskIntoConstraints = false

            orderButton.topAnchor.constraint(equalTo: applePayButton.bottomAnchor, constant: 12).isActive = true
            orderButton.leadingAnchor.constraint(equalTo: sheetController.contentViewController.view.leadingAnchor, constant: 18).isActive = true
            orderButton.trailingAnchor.constraint(equalTo: sheetController.contentViewController.view.trailingAnchor, constant: -18).isActive = true

            myLocationButton.transform = CGAffineTransform(translationX: 0, y: 100)
            
        case .fourthScreen:
            
            sheetController.setSizes([.fixed(0)], animated: true)
            
            let camera = GMSCameraPosition.camera(withLatitude: arrayOfMarkers[arrayOfMarkers.count - 1].position.latitude,
                                                  longitude: arrayOfMarkers[arrayOfMarkers.count - 1].position.longitude, zoom: 15.0)

            self.mapView.animate(to: camera)
            
            placesScrollView.removeFromSuperview()
            myLocationButton.removeFromSuperview()
            
            startPulse()
        }
        
    }
    
    private func startPulse() {
        pulsator.start()
        
        pulsator.numPulse = 5
        pulsator.radius = 240
        pulsator.backgroundColor = UIColor(red: 0.047, green: 0.416, blue: 0.824, alpha: 0.6).cgColor
    }
    
    private func showBottomSheet() {
        sheetController?.animateIn(to: self.view, in: self)
        addPlacesToScrollView()
        bottomSheetStates(.firstScreen)
    }

}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)

        return ceil(boundingBox.width)
    }
}

extension FeatureViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("coordinate ", coordinate)
    }
    
}

extension FeatureViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 15.0)

        self.mapView.animate(to: camera)

        self.locationManager.stopUpdatingLocation()
    }
    
    
}

extension GMSMutablePath {
    convenience init(coordinates: [CLLocationCoordinate2D]) {
        self.init()
        for coordinate in coordinates {
            add(coordinate)
        }
    }
}

extension GMSMapView {
    func addPath(_ path: GMSPath, strokeColor: UIColor? = nil, strokeWidth: CGFloat? = nil, geodesic: Bool? = nil, spans: [GMSStyleSpan]? = nil) {
        let line = GMSPolyline(path: path)
        line.strokeColor = strokeColor ?? line.strokeColor
        line.strokeWidth = strokeWidth ?? line.strokeWidth
        line.geodesic = geodesic ?? line.geodesic
        line.spans = spans ?? line.spans
        line.map = self
    }
}
