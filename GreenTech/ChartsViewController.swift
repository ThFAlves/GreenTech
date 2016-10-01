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

    
    @IBOutlet weak var lineChartGraphic: LineChartView!
    @IBOutlet weak var barChartGraphic: BarChartView!
    @IBOutlet weak var PieChartGraphic: PieChartView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
        self.lineChartGraphic.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        yse1[0].label = "Vendido"
        yse1[1].label = "Consumido"
        yse1[2].label = "Perdido"
        yse1[3].label = "Produzido"
        
        let ds1 = PieChartDataSet(values: yse1, label: "Valores")
        
        ds1.colors = ChartColorTemplates.colorful()
        
        data.addDataSet(ds1)
        
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: "Produção")
        
        self.PieChartGraphic.centerAttributedText = centerText
        
        self.PieChartGraphic.data = data
        
        self.PieChartGraphic.chartDescription?.text = "Produção total do leite/perca"
        
        
        
        //MARK: - line chart
        let ys1Line = Array(1..<30).map { xLine in return sin(Double(xLine) / 2.0 / 3.141 * 1.5) }
        let ys2Line = Array(1..<30).map { xLine in return cos(Double(xLine) / 3.0 / 4 * 1.5)}
        
        let yse1Line = ys1Line.enumerated().map { xLine, yLine in return ChartDataEntry(x: Double(xLine), y: yLine) }
        let yse2Line = ys2Line.enumerated().map { xLine, yLine in return ChartDataEntry(x: Double(xLine), y: yLine) }
        

        
        let dataLine = LineChartData()
    
        let ds1Line = LineChartDataSet(values: yse1Line, label: "Hello")
        ds1Line.colors = [NSUIColor.darkGray]
        ds1Line.drawCirclesEnabled = false
        //ds1Line.drawCubicEnabled = true
        ds1Line.drawFilledEnabled = true
        ds1Line.fillColor = UIColor.gray
        ds1Line.drawValuesEnabled = false

        
        dataLine.addDataSet(ds1Line)
        
        let ds2Line = LineChartDataSet(values: yse2Line, label: "World")
        ds2Line.colors = [NSUIColor.red]
        ds2Line.drawCirclesEnabled = false
        //ds2Line.drawCubicEnabled = true
        ds2Line.drawFilledEnabled = true
        ds2Line.fillColor = UIColor.red
        ds2Line.drawValuesEnabled = false

        dataLine.addDataSet(ds2Line)
        self.lineChartGraphic.data = dataLine
        self.lineChartGraphic.data?.highlightEnabled = false
        self.lineChartGraphic.gridBackgroundColor = NSUIColor.white
       
        self.lineChartGraphic.xAxis.drawGridLinesEnabled = false
        self.lineChartGraphic.xAxis.drawAxisLineEnabled = false
        self.lineChartGraphic.dragEnabled = false
        self.lineChartGraphic.pinchZoomEnabled = false
        self.lineChartGraphic.chartDescription?.text = "Linechart Demo"
       

    }
        
}


 
    

