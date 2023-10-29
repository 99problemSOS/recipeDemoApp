//
//  BaseScrollView.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit

class BaseScrollView: UIScrollView {
    let contentView = UIView()
    var direction: ScrollViewDirection = .vertical
    
    // MARK: - Initialization
    
    required init(direction: ScrollViewDirection) {
        super.init(frame: .zero)
        self.direction = direction
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setup()
    }
    
    // MARK: - View Setup
    
    private func setup() {
        addSubview(contentView)
        configureBounces()
        addConstraints()
    }
    
    private func configureBounces() {
        switch direction {
        case .horizontal:
            alwaysBounceHorizontal = true
            alwaysBounceVertical = false
        case .vertical:
            alwaysBounceHorizontal = false
            alwaysBounceVertical = true
        }
    }
    
    // MARK: - Constraints
    
    private func addConstraints() {
        if direction == .horizontal {
            contentView.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
            }
        } else {
            contentView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.centerX.equalToSuperview()
                make.width.equalToSuperview()
            }
        }
    }
}
