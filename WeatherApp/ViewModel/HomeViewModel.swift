//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by anas amer on 26/08/2024.

import Foundation
import CoreLocation
import SwiftUI
import Combine

class HomeViewModel:ObservableObject{
    
    
    @Published var isLoading:Bool = false
    @Published var hideComponent:Bool = false
    @Published var weatherTime:[String] = []
    @Published var weatherTemp:[Double] = []
    @Published var weatherCode:[Int] = []
    @Published var weatherConditions: [String: WeatherCodeIcon] = [:]
    @AppStorage("location") var location:String = ""
    @Published var toFahrenheit: Int = 0 {
        didSet {
            Task { @MainActor in
                updateTemperatures()
            }
        }
    }
    @Published var showErrorAlert:Bool = false
    var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    private let networkMonitor = NetworkMonitor()
    
    init() {
        // Observe changes to the network connection
        LoadIcons()
        networkMonitor.$isConnected
            .receive(on: DispatchQueue.main) // Ensure updates are on the main thread
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] isConnected in
                // Ensure self is not deallocated before performing the action
                guard let self = self else { return }
                print("internet status \(isConnected)")
                self.hideComponent = !isConnected
                if !isConnected {
                    Task { @MainActor in
                        self.loadWeatherFromLocalStorage()
                        self.location = ""
                    }
                }else{
                    if !location.isEmpty{
                        Task { @MainActor in
                            self.searchLocation()
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    func getCodeIcon(_ code:Int)->String{
        print("code => \(code)")
        if let icon = self.weatherConditions["\(code)"]?.day.image{
            print("code => \(code)")
            print("icon => \(icon)")
            return icon
        }
        return ""
    }
    private func LoadIcons(){
        if let loadedConditions = JsonLoader.shared.loadJson(filename: "weatherIcon", [String:WeatherCodeIcon].self) {
            self.weatherConditions = loadedConditions
        } else {
            print("Failed to load weather conditions.")
        }
    }
    
    @MainActor
    private func loadFromLocalStorage<T: Codable>(forKey key: String,as type: T.Type,process: (T) -> Void) {
        if let savedData: T = LocalStorageService.shared.load(forKey: key, as: type) {
            process(savedData)
        } else {
            self.weatherTime = []
            self.weatherTemp = []
            self.weatherCode = []
        }
    }
    
    @MainActor
    private func loadWeatherFromLocalStorage() {
        if self.weatherTemp.isEmpty{
            if let savedData = LocalStorageService.shared.load(forKey: "weather", as: Weather.self) {
                self.weatherTime = savedData.hourly.formatDate()
                self.weatherTemp = self.convertTemperatures(savedData.hourly.temperature2M)
                self.weatherCode = savedData.hourly.weatherCode
            }
        }
    }
    
    @MainActor
    func searchLocation() {
        CLGeocoder().geocodeAddressString(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if error != nil{
                // MARK: the geocodeAddressString error not clear message so i send nil so diplay a custom message
                self.handleLocationError(nil)
                return
            }
            
            guard let lat = placemarks?.first?.location?.coordinate.latitude,
                  let long = placemarks?.first?.location?.coordinate.longitude else {
                self.handleLocationError(nil)
                return
            }
            
            self.fetchWeatherData(lat: lat, long: long)
        }
    }
    
    @MainActor
    private func fetchWeatherData(lat: Double, long: Double) {
        self.isLoading = true
        
        NetworkHandler.shared.fetchAndStoreData(urlString: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(long)&hourly=temperature_2m,precipitation,weather_code&timezone=auto", responseType: Weather.self, storageKey: "weather") {[weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in
                switch result {
                case .success(let data):
                    self.weatherTime = data.hourly.formatDate()
                    self.weatherTemp = self.convertTemperatures(data.hourly.temperature2M)
                    self.weatherCode = data.hourly.weatherCode
                    self.isLoading = false
                    
                case .failure(let error):
                    self.showErrorAlert = true
                    self.errorMessage = error.errorDescription
                    self.isLoading = false
                }
            }
        }
        
    }
    
    @MainActor
    private func convertTemperatures(_ temps: [Double]) -> [Double] {
        return temps.map { temp in
            self.toFahrenheit == 1 ? temp.toFahrenheit().rounded(toDecimalPlaces: 2) : temp
        }
    }
    
    @MainActor
    private func updateTemperatures() {
        var newList:[Double] = []
        newList = self.weatherTemp.map { temp in
            toFahrenheit == 1 ? temp.toFahrenheit().rounded(toDecimalPlaces: 2) : temp.toCelsius().rounded(toDecimalPlaces: 2)
        }
        self.weatherTemp = newList
    }
    
    @MainActor
    private func handleLocationError(_ error: Error?) {
        self.showErrorAlert = true
        self.errorMessage = error?.localizedDescription ?? "Could not find the location, please enter a valid location name"
    }
}


