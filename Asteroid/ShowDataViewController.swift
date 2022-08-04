//
//  ShowDataViewController.swift
//  Asteroid
//
//  Created by Kaushlendra on 03/08/22.
//

import UIKit
import FLCharts
import Alamofire
import SwiftUI

class ShowDataViewController: ViewController {
    var decodedData : Asteroid?
    var dates: [String] = [""]
    var asteroidSpeed: [String: String] = [:]
    var asteroidMissData: [String: String] = [:]
    var asteroidDiameters: [Float] = []
    
    var fastestAsteroidId: String = ""
    var fastestAsteroidSpeed: Float = 0.0
    var closestAsteroidId: String = ""
    var closestAsteroidMissDistance : Float = Float.greatestFiniteMagnitude
    var avgAsteroidDiameter: Float = 0.0
    
    
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var fastestAsteroidIdLabel: UILabel!
    @IBOutlet weak var fastestAsteroidSpeedLabel: UILabel!
    @IBOutlet weak var closestAsteroidIdLabel: UILabel!
    @IBOutlet weak var closestAsteroidDistanceLabel: UILabel!
    @IBOutlet weak var avgAsteroidSizeLabel: UILabel!
    @IBOutlet weak var chartView: FLChart!
    
    
    
    typealias asteroidsCallBack = (_ asteroid:Asteroid?, _ status: Bool, _ message:String) -> Void
    
    var callBack:asteroidsCallBack?
    
    var dateWiseAsteroidCount: [MultiPlotable] = []
    
    
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorView.isHidden = true
        fetchData()
        //showChart()
        
    }
    
    func fetchData()
    {
        let urlToFetch = "https://api.nasa.gov/neo/rest/v1/feed?start_date=" + ViewController.sharedStartDateString + "&end_date=" + ViewController.sharedEndDateString + "&detailed=true&api_key=DEMO_KEY"
        
        AF.request(urlToFetch, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response { (responseData) in
            guard let data = responseData.data else {
                self.callBack?(nil, false, "")

                return}
            do {
                let example = try JSONDecoder().decode(Asteroid.self, from: data)
                self.decodedData = example
                for i in self.decodedData?.nearEarthObjects.innerData ?? [:] {
                    self.dateWiseAsteroidCount.append(MultiPlotable(name: String(i.key), values: [ CGFloat(i.value.count)]))
                    for j in i.value {
                        for k in j.closeApproachData{
                            self.asteroidSpeed[j.id] = k.relativeVelocity.kilometersPerSecond
                            self.asteroidMissData[j.id] = k.missDistance.kilometers
                        }
                        self.asteroidDiameters.append(j.estimatedDiameter.kilometers.estimatedDiameterMax)
                        self.asteroidDiameters.append(j.estimatedDiameter.kilometers.estimatedDiameterMin)
                    }
                    
                }
                
                self.doCalculations()
                self.showChart()
                self.callBack?(example, true,"")
            } catch {
                //print(error.localizedDescription)
                self.errorView.isHidden = false
                self.callBack?(nil, false, error.localizedDescription)
            }

        }
    }

    func completionHandler(callBack: @escaping asteroidsCallBack) {
        self.callBack = callBack
    }
    
    func doCalculations(){
        for (a,b) in self.asteroidSpeed
        {
            if(self.fastestAsteroidSpeed < Float(b) ?? 0.0)
            {
                self.fastestAsteroidSpeed = Float(b) ?? 0.0
                self.fastestAsteroidId = a
            }
        }
        
        for (a,b) in self.asteroidMissData
        {
            if(self.closestAsteroidMissDistance > Float(b) ?? 0.0)
            {
                self.closestAsteroidMissDistance = Float(b) ?? 0.0
                self.closestAsteroidId = a
            }
        }
        
        var asteroidDiameterSum = 0.0
        //self.avgAsteroidDiameter = self.asteroidDiameters
        for a in self.asteroidDiameters
        {
            asteroidDiameterSum = asteroidDiameterSum + Double(a)
        }
        self.avgAsteroidDiameter = Float(asteroidDiameterSum/Double((self.asteroidDiameters.count)))
        self.assignLabelTexts()
        
    }
    
    func assignLabelTexts(){
        fastestAsteroidIdLabel.text = self.fastestAsteroidId
        fastestAsteroidSpeedLabel.text = ("\(self.fastestAsteroidSpeed) km/h")
        closestAsteroidIdLabel.text = self.closestAsteroidId
        closestAsteroidDistanceLabel.text = ("\(self.closestAsteroidMissDistance) km")
        avgAsteroidSizeLabel.text = ("\(self.avgAsteroidDiameter) km") 
        
    }
    
    func showChart(){
        
        let barChartData = FLChartData(title: "Day Wise Asteroids",
                                       data: dateWiseAsteroidCount,
                                       legendKeys: [
                                        Key(key: "1", color: .red),
                                        //Key(key: "2", color: .blue),
                                        //Key(key: "3", color: .green)
                                       ],
                                       unitOfMeasure: "No. of Asteroids")
        barChartData.xAxisUnitOfMeasure = "Days"
        barChartData.yAxisFormatter = .decimal(5)
        
        let lineChart = FLChart(data: barChartData, type: .bar(bar: FLHorizontalMultipleValuesChartBar.self, highlightView: BarHighlightedView(), config: FLBarConfig(radius: .none, width: 10, spacing: 35)))
        lineChart.showAverageLine = true
        lineChart.config = FLChartConfig(granularityY: 20)
        
        let card = FLCard(chart: lineChart, style: .plain)
        card.showAverage = false
        card.showLegend = false
        
        view.addSubview(card)
        card.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.heightAnchor.constraint(equalToConstant: 290),
            card.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    
    struct FetchedData: Codable
    {
        let FastestAsteroidID: String
        let speedInKmph: Float
        let closestAsteroidID: String
        let closestAsteroidMissDistance: Float
        let sizeofAsteroidinKm: Float
    }
}






