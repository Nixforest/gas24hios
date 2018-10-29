//
//  MapAgentViewController.swift
//  project
//
//  Created by Lâm Phạm on 4/23/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import MapKit
import harpyframework
import GoogleMaps
import GooglePlaces

class MapAgentViewController: BaseParentViewController {
    // MARK: Properties
    /** Map view */
    @IBOutlet weak var mapView: MKMapView!
    /** Location manager */
    private var _locationManager:   CLLocationManager   = CLLocationManager()
    /** Address textfield */
    private var _txtAddress:        UITextField         = UITextField()
    /** Map view */
    internal var _mapView:          GMSMapView?   = nil
    /** Data */
    private var _data:              MapAgentResponse    = MapAgentResponse()
    /** Current user location marker */
    private var _marker:            GMSMarker           = GMSMarker()
    
    // MARK: Static values
    // MARK: Constant
    var LOGIN_PHONE_REAL_WIDTH_HD       = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_HD
    var LOGIN_PHONE_REAL_HEIGHT_HD      = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_HD
    var LOGIN_PHONE_REAL_WIDTH_FHD      = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD
    var LOGIN_PHONE_REAL_HEIGHT_FHD     = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD
    var LOGIN_PHONE_REAL_WIDTH_FHD_L    = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD_L
    var LOGIN_PHONE_REAL_HEIGHT_FHD_L   = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    
    // MARK: Override methods
    /**
     * Called after the controller's view is loaded into memory.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigationBar(title: DomainConst.CONTENT00545)
//        settingMap()
        updateCurrentLocation()
        requestMapAgent()
        mapView.isHidden = true
    }
    
    /**
     * Handle update constants
     */
    override func updateConst() {
        super.updateConst()
        // Phone
        LOGIN_PHONE_REAL_WIDTH_HD       = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_HD
        LOGIN_PHONE_REAL_HEIGHT_HD      = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_HD
        
        LOGIN_PHONE_REAL_WIDTH_FHD      = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD
        LOGIN_PHONE_REAL_HEIGHT_FHD     = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD
        
        LOGIN_PHONE_REAL_WIDTH_FHD_L    = GlobalConst.LOGIN_TEXTFIELD_WIDTH * G00LoginExtVC.W_RATE_FHD_L
        LOGIN_PHONE_REAL_HEIGHT_FHD_L   = GlobalConst.LOGIN_TEXTFIELD_HEIGHT * G00LoginExtVC.H_RATE_FHD_L
    }
    
    /**
     * Create children views
     */
    override func createChildrenViews() {
        super.createChildrenViews()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            createAddressTextFieldHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                createAddressTextFieldFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                createAddressTextFieldFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
        self.view.addSubview(_txtAddress)
    }
    
