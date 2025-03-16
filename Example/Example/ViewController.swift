//
//  ViewController.swift
//  Example
//
//  Created by lalawue on 2021/6/19.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Examples"
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.pin.all()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Fixed Style"
        case 1: return "Auto Style"
        case 2: return "Nested Example"
        default: return "Demo"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                cell.textLabel?.text = "distribution equal"
            } else {
                cell.textLabel?.text = "distribution start / end"
            }
        case 1:
            cell.textLabel?.text = "distribution start"
        case 2:
            cell.textLabel?.text = "nested views"
        case 3:
            if indexPath.row == 0 {
                cell.textLabel?.text = "login demo"
            } else {
                cell.textLabel?.text = "scroll view"
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UIViewController
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                vc = FixedEqualViewConrtroller()
            } else {
                vc = FixedSEViewController()
            }
        case 1:
            vc = AutoStartViewController()
        case 2:
            vc = NestedViewController()
        case 3:
            if indexPath.row == 0 {
                vc = LoginDemoViewController()
            } else {
                vc = ScrollViewDemoViewController()
            }
        default:
            vc = UIViewController()
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

