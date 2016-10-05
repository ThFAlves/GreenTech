//
//  ViewController.swiftCVCalendarView
//  CVCalendar Demo
//
//  Created by Мак-ПК on 1/3/15.
//  Copyright (c) 2015 GameApp. All rights reserved.
//

import UIKit
import CVCalendar
import Firebase
import FirebaseDatabase

class CalendarMilkViewController: UIViewController  {
    
    @IBOutlet weak var milksTableView: UITableView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var expandedSwitch: UIButton!
    @IBOutlet weak var calendarProportionalSize: NSLayoutConstraint!
    @IBOutlet weak var tableProporcionalHeight: NSLayoutConstraint!
    // MARK: - Properties
    
    var expandedCalendar = false
    var animationFinished = true
    var selectedDay:DayView!
    
    
    // MARK: - TableView Declaration
    
    let cellIdentifier = "CellIdentifier"
    let service  = FirebaseService()
    let descriptionVector: [String] = ["Quantidade", "CBT", "CCS", "CR", "Empresa"]
    let unitVector: [String] = ["Lts", "UFC/mL", "mil/mL", "oH", ""]
    var milksInfo = [String]()
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        takeValue("ID", year: "2016" , month: "10", day: "01")
        monthLabel.text = CVDate(date: Date()).globalDescription
    
    }
    
    @IBAction func todayMonthView(_ sender: AnyObject) {
        calendarView.toggleCurrentDayView()
    }
    
    @IBAction func toWeekView(_ sender: AnyObject) {
        (expandedCalendar) ?  changeCalendarMode(modeView: .monthView, expanded: false, title: "Reduzir", multiplierCalendar: 0.3, multiplierTable: 0.42) : changeCalendarMode(modeView: .weekView, expanded: true, title: "Expandir", multiplierCalendar: 0.08, multiplierTable: 0.64)
    }
    
    func changeCalendarMode(modeView: CalendarMode, expanded: Bool,title: String, multiplierCalendar: CGFloat, multiplierTable: CGFloat){
        
        calendarView.changeMode(modeView)
        expandedCalendar = expanded
        expandedSwitch.setTitle(title, for: .normal)
        calendarProportionalSize = MyConstraint.changeMultiplier(constraint: calendarProportionalSize, multiplier: multiplierCalendar)
        tableProporcionalHeight = MyConstraint.changeMultiplier(constraint: tableProporcionalHeight, multiplier: multiplierTable)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    // take value for itens from database
    func takeValue(_ id: String,year: String, month: String, day: String) {
        service.takeValueFromDatabase(id,year: year, month: month, day: day) { (milk) in
            self.milksInfo.append(milk.quantidade)
            self.milksInfo.append(milk.cbt)
            self.milksInfo.append(milk.ccs)
            self.milksInfo.append(milk.cr)
            self.milksInfo.append(milk.empresa)

            self.milksTableView.reloadData()
        }
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate


extension CalendarMilkViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        selectedDay = dayView
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center

            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)

            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0

                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity

                }) { _ in

                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransform.identity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }

    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColorFromRGB(rgbValue: 0x804000)
    }
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarMilkViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }
    
    func dayLabelColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (_, .selected, _), (_, .highlighted, _): return Color.selectedText
        case (.sunday, .in, _): return Color.sundayText
        case (.sunday, _, _): return Color.sundayTextDisabled
        case (_, .in, _): return Color.text
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return Color.sundaySelectionBackground
        case (_, .selected, _), (_, .highlighted, _): return Color.selectionBackground
        default: return nil
        }
    }
}

// MARK: - Convenience API Demo

extension CalendarMilkViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.current
        var components = Manager.componentsForDate(Foundation.Date()) // from today
        components.month! += offset
        let resultDate = calendar.date(from: components)!
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate) {
        let components = Manager.componentsForDate(date as Date) // from today
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate) {
        let components = Manager.componentsForDate(date as Date) // from today
        print("Showing Month: \(components.month)")
    }
    
}

// MARK: - TableView

// CAN BE DELETED IN THE NEW TYPE OF CALLENDAR
//generate the cells of itens
extension CalendarMilkViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell(descriptionVector[indexPath.row], valueInfo: milksInfo[indexPath.row], unitInfo: unitVector[indexPath.row])

        return cell
    }
    

}
