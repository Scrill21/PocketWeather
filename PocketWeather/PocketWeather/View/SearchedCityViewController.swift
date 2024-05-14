//
//  CityWeatherViewController.swift
//  PocketWeather
//
//  Created by anthony byrd on 5/12/24.
//

import Foundation

import UIKit
import Combine

class SearchedCityViewController: UIViewController {
    
    //MARK: - UI Elements
    
    private var cityLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 70, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var measurementSegmentedControl: UISegmentedControl = {
        let items = ["°F", "°C"]
        let segmentedControl = UISegmentedControl(items: items)
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "-"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    //MARK: - Properties
    
    private let viewModel = SearchedCityViewModel()
    private var cancellables: Set<AnyCancellable> = []
    var cityName: String!
    
    //MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchWeather(cityName: cityName)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIElements()
    }
}

//MARK: - Actions

extension SearchedCityViewController {
    
    @objc func measurementChanged(_ segmentedControl: UISegmentedControl) {
        viewModel.measurementConversion(index: segmentedControl.selectedSegmentIndex)
    }
}

//MARK: - Methods

extension SearchedCityViewController {
    
    private func updateUIElements() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingView()
                } else {
                    self?.dismissLoadingView()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$networkError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error {
                    self?.presentErrorAlert(error)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$cityName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cityName in
                self?.cityLabel.text = cityName
            }
            .store(in: &cancellables)
        
        viewModel.$iconName
            .receive(on: DispatchQueue.main)
            .sink { [weak self] iconName in
                let iconNameURL = self?.viewModel.createIconURL(from: iconName)
                self?.weatherIconImageView.download(url: iconNameURL)
            }
            .store(in: &cancellables)
        
        viewModel.$temperature
            .receive(on: DispatchQueue.main)
            .sink { [weak self] temperature in
                if let temperature = temperature {
                    let tempToString = String(format: "%0.0f", temperature)
                    self?.temperatureLabel.text = "\(tempToString)°"
                }
            }
            .store(in: &cancellables)
        
        viewModel.$forecastDescription
            .receive(on: DispatchQueue.main)
            .sink { [weak self] description in
                self?.descriptionLabel.text = description?.capitalized
            }
            .store(in: &cancellables)
    }
    
    func presentErrorAlert(_ error: Error) {
        let alert = UIAlertController(title: "Network Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
}


//MARK: - UI Configuration

extension SearchedCityViewController {

    private func setup() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(cityLabel)
        mainStackView.addArrangedSubview(weatherIconImageView)
        mainStackView.addArrangedSubview(temperatureLabel)
        mainStackView.addArrangedSubview(measurementSegmentedControl)
        mainStackView.addArrangedSubview(descriptionLabel)
        
        applyGradientLayer()
        configureMeasurementSegmentedControl()
        addUIConstraints()
    }
    
    private func configureMeasurementSegmentedControl() {
        measurementSegmentedControl.addTarget(self, action: #selector(measurementChanged), for: .valueChanged)
    }
    
    private func applyGradientLayer() {
        let gradientLayer = CAGradientLayer.gradientLayer(in: view.bounds)
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addUIConstraints() {
        NSLayoutConstraint.activate([
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 300),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 200),
            
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
