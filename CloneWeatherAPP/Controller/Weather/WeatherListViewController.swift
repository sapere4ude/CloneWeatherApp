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
    
    private func fetchCityList() {
        guard let cities = UserInfo.getCityList() else {
            return
        }
        myCities = cities
        DispatchQueue.global().async {
            self.myCities.forEach({
                self.getWeatherByCoordinate(latitude: $0.lat,
                                            longitude: $0.lon)
                
            })
        }
    }
    
    // 79 - 99 공부하기. 아직 안봤음.
    private func setupViewController() {
        tableView.addSubview(refreshControl)
        registerForPreviewing(with: self, sourceView: tableView)
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
    }
    
    private func registerNib() {
        tableView.register(WeatherListTableViewCell.self)
        tableView.register(WeatherListSettingTableViewCell.self)
    }
    
    private func createObserver() {
        // NotificationCenter : notification의 중계자 역할
        // addObserver의 name이라는 키 값을 탐지. ".selectCity"라는 name의 notification이 오면 selector를 실행
        // NotificationCenter는 싱글턴 인스턴스라서 여러 오브젝트에 공유됨. 그래서 옵저버를 등록한 오브젝트가 메모리에서 해제되면 NSNotificationCenter에서도 옵저버를 없앴다고 알려줘야한다.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(selectedCity),
                                               name: .selectCity,
                                               object: nil
        )
    }
    
    @objc private func selectedCity(notification: NSNotification) {
        guard let cityCoordinate = notification.object as? CLLocationCoordinate2D else {    // as? <- 다운캐스팅
            return
        }
        if !myCities.contains(Coordinate(lat: cityCoordinate.latitude.makeRound(), lon: cityCoordinate.longitude.makeRound())){
            getWeatherByCoordinate(latitude: cityCoordinate.latitude, longitude: cityCoordinate.longitude)
            
            myCities.append(Coordinate(lat: cityCoordinate.latitude.makeRound(), lon: cityCoordinate.longitude.makeRound()))
        }
    }
    
    @objc private func refreshData() {
        guard let coordinate = currentLocation?.coordinate else {   // ?. <- 옵셔널 체이닝 확인할것
            return
        }
        
        weather.removeAll()
        DispatchQueue.global().async {
            self.getWeatherByCoordinate(latitude: coordinate.latitude.makeRound(),
                                        longitude: coordinate.longitude.makeRound())
            //self.fetchCityList()    // fetch : (어딘가에서)가져오다
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
                if let response = try? response.decode(to: WeatherInfo.self) {
                    self.checkCurrentLocationOrNot(bodyData: response.body)
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
                } else {
                    print(APIError.decodingFailed)
                }
            case .failure:
                print(APIError.networkFailed)
            }
        }
    }
    
    private func checkCurrentLocationOrNot(bodyData: WeatherInfo) {
        guard let coordinate = currentLocation?.coordinate else {   // coordinate = cuurentLocation?.coordinate가 아니라면 { } 구문 수행. 맞다면? bodyData.name 부분 실행
            if !allowPermisson {    // true라면 weather라는 이름의 배열에 데이터를 추가해준다.
                weather.append(bodyData)
            }
            return
        }
        if bodyData.name == weather.first?.name {
            return
        }
        if coordinate.latitude.makeRound() == bodyData.coord.lat,
           coordinate.longitude.makeRound() == bodyData.coord.lon {
            weather.insert(bodyData, at: 0)
        } else {
            weather.append(bodyData)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) // self에 등록된 옵저버 전체 제거
    }
    
}

// MARK : TableView Delegate and Datasource
extension WeatherListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherListCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}
