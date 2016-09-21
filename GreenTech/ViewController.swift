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

class ViewController: UIViewController  {
    struct Color {
        static let selectedText = UIColor.white
        static let text = UIColor.black
        static let textDisabled = UIColor.gray
        static let selectionBackground = UIColor(red: 0.2, green: 0.2, blue: 1.0, alpha: 1.0)
        static let sundayText = UIColor(red: 1.0, green: 0.2, blue: 0.2, alpha: 1.0)
        static let sundayTextDisabled = UIColor(red: 1.0, green: 0.6, blue: 0.6, alpha: 1.0)
        static let sundaySelectionBackground = sundayText
    }
    
    @IBOutlet weak var milksTableView: UITableView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    
    // MARK: - Properties
    
    var shouldShowDaysOut = false
    var animationFinished = true
    
    var selectedDay:DayView!
    
    
    // MARK: - TableView Declaration
    
    let cellIdentifier = "CellIdentifier"
    let service  = FirebaseService()
    
    var milksInfo = [String]()
    
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        monthLabel.text = CVDate(date: Date()).globalDescription
    }
    
    @IBAction func todayMonthView(_ sender: AnyObject) {
        calendarView.toggleCurrentDayView()
    }
    
    @IBAction func toWeekView(_ sender: AnyObject) {
        calendarView.changeMode(.weekView)
    }
    
    @IBAction func toMonthView(_ sender: AnyObject) {
        calendarView.changeMode(.monthView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    func takeValue(_ id: String, month: String, day: String) {
        service.takeValueFromDatabase(id, month: month, day: day) { (milk) in
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

extension ViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        return UIColor.orange
    }
}


// MARK: - CVCalendarViewAppearanceDelegate

extension ViewController: CVCalendarViewAppearanceDelegate {
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

extension ViewController {
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

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milksInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MilkTableViewCell
        cell.configureCell("Quantidade", valueInfo: "100", unitInfo: "Lts")

        return cell
    }
    
    
}
