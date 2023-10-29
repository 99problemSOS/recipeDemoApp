//
//  BaseViewController.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    let safeAreaView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addView()
        addConstraint()
    }
    
    private func setup() {
        view.backgroundColor = AppColors.background
    }
    
    private func addView() {
        view.addSubview(safeAreaView)
    }
    
    private func addConstraint() {
        safeAreaView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
