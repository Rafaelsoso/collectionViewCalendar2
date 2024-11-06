//
//  ViewController.swift
//  Swift_CollectionView_Calendar
//
//  Created by anh.nguyen3 on 31/10/24.
//

import UIKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let dataSource: CalendarDataSource = CalendarDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        let headerViewNib = UINib(nibName: "HeaderView", bundle: nil)
        collectionView.register(headerViewNib, forSupplementaryViewOfKind: "DayHeaderView", withReuseIdentifier: "HeaderView")
        collectionView.register(headerViewNib, forSupplementaryViewOfKind: "HourHeaderView", withReuseIdentifier: "HeaderView")
        collectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "CalendarCell")
        let nib = UINib(nibName: "CalendarCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CalendarCell")

        self.collectionView.dataSource = dataSource

        if let dataSource = self.collectionView.dataSource as? CalendarDataSource {
            dataSource.configureCellBlock = { calendarCell, indexPath, calendarEvent in
                if let event = calendarEvent as? SampleCalendarEvent {
                    calendarCell.title?.text = event.title
                }
            }

            dataSource.configureHeaderViewBlock = {headerView, kind, indexPath in
                if kind == "DayHeaderView" {
                    headerView.titleLabel?.text = "Day \(indexPath.item + 1)"
                } else if kind == "HourHeaderView" {
                    headerView.titleLabel?.text = String(format: "%2d:00", indexPath.item + 1)
                }
            }
        }
    }
}
