//
//  TimersViewController.swift
//  FMVPDemo
//
//  Created by Alexey Demedetskii on 10/4/16.
//  Copyright © 2016 dalog. All rights reserved.
//

import UIKit
import QuartzCore

final class TimerViewCell: UITableViewCell {
    @IBOutlet fileprivate var label: UILabel! {
        didSet {
            label.font = UIFont.monospacedDigitSystemFont(
                ofSize: label.font.pointSize,
                weight: UIFontWeightMedium)
        }
    }
}

final class TimersViewController: UITableViewController {
    
    private var link: CADisplayLink?
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        link = CADisplayLink(target: self, selector: #selector(updateTimers))
        link?.preferredFramesPerSecond = 60
        link?.add(to: .current, forMode: .commonModes)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        link?.remove(from: .current, forMode: .commonModes)
        link = nil
    }
    
    @objc private func updateTimers() {
        let calender = NSCalendar.autoupdatingCurrent
        for cell in tableView.visibleCells {
            guard let cell = cell as? TimerViewCell else { fatalError() }
            
            let components = calender.dateComponents(
                [Calendar.Component.second, .nanosecond],
                from: timers[tableView.indexPath(for: cell)!.row],
                to: Date())
            guard let seconds = components.second,
                let nanosec = components.nanosecond else { fatalError() }
            
            cell.label.text =
                String(format: "%02d", seconds)
                + ":" +
                String(format: "%03d", .init(nanosec) / NSEC_PER_MSEC)
        }
    }
    
    private var timers = [] as [Date]
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timer") else {
            fatalError("Incorrect cell id")
        }
        
        return cell
    }
    
    @IBAction private func addTimer() {
        tableView.beginUpdates()
        tableView.insertRows(at: [.init(row: timers.count, section: 0)], with: .automatic)
        timers.append(Date())
        tableView.endUpdates()
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath)
    {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        timers.remove(at: indexPath.row)
        tableView.endUpdates()
    }
}
