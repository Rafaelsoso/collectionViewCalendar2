//
//  CalendarDataSource.swift
//  Swift_CollectionView_Calendar
//
//  Created by anh.nguyen3 on 31/10/24.
//

import UIKit

typealias ConfigureCellBlock = (CalendarCell, IndexPath, CalendarEvent) -> Void
typealias ConfigureHeaderViewBlock = (HeaderView, String, IndexPath) -> Void

class CalendarDataSource: NSObject {

    var events: [CalendarEvent] = []
    var configureCellBlock: ConfigureCellBlock?
    var configureHeaderViewBlock: ConfigureHeaderViewBlock?

    override init() {
        self.events = CalendarDataSource.generateSampleData()
    }

    func event(at indexPath: IndexPath) -> CalendarEvent {
        return events[indexPath.item]
    }

    func indexPathsOfEventsBetween(minDayIndex: Int, maxDayIndex: Int, minStartHour: Int, maxStartHour: Int) -> [IndexPath] {
        var indexPaths: [IndexPath] = []
        events.enumerated().forEach { (idx, calendarEvent) in
            if let event = calendarEvent as? SampleCalendarEvent {
                if event.day >= minDayIndex && event.day <= maxDayIndex && event.startHour >= minStartHour && event.startHour <= maxStartHour {
                    let indexPath = IndexPath(item: idx, section: 0)
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }

    static func generateSampleData() -> [CalendarEvent] {
        var events: [CalendarEvent] = []
        for _ in 0..<20 {
            let event = SampleCalendarEvent.randomEvent()
            events.append(event)
        }
        return events
    }
}

extension CalendarDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        configureCellBlock?(cell, indexPath, event)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath)
        configureHeaderViewBlock?(headerView as! HeaderView, kind, indexPath)
        return headerView
    }
    
    
}
