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
    
    @IBOutlet weak var productionDetailOutlet: UIButton!
    @IBOutlet weak var generalDetailOutlet: UIButton!
    @IBOutlet weak var ProductionViewInDayTab: UIView!
    @IBOutlet weak var lineChartDetailViewTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet var detailImageIndicator: [UIImageView]!
    @IBOutlet weak var pieChartDetailsView: BottonCornerView!
    @IBOutlet weak var lineChartDetaisView: BottonCornerView!
    @IBOutlet weak var segmentedViewOutlet: UISegmentedControl!
    @IBOutlet weak var lineChartGraphic: LineChartView!
    @IBOutlet weak var PieChartGraphic: PieChartView!
    
    
    let service  = FirebaseService()
    let dateStringFunctions = DateString()
    var milksInfo = [MilkInfo]()
    var axisFormatDelegate: IAxisValueFormatter?
    var months: [String]! = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    var showMonth = false

    override func viewWillAppear(_ animated: Bool) {
        //animate charts wen appear
        self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        self.lineChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartsLayout()
        axisFormatDelegate = self
        takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Day)
    }
    
    // MARK: - SEGUE FROM DETAIL ABOUT CHARTS


    @IBAction func didSelectGeneralDetails(_ sender: AnyObject) {
        performSegue(withIdentifier: "detailSegueIdentifier", sender: nil)
    }
    
    @IBAction func didSelectProductionDetails(_ sender: AnyObject) {
        performSegue(withIdentifier: "detailSegueIdentifier", sender: nil)
    }
    
    // MARK - Actions FROM ADVANCED SEARCH
    
    @IBAction func didSelectEditCalendar(_ sender: AnyObject) {
        
        switch(segmentedViewOutlet.selectedSegmentIndex){
            
        case 0 :
            performSegue(withIdentifier: CALENDAR_SEGUE, sender: self)
            break
        case 1:
            performSegue(withIdentifier: CALENDAR_SEGUE, sender: self)
            break
        default:
            performSegue(withIdentifier: SPINNER_SEGUE, sender: self)
            break
        }
    }
    
    @IBAction func segmentControlAction(_ sender: AnyObject) {
        switch(segmentedViewOutlet.selectedSegmentIndex){
            
        case 0 :
            takeValue(path: "Fazendas/ID/Coleta/2016/10/07", queryType: .Day)
            break
        case 1:
            getWeekValues(day: "05/10/2016")
            break
        case 2:
            takeValue(path: "Fazendas/ID/Coleta/2016/10", queryType: .Month)
            break
        case 3:
            takeValue(path: "Fazendas/ID/Coleta/2016", queryType: .Year)
            break
        default:
            break
        }
    }
    
    func getTotalMilkInfo() -> [Double] {
        var total = [00.00,00.00,00.00]
        for index in milksInfo {
            if let sold = index.sold {
                total[0] += Double(sold)
            }
            if let intern = index.internConsume {
                total[1] += Double(intern)
            }
            if let lost = index.lost {
                total[2] += Double(lost)
            }
        }
        return total
    }
    
}

// MARK: - Database functions

extension ChartsViewController {
    
    func takeValue(path: String, queryType: QueryType) {
        service.takeValueFromDatabase(path: path, queryType: queryType) { [weak self] result in
            self?.milksInfo = result
            self?.loadAllCharts(queryType: queryType)
        }
    }
    
    func getWeekValues(day: String) {
        milksInfo.removeAll()
        var date = dateStringFunctions.getFormattedDay(day: day)
        let calendar = Calendar.current
        
        let group = DispatchGroup()
        for _ in 0..<7 {
            let dateString = dateStringFunctions.dateToString(calendar: calendar, date: date)
            let path = dateStringFunctions.getPathFromDate(dateString: dateString)

            group.enter()
            service.takeValueFromDatabase(path: path, queryType: .Week) { [weak self] result in
                self?.milksInfo += result
                group.leave()
            }
            
            date = dateStringFunctions.decreaseDate(calendar: calendar, date: date)
        }
        
        group.notify(qos: .background, flags: .assignCurrentContext, queue: .main) { [weak self] in
            self?.milksInfo = (self?.milksInfo.sorted { (self?.dateStringFunctions.getFormattedDay(day: $0.date!))!  < (self?.dateStringFunctions.getFormattedDay(day: $1
                .date!))!  })!
            self?.loadAllCharts(queryType: .Week)
        }
    }
}

// MARK: - Charts functions

extension ChartsViewController {
    
    
    func setupChartsLayout() {
        //make the segmented view upon other views
        segmentedViewOutlet.layer.zPosition = 1
        
        //create a color in detail views
        lineChartDetaisView.color = UIColor(red:187/255.0, green:138/255.0, blue:88/255.0, alpha: 1.0)
        pieChartDetailsView.color = UIColor(red: 58/255, green: 153/255, blue: 216/255, alpha: 1)
        
        //criate a border of charts views
        self.PieChartGraphic.layer.borderWidth = 1
        self.PieChartGraphic.layer.borderColor = UIColor(red: 58/255, green: 153/255, blue: 216/255, alpha: 1).cgColor
        
        self.lineChartGraphic.layer.borderWidth = 1
        self.lineChartGraphic.layer.borderColor = UIColor(red:187/255.0, green:138/255.0, blue:88/255.0, alpha: 1.0).cgColor
        
        ProductionViewInDayTab.layer.borderWidth = 1
        ProductionViewInDayTab.layer.borderColor = UIColor(red:187/255.0, green:138/255.0, blue:88/255.0, alpha: 1.0).cgColor
        
        
        for i in detailImageIndicator{
            i.image = i.image?.imageWithColor(tintColor: .white)
        }
    }
    
