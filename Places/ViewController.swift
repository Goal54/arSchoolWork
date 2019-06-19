/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

import MapKit
import CoreLocation

class ViewController: UIViewController {
  
  @IBOutlet weak var labelAccuracy: UILabel!
  @IBOutlet weak var mapView: MKMapView!
  fileprivate let locationManager = CLLocationManager()
  fileprivate var startedLoadingPOIs = false
  fileprivate var places = [Place]()
  fileprivate var arViewControoler: ARViewController!
  let string = "[ {\"lat\": 48.656472, \"lng\": 6.130655, \"name\": \"C20\"}, {\"lat\": 48.656470, \"lng\": 6.130413, \"name\": \"C23\"} ]"
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = 1
    //locationManager.desiredAccuracy :CLLocationAccuracy { get set }
    locationManager.activityType = CLActivityType .fitness
    locationManager.startUpdatingLocation()
    locationManager.requestWhenInUseAuthorization()
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  @IBAction func showARController(_ sender: Any) {
    mapView = nil
    arViewControoler = ARViewController();
    arViewControoler.dataSource = self;
    arViewControoler.maxVisibleAnnotations = 30
    arViewControoler.headingSmoothingFactor = 0.05
    //arViewControoler.setAnnotations(places)
    self.present(arViewControoler, animated: true, completion: nil)
  }
  func JSONParseArray(string: String) -> [AnyObject]{
    if let data = string.data(using: String.Encoding.utf8){
      
      do{
        
        if let array = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)  as? [AnyObject] {
          return array
        }
      }catch{
        
        print("error")
        //handle errors here
        
      }
    }
    return [AnyObject]()
  }
}
extension ViewController: CLLocationManagerDelegate{
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if locations.count > 0 {
      let location = locations.last!
        labelAccuracy.text = String(location.horizontalAccuracy);
      if location.horizontalAccuracy < 80 {
        if(!startedLoadingPOIs){
            startedLoadingPOIs = true;
            for element: AnyObject in JSONParseArray(string: string) {
              let latitude = element["lat"] as! CLLocationDegrees
              let longitude = element["lng"] as! CLLocationDegrees
              let location = CLLocation(latitude: latitude, longitude: longitude)
              let name = element["name"] as! String
              let address = "ok"
              let reference = "ok"
              let place = Place(location: location, reference: reference, name: name, address: address)
              self.places.append(place)
              //let age = element["age"] as? Int
              let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
              //6
              DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
              }
            }
      
            }
        }
      }
    }
  }

extension ViewController: ARDataSource {
  func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
    let annotationView = AnnotationView()
    annotationView.annotation = viewForAnnotation
    annotationView.delegate = self
    annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
    
    return annotationView
  }
}
extension ViewController: AnnotationViewDelegate {
  func didTouch(annotationView: AnnotationView) {
    print("Tapped view for POI: \(String(describing: annotationView.titleLabel?.text))")
  }
}
