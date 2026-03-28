//
//  ViewController.swift
//  API_Weather
//
//  Created by Hoàng Võ on 20/03/2026.
//

import UIKit

class WeatherViewController: UIViewController {
    //MARK: -UI
    var cityLabel = UILabel()
    var tempLabel = UILabel()
    var desLabel = UILabel()
    let button = UIButton()
    
    //MARK: - ViewModel
    let vm = WeatherViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
    
    //MARK: - Set up UI
    func setupUI() {
        view.backgroundColor = .white
        
        cityLabel.textAlignment = .center
        tempLabel.textAlignment = .center
        desLabel.textAlignment = .center
        
        button.setTitle("Refresh", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(onRefresh), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [cityLabel, tempLabel, desLabel, button])
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    //MARK: - Bind Data
    func bindData() {
        vm.fetchWeather { [weak self] in
            guard let self = self else {return}
            print("cityLabel: ", self.vm.cityName)
            print("tempLabel: ", self.vm.temperature)
            print("desLabel: ", self.vm.weatherDescription)
            
            self.cityLabel.text = self.vm.cityName
            self.tempLabel.text = self.vm.temperature
            self.desLabel.text = self.vm.weatherDescription
        }
    }
    //MARK: - Action
    @objc func onRefresh() {
        bindData()
    }
}