    // MARK: - Load Charts
    
    func loadAllCharts(queryType: QueryType) {
        switch queryType {
        case .Day:
            setupCharts(showLine: false, hiddenChart: true, isMonth: false, constant: -285)
        case .Week:
            setupCharts(showLine: true, hiddenChart: false, isMonth: false, constant: -5)
        case .Month:
            setupCharts(showLine: true, hiddenChart: false, isMonth: false, constant: -5)
        case .Year:
            setupCharts(showLine: true, hiddenChart: false, isMonth: true, constant: -5)
        default:
            break
        }
        
    }
    
    // MARK: - Setup Charts
    
    func setupCharts(showLine: Bool, hiddenChart: Bool, isMonth: Bool, constant: CGFloat) {
        loadPieChart()
        if(showLine) { loadLineChart() }
        self.lineChartGraphic.isHidden = hiddenChart
        lineChartDetailViewTopSpaceConstraint.constant = constant
        showMonth = isMonth
    }
    
    // MARK: - Load Pie Chart
    
    func loadPieChart() {
        let ys1 = Array(1..<4).map { x in return Double(x)}
        
        var total = getTotalMilkInfo()
        
        var pieChartLabel = ["Comercializado","Consumo","Descartado"]
        
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: total[x], label: pieChartLabel[x]) }
        
        let data = PieChartData()

        let ds1 = PieChartDataSet(values: yse1, label: "")
        
        ds1.colors = ChartColorTemplates.material()
        ds1.valueTextColor = UIColor.white
        ds1.sliceSpace = 0.1
        data.addDataSet(ds1)
        
        setupPieChartGraphic(data: data)
    }
    
    //MARK: - Load Line chart
    
    func loadLineChart() {
        
        let xs1Line = getXs1Line()
        
        let calendar = Calendar.current
        
        let se1Line = getSe1Line(xs1Line: xs1Line, calendar: calendar)
        
        let ds1Line = LineChartDataSet(values: se1Line, label: "Produção")
        
        setupDs1Line(ds1Line: ds1Line)
        
        let dataLine = LineChartData(dataSet: ds1Line)
        
        setupLineChartGraphic(dataLine: dataLine)
        
    }

    func getXs1Line() -> [Date] {
        let xs1Line = milksInfo.enumerated().map { indiceX, indiceY -> Date in
            if let date = milksInfo[indiceX].date {
                let dateFormatted = dateStringFunctions.getFormattedDay(day: date)
                return dateFormatted
            }
            return Date()
        }
        return xs1Line
    }
    
    
    func getSe1Line(xs1Line: [Date], calendar: Calendar) -> [ChartDataEntry] {
        let se1Line = xs1Line.enumerated().map { indiceX, indiceY -> ChartDataEntry in
            if let produced = milksInfo[indiceX].produced {
                let date = xs1Line[indiceX]
                return ChartDataEntry(x: date.timeIntervalSince1970, y: Double(produced))
            }
            return ChartDataEntry()
        }
        return se1Line
    }

    func setupDs1Line(ds1Line: LineChartDataSet) {
        ds1Line.colors = [NSUIColor.black]
        ds1Line.drawCirclesEnabled = true
        ds1Line.circleColors = [NSUIColor.black]
        ds1Line.circleRadius = 3
        ds1Line.circleHoleRadius = 0
        ds1Line.drawFilledEnabled = true
        ds1Line.fillColor = UIColor(colorLiteralRed: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        ds1Line.drawValuesEnabled = true
        ds1Line.lineWidth = 1
        ds1Line.mode = .linear
    }
    
    func setupLineChartGraphic(dataLine: LineChartData) {
        self.lineChartGraphic.data = dataLine
        self.lineChartGraphic.data?.highlightEnabled = false
        self.lineChartGraphic.gridBackgroundColor = NSUIColor.white
        self.lineChartGraphic.xAxis.drawGridLinesEnabled = false
        self.lineChartGraphic.xAxis.drawAxisLineEnabled = false
        self.lineChartGraphic.xAxis.setLabelCount(dataLine.entryCount, force: true)
        self.lineChartGraphic.xAxis.valueFormatter = axisFormatDelegate
        self.lineChartGraphic.dragEnabled = false
        self.lineChartGraphic.pinchZoomEnabled = false
        self.lineChartGraphic.chartDescription?.text = "Produção"
    }
    
    func setupPieChartGraphic(data: PieChartData) {
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        let centerText = NSMutableAttributedString(string: "Litros")
        self.PieChartGraphic.centerAttributedText = centerText
        self.PieChartGraphic.holeRadiusPercent = 0.35
        self.PieChartGraphic.transparentCircleRadiusPercent = 0.39
        self.PieChartGraphic.data = data
        self.PieChartGraphic.chartDescription?.text = "Produção total do leite/perca"
    }
}

extension ChartsViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM"
        let date = Date(timeIntervalSince1970: value)
        let calendar = Calendar.current
        
        if(showMonth) {
            return months[calendar.component(.month, from: date)]
        }else{
            return dateFormatter.string(from: Date(timeIntervalSince1970: value))
        }
    }
    
}
