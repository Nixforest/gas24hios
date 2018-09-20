//
//  GoogleMapVC.swift
//  project
//
//  Created by SPJ on 8/31/17.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import harpyframework
import GoogleMaps
import GooglePlaces

class GoogleMapVC: BaseChildViewController {
    // MARK: Properties
    /** Map view */
    @IBOutlet weak var viewMap:     GMSMapView!
    /** Location */
    private let locationManager:    CLLocationManager   = CLLocationManager()
    /** Top view */
    private var _topView:           UIView              = UIView()
    /** Source address textfield */
    private var _txtAddressSrc:     UITextField         = UITextField()
    /** Destination address textfield */
    private var _txtAddressDest:    UITextField         = UITextField()
    /** Center mark */
    private var _centerMark:        UIImageView         = UIImageView()
    /** Origin position */
    private var _source:            (lat: Double, long: Double) = (0, 0)
    /** Origin position */
    private var _destination:       (lat: Double, long: Double) = (0, 0)
    /** Destination address textfield */
    public var _currentTextField:   UITextField         = UITextField()
    /** Service request direction */
    public let directionService:    DirectionService    = DirectionService()

    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Map view setting
        settingMap()
        
        // Location setting
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        } else {
            locationManager.startUpdatingLocation()
        }
        
        // Navigation
        self.createNavigationBar(title: "Thử nghiệm Google map")
        
        // Topview
        _ = setupTopView(offset: self.getTopHeight())
        
        // Center mark
        setupCenterMark()
        
        self.view.makeComponentsColor()
    }
    
    // MARK: Utility methods
    /**
     * Setting for map properties
     */
    private func settingMap() {
        // Show compass button
        viewMap.settings.compassButton      = true
        // Show mylocation button
        viewMap.settings.myLocationButton   = true
        viewMap.isMyLocationEnabled         = true
        viewMap.delegate                    = self
    }
    
    /**
     * Setup all components of top view
     * - parameter offset: Input offset
     * - returns: Output offset
     */
    func setupTopView(offset: CGFloat) -> CGFloat {
        // Address textfield
        _txtAddressSrc.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                   y: GlobalConst.MARGIN,
                                   width: GlobalConst.BUTTON_W,
                                   height: GlobalConst.BUTTON_H)
        _txtAddressSrc.placeholder         = DomainConst.BLANK
        _txtAddressSrc.layer.cornerRadius  = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        _txtAddressSrc.backgroundColor     = UIColor.white
        _txtAddressSrc.font                = UIFont.systemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE_1)
        _txtAddressSrc.delegate            = self
        CommonProcess.setLeftImgTextField(textField: _txtAddressSrc, name: DomainConst.ADDRESS_ICON_IMG_NAME);
        _txtAddressDest.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.BUTTON_W) / 2,
                                      y: _txtAddressSrc.frame.maxY + GlobalConst.MARGIN,
                                      width: GlobalConst.BUTTON_W,
                                      height: GlobalConst.BUTTON_H)
        _txtAddressDest.placeholder         = DomainConst.BLANK
        _txtAddressDest.layer.cornerRadius  = GlobalConst.LOGIN_BUTTON_CORNER_RADIUS
        _txtAddressDest.backgroundColor     = UIColor.white
        _txtAddressDest.font                = UIFont.systemFont(ofSize: GlobalConst.NORMAL_FONT_SIZE_1)
        _txtAddressDest.delegate            = self
        CommonProcess.setLeftImgTextField(textField: _txtAddressDest, name: DomainConst.ADDRESS_ICON_IMG_NAME);
        
        // Top view
        self._topView.frame = CGRect(x: 0, y: offset,
                                     width: GlobalConst.SCREEN_WIDTH,
                                     height: GlobalConst.MARGIN * 3 + GlobalConst.EDITTEXT_H * 2)
        self._topView.backgroundColor = UIColor(white: 0, alpha: 0.0)
        self._topView.addSubview(_txtAddressSrc)
        self._topView.addSubview(_txtAddressDest)
        
        self.view.addSubview(_topView)
        return offset
    }
    
    /**
     * Create center marker
     */
    func setupCenterMark() {
        self._centerMark.frame = CGRect(x: (GlobalConst.SCREEN_WIDTH - GlobalConst.CENTER_MARKER_SIZE_WIDTH) / 2,
                                        y: (GlobalConst.SCREEN_HEIGHT - getTopHeight()) / 2 - GlobalConst.CENTER_MARKER_SIZE_HEIGHT + getTopHeight(),
            width: GlobalConst.CENTER_MARKER_SIZE_WIDTH,
            height: GlobalConst.CENTER_MARKER_SIZE_HEIGHT)
        self._centerMark.image = ImageManager.getImage(named: DomainConst.CENTER_MARKER_IMG_NAME)
        self._centerMark.contentMode = .scaleAspectFit
        self.view.addSubview(self._centerMark)
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setSrcAddress(position: CLLocationCoordinate2D, isFirstTime: Bool = false) {
        var address = DomainConst.BLANK
        GMSGeocoder().reverseGeocodeCoordinate(position, completionHandler: {
            (response, error) in
            if error != nil {
                return
            }
            // Get address
            address = (response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER))!
            if isFirstTime {
                if (self._txtAddressSrc.text?.isEmpty)! {
                    self._txtAddressSrc.text = address
                    self._source.lat = position.latitude
                    self._source.long = position.longitude
                }
            } else {
                self._txtAddressSrc.text = address
                self._source.lat = position.latitude
                self._source.long = position.longitude
            }
        })
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setDestAddress(position: CLLocationCoordinate2D) {
        var address = DomainConst.BLANK
        GMSGeocoder().reverseGeocodeCoordinate(position, completionHandler: {
            (response, error) in
            if error != nil {
                return
            }
            // Get address
            address = (response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER))!
            self._txtAddressDest.text = address
            self._destination.lat = position.latitude
            self._destination.long = position.longitude
        })
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    public func setAddress(address: GMSPlace) {
        _currentTextField.text = address.formattedAddress!
        switch _currentTextField {
        case self._txtAddressSrc:
            self._source.lat = address.coordinate.latitude
            self._source.long = address.coordinate.longitude
            break
        case self._txtAddressDest:
            self._destination.lat = address.coordinate.latitude
            self._destination.long = address.coordinate.longitude
            break
        default:
            break
        }
    }
    
    /**
     * Move camera
     * - parameter position: Position to move
     */
    public func moveCamera(position: CLLocationCoordinate2D) {
        let camera       = GMSCameraPosition.camera(withLatitude: position.latitude,
                                                    longitude: position.longitude,
                                                    zoom: self.viewMap.camera.zoom)
        //self.viewMap.camera = camera
        self.viewMap.animate(to: camera)
    }
    
    public func openContextMenu() {
        // Show alert
        let alert = UIAlertController(title: DomainConst.CONTENT00401,
                                      message: DomainConst.BLANK,
                                      preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: DomainConst.CONTENT00202,
                                   style: .cancel,
                                   handler: nil)
        
        let direction = UIAlertAction(title: DomainConst.CONTENT00469,
                                   style: .default,
                                   handler: {
                                    action in
                                    self.direction()
        })
        
        alert.addAction(cancel)
        alert.addAction(direction)
        
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self._centerMark
            presenter.sourceRect = self._centerMark.bounds
        }
        // Show alert
        self.present(alert, animated: true, completion: nil)
    }
    
    public func direction() {
        self.viewMap.clear()
        let origin: String = "\(self._source.lat),\(self._source.long)"
        let destination: String =
        "\(self._destination.lat),\(self._destination.long)"
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: self._destination.lat, longitude: self._destination.long))
        marker.map = self.viewMap
        self.directionService.getDirections(origin: origin,
                                            destination: destination,
                                            travelMode: TravelModes.driving) { [weak self] (success) in
                                                if success {
                                                    DispatchQueue.main.async {
                                                        self?.drawRoute()
                                                        if let totalDistance = self?.directionService.totalDistance,
                                                            let totalDuration = self?.directionService.totalDuration {
//                                                            self?.detailDirection.text = totalDistance + ". " + totalDuration
//                                                            self?.detailDirection.isHidden = false
                                                        }
                                                    }
                                                } else {
                                                    print("error direction")
                                                }
        }
    }
    private func drawRoute() {
        for step in self.directionService.selectSteps {
            if step.polyline.points != "" {
                let path = GMSPath(fromEncodedPath: step.polyline.points)
                let routePolyline = GMSPolyline(path: path)
                routePolyline.strokeColor = UIColor.red
                routePolyline.strokeWidth = 3.0
                routePolyline.map = self.viewMap
                let mapBound = GMSCoordinateBounds(path: path!)
                let cameraUpdate = GMSCameraUpdate.fit(mapBound, withPadding: 30)
                self.viewMap.moveCamera(cameraUpdate)
            } else {
                return
            }
        }
    }
}

