//
//  ViewController.swift
//  CityWeatherAPIExample
//
//  Created by 青单 on 12/9/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftSpinner

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cityValues: [WeatherClass] = [WeatherClass]()
    
    var cityNames = ["Seattle","San Francisco", "Portland", "New York","Miami"]
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func getWeatherInformation(_ sender: Any) {
        var cities = ""
        for city in cityNames {
            cities.append("\(city),")
        }
        let citiesStr = cities.dropLast()
        let url = "https://us-central1-fir-api-s-8d31b.cloudfunctions.net/app"
        print(url)
        SwiftSpinner.show("Getting City Weather")
        AF.request(url).responseJSON { response in
            SwiftSpinner.hide()
            if response.error != nil {
                print(response.error?.localizedDescription ?? "Error")
                return
            }
            guard let rawData = response.data else {return}
            guard let jsonArray = JSON(rawData).array else {return}
            
            self.cityValues = [WeatherClass]()
            for weatherJSON in jsonArray {
                print("Weather : \(weatherJSON)")
                let city = weatherJSON["city"].stringValue
                let temperature = weatherJSON["temperature"].floatValue
                let conditions = weatherJSON["conditions"].stringValue
                
                let weatherClass = WeatherClass()
                weatherClass.city = city
                weatherClass.temperature = temperature
                weatherClass.conditions = conditions
                self.cityValues.append(weatherClass)
            }
            self.tblView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cityValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let city = cityValues[indexPath.row].city
        let temperature = cityValues[indexPath.row].temperature
        cell.textLabel?.text = "City: \(city) Temperature: \(temperature)"
        return cell
    }
}

