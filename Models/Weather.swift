//
//  Weather.swift
//  Weather
//
//  Created by Amber Xiao on 4/4/24.
//

import Foundation

struct Location: Identifiable, Codable, Hashable {
    let lat: String
    let lon: String
    let name: String
    let display_name: String
    let address: Address

    var id: String { "\(lat)_\(lon)" }

    private enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case name
        case display_name
        case address
    }
}

struct Address: Codable, Hashable {
    let city: String
    let county: String?
    let state: String
    let country: String
    let country_code: String

    private enum CodingKeys: String, CodingKey {
        case city
        case county, state, country, country_code
    }
}

struct WeatherInfo: Codable {
    var timestamp = Date()
    let data: WeatherData
    var hour: Int

    enum CodingKeys: String, CodingKey {
        case data = "hourly"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode(WeatherData.self, forKey: .data)
        hour = Calendar.current.component(.hour, from: Date())
    }
}

struct WeatherData: Codable {
    let time: [Date]
    let temperature: [Double]
    let precipitation_probability: [Int]
    let precipitation: [Double]

    private enum HourlyCodingKeys: String, CodingKey {
        case time
        case temperature_2m
        case precipitation_probability
        case precipitation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: HourlyCodingKeys.self)
        
        // Decode arrays directly from the container using nested keys
        time = try container.decode([String].self, forKey: .time).compactMap {
            // Convert each ISO8601-formatted string to Date
            DateFormatter.iso8601.date(from: $0)
        }
        temperature = try container.decode([Double].self, forKey: .temperature_2m)
        precipitation_probability = try container.decode([Int].self, forKey: .precipitation_probability)
        precipitation = try container.decode([Double].self, forKey: .precipitation)
    }
}

// Extension to DateFormatter for ISO8601 full date format
extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

// Mock Location and WeatherInfo
extension Location {
    static let mock: [Location] = {
        let json = """
        [{"place_id":14128726,"licence":"Data © OpenStreetMap contributors, ODbL 1.0. http://osm.org/copyright","osm_type":"relation","osm_id":188022,"lat":"39.9527237","lon":"-75.1635262","class":"boundary","type":"administrative","place_rank":16,"importance":0.7137973339835988,"addresstype":"city","name":"Philadelphia","display_name":"Philadelphia, Philadelphia County, Pennsylvania, United States","address":{"city":"Philadelphia","county":"Philadelphia County","state":"Pennsylvania","ISO3166-2-lvl4":"US-PA","country":"United States","country_code":"us"},"boundingbox":["39.8670050","40.1379593","-75.2802977","-74.9558314"]}]
        """

        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([Location].self, from: jsonData)
        } catch let error {
            fatalError("Failed to decode mock Location: \(error)")
        }
    }()
}

extension WeatherInfo {
    static let mock: WeatherInfo = {
        let json = """
        {"latitude":39.96187,"longitude":-75.155365,"generationtime_ms":0.0400543212890625,"utc_offset_seconds":0,"timezone":"GMT","timezone_abbreviation":"GMT","elevation":12.0,"hourly_units":{"time":"iso8601","temperature_2m":"°F","precipitation_probability":"%","precipitation":"mm"},"hourly":{"time":["2024-04-09T00:00","2024-04-09T01:00","2024-04-09T02:00","2024-04-09T03:00","2024-04-09T04:00","2024-04-09T05:00","2024-04-09T06:00","2024-04-09T07:00","2024-04-09T08:00","2024-04-09T09:00","2024-04-09T10:00","2024-04-09T11:00","2024-04-09T12:00","2024-04-09T13:00","2024-04-09T14:00","2024-04-09T15:00","2024-04-09T16:00","2024-04-09T17:00","2024-04-09T18:00","2024-04-09T19:00","2024-04-09T20:00","2024-04-09T21:00","2024-04-09T22:00","2024-04-09T23:00"],"temperature_2m":[62.9,59.0,56.1,53.9,52.3,50.9,49.8,48.7,48.1,47.4,46.1,45.6,50.3,58.0,63.8,68.7,72.6,75.8,75.7,77.8,78.6,78.1,76.1,73.2],"precipitation_probability":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],"precipitation":[0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00,0.00]}}
        """

        let jsonData = Data(json.utf8)
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(WeatherInfo.self, from: jsonData)
        } catch let error {
            fatalError("Failed to decode mock WeatherInfo: \(error)")
        }
    }()
}
