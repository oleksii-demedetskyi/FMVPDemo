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

final public class TimersViewController: UITableViewController {
    public struct Props {
        public static let new = Props.init
        
        public struct Timer {
            public let value: String
            public let delete: () -> ()
            
            public init(value: String, delete: @escaping () -> ()) {
                self.value = value
                self.delete = delete
            }
        }
        
        public let timers: [Timer]
        public let addTimer: () -> ()
        public let update: () -> ()
        
        public init(timers: [Timer],
                    addTimer: @escaping () -> (),
                    update: @escaping () -> ()) {
            self.timers = timers
            self.addTimer = addTimer
            self.update = update
        }
        
        static func empty() -> Props {
            return Props(timers: [], addTimer: {}, update: {})
        }
    }
    
    private var link: CADisplayLink?
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        link = CADisplayLink(target: self, selector: #selector(updateTimers))
        link?.preferredFramesPerSecond = 30
        link?.add(to: .current, forMode: .commonModes)
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        link?.remove(from: .current, forMode: .commonModes)
        link = nil
    }
    
    @objc private func updateTimers() {
        props.update()
        for case let cell as TimerViewCell in tableView.visibleCells {
            guard let index = tableView.indexPath(for: cell) else { fatalError() }
            cell.label.text = props.timers[index.row].value
        }
    }
    
    public var props: Props = Props.empty()
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return props.timers.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "timer") else {
            fatalError("Incorrect cell id")
        }
        
        return cell
    }
    
    @IBAction private func addTimer() {
        tableView.beginUpdates()
        tableView.insertRows(at: [.init(row: props.timers.count, section: 0)], with: .automatic)
        props.addTimer()
        tableView.endUpdates()
    }
    
    override public func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCellEditingStyle,
        forRowAt indexPath: IndexPath)
    {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        props.timers[indexPath.row].delete()
        tableView.endUpdates()
    }
}