// MARK: Protocol - CLLocationManagerDelegate
extension GoogleMapVC: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        if let location: CLLocation = locations.last {
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                                  longitude: location.coordinate.longitude,
                                                  zoom: Float(BaseModel.shared.getZoomValue()))
            viewMap.frame = CGRect(x: 0, y: self.getTopHeight(),
                                   width: GlobalConst.SCREEN_WIDTH,
                                   height: GlobalConst.SCREEN_HEIGHT - self.getTopHeight())
            if viewMap.isHidden {
                viewMap.isHidden = false
                viewMap.camera = camera
            } else {
                viewMap.animate(to: camera)
            }
        }
    }
    
    /**
     * Tells the delegate that the authorization status for the application changed.
     */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }
    
    /**
     * Tells the delegate that the location manager was unable to retrieve a location value.
     */
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
}

// MARK: Protocol - GMSMapViewDelegate
extension GoogleMapVC: GMSMapViewDelegate {
    /**
     * Handle long press inside map
     */
    func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
        self.setDestAddress(position: coordinate)
        self.moveCamera(position: coordinate)
        self.openContextMenu()
    }
    
    /**
     * Finish detect current location
     */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.setSrcAddress(position: position.target, isFirstTime: true)
    }
}

// MARK: Protocol - UITextFieldDelegate
extension GoogleMapVC: UITextFieldDelegate {
    /**
     * Tells the delegate that editing began in the specified text field.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        _currentTextField = textField
        // Start search address from google toolkit
        let autocompleteCtrl = GMSAutocompleteViewController()
        autocompleteCtrl.delegate = self
        self.present(autocompleteCtrl, animated: true, completion: nil)
    }
}

// MARK: Protocol - GMSAutocompleteViewControllerDelegate
extension GoogleMapVC: GMSAutocompleteViewControllerDelegate {
    /**
     * Handle the user's selection.
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.setAddress(address: place);
        // Update camera position
        self.moveCamera(position: place.coordinate)
        // Hide current autocomplete view
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Handle fail event
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    /**
     * User canceled the operation.
     */
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    /**
     * Turn the network activity indicator on and off again.
     */
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    /**
     * Turn the network activity indicator on and off again.
     */
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
