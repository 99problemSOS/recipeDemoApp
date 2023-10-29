//
//  AddTextFieldStackView.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit
import FormTextField

protocol AddTextFieldStackViewDelegate: AnyObject {
    func didTappedAddButton()
    func didTappedDeleteButton(id: Int)
}

class AddTextFieldStackView: UIStackView {
    var id = 0
    let textField = FormTextField()
    let buttonAdd = UIButton(type: .contactAdd)
    let buttonDelete = UIButton(type: .close)
    
    weak var delegate: AddTextFieldStackViewDelegate?
    
    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }
    
    required init(id: Int, showDelete: Bool) {
        super.init(frame: .zero)
        self.id = id
        showDelete ? (buttonDelete.isHidden = false) : (buttonDelete.isHidden = true)
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
        axis = .horizontal
        distribution = .fill
        alignment = .fill
        spacing = AppConstant.margin
        
        var validation = Validation()
        validation.minimumLength = 1
        textField.borderStyle = .roundedRect
        textField.inputValidator = InputValidator(validation: validation)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        buttonAdd.addTarget(self, action: #selector(buttonAddAction), for: .touchUpInside)
        buttonDelete.addTarget(self, action: #selector(buttonDeleteAction), for: .touchUpInside)
    }
    
    private func addView() {
        addArrangedSubview(textField)
        addArrangedSubview(buttonDelete)
        addArrangedSubview(buttonAdd)
    }
    
    private func addConstraint() {
        buttonAdd.snp.makeConstraints { make in
            make.width.equalTo(AppConstant.defaultButtonWidth)
        }
        
        buttonDelete.snp.makeConstraints { make in
            make.width.equalTo(AppConstant.defaultButtonWidth)
        }
    }
}

extension AddTextFieldStackView {
    @objc func buttonAddAction() {
        delegate?.didTappedAddButton()
    }
    
    @objc func buttonDeleteAction() {
        delegate?.didTappedDeleteButton(id: id)
    }
    
    func validate() -> Bool {
        return textField.validate()
    }
}
