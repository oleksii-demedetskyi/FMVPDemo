//: Playground - noun: a place where people can play

import UIKit
import FVMP_UI
import FMVP_Core

let bundle = Bundle(identifier: "dalog.FVMP-UI")
let storyboard = UIStoryboard(name: "Main", bundle: bundle)

guard let vc = storyboard.instantiateViewController(withIdentifier: "timer view controller")
    as? TimersViewController else { fatalError() }

let timers = Timers()
vc.props = timers.connect(to: vc)


let nvc = UINavigationController.init(rootViewController: vc)
nvc.view.frame = CGRect(x: 0, y: 0, width: 300, height: 500)

import PlaygroundSupport

PlaygroundPage.current.liveView = nvc.view
