//
//  PieChartDataSet.swift
//  Charts
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

open class PieChartDataSet: ChartDataSet, IPieChartDataSet
{
    @objc(PieChartValuePosition)
    public enum ValuePosition: Int
    {
        case insideSlice
        case outsideSlice
    }
    
    fileprivate func initialize()
    {
        self.valueTextColor = NSUIColor.white
        self.valueFont = NSUIFont.systemFont(ofSize: 12.0)
    }
    
    public required init()
    {
        super.init()
        initialize()
    }
    
    public override init(values: [ChartDataEntry]?, label: String?)
    {
        super.init(values: values, label: label)
        initialize()
    }
    
    internal override func calcMinMax(entry e: ChartDataEntry)
    {
        calcMinMaxY(entry: e)
    }
    
    // MARK: - Styling functions and accessors
    
    fileprivate var _sliceSpace = CGFloat(0.0)
    
    /// the space in pixels between the pie-slices
    /// **default**: 0
    /// **maximum**: 20
    open var sliceSpace: CGFloat
    {
        get
        {
            return _sliceSpace
        }
        set
        {
            var space = newValue
            if space > 20.0
            {
                space = 20.0
            }
            if space < 0.0
            {
                space = 0.0
            }
            _sliceSpace = space
        }
    }
    
    /// indicates the selection distance of a pie slice
    open var selectionShift = CGFloat(18.0)
    
    open var xValuePosition: ValuePosition = .insideSlice
    open var yValuePosition: ValuePosition = .insideSlice
    
    /// When valuePosition is OutsideSlice, indicates line color
    open var valueLineColor: NSUIColor? = NSUIColor.black
    
    /// When valuePosition is OutsideSlice, indicates line width
    open var valueLineWidth: CGFloat = 1.0
    
    /// When valuePosition is OutsideSlice, indicates offset as percentage out of the slice size
    open var valueLinePart1OffsetPercentage: CGFloat = 0.75
    
    /// When valuePosition is OutsideSlice, indicates length of first half of the line
    open var valueLinePart1Length: CGFloat = 0.3
    
    /// When valuePosition is OutsideSlice, indicates length of second half of the line
    open var valueLinePart2Length: CGFloat = 0.4
    
    /// When valuePosition is OutsideSlice, this allows variable line length
    open var valueLineVariableLength: Bool = true
    
    /// the font for the slice-text labels
    open var entryLabelFont: NSUIFont? = nil
    
    /// the color for the slice-text labels
    open var entryLabelColor: NSUIColor? = nil
    
    // MARK: - NSCopying
    
    open override func copyWithZone(_ zone: NSZone?) -> AnyObject
    {
        let copy = super.copyWithZone(zone) as! PieChartDataSet
        copy._sliceSpace = _sliceSpace
        copy.selectionShift = selectionShift
        return copy
    }
}
