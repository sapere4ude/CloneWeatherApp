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
    private var fahrenheitOrCelsius: fahrenheigtOrCelsius? = UserInfo
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
