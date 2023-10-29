//
//  GroupedAddTextFieldStackView.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit
import RealmSwift

class GroupedAddTextFieldStackView: UIStackView {
    var latestId = 0
    var placeholder = ""
    var stackViewAddTextFields: [AddTextFieldStackView] = []
    
    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }
    
    required init(placeholder: String) {
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func setup() {
        axis = .vertical
        distribution = .fill
        alignment = .fill
        spacing = AppConstant.margin
        
        let stackView = AddTextFieldStackView(id: latestId, showDelete: false)
        stackView.delegate = self
        latestId += 1
        stackViewAddTextFields.append(stackView)
    }
    
    private func addView() {
        updateUI()
    }
    
    private func addConstraint() {
        
    }
}

extension GroupedAddTextFieldStackView {
    private func updateUI() {
        for item in arrangedSubviews {
            removeArrangedSubview(item)
            item.removeFromSuperview()
        }
        
        for (index, stackView) in stackViewAddTextFields.enumerated() {
            stackView.textField.placeholder = "\(placeholder) #\(index + 1)"
            addArrangedSubview(stackView)
        }
    }
    
    func validate() -> Bool {
        for stackView in stackViewAddTextFields {
            if !stackView.validate() {
                return false
            }
        }
        
        return true
    }
    
    func getTexts() -> List<String> {
        let texts: List<String> = List<String>()
        
        for stackView in stackViewAddTextFields {
            if let text = stackView.textField.text {
                texts.append(text)
            }
        }
        return texts
    }
}

extension GroupedAddTextFieldStackView: AddTextFieldStackViewDelegate {
    func didTappedAddButton() {
        let stackViewAddTextField = AddTextFieldStackView(id: latestId, showDelete: true)
        stackViewAddTextField.delegate = self
        stackViewAddTextFields.append(stackViewAddTextField)
        latestId += 1
        updateUI()
    }
    
    func didTappedDeleteButton(id: Int) {
        stackViewAddTextFields = stackViewAddTextFields.filter({ stackView in
            return stackView.id != id
        })
        updateUI()
    }
}
