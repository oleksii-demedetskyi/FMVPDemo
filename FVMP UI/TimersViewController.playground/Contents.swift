//: Playground - noun: a place where people can play

import UIKit
@testable import FVMP_UI

let bundle = Bundle(identifier: "dalog.FVMP-UI")
let storyboard = UIStoryboard(name: "Main", bundle: bundle)

guard let vc = storyboard.instantiateViewController(withIdentifier: "timer view controller")
    as? TimersViewController else { fatalError() }


final class Timers {
    private(set) var startDates = [] as [Date]

    func add() {
        startDates.append(Date())
    }
    
    func remove(at index: Int) {
        startDates.remove(at: index)
    }
}

let timersModel = Timers()

func connect() -> TimersViewController.Props {
    let newDate = Date()
    let calender = NSCalendar.autoupdatingCurrent
    
    func update() {
        vc.props = connect()
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
                timersModel.remove(at: index)
                update()
            }
            
            return .init(value: value(), delete: delete)
        }
        
        return timersModel.startDates.enumerated().map(timer)
    }
    
    func add() {
        timersModel.add()
        update()
    }
    
    return TimersViewController.Props(
        timers: timers(),
        addTimer: add,
        update: update)
}

vc.props = connect()

let nvc = UINavigationController.init(rootViewController: vc)
nvc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 500)

import PlaygroundSupport

PlaygroundPage.current.liveView = nvc.view
