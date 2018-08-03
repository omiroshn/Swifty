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

class SecondVC: UIViewController {
    
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
//    @IBOutlet weak var spiderChartView: DDSpiderChartView!
    
    
    var user: NSDictionary?
    var coalitions: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            levelLabel.text = "Level " + v1 + " - " + v2 + "%"
        }
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
    
}
