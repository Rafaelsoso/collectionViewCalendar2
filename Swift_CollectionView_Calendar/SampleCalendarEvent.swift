//
//  SampleCalendarEvent.swift
//  Swift_CollectionView_Calendar
//
//  Created by anh.nguyen3 on 31/10/24.
//

import UIKit

class SampleCalendarEvent: CalendarEvent {
    var title: String
    var day: Int
    var startHour: Int
    var durationInHours: Int

    static func randomEvent() -> SampleCalendarEvent {
        let randomID = arc4random_uniform(10000)
        let title = String("Event \(randomID)")
        let randomDay = arc4random_uniform(7)
        let randomStartHour = arc4random_uniform(24)
        let randomDurationInHours = arc4random_uniform(5) + 1
        return event(with: title, day: Int(randomDay), startHour: Int(randomStartHour), durationInHours: Int(randomDurationInHours))
    }
    
    static func event(with title: String, day: Int, startHour: Int, durationInHours: Int) -> SampleCalendarEvent {
        return SampleCalendarEvent(title: title, day: day, startHour: startHour, durationInHours: durationInHours)
    }

    init(title: String, day: Int, startHour: Int, durationInHours: Int) {
        self.title = title
        self.day = day
        self.startHour = startHour
        self.durationInHours = durationInHours
    }

    func description() -> String {
        return String(format: "%@: Day %d - Hour %d - Duration %d", title, day, startHour, durationInHours)
    }
}