    /**
     * Update children views
     */
    override func updateChildrenViews() {
        super.updateChildrenViews()
        updateMapView()
        // Get current device type
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:        // iPhone
            updateAddressTextFieldHD()
            break
        case .pad:          // iPad
            switch UIApplication.shared.statusBarOrientation {
            case .portrait, .portraitUpsideDown:        // Portrait
                updateAddressTextFieldFHD()
                break
            case .landscapeLeft, .landscapeRight:       // Landscape
                updateAddressTextFieldFHD_L()
                break
            default:
                break
            }
            
            break
        default:
            break
        }
    }
    
    // MARK: Layout
    // MARK: Mapview
    /**
     * Create map view
     * - parameter coordinate: Coordinate
     */
    internal func createMapView(coordinate: CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(
            withLatitude: coordinate.latitude,
            longitude: coordinate.longitude,
            zoom: Float(BaseModel.shared.getZoomValue()))
        // Create mapview
        _mapView = GMSMapView.map(
            withFrame: CGRect(x: 0, y: self.getTopHeight(),
                              width: UIScreen.main.bounds.width,
                              height: UIScreen.main.bounds.height - self.getTopHeight()),
            camera: camera)
        settingMap()
        self.view.insertSubview(_mapView!, at: 0)
    }
    
    /**
     * Update map view
     */
    private func updateMapView() {
        if let map = _mapView {
            CommonProcess.updateViewPos(
                view: map,
                x: 0, y: self.getTopHeight(),
                w: UIScreen.main.bounds.width,
                h: UIScreen.main.bounds.height - self.getTopHeight())
        }
    }
    
    // MARK: Address textfield
    /**
     * Create Address textfield
     */
    private func createAddressTextField(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        _txtAddress.frame = CGRect(
            x: x, y: y, width: w, height: h)
        _txtAddress.placeholder         = DomainConst.BLANK
        _txtAddress.layer.cornerRadius  = GlobalConst.BUTTON_CORNER_RADIUS_NEW
        _txtAddress.backgroundColor     = UIColor.white
        _txtAddress.font                = GlobalConst.BASE_FONT
        _txtAddress.delegate            = self
        setLeftViewForTextField(textField: _txtAddress, named: DomainConst.ADDRESS_IMG_NAME)
    }
    
    /**
     * Create address textfield (in HD mode)
     */
    private func createAddressTextFieldHD() {
        self.createAddressTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Create address textfield (in Full HD mode)
     */
    private func createAddressTextFieldFHD() {
        self.createAddressTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Create address textfield (in Full HD Landscape mode)
     */
    private func createAddressTextFieldFHD_L() {
        self.createAddressTextField(
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Update Address textfield (in HD mode)
     */
    private func updateAddressTextFieldHD() {
        CommonProcess.updateViewPos(
            view: _txtAddress,
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_HD) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_HD,
            h: LOGIN_PHONE_REAL_HEIGHT_HD)
    }
    
    /**
     * Update Address textfield (in Full HD mode)
     */
    private func updateAddressTextFieldFHD() {
        CommonProcess.updateViewPos(
            view: _txtAddress,
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD)
    }
    
    /**
     * Update Address textfield (in Full HD Landscape mode)
     */
    private func updateAddressTextFieldFHD_L() {
        CommonProcess.updateViewPos(
            view: _txtAddress,
            x: (UIScreen.main.bounds.width - LOGIN_PHONE_REAL_WIDTH_FHD_L) / 2,
            y: getTopHeight() + GlobalConst.MARGIN,
            w: LOGIN_PHONE_REAL_WIDTH_FHD_L,
            h: LOGIN_PHONE_REAL_HEIGHT_FHD_L)
    }
    
    /**
     * Set left image for text field
     * - parameter textField:   Text field object
     * - parameter named:       Image name
     */
    func setLeftViewForTextField(textField: UITextField, named: String) {
        textField.leftViewMode = .always
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                width: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X,
                                                height: GlobalConst.EDITTEXT_H - GlobalConst.MARGIN_CELL_X))
        let img             = ImageManager.getImage(named: named)
        imgView.image       = img
        textField.leftView  = imgView
    }
    
    // MARK: Logic
    /**
     * Setting for map properties
     */
    internal func settingMap() {
        if let map = _mapView {
            // Show compass button
            map.settings.compassButton      = true
            // Show mylocation button
            map.isMyLocationEnabled         = true
            map.delegate                    = self
            map.settings.myLocationButton = true
            map.settings.indoorPicker     = true
        }
    }
    
    /**
     * Update current location
     */
    func updateCurrentLocation() {
        _locationManager.requestWhenInUseAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            _locationManager.delegate = self
            _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            _locationManager.requestAlwaysAuthorization()
            _locationManager.requestWhenInUseAuthorization()
        }
        _locationManager.startUpdatingLocation()
    }
    
    /**
     * Update address text value
     * - parameter address: Address value
     */
    internal func setAddressText(address: String) {
        self._txtAddress.text = address
    }
    
    /**
     * Move camera
     */
    public func moveCamera(position: CLLocationCoordinate2D) {
        let camera       = GMSCameraPosition.camera(
            withLatitude: position.latitude,
            longitude: position.longitude,
            zoom: Float(BaseModel.shared.getZoomValue()))
        let bounds       = GMSCoordinateBounds.init()
        bounds.includingCoordinate(position)
        if let map = _mapView {
            map.camera = camera
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadAgent(listAgent: [AgentInfoBean]) {
        for agent in listAgent {
//            let annotation = MKPointAnnotation()
//            let lat = Double(agent.info_agent.agent_latitude.trimmingCharacters(in: .whitespaces))
//            let long = Double(agent.info_agent.agent_longitude.trimmingCharacters(in: .whitespaces))
//            annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
//            mapView.addAnnotation(annotation)
            let lat         = (agent.info_agent.agent_latitude as NSString).doubleValue
            let long        = (agent.info_agent.agent_longitude as NSString).doubleValue
            let location    = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            // Insert marker into map view
            createMarker(iconPath: DomainConst.GAS24H_AGENT_48_ANNOTATION,
                         location: location,
                         title: agent.info_agent.agent_name,
                         snippet: agent.info_agent.agent_address)
        }
    }
    
    /**
     * Create marker
     * - parameter iconPath:    Path of icon
     * - parameter location:    Location of marker
     * - parameter title:       Title
     * - parameter snippet:     Snippet
     */
    internal func createMarker(iconPath: String, location: CLLocationCoordinate2D,
                              title: String, snippet: String) {
        let marker      = GMSMarker()
        // Set icon
        marker.icon     = ImageManager.getImage(named: iconPath)
        // Set marker position
        marker.position = location
        marker.title    = title
        marker.snippet  = snippet
        // Insert marker into map view
        marker.map      = self._mapView
    }
    
    internal func createUserMarker(location: CLLocationCoordinate2D, snippet: String) {
        _marker.icon = ImageManager.getImage(named: DomainConst.GAS24H_USER_48_ANNOTATION)
        _marker.position = location
        _marker.title = DomainConst.CONTENT00546
        _marker.snippet = snippet
        _marker.map = self._mapView
    }
    
    internal func updateUserMarker(location: CLLocationCoordinate2D, snippet: String) {
        _marker.map = nil
        _marker = GMSMarker()
        createUserMarker(location: location, snippet: snippet)
//        _marker.position = location
//        _marker.snippet = snippet
//        _marker.map = self._mapView
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationIdentifier = "AgentAnnotation"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        var pinImage = UIImage()
        if annotation.isKind(of: MKUserLocation.self) {
            pinImage = ImageManager.getImage(named: DomainConst.GAS24H_USER_ANNOTAION)!
        } else {
            pinImage = ImageManager.getImage(named: DomainConst.GAS24H_AGENT_ANNOTATION)!
        }
        let size = CGSize(width: 20, height: 30)
        UIGraphicsBeginImageContext(size)
        pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        annotationView?.image = resizedImage
        annotationView?.contentMode = .scaleAspectFit
        return annotationView
    }
    
    /**
     * Request Map Agent
     */
    private func requestMapAgent() {
        MapAgentRequest.request(action: #selector(finishMapAgentRequest(_:)), view: self, id: "")
    }
    
    /**
     * Handler when order config request is finish
     */
    internal func finishMapAgentRequest(_ notification: Notification) {
        let data = (notification.object as! String)
        _data = MapAgentResponse(jsonString: data)
        if _data.isSuccess() {
            loadAgent(listAgent: _data.listAgent)
            _txtAddress.isUserInteractionEnabled = _data.isAllowSearch
            _txtAddress.isEnabled = _data.isAllowSearch
        } else {

        }
    }

}

// MARK: Protocol - UITextFieldDelegate
extension MapAgentViewController: UITextFieldDelegate {
    /**
     * Tells the delegate that editing began in the specified text field.
     */
    internal func textFieldDidBeginEditing(_ textField: UITextField) {
        let autocompleteController      = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
}


// MARK: Protocol - GMSMapViewDelegate
extension MapAgentViewController: GMSMapViewDelegate {
    /**
     * Finish detect current location
     */
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let center = position.target
        var snippet = DomainConst.BLANK
        GMSGeocoder().reverseGeocodeCoordinate(center) { (response, error) in
            if error != nil {
                return
            }
            // Get address
            if let address = response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER) {
                self.setAddressText(address: address)
                snippet = address
                self.updateUserMarker(location: center, snippet: snippet)
            }
        }
        self.updateUserMarker(location: center, snippet: snippet)
    }
    
    /**
     * Mapview changing
     */
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        print("didChange: " + "\(position)")
    }
    
    /**
     * Handle event start drag map view
     */
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        print("willMove: " + "\(gesture)")
    }
}

// MARK: Protocol - GMSAutocompleteViewControllerDelegate
extension MapAgentViewController: GMSAutocompleteViewControllerDelegate {
    /**
     * Handle the user's selection.
     */
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        // Update address text
        if let address = place.formattedAddress {
            self.setAddressText(address: address)
        }
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

// MARK: Protocol - CLLocationManagerDelegate
extension MapAgentViewController: CLLocationManagerDelegate {
    /**
     * Tells the delegate that new location data is available.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let location = locations.last {
            let coordinate: CLLocationCoordinate2D = location.coordinate
            if _mapView == nil {
                createMapView(coordinate: coordinate)
            }
            var snippet = ""
            GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
                if error != nil {
                    return
                }
                // Get address
                if let address = response?.firstResult()?.lines?.joined(separator: DomainConst.ADDRESS_SPLITER) {
                    snippet = address
                }
            }
//            createMarker(iconPath: DomainConst.GAS24H_USER_48_ANNOTATION,
//                         location: coordinate,
//                         title: DomainConst.CONTENT00546,
//                         snippet: snippet)
            createUserMarker(location: coordinate, snippet: snippet)
            
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
