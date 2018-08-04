//
//  SecondVC.swift
//  Swifty
//
//  Created by Oleksii MIROSHNYK on 7/30/18.
//  Copyright © 2018 Oleksii MIROSHNYK. All rights reserved.
//

import Foundation
import UIKit
import Charts
import DDSpiderChart

class SecondVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var navigationName: UINavigationItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coalitionImageView: UIImageView!
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var correctionLabel: UILabel!
    @IBOutlet weak var walletLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var staffLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    @IBOutlet weak var horizontalLevelBar: HorizontalBarChartView!
    @IBOutlet weak var spiderChartView: DDSpiderChartView!
    
    @IBOutlet weak var tableView: UITableView!
    let identifier = "cell"
    
    var user: NSDictionary?
    var coalitions: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifier)
        
        let student = Student(user: user!, coalitions: coalitions!)

        if (student.isStaff == true) {
            staffLabel.isHidden = false
        } else {
            staffLabel.isHidden = true
        }
        navigationName.title = student.displayname
        imageView.layer.cornerRadius = imageView.frame.width/4
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        if let url = URL(string: student.image_url!) {
            do {
                let data = try Data(contentsOf: url)
                imageView.image = UIImage(data: data)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        if student.coalition_name == "The Hive" {
            coalitionImageView.image = UIImage(named: "hive_back")
        } else if student.coalition_name == "The Empire" {
            coalitionImageView.image = UIImage(named: "empire_back")
        } else if student.coalition_name == "The Alliance" {
            coalitionImageView.image = UIImage(named: "alliance_back")
        } else if student.coalition_name == "The Union" {
            coalitionImageView.image = UIImage(named: "union_back")
        } else {
            coalitionImageView.image = UIImage(named: "42")
        }
        
        loginLabel.text = student.login
        locationLabel.text = student.location
        if let email = student.email {
            emailLabel.text = "✉️: " + email
        }
        if let phone = student.phone {
            phoneLabel.text = "📞: " + phone
        }
        if let wallet = student.wallet {
            walletLabel.text = "Wallet: " + wallet
        }
        if let points = student.correctionPoints {
            correctionLabel.text = "Points: " + points
        }
        if let level = student.level {
            self.drawHorizontalChart(level: level)
            levelLabel.textColor = UIColor.white
            let v1 = level.split(separator: ".")[0]
            let v2 = level.split(separator: ".")[1]
            levelLabel.text = "Level " + v1 + " - " + String(describing: Int(v2)!) + "%"
        }
        
        self.drawSpiderChart(student: student)
    }
    
    func drawSpiderChart(student: Student) {
        student.skills.sort(by: {$0 > $1})
        spiderChartView.color = .gray
        var val : [Float] = []
        var name : [String] = []
        let skills = student.returnSkillsForRadar()
        for s in skills {
            name.append(s.0)
            val.append(Float(s.1)! / 20)
        }
        spiderChartView.axes = name.map { attributedAxisLabel($0) }
        spiderChartView.addDataSet(values: val, color: UIColor(red: 8.0/255.0, green: 160.0/255.0, blue: 133.0/255.0, alpha: 1.0))
    }
    
    func attributedAxisLabel(_ label: String) -> NSAttributedString {
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: label, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "ArialMT", size: 8)!, NSAttributedStringKey.paragraphStyle: style]))
        return attributedString
    }
    
    func drawHorizontalChart(level: String) {
    
        horizontalLevelBar.drawBarShadowEnabled = true
        horizontalLevelBar.drawValueAboveBarEnabled = true
        horizontalLevelBar.maxVisibleCount = 100
        horizontalLevelBar.chartDescription?.text = ""
        horizontalLevelBar.scaleXEnabled = false
        horizontalLevelBar.scaleYEnabled = false
        horizontalLevelBar.dragEnabled = false

        let xAxis  = horizontalLevelBar.xAxis
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.drawLabelsEnabled = false

        let leftAxis = horizontalLevelBar.leftAxis
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.axisMinimum = 0.0;
        leftAxis.axisMaximum = 100;
        leftAxis.drawLabelsEnabled = false

        let rightAxis = horizontalLevelBar.rightAxis
        rightAxis.enabled = false

        let l = horizontalLevelBar.legend
        l.enabled =  false
        setDataCount(level: level)

    }

    func setDataCount(level: String) {

        var yVals = [BarChartDataEntry]()
        let level = Double(String(level).split(separator: ".")[1])!
        yVals.append(BarChartDataEntry(x: 0, y: level))
        var set1 : BarChartDataSet!

        if let count = horizontalLevelBar.data?.dataSetCount, count > 0 {
            set1 = horizontalLevelBar.data?.dataSets[0] as! BarChartDataSet
            set1.values = yVals
            horizontalLevelBar.data?.notifyDataChanged()
            horizontalLevelBar.notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(values: yVals, label: nil)
            set1.drawValuesEnabled = false
            var dataSets = [BarChartDataSet]()
            set1.colors = [NSUIColor(red: 0.0/255.0, green: 186.0/255.0, blue: 188.0/255.0, alpha: 1.0)]
            dataSets.append(set1)
            let data = BarChartData(dataSets: dataSets)
            horizontalLevelBar.data = data
            horizontalLevelBar.animate(yAxisDuration: 1.0, easingOption: .easeInOutQuart)
        }
    }
    
    //MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            break
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.textLabel?.text = "section = \(indexPath.section) row = \(indexPath.row)"
        return cell
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
