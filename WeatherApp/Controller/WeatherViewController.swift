//
//  ViewController.swift
//  WeatherApp
//
//  Created by Os! on 28/12/1439 AH.
//  Copyright © 1439 Os!. All rights reserved.
//

import UIKit
import SwiftyButton
import CoreLocation
import Alamofire
import SwiftyJSON



class ViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {


    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    var counter = 0
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        // set up the location manager here
        locationManager.delegate = self //delegate of location manager from here
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // arround a 100 meter
        locationManager.requestWhenInUseAuthorization() //to ask for user  permission, here you need to add two properties in info.plist in order to get user permission. And we need add key into inf.plist source code because Apple allows Iphone to conncet with the https so our API is http so in order to do that we need to put a keys that existed on github for Clima app
        locationManager.startUpdatingLocation() //start updating location (every unit of time) and put it into CLLocation array
      
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //if it is grabed the location then this method will be triggerd
        //if you find the location put in in the locations: [CLLocation]
        // before getting the location we should ask for
        
        let location = locations[locations.count - 1] // the most acurate location is the last one so it is locations[locations.count - 1]4
        
        if location.horizontalAccuracy > 0 { // if it is valid
            locationManager.stopUpdatingLocation() // stop updating the location
            
            locationManager.delegate = nil //that stop locationManager from receving messages while it is in the process of being stopped ( because the delay in stopUpdatingLocation() )
            print("the longitude is \(location.coordinate.longitude) and the latitude is \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude , "lon" : longitude , "appid" : APP_ID]
            getWeatherData(url: WEATHER_URL, parameters: params)
  
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) // if grab location failed for any issue like Iphone in Airplane mode or there is no internet then this method will be triggred
    {
        print(error)
        cityLabel.text = "Location Unavailable"
    }

    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url : String , parameters: [String : String])
        // we should here use Alamofire library to make http request to grab the weather data
        // the Almofire will communicate with open weather map servers in asynchrounous fashion (background)
    {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            
            response in //response come from the server
            
            if response.result.isSuccess {
                
                print("Success get weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json : weatherJSON)
                
                
                
            }
            else {
                print(response.result.error)
            }
            
        }
        
    }
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON)
    // for sperreting a JSON data because we have a bunch of data and we want some specific data
    {
       let tempResult = json ["main"] ["temp"].double
        //because a SwiftyJSON you can write like this simple and how to navigate into entire data
        // and the way to change data type of JSON simply you put .dataType and you must unwrapped it OR you can write dataTypeValue and that with out unwrapping
        //The temperature is in Kelvins unit and if we want to converte it to C = temp - 273.15
        
        if (tempResult != nil) {
        weatherDataModel.temprture = Int(tempResult! - 273.15)
        }
        else{
           wrongCityName()
           return
        }
         // ! force unwrapping because we are sure that inside the tempResult value because we checked in isSuccess
        
        weatherDataModel.cityName = json ["name"].stringValue
        
        weatherDataModel.condition = json ["weather"] [0] ["id"].intValue
        //check for chain to navigate the particular data with the website JSON online editor
        // and the id (weather condtiotin) that shows you what the weather is , and if you want to check go to the open weather map and see the id table with conditions https://openweathermap.org/weather-conditions
        
        weatherDataModel.nameOfConditionImage =  weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        
        updateUIWithWeatherData()

    }
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData() {
        
        degreeLabel.text = String (weatherDataModel.temprture) + "º"
        
        weatherConditionImage.image = UIImage(named: weatherDataModel.nameOfConditionImage)
        if counter != 0 {
        cityLabel.text = weatherDataModel.cityName
        }
        
        else {
            cityLabel.text = "Riyadh"
            counter += 1

        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "changeToSecondView" {
            
            let destenationVC = segue.destination as! ChangeWeatherViewController
            destenationVC.delegate = self
            
        }
        
    }
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    // so here you are going to be a delegate so you have to impelement a requirment of the protocol
    
    func userEnteredANewCityName(city: String) {
        let params : [String : String] = ["q" : city , "appid" : APP_ID]
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    func wrongCityName()
    {
        cityLabel.text = "wrong city entered!"
        degreeLabel.text = ""
        weatherConditionImage.image = nil
        
    }
   


}

