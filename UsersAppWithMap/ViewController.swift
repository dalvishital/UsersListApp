//
//  ViewController.swift
//  UsersAppWithMap
//
//  Created by Clouds Mac1 on 29/01/22.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

var userFlag: Bool = false
let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height
class ViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, MKMapViewDelegate{
    
    var webTable = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        users.removeAll()
        offlineData()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        title = "Users"
        webTableUI()
        CheckConnection()
       // Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(CheckConnection), userInfo: nil, repeats: true)
   }
    
   func CheckConnection() {
        if Reachability.isConnectedToNetwork(){
            ApiUserClass.shared.FetchData { Success in
                DispatchQueue.main.async {
                    self.webTable.reloadData()
                }
            } onFailure: { failed in
                print("Failed")
            }
       }else
       {
           userFlag = false
           offlineData()
       }
  }
    func offlineData()
    {
        users.removeAll()
        CreateDB.shared.FetchData { Success in
            for i in 0..<Success.count
            {
                let user = UsersModelClass(data: Success[i])
                users.append(user)
            }
            self.webTable.reloadData()
        }
    }
    func webTableUI()
    {
        webTable.translatesAutoresizingMaskIntoConstraints = false
        webTable.backgroundColor = .clear
        webTable.delegate = self
        webTable.tableFooterView = UIView()
        webTable.dataSource = self
        webTable.register(CustomCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(webTable)
        NSLayoutConstraint(item: webTable, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: width/25).isActive = true
        NSLayoutConstraint(item: webTable, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant:height/13.34).isActive = true
        NSLayoutConstraint(item: webTable, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width/1.086).isActive = true
        NSLayoutConstraint(item: webTable, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height/1.130).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
         webTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height / 7.411
    }
    var index = 0
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        cell.selectionStyle = .none
        if users.count != 0{
        let obj = users[indexPath.row].getpicture()
        let locObj = users[indexPath.row].getlocation()
        cell.NameLabel.text = users[indexPath.row].getname()
        cell.genderLabel.text = users[indexPath.row].getGender()
        //cell.mapView.tag = indexPath.row
        let url = URL(string: obj)
        if url != nil && userFlag == true
        {
            cell.mapView.isHidden = false
            DispatchQueue.global(qos: .background).async {
                let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        if data != nil{
                        cell.showImage.image = UIImage(data: data!)
                        }
                        let annotation = MKPointAnnotation()
                       cell.mapView.tag = indexPath.row
                        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(users[indexPath.row].getlattitude())!, longitude: Double(users[indexPath.row].getlongitude())!)
                        cell.mapView.addAnnotation(annotation)
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                        cell.mapView.setRegion(region, animated: true)
                    }
               }
         }
        }
       return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let cell = webTable.cellForRow(at: indexPath) as! CustomCell
        let annotation = MKPointAnnotation()
        let locObj = users[indexPath.row].getlocation()
        let streetObj = locObj["street"] as? [String:Any] ?? [:]
        annotation.title = "\(streetObj["number"] as! Int) \(streetObj["name"] as! String)"
       annotation.subtitle = "\(locObj["city"] as! String) \(locObj["state"] as! String)"
        annotation.coordinate = CLLocationCoordinate2D(latitude: Double(users[indexPath.row].getlattitude())!, longitude: Double(users[indexPath.row].getlongitude())!)
        cell.mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        cell.mapView.setRegion(region, animated: true)
        //webTable.reloadData()
    }
    
}

class CustomCell: UITableViewCell {

    var showImage = UIImageView()
    var genderLabel = UILabel()
    var NameLabel = UILabel()
    var mapView = MKMapView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
        showImageUI()
        mapViewUI()
        nameLabelUI()
        genderLabelUI()
    }
    func showImageUI()
    {
        showImage.translatesAutoresizingMaskIntoConstraints = false
        showImage.layer.borderColor = UIColor.gray.cgColor
        showImage.image = UIImage(named: "default_img")
        showImage.layer.borderWidth = 1
        showImage.clipsToBounds = true
        self.addSubview(showImage)
        NSLayoutConstraint(item: showImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: width/75).isActive = true
        NSLayoutConstraint(item: showImage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: showImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width/6.25).isActive = true
        NSLayoutConstraint(item: showImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width/6.25).isActive = true
    }
    func mapViewUI()
    {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.backgroundColor = .clear
        mapView.isHidden = true
        contentView.addSubview(mapView)
        NSLayoutConstraint(item: mapView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -(width/37.5)).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width/4.166).isActive = true
        NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: width/4.166).isActive = true
    }
    func nameLabelUI(){
        NameLabel.translatesAutoresizingMaskIntoConstraints = false
        NameLabel.textColor = UIColor.black
        NameLabel.font = UIFont.systemFont(ofSize: width / 18.75)
        NameLabel.lineBreakMode = .byTruncatingTail
        NameLabel.textAlignment = .left
        self.addSubview(NameLabel)
        NSLayoutConstraint(item: NameLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: width/5).isActive = true
        NSLayoutConstraint(item: NameLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: height/44.4666).isActive = true
        NSLayoutConstraint(item: NameLabel, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1, constant: -width/4.411).isActive = true
    }
    func genderLabelUI(){
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.textColor = UIColor.black.withAlphaComponent(0.77)
        genderLabel.font = UIFont.systemFont(ofSize: width / 20.833)
        genderLabel.lineBreakMode = .byTruncatingTail
        genderLabel.textAlignment = .left
        self.addSubview(genderLabel)
        NSLayoutConstraint(item: genderLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -height/22.233).isActive = true
        NSLayoutConstraint(item: genderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: width/5).isActive = true
        NSLayoutConstraint(item: genderLabel, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1, constant: -(width/6.818)).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

