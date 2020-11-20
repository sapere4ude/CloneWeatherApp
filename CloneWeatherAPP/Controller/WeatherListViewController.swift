//
//  WeatherListViewController.swift
//  CloneWeatherAPP
//
//  Created by sapere4ude on 2020/11/16.
//

import UIKit
import MapKit

class WeatherListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let locationManager: CLLocationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var allowPermisson: Bool = false
    private var weather: [WeatherInfo] = [WeatherInfo]() {
        didSet {    //  프로퍼티 옵저버를 사용. 보여줘야하는 weather의 데이터가 지속적으로 변경될 때 didSet 하나만 설정해두면 귀찮은 작업을 반복하지 않아도 된다.
            DispatchQueue.main.async {  // UI관련 작업은 반드시 메인쓰레드에서 진행되어야 한다. 메인쓰레드.비동기방식
                self.tableView.reloadData()
            }
        }
    }
    private var fahrenheitOrCelsius: FahrenheitOrCelsius? = UserInfo.getFahrenheitOrCelsius() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var myCities: [Coordinate] = [Coordinate]() {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.myCities),
                                      forKey: UserInfo.cities
            )
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    private lazy var refreshControl: UIRefreshControl = {   // 새로고침을 만드는 메서드. lazy로 만들었기때문에 호출되는 시점에 사용되는 것.
                                                            // lazy를 사용하기 위해선? -> 1. 반드시 var와 함께 사용 2. struct,class에서만 사용 등등
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refreshData),
                                 for: .valueChanged
        )
        refreshControl.tintColor = UIColor.black
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        getCoordinate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    
    @objc private func refreshData() {
        guard let coordinate = currentLocation?.coordinate else {   // ?. <- 옵셔널 체이닝 확인할것
            return
        }
        
        weather.removeAll()
        DispatchQueue.global().async {
            self.getWeatherByCoordinate(latitude: coordinate.latitude.makeRound(),
                                        longitude: coordinate.longitude.makeRound())
            self.fetchCityList()    // fetch : (어딘가에서)가져오다
        }
    }
    
    private func getCoordinate() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func getWeatherByCoordinate(latitude lat: Double, longitude lon: Double) {
        let parameters: [String: Any] = [
            "lat" : "\(lat)",
            "lon" : "\(lon)",
            "appid" : weatherAPIKey
        ]
        
        let request = APIRequest(method: .get,
                                 path: BasePath.list,
                                 queryItems: parameters)
        APICenter().performSync(urlString: BaseURL.weatherURL, request: request){ [weak self] (result) in   // weak self : 약한참조로 만들어주기 위해 사용
            guard let self = self else {
                return
            }
            switch result {
            case .success(let response):
                if let response = try?  // 여기부터 시작할 것. weak self부터 타고타고 넘어가는 부분에 대한 것 질문해보기
            }
            
        }
        
    }
    
}
