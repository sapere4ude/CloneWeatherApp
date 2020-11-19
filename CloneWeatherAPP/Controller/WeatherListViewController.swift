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
    
    @objc private func refreshData() {
        guard let coordinate = currentLocation?.coordinate else {
            return
        }
        
        weather.removeAll()
        DispatchQueue.global().async {
            self.getWeatherByCoordinate(latitude: coordinate.latitude.makeRound(),
                                        longitude: coordinate.longitude.makeRound())
            self.fetchCityList()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
