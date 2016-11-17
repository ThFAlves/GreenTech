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
    
    var select = 0
    let service  = FirebaseService()
    let dateStringFunctions = DateString()
    var milksInfo = [MilkInfo]()
    var axisFormatDelegate: IAxisValueFormatter?
    var months: [String]! = ["", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var showMonth = false

    override func viewWillAppear(_ animated: Bool) {
        //animate charts wen appear
        //navigationController?.viewControllers.removeFirst()
        
        
        if let id = UserDefaults.standard.value(forKey: "Actual") {
            let date = dateStringFunctions.getCurrentDate()
            
            animateCellOfCharts(anim: select)
            if select == 0 {
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)/\(date.1)/\(date.0)", queryType: .Day)
                animateCellOfCharts(anim: 0)
            }
            if select == 1 {
                getWeekValues(day: "\(date.0)/\(date.1)/\(date.2)")
                animateCellOfCharts(anim: 1)
            }
            if select == 2 {
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)/\(date.1)", queryType: .Month)
                animateCellOfCharts(anim: 2)
            }
            if select == 3 {
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)", queryType: .Year)
                animateCellOfCharts(anim: 3)
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChartsLayout()
        axisFormatDelegate = self
    }
    
    
    // MARK: animations
    //animation for give a feedback from reload data
    
    func animateCellOfCharts(anim: Int) {
        
        if anim == 0 {
            self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            self.lineChartGraphic.animate(xAxisDuration: 0, yAxisDuration: 1.0)
            
            PieChartGraphic.alpha = 0
            lineChartGraphic.alpha = 0
            pieChartDetailsView.alpha = 0
            lineChartDetaisView.alpha = 0
            ProductionViewInDayTab.alpha = 0
            
            
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -5, 0, 0)
            PieChartGraphic.layer.transform = rotationTransform
            lineChartGraphic.layer.transform = rotationTransform
            pieChartDetailsView.layer.transform = rotationTransform
            lineChartDetaisView.layer.transform = rotationTransform
            ProductionViewInDayTab.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5, animations: {
                self.PieChartGraphic.alpha = 1
                self.lineChartGraphic.alpha = 0
                self.pieChartDetailsView.alpha = 1
                self.lineChartDetaisView.alpha = 1
                self.ProductionViewInDayTab.alpha = 1
                
                self.PieChartGraphic.layer.transform = CATransform3DIdentity
                self.lineChartGraphic.layer.transform = CATransform3DIdentity
                self.pieChartDetailsView.layer.transform = CATransform3DIdentity
                self.lineChartDetaisView.layer.transform = CATransform3DIdentity
                self.ProductionViewInDayTab.layer.transform = CATransform3DIdentity
                
            })
        }
        if anim >= 1 {

            self.PieChartGraphic.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
            self.lineChartGraphic.animate(xAxisDuration: 0, yAxisDuration: 1.0)
            
            PieChartGraphic.alpha = 0
            lineChartGraphic.alpha = 0
            pieChartDetailsView.alpha = 0
            lineChartDetaisView.alpha = 0
            ProductionViewInDayTab.alpha = 0
            
            
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -5, 0, 0)
            PieChartGraphic.layer.transform = rotationTransform
            lineChartGraphic.layer.transform = rotationTransform
            pieChartDetailsView.layer.transform = rotationTransform
            lineChartDetaisView.layer.transform = rotationTransform
            ProductionViewInDayTab.layer.transform = rotationTransform
            
            UIView.animate(withDuration: 0.5, animations: {
                self.PieChartGraphic.alpha = 1
                self.lineChartGraphic.alpha = 1
                self.pieChartDetailsView.alpha = 1
                self.lineChartDetaisView.alpha = 1
                self.ProductionViewInDayTab.alpha = 0
                
                self.PieChartGraphic.layer.transform = CATransform3DIdentity
                self.lineChartGraphic.layer.transform = CATransform3DIdentity
                self.pieChartDetailsView.layer.transform = CATransform3DIdentity
                self.lineChartDetaisView.layer.transform = CATransform3DIdentity
                self.ProductionViewInDayTab.layer.transform = CATransform3DIdentity
                
            })
        }
    }
    
    // MARK: - SEGUE FROM DETAIL ABOUT CHARTS

    func segmentToKind(_ kind: Int ) -> DateSelectionKind {
        
        var selectedKind = DateSelectionKind.DAY
        
        switch(kind){
            
        case 0 :
            selectedKind = DateSelectionKind.DAY
            break
        case 1:
            selectedKind = DateSelectionKind.WEEK
            break
        case 2:
            selectedKind = DateSelectionKind.MONTH
            break
        case 3:
            selectedKind = DateSelectionKind.YEAR
            break
        default:
            selectedKind = DateSelectionKind.DAY
            break
        }
        
        return selectedKind
    }

    
    //select the pie button
    @IBAction func didSelectGeneralDetails(_ sender: AnyObject) {
        performSegue(withIdentifier: "detailSegueIdentifier", sender: nil)
        
    }
    //select the line button
    @IBAction func didSelectProductionDetails(_ sender: AnyObject) {
        performSegue(withIdentifier: "productionDetailSegueIdentifier", sender: nil)
    }
    
    //send the segmented state from milkviewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegueIdentifier" {
            if let detailSelected = segue.destination as? MilkViewController {
                detailSelected.chartToDetailSelection = "generalDetail"
                detailSelected.segmentedSelection = String(segmentedViewOutlet.selectedSegmentIndex)

            }
        }
        
        if segue.identifier == "productionDetailSegueIdentifier" {
            if let detailSelected = segue.destination as? MilkViewController {
                detailSelected.chartToDetailSelection = "productionDetail"
                detailSelected.segmentedSelection = String(segmentedViewOutlet.selectedSegmentIndex)

            }
        }
        
        if segue.identifier == CALENDAR_SEGUE {
            if let selectedDateKindSelected = segue.destination as? CalendarViewController {
                selectedDateKindSelected.selectedDateKind = segmentToKind(segmentedViewOutlet.selectedSegmentIndex)
                
            }
        }
        
        if segue.identifier == SPINNER_SEGUE {
            if let selectedDateKindSelected = segue.destination as? SpinnerViewController {
                selectedDateKindSelected.selectedDateKind = segmentToKind(segmentedViewOutlet.selectedSegmentIndex)
            }
        }
    }
    
    //create a func with take the segmented section on milkViewController and update the segmented of chartsViewcontroller
    @IBAction func unwindFromMilkViewController(segue:UIStoryboardSegue) {
        if let detailSelected = segue.source as? MilkViewController {
            segmentedViewOutlet.selectedSegmentIndex = detailSelected.segmentedViewOutlet.selectedSegmentIndex
            select = detailSelected.segmentedViewOutlet.selectedSegmentIndex

        }
        
    }

    
    
    // MARK: - Actions FROM ADVANCED SEARCH
    
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
            print("spin")
            break
        }
    }
    
    @IBAction func segmentControlAction(_ sender: AnyObject) {
        
        if let id = UserDefaults.standard.value(forKey: "Actual") {
            let date = dateStringFunctions.getCurrentDate()
            
            switch(segmentedViewOutlet.selectedSegmentIndex){
                
            case 0 :
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)/\(date.1)/\(date.0)", queryType: .Day)
                animateCellOfCharts(anim: 0)
                break
            case 1:
                getWeekValues(day: "\(date.0)/\(date.1)/\(date.2)")
                animateCellOfCharts(anim: 1)
                break
            case 2:
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)/\(date.1)", queryType: .Month)
                animateCellOfCharts(anim: 1)
                break
            case 3:
                takeValue(path: "Fazendas/\(id)/Coleta/\(date.2)", queryType: .Year)
                animateCellOfCharts(anim: 1)
                break
            default:
                break
            }
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
        print(path)
        service.takeValueFromDatabase(path: path, queryType: queryType) { [weak self] result in
            self?.milksInfo = result
            print("Maffei")
            self?.loadAllCharts(queryType: queryType)
        }
    }
    
    func getWeekValues(day: String) {
        milksInfo.removeAll()
        var date = dateStringFunctions.getFormattedDay(day: day)
        let calendar = Calendar.current
        
        let group = DispatchGroup()
        for _ in 0..<7 {
            let dateString = dateStringFunctions.dateToStringPath(date: date)
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
        
        lineChartDetaisView.color = Color.browClear
        pieChartDetailsView.color = Color.blueClear
        
        //criate a border of charts views
        self.PieChartGraphic.layer.borderWidth = 1
        self.PieChartGraphic.layer.borderColor = Color.blueClear.cgColor
        
        self.lineChartGraphic.layer.borderWidth = 1
        self.lineChartGraphic.layer.borderColor = Color.browClear.cgColor
        
        ProductionViewInDayTab.layer.borderWidth = 1
        ProductionViewInDayTab.layer.borderColor = Color.browClear.cgColor
        
        
        for i in detailImageIndicator{
            i.image = i.image?.imageWithColor(tintColor: .white)
        }
    }
    
    // MARK: - Load Charts
    
    func loadAllCharts(queryType: QueryType) {
        switch queryType {
        case .Day:
            setupCharts(showLine: false, hiddenChart: true, isMonth: false, constant:-285)
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
        
        
        let pieColor = [Color.green,Color.chartYellow,Color.darkRed]
        
        ds1.colors = pieColor
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
        
        let ds1Line = LineChartDataSet(values: se1Line, label: "")
        
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
        ds1Line.fillColor = Color.browClear
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
        self.lineChartGraphic.chartDescription?.text = ""
        self.lineChartGraphic.noDataText = "Carregando os Dados..."
        self.lineChartGraphic.pinchZoomEnabled = false
        self.lineChartGraphic.doubleTapToZoomEnabled = false
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
        self.PieChartGraphic.noDataText = "Carregando os Dados..."

    }
}

extension ChartsViewController: IAxisValueFormatter {
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM"
        let date = Date(timeIntervalSince1970: value)
        let calendar = Calendar.current
        
        if(showMonth) {
            return months[calendar.component(.month, from: date)]
        }else{
            return dateFormatter.string(from: Date(timeIntervalSince1970: value))
        }
    }
    
}
