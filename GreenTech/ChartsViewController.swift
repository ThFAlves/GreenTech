//
//  ChartsViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 30/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Charts
import Firebase
import FirebaseDatabase

class ChartsViewController: UIViewController {

    
    
    
    @IBOutlet weak var pieChartDetailsView: BottonCornerView!
    @IBOutlet weak var lineChartDetaisView: BottonCornerView!
    @IBOutlet weak var segmentedViewOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartGraphic: LineChartView!
    @IBOutlet weak var PieChartGraphic: PieChartView!
    
    let service  = FirebaseService()

    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //animate charts wen appear
        self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        self.lineChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        takeMonthValue("ID", year: "2016", month: "10")
        
        //make the segmented view upon other views
        segmentedViewOutlet.layer.zPosition = 1
        
        
        lineChartDetaisView.color = UIColor(red:194/255.0, green:179/255.0, blue:162/255.0, alpha: 1.0)
        pieChartDetailsView.color = UIColor(red: 152/255, green: 189/255, blue: 245/255, alpha: 1)

        //criate a border of charts views
        self.PieChartGraphic.layer.borderWidth = 1
        self.PieChartGraphic.layer.borderColor = UIColor(red: 152/255, green: 189/255, blue: 245/255, alpha: 1).cgColor
        
        self.lineChartGraphic.layer.borderWidth = 1
        self.lineChartGraphic.layer.borderColor = UIColor(red:194/255.0, green:179/255.0, blue:162/255.0, alpha: 1.0).cgColor
        
        
        // MARK: - Pie Chart
        // Creating a pie chart
        
        //y values for the pie chart
        let ys1 = Array(1..<5).map { x in return Double(x)}
        
        //y of type piecChartDataEntry saving the x and y values of an item for the pie Chart
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: y, label: String(x)) }
        
        //creating piechartData object
        let data = PieChartData()
        //changing the name label of pie itens
        yse1[0].label = "Perdido"
        yse1[1].label = "Consumido"
        yse1[2].label = "Vendido"
        yse1[3].label = "Produzido"
        
        // insert the data obj
        let ds1 = PieChartDataSet(values: yse1, label: "Valores")
        
        ds1.colors = ChartColorTemplates.colorful()
        
        ds1.valueTextColor = UIColor.white
        ds1.sliceSpace = 0.1
       
        
        data.addDataSet(ds1)
        
        
        //change mode texts in pie chart
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: "Produção")
        
        self.PieChartGraphic.centerAttributedText = centerText
        self.PieChartGraphic.holeRadiusPercent = 0.35
        self.PieChartGraphic.transparentCircleRadiusPercent = 0.39
        
        self.PieChartGraphic.data = data
        
        self.PieChartGraphic.chartDescription?.text = "Produção total do leite/perca"
    
        
        
        
        //MARK: - line chart
        
        
        let xs1Line = Array(1..<31)
        let ys1Line = [385, 386, 380, 370, 400, 390, 400, 380, 355, 370, 380, 370, 383, 370, 380, 370, 386, 380, 380, 380, 390, 400, 380, 385, 370, 380, 380, 375, 380, 385, 380, 380]
        var se1Line: [ChartDataEntry] = []

        for i in 1..<xs1Line.count {
            
            se1Line.append(ChartDataEntry(x: Double(xs1Line[i]), y: Double(ys1Line[i])))
        }
        
//        let se1Line = xs1Line.enumerated().map { xs1Line, ys1Line in return ChartDataEntry(x: Double(xs1Line), y: Double(ys1Line))
        
        
        let dataLine = LineChartData()
    
        let ds1Line = LineChartDataSet(values: se1Line, label: "Produção")
        ds1Line.colors = [NSUIColor.black]
        ds1Line.drawCirclesEnabled = true
        ds1Line.circleColors = [NSUIColor.black]
        ds1Line.circleRadius = 3
        ds1Line.circleHoleRadius = 0
        ds1Line.drawFilledEnabled = true
        ds1Line.fillColor = UIColor(colorLiteralRed: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        ds1Line.drawValuesEnabled = false
        ds1Line.lineWidth = 1
        ds1Line.mode = LineChartDataSet.Mode.linear

        
        dataLine.addDataSet(ds1Line)
        self.lineChartGraphic.data = dataLine
        self.lineChartGraphic.data?.highlightEnabled = false
        self.lineChartGraphic.gridBackgroundColor = NSUIColor.white
       
        self.lineChartGraphic.xAxis.drawGridLinesEnabled = false
        self.lineChartGraphic.xAxis.drawAxisLineEnabled = false
        self.lineChartGraphic.dragEnabled = false
        self.lineChartGraphic.pinchZoomEnabled = false
        self.lineChartGraphic.chartDescription?.text = "Produção"
       
    }
    
}

// MARK: - Database functions

extension ChartsViewController {
    
    func takeMonthValue(_ id: String,year: String , month: String) {
        service.takeMonthValueFromDatabase(id, year: year , month: month) { [weak self] milk in

        }
    }
    
}



 
    

