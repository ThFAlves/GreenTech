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

struct MilkTotal{
    var produced: Float?
    var internConsume: Float?
    var sold: Float?
}

class ChartsViewController: UIViewController {
    
    @IBOutlet var detailImageIndicator: [UIImageView]!
    @IBOutlet weak var pieChartDetailsView: BottonCornerView!
    @IBOutlet weak var lineChartDetaisView: BottonCornerView!
    @IBOutlet weak var segmentedViewOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartGraphic: LineChartView!
    @IBOutlet weak var PieChartGraphic: PieChartView!
    
    let service  = FirebaseService()
    
    var queryMonth: [MilkInfo] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //animate charts wen appear
        self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        self.lineChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //make the segmented view upon other views
        segmentedViewOutlet.layer.zPosition = 1
        
        
        lineChartDetaisView.color = UIColor(red:187/255.0, green:138/255.0, blue:88/255.0, alpha: 1.0)
        pieChartDetailsView.color = UIColor(red: 58/255, green: 153/255, blue: 216/255, alpha: 1)
        
        //criate a border of charts views
        self.PieChartGraphic.layer.borderWidth = 1
        self.PieChartGraphic.layer.borderColor = UIColor(red: 58/255, green: 153/255, blue: 216/255, alpha: 1).cgColor
        
        self.lineChartGraphic.layer.borderWidth = 1
        self.lineChartGraphic.layer.borderColor = UIColor(red:187/255.0, green:138/255.0, blue:88/255.0, alpha: 1.0).cgColor
        
        
        for i in detailImageIndicator{
            i.image = i.image?.imageWithColor(tintColor: .white)
        }
        
        takeValue(path: "Fazendas/ID/Coleta/2016/10")
        
        
    }
    
    func loadCharts(){
        
        print(queryMonth)
        // MARK: - Pie Chart
        // Creating a pie chart
        
        //y values for the pie chart
        let ys1 = Array(1..<4).map { x in return Double(x)}
        
        var total = [00.00,00.00,00.00]
        var pieChartLabel = ["Comercializado","Consumo","Descartado",]
        
        for i in queryMonth {
            total[0] += Double(i.sold!)
            total[1] += Double(i.internConsume!)
            total[2] += Double(i.lost!)
        }
        
        
        //y of type piecChartDataEntry saving the x and y values of an item for the pie Chart
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: total[x], label: pieChartLabel[x]) }
        
        //creating piechartData object
        let data = PieChartData()
        //changing the name label of pie itens
        //        yse1[0].label = "Perdido"
        //        yse1[1].label = "Consumido"
        //        yse1[2].label = "Vendido"
        //        yse1[3].label = "Produzido"
        
        // insert the data obj
        let ds1 = PieChartDataSet(values: yse1, label: "")
        
        ds1.colors = ChartColorTemplates.material()
        
        ds1.valueTextColor = UIColor.white
        ds1.sliceSpace = 0.1
        
        
        data.addDataSet(ds1)
        
        
        //change mode texts in pie chart
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: "Litros")
        
        self.PieChartGraphic.centerAttributedText = centerText
        self.PieChartGraphic.holeRadiusPercent = 0.35
        self.PieChartGraphic.transparentCircleRadiusPercent = 0.39
        
        self.PieChartGraphic.data = data
        
        self.PieChartGraphic.chartDescription?.text = "Produção total do leite/perca"
        
        
        
        
        //MARK: - line chart
        
        
        
        
        
        //        var xs1Line = Array(1..<31)
        var ys1Line = [385, 386, 380]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        var xs1Line: [Date] = []//dateFormatter.date(from: "01-10-2016")
        
        for i in queryMonth {
            xs1Line.append(dateFormatter.date(from: i.date!)!)
            print(i.date)
        }
        
        
        
        // var ys1Line: [Float] = []
        
        
        var se1Line: [ChartDataEntry] = []
        
        
        let calendar = Calendar.current
        
        
        for i in 0..<xs1Line.count {
            let day = calendar.component(.day, from: xs1Line[i])
            print(day)
            se1Line.append(ChartDataEntry(x: Double(day), y: Double(ys1Line[i])))
        }
        
        
        let dataLine = LineChartData()
        
        let ds1Line = LineChartDataSet(values: se1Line, label: "Produção")
        ds1Line.colors = [NSUIColor.black]
        ds1Line.drawCirclesEnabled = true
        ds1Line.circleColors = [NSUIColor.black]
        ds1Line.circleRadius = 3
        ds1Line.circleHoleRadius = 0
        ds1Line.drawFilledEnabled = true
        //ds1Line.
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
    
    // MARK - Actions
    
    @IBAction func didSelectEditCalendar(_ sender: AnyObject) {
        
        switch(segmentedViewOutlet.selectedSegmentIndex){
            
        case 0 :
            performSegue(withIdentifier: CALENDAR_SEGUE, sender: self)
            break;
        case 1:
            performSegue(withIdentifier: CALENDAR_SEGUE, sender: self)
            break;
        default:
            performSegue(withIdentifier: SPINNER_SEGUE, sender: self)
            break;
        }
    }
}





// MARK: - Database functions

extension ChartsViewController {
    
    func takeValue(path: String) {
        service.takeMonthValueFromDatabase(path: path) { [weak self] result in
            self?.queryMonth = result
            self?.loadCharts()
        }
    }
    
}
