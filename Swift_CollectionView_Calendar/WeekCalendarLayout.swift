//
//  WeekCalendarLayout.swift
//  Swift_CollectionView_Calendar
//
//  Created by anh.nguyen3 on 1/11/24.
//
import WebKit

class WeekCalendarLayout: UICollectionViewLayout {
    var daysPerWeek: Int = 7
    var hoursPerDay: Int = 24
    var horizontalSpacing: CGFloat = 10
    var heightPerHour: CGFloat = 100
    var dayHeaderHeight: CGFloat = 40
    var hourHeaderWidth: CGFloat = 100

    override var collectionViewContentSize: CGSize {
        // don't scroll horizontally
        let contentWidth: CGFloat = self.collectionView?.bounds.width ?? 0

        // scroll vertically to display a full day
        let contentHeight: CGFloat = dayHeaderHeight + (heightPerHour * (CGFloat)(hoursPerDay))

        let contentSize = CGSize(width: contentWidth, height: contentHeight)
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes] {
        var layoutAttributes: [UICollectionViewLayoutAttributes] = []

        // cells
        let visibleIndexPaths = indexPathsOfItems(in: rect)
        for indexPath in visibleIndexPaths {
            let attributes = layoutAttributesForItem(at: indexPath)
            layoutAttributes.append(attributes)
        }

        // supplementary views
        let dayHeaderViewIndexPaths = indexPathsOfHourHeaderViews(in: rect)
        for indexPath in dayHeaderViewIndexPaths {
            let attributes = layoutAttributesForSupplementaryView(ofKind: "DayHeaderView", at: indexPath)
            layoutAttributes.append(attributes)
        }

        let hourHeaderViewIndexPaths = indexPathsOfHourHeaderViews(in: rect)
        for indexPath in hourHeaderViewIndexPaths {
            let attributes = layoutAttributesForSupplementaryView(ofKind: "HourHeaderView", at: indexPath)
            layoutAttributes.append(attributes)
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        guard let dataSource = collectionView?.dataSource as? CalendarDataSource else {
            return UICollectionViewLayoutAttributes.init()
        }
        let event = dataSource.event(at: indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frame(for: event)
        return attributes
    }

    override func layoutAttributesForSupplementaryView(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: kind, with: indexPath)
        
        let totalWidth = collectionViewContentSize.width
        if kind == "DayHeaderView" {
            let availableWidth = totalWidth - hourHeaderWidth
            let widthPerDay = availableWidth / CGFloat(daysPerWeek)
            attributes.frame = CGRect(x: hourHeaderWidth + (widthPerDay * CGFloat(indexPath.item)), y: 0, width: widthPerDay, height: dayHeaderHeight)
            attributes.zIndex = -10
        } else if kind == "HourHeaderView" {
            attributes.frame = CGRect(x: 0, y: dayHeaderHeight + heightPerHour * CGFloat(indexPath.item), width: totalWidth, height: heightPerHour)
            attributes.zIndex = -10
        }
        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    // - MARK: Helpers
    func indexPathsOfItems(in rect: CGRect) -> [IndexPath] {
        let minVisibleDay = dayIndex(fromXCoordinate: rect.minX)
        let maxVisibleDay = dayIndex(fromXCoordinate: rect.maxX)
        let minVisibleHour = hourIndex(fromYCoordinate: rect.minY)
        let maxVisibleHour = hourIndex(fromYCoordinate: rect.maxY)

        guard let dataSource = collectionView?.dataSource as? CalendarDataSource else {
            return []
        }
        let indexPaths = dataSource.indexPathsOfEventsBetween(minDayIndex: minVisibleDay,
                                                        maxDayIndex: maxVisibleDay,
                                                        minStartHour: minVisibleHour,
                                                        maxStartHour: maxVisibleHour)
        return indexPaths
    }

    func dayIndex(fromXCoordinate xPosition: CGFloat) -> Int {
        let contentWidth = collectionViewContentSize.width - hourHeaderWidth
        let widthPerDay = contentWidth / CGFloat(daysPerWeek)
        let dayIndex = max(0, Int((xPosition - hourHeaderWidth) / widthPerDay))
        return dayIndex
    }

    func hourIndex(fromYCoordinate yPosition: CGFloat) -> Int {
        let hourIndex = max(0, Int((yPosition - dayHeaderHeight) / heightPerHour))
        return hourIndex
    }

    func indexPathsOfHourHeaderViews(in rect: CGRect) -> [IndexPath] {
        if rect.minX > hourHeaderWidth {
            return []
        }
        
        let minHourIndex = hourIndex(fromYCoordinate: rect.minY)
        let maxHourIndex = hourIndex(fromYCoordinate: rect.maxY)
        
        var indexPaths: [IndexPath] = []
        for idx in minHourIndex...maxHourIndex {
            let indexPath = IndexPath(item: idx, section: 0)
            indexPaths.append(indexPath)
        }
        return indexPaths
    }

    func frame(for calendarEvent: CalendarEvent) -> CGRect {
        guard let event = calendarEvent as? SampleCalendarEvent else {
            return .zero
        }
        let totalWidth = collectionViewContentSize.width - hourHeaderWidth
        let widthPerDay = totalWidth / CGFloat(daysPerWeek)
        
        var frame = CGRect.zero
        frame.origin.x = hourHeaderWidth + widthPerDay * CGFloat(event.day)
        frame.origin.y = dayHeaderHeight + heightPerHour * CGFloat(event.startHour)
        frame.size.width = widthPerDay
        frame.size.height = CGFloat(event.durationInHours) * heightPerHour
        frame = frame.insetBy(dx: horizontalSpacing / 2.0, dy: 0)
        return frame
    }
}
