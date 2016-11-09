//
//  CalendarViewController.swift
//  GreenTech
//
//  Created by Juliana Salgado on 13/10/16.
//  Copyright © 2016 HyagoHirai. All rights reserved.
//

import Foundation
import UIKit
import CVCalendar

enum DateSelectionKind {
    
    case DAY
    case WEEK
    case MONTH
    case YEAR
}

class CalendarViewController: UIViewController {
    
    //MARK - Outlets and properties
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    var selectedDay:DayView!
    var selectedDateKind : DateSelectionKind?
    
    //MARK - Class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = CVDate(date: Date()).globalDescription
        
        // Appearance delegate [Optional]
        self.calendarView.calendarAppearanceDelegate = self
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCalendarViewAccording(selectedDateKind)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func setCalendarViewAccording(_ toKind : DateSelectionKind?) {
        
        guard let dateKind = toKind else { return }
        
        switch (dateKind){
        case DateSelectionKind.DAY :
            break
            
        case DateSelectionKind.WEEK :
            break
            
        default :
            break
        }
    }
    
    //MARK - Actions
    @IBAction func didFinishedEditing(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarView: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    public func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    public func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    public func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ? UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0) : UIColor.white
    }
    
    public func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    public func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    public func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        //        selectedDay = dayView
    }
}

// MARK: - CVCalendarViewAppearanceDelegate

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
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
