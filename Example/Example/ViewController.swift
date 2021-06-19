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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Fixed Style"
        }
        return "Auto Style"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "distribution equal"
            } else {
                cell.textLabel?.text = "distribution start / end"
            }
        } else {
            cell.textLabel?.text = "distribution start"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc: UIViewController
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                vc = FixedEqualViewConrtroller()
            } else {
                vc = FixedSEViewController()
            }
        } else {
            vc = AutoStartViewController()
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

