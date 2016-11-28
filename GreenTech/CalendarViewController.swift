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

protocol CalendarFilterSelection {
    func didSelectYear(_ startYear: Int , _ endYear: Int)
    func didSelectMonth(_ startMonth: Int , _ endMonth: Int)
    func didSelectCustomDate(_ dates: [CVDate])
}

class CalendarViewController: UIViewController {
    
    //MARK - Outlets and properties
    
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var startPeriodButton: UIButton!
    @IBOutlet weak var endPeriodButton: UIButton!
    
    var selectedDay:DayView!
    var selectedDateKind : DateSelectionKind?
    var filterDelegate : CalendarFilterSelection?
    
    //MARK - Class methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let month = CVDate(date: Date()).month
        let monthName = DateFormatter().monthSymbols[month - 1]
        self.title = monthName.capitalizingFirstLetter()
        
        // Appearance delegate [Optional]
        self.calendarView.calendarAppearanceDelegate = self
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        //Appearance
        startPeriodButton.layer.borderWidth = 1
        startPeriodButton.layer.borderColor = strongGreen.cgColor
        startPeriodButton.backgroundColor = strongGreen
        startPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        startPeriodButton.setTitleColor(UIColor.white, for: .normal)
        
        endPeriodButton.layer.borderWidth = 1
        endPeriodButton.layer.borderColor = customLightGreen.cgColor
        endPeriodButton.backgroundColor = UIColor.white
        endPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        endPeriodButton.setTitleColor(customLightGreen, for: .normal)
        endPeriodButton.titleLabel?.textColor = customLightGreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    //MARK - Actions
    
    @IBAction func editingEndPeriod(_ sender: Any) {
        //Appearance
        startPeriodButton.layer.borderWidth = 1
        startPeriodButton.layer.borderColor = customLightGreen.cgColor
        startPeriodButton.backgroundColor = UIColor.white
        startPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        startPeriodButton.setTitleColor(customLightGreen, for: .normal)
        
        endPeriodButton.layer.borderWidth = 1
        endPeriodButton.layer.borderColor = strongGreen.cgColor
        endPeriodButton.backgroundColor = strongGreen
        endPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        endPeriodButton.titleLabel?.textColor = UIColor.white
        endPeriodButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func editingStartPeriod(_ sender: Any) {
        //Appearance
        startPeriodButton.layer.borderWidth = 1
        startPeriodButton.layer.borderColor = strongGreen.cgColor
        startPeriodButton.backgroundColor = strongGreen
        startPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        startPeriodButton.setTitleColor(UIColor.white, for: .normal)
        
        endPeriodButton.layer.borderWidth = 1
        endPeriodButton.layer.borderColor = customLightGreen.cgColor
        endPeriodButton.backgroundColor = UIColor.white
        endPeriodButton.setTitle("\(START_DATE) Teste", for: .normal)
        endPeriodButton.setTitleColor(customLightGreen, for: .normal)
    }
    
    @IBAction func didFinishedEditing(_ sender: AnyObject) {
        //        if startDate.month > endDate.month {
        //            showErrorAlert()
        //        }else {
        filterDelegate?.didSelectCustomDate([])
        
        // _ to discard resulting view controller
        _ = self.navigationController?.popViewController(animated: true)
        //        }
    }
}

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        return weekday == .sunday ? strongGreen : customLightGreen
    }
    
    public func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    public func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    public func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        
        if let date = dayView.date.convertedDate() {
            let month = CVDate(date: date).month
            let monthName = DateFormatter().monthSymbols[month - 1]
            self.title = monthName.capitalizingFirstLetter()
        }
        
        selectedDay = dayView
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
        case (.sunday, .in, _): return strongGreen
        case (.sunday, _, _): return strongGreen
        case (_, .in, _): return UIColor.darkGray
        default: return Color.textDisabled
        }
    }
    
    func dayLabelBackgroundColor(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIColor? {
        switch (weekDay, status, present) {
        case (.sunday, .selected, _), (.sunday, .highlighted, _): return strongGreen
        case (_, .selected, _), (_, .highlighted, _): return UIColor.darkGray
        default: return nil
        }
    }
}

