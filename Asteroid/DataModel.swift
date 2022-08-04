
import Foundation
import UIKit

struct Asteroid: Decodable{
    enum CodingKeys : String, CodingKey { case nearEarthObjects = "near_earth_objects" }
    let nearEarthObjects : NearEarthObjects

    struct NearEarthObjects: Decodable{
        //private enum CodingKeys : String, CodingKey { case innerData = "2022-08-01" }
        let innerData : [String:[DateData]]



        struct DateData : Decodable {
            enum CodingKeys : String, CodingKey { case estimatedDiameter = "estimated_diameter"
                case id = "id"
                case closeApproachData = "close_approach_data"
            }
            let estimatedDiameter : EstimatedDiameter
            let id : String
            let closeApproachData: [CloseApproachData]
            struct EstimatedDiameter : Decodable {
                enum CodingKeys : String, CodingKey { case kilometers = "kilometers" }
                let kilometers : Kilometers
                struct Kilometers : Decodable {
                    enum CodingKeys : String, CodingKey { case estimatedDiameterMax = "estimated_diameter_max"
                        case estimatedDiameterMin = "estimated_diameter_min"
                    }
                    let estimatedDiameterMax : Float
                    let estimatedDiameterMin : Float
                }
            }
            struct CloseApproachData : Decodable {
                enum CodingKeys : String, CodingKey { case relativeVelocity = "relative_velocity"
                    case missDistance = "miss_distance"
                }
                let relativeVelocity : RelativeVelocity
                let missDistance: MissDistance
                struct RelativeVelocity : Decodable {
                    enum CodingKeys : String, CodingKey { case kilometersPerSecond = "kilometers_per_second" }
                    let kilometersPerSecond : String
                }
                struct MissDistance : Decodable {
                    enum CodingKeys : String, CodingKey { case kilometers = "kilometers" }
                    let kilometers : String
                }
            }

        }

        init(from decoder: Decoder) throws {
            
                    var inner = [String: [DateData]]()
                    let customContainer = try decoder.container(keyedBy: CustomKey.self)
                    for key in customContainer.allKeys {
                        
                        if let innerValue = try? customContainer.decode([DateData].self, forKey: key) {
                            inner[key.stringValue] = innerValue

                        }
                       
                    }
            self.innerData = inner
        }
    }
    struct CustomKey: CodingKey {
            var stringValue: String
            var intValue: Int?
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            init?(intValue: Int) {
                self.stringValue = "\(intValue)";
                self.intValue = intValue
            }
        }

}





















