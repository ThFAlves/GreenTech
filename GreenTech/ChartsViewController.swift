//
//  ChartsViewController.swift
//  GreenTech
//
//  Created by Leonardo Maffei on 30/09/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {

    
    @IBOutlet weak var segmentedViewOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartGraphic: LineChartView!
    @IBOutlet weak var barChartGraphic: BarChartView!
    @IBOutlet weak var PieChartGraphic: PieChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        self.lineChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedViewOutlet.layer.zPosition = 1
        
        
        self.PieChartGraphic.layer.borderWidth = 1
        self.PieChartGraphic.layer.borderColor = UIColor(red:51/255.0, green:173/255.0, blue:66/255.0, alpha: 1.0).cgColor
        
        self.lineChartGraphic.layer.borderWidth = 1
        self.lineChartGraphic.layer.borderColor = UIColor(red:51/255.0, green:173/255.0, blue:66/255.0, alpha: 1.0).cgColor
        
        let ys1 = Array(1..<5).map { x in return Double(x)}
//        var ys1: [String] = []
//        for i in 0 ... teste.count {
//            ys1.append(teste[])
//        }
        
        
        // MARK: - Pie Chart
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: y, label: String(x)) }
        
        let data = PieChartData()
        yse1[0].label = "Perdido"
        yse1[1].label = "Consumido"
        yse1[2].label = "Vendido"
        yse1[3].label = "Produzido"
        
        let ds1 = PieChartDataSet(values: yse1, label: "Valores")
        
        ds1.colors = ChartColorTemplates.colorful()
        
        ds1.valueTextColor = UIColor.white
        ds1.sliceSpace = 0.1
       
        
        data.addDataSet(ds1)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Produção")
        
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
        ds1Line.colors = [NSUIColor.gray]
        ds1Line.drawCirclesEnabled = true
        ds1Line.circleColors = [NSUIColor.black]
        ds1Line.circleRadius = 3
        ds1Line.circleHoleRadius = 0
        ds1Line.drawFilledEnabled = true
        ds1Line.fillColor = UIColor.gray
        ds1Line.drawValuesEnabled = false
        ds1Line.lineWidth = 1
        ds1Line.mode = LineChartDataSet.Mode.linear

        
        dataLine.addDataSet(ds1Line)
        
//        ds2Line.colors = [NSUIColor.red]
//        ds2Line.drawCirclesEnabled = false
//        //ds2Line.drawCubicEnabled = true
//        ds2Line.drawFilledEnabled = true
//        ds2Line.fillColor = UIColor.red
//        ds2Line.drawValuesEnabled = false
//
//        dataLine.addDataSet(ds2Line)
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


 
    

