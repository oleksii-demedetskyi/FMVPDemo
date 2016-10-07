//
//  TimersModel.swift
//  FMVPDemo
//
//  Created by Alexey Demedetskii on 10/7/16.
//  Copyright © 2016 dalog. All rights reserved.
//

import Foundation
import FVMP_UI

final public class Timers {
    public init() {
        startDates = []
    }
    
    private(set) var startDates: [Date]
    
   ` public func add() {
        startDates.append(Date())
    }
    
    public func remove(at index: Int) {
        startDates.remove(at: index)
    }

    public func connect(to vc: TimersViewController) -> TimersViewController.Props {
        let newDate = Date()
        let calender = NSCalendar.autoupdatingCurrent
        
        func update() {
            vc.props = connect(to: vc)
        }
        
        func timers() -> [TimersViewController.Props.Timer] {
            func timer(from index: Int, date: Date) -> TimersViewController.Props.Timer {
                func value() -> String {
                    let components = calender.dateComponents(
                        [Calendar.Component.second, .nanosecond],
                        from: date, to: newDate)
                    guard let seconds = components.second,
                        let nanosec = components.nanosecond else { fatalError() }
                    
                    return
                        String(format: "%02d", seconds)
                            + ":" +
                            String(format: "%03d", .init(nanosec) / NSEC_PER_MSEC)
                }
                
                func delete() {
                    self.remove(at: index)
                    update()
                }
                
                return .init(value: value(), delete: delete)
            }
            
            return self.startDates.enumerated().map(timer)
        }
        
        func add() {
            self.add()
            update()
        }
        
        return TimersViewController.Props(
            timers: timers(),
            addTimer: add,
            update: update)
    }
}
