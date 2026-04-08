//
//  ViewController.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherViewController: UIViewController {
    //MARK: - UI list
    let recentTitleLabel = UILabel()
    let recentStackView = UIStackView()
    //MARK: - ViewState
    let statusLabel = UILabel()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)
    let retryButton = UIButton(type: .system)
    //MARK: -UI
    var cityLabel = UILabel()
    var tempLabel = UILabel()
    var desLabel = UILabel()
    let button = UIButton()
    let cityTextField = UITextField()
    
    //MARK: - ViewModel
    let vm = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        render(.idle)
        bindViewModel()
        renderRecentSearches()
//        bindData()
    }
    
    //MARK: - Set up UI
    func render(_ state: WeatherViewState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            
            statusLabel.isHidden = false
            statusLabel.text = "Search for a city to see the weather"
            
            cityLabel.isHidden = true
            tempLabel.isHidden = true
            desLabel.isHidden = true
            
            retryButton.isHidden = true
        case .loading:
            loadingIndicator.startAnimating()
            
            statusLabel.isHidden = false
            statusLabel.text = "Loading...."
            
            cityLabel.isHidden = true
            tempLabel.isHidden = true
            desLabel.isHidden = true
            
            retryButton.isHidden = true
        case .success(let data):
            loadingIndicator.stopAnimating()

            statusLabel.isHidden = true

            cityLabel.isHidden = false
            tempLabel.isHidden = false
            desLabel.isHidden = false

            cityLabel.text = data.name
            tempLabel.text = "\(data.main.temp)°C"
            desLabel.text = data.weather.first?.description ?? "No description"

            retryButton.isHidden = true
        case .error(let message):
            loadingIndicator.stopAnimating()

            statusLabel.isHidden = false
            statusLabel.text = message

            cityLabel.isHidden = true
            tempLabel.isHidden = true
            desLabel.isHidden = true
            

            retryButton.isHidden = false

        }
    }
    func setupUI() {
        view.backgroundColor = .white
        
        recentTitleLabel.text = "Recent Searches"
        recentTitleLabel.textAlignment = .center
        recentTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        recentStackView.axis = .vertical
        recentStackView.spacing = 12
        recentStackView.alignment = .fill
        recentStackView.distribution = .fill
        
        cityTextField.textAlignment = .center
        cityTextField.placeholder = "Enter city name"
        cityTextField.borderStyle = .roundedRect
        cityLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        desLabel.textAlignment = .center
        
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(onRefresh), for: .touchUpInside)
                
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(onRefresh), for: .touchUpInside)
        
//        loadingIndicator.hidesWhenStopped = true
        
        let stack = UIStackView(arrangedSubviews: [
            cityTextField,
            button,
            loadingIndicator,
            statusLabel,
            cityLabel,
            tempLabel,
            desLabel,
            retryButton,
            recentTitleLabel,
            recentStackView
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            recentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
//            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: - Bind Data
//    func bindData() {
//        vm.fetchWeather(city: city) { [weak self] in
//            guard let self = self else {return}
//            print("cityLabel: ", self.vm.cityName)
//            print("tempLabel: ", self.vm.temperature)
//            print("desLabel: ", self.vm.weatherDescription)
//            
//            self.cityLabel.text = self.vm.cityName
//            self.tempLabel.text = self.vm.temperature
//            self.desLabel.text = self.vm.weatherDescription
//        }
//    }
//    //MARK: - Action
    @objc func onRefresh() {
        guard let city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !city.isEmpty else {
            render(.error("Please enter a city name"))
            return
        }
        
        vm.fetchWeather(city: city)
    }
    //MARK: -render UI
    func renderRecentSearches() {
        recentStackView.arrangedSubviews.forEach{subview in
            recentStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        let recentCities = vm.getRecentSearches()
        print("list", recentCities)
        
        recentTitleLabel.isHidden = recentCities.isEmpty
        recentStackView.isHidden = recentCities.isEmpty
        print("recentStackView hidden:", recentStackView.isHidden)
        
        for city in recentCities {
            let button = UIButton(type: .system)
            button.setTitle(city, for: .normal)
            button.contentHorizontalAlignment = .center
            button.addAction(UIAction { [weak self] _ in
                self?.cityTextField.text = city
                self?.onRefresh()
            }, for: .touchUpInside)
            recentStackView.addArrangedSubview(button)
        }
        recentStackView.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    func bindViewModel() {
        vm.onStateWeather = { [weak self] state in
            guard let self = self else { return }
            self.render(state)
            
            switch state {
            case .success, .error:
                self.renderRecentSearches()
            default:
                break
            }
        }
    }
}

