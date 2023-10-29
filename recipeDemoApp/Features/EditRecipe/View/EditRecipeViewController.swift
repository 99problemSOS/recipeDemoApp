//
//  EditRecipeViewController.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import FormTextField
import PhotosUI
import UIKit
import ProgressHUD

class EditRecipeViewController: BaseViewController {
    let labelTitle = UILabel()
    let scrollViewContainer = BaseScrollView(direction: .vertical)
    let stackViewContainer = UIStackView()
    let imageViewRecipe = UIImageView()
    let imageViewCamera = UIImageView()
    let labelName = UILabel()
    let textFieldName = FormTextField()
    let labelIngredients = UILabel()
    let stackViewGroupedAddTextFieldIngredient = GroupedAddTextFieldStackView(placeholder: "Ingredient")
    let labelSteps = UILabel()
    let stackViewGroupedAddTextFieldStep = GroupedAddTextFieldStackView(placeholder: "Step")
    let pickerViewRecipeType = UIPickerView()
    let buttonAdd = UIButton(type: .contactAdd)

    let modelData = ModelData()
    let recipeService = RecipeService()
    lazy var recipeTypes: [String] = {
        modelData.modelRecipeTypes.category
    }()
    
    var recipeAction: RecipeAction = .create
    var recipe: Recipe?
    
    required init(recipeAction: RecipeAction, recipe: Recipe? = nil) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.recipeAction = recipeAction
        if let recipe = recipe, recipeAction == .edit {
            self.recipe = recipe
            labelTitle.text = "Edit Recipe"
            imageViewRecipe.image = UIImage(data: recipe.image, scale: 1.0)
            textFieldName.text = recipe.name
            stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[0].textField.text = recipe.ingredients[0]
            for i in 0..<recipe.ingredients.count - 1 {
                stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[i].buttonAddAction()
                stackViewGroupedAddTextFieldIngredient.stackViewAddTextFields[i + 1].textField.text = recipe.ingredients[i + 1]
            }
            stackViewGroupedAddTextFieldStep.stackViewAddTextFields[0].textField.text = recipe.steps[0]
            for i in 0..<recipe.steps.count - 1 {
                stackViewGroupedAddTextFieldStep.stackViewAddTextFields[i].buttonAddAction()
                stackViewGroupedAddTextFieldStep.stackViewAddTextFields[i + 1].textField.text = recipe.steps[i + 1]
            }
        } else {
            labelTitle.text = "Add Recipe"
            imageViewRecipe.image = UIImage(named: "placeholder_image")
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        commonInit()
        
        super.viewDidLoad()
    }

    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }

    private func setup() {
        
        _ = imageViewRecipe.addTapGestureRecognizer { [weak self] in
            guard let self = self else { return }
            ImagePickerManager().pickImage(self) { image in
                self.imageViewRecipe.image = image
            }
        }
        
        imageViewCamera.image = UIImage(named: "upload_image")
        imageViewCamera.contentMode = .scaleAspectFit

        labelTitle.font = .systemFont(ofSize: AppConstant.defaultBigFontSize, weight: .medium)
        labelTitle.textAlignment = .center

        stackViewContainer.axis = .vertical
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = AppConstant.margin

        imageViewRecipe.contentMode = .scaleAspectFit

        labelName.text = "Recipe Name"
        
        var validation = Validation()
        validation.minimumLength = 1
        textFieldName.placeholder = "Recipe Name"
        textFieldName.borderStyle = .roundedRect
        textFieldName.inputValidator = InputValidator(validation: validation)
        textFieldName.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        labelIngredients.text = "Ingredients"
        
        labelSteps.text = "Steps"
        
        pickerViewRecipeType.delegate = self
        pickerViewRecipeType.dataSource = self
        if recipeAction == .edit {
            if let recipe = recipe {
                let categories = modelData.modelRecipeTypes.category
                if let row = categories.firstIndex(of: recipe.category) {
                    pickerViewRecipeType.selectRow(row, inComponent: 0, animated: false)
                }
            }
        }

        buttonAdd.addTarget(self, action: #selector(buttonAddAction), for: .touchUpInside)
        buttonAdd.accessibilityLabel = "buttonAdd"
    }

    private func addView() {
        safeAreaView.addSubview(labelTitle)
        safeAreaView.addSubview(scrollViewContainer)
        scrollViewContainer.contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        imageViewRecipe.addSubview(imageViewCamera)
        stackViewContainer.addArrangedSubview(labelName)
        stackViewContainer.addArrangedSubview(textFieldName)
        stackViewContainer.addArrangedSubview(labelIngredients)
        stackViewContainer.addArrangedSubview(stackViewGroupedAddTextFieldIngredient)
        stackViewContainer.addArrangedSubview(labelSteps)
        stackViewContainer.addArrangedSubview(stackViewGroupedAddTextFieldStep)
        stackViewContainer.addArrangedSubview(pickerViewRecipeType)
        safeAreaView.addSubview(buttonAdd)
    }

    private func addConstraint() {
        labelTitle.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }

        scrollViewContainer.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom).offset(AppConstant.margin)
            make.leading.trailing.equalToSuperview()
        }

        stackViewContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(AppConstant.margin2x)
            make.trailing.equalToSuperview().inset(AppConstant.margin2x)
        }

        imageViewRecipe.snp.makeConstraints { make in
            make.height.equalTo(AppConstant.defaultImageHeight)
        }
        
        imageViewCamera.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
            make.width.height.equalTo(AppConstant.defaultButtonWidth)
        }

        buttonAdd.snp.makeConstraints { make in
            make.top.equalTo(scrollViewContainer.snp.bottom).offset(AppConstant.margin)
            make.bottom.leading.trailing.equalToSuperview().inset(AppConstant.margin)
        }
    }
}

extension EditRecipeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        recipeTypes.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        recipeTypes[row]
    }
}

extension EditRecipeViewController {
    @objc private func buttonAddAction() {
        if textFieldName.validate() && stackViewGroupedAddTextFieldIngredient.validate() && stackViewGroupedAddTextFieldStep.validate() {
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            let alertOK = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                if self.recipeAction == .create {
                    if let textName = self.textFieldName.text, let image = self.imageViewRecipe.image {
                        let recipe = Recipe(name: textName,
                                            ingredients: self.stackViewGroupedAddTextFieldIngredient.getTexts(),
                                            steps: self.stackViewGroupedAddTextFieldStep.getTexts(),
                                            category: self.recipeTypes[self.pickerViewRecipeType.selectedRow(inComponent: 0)],
                                            image: (image.pngData() ?? UIImage(named: "placeholder_image")?.pngData())!)
                        
                        self.recipeService.insertRecipe(recipe: recipe)
                        self.pushToDisplay(recipe: recipe)
                    }
                } else {
                    if let recipe = self.recipe {
                        if let textName = self.textFieldName.text, let image = self.imageViewRecipe.image {
                            let newRecipe = Recipe(name: textName,
                                                   ingredients: self.stackViewGroupedAddTextFieldIngredient.getTexts(),
                                                   steps: self.stackViewGroupedAddTextFieldStep.getTexts(),
                                                   category: self.recipeTypes[self.pickerViewRecipeType.selectedRow(inComponent: 0)], image: (image.pngData() ?? UIImage(named: "placeholder_image")?.pngData())!)
                            
                            self.recipeService.modifyRecipe(recipeToUpdate: recipe, newValue: newRecipe)
                            self.pushToDisplay(recipe: newRecipe)
                        }
                    }
                }
            })
            alertOK.accessibilityLabel = "alertOK"
            alert.addAction(alertOK)
            present(alert, animated: true, completion: nil)
        } else {
            ProgressHUD.error("Please ensure all text field is not empty")
          
        }
    }
    
    private func pushToDisplay(recipe: Recipe) {
        if let navStack = navigationController?.viewControllers {
            var filtered = navStack.filter { vc in
                
                return vc is RecipeListViewController
            }
            
            let vc = RecipeDetailViewController()
            vc.recipe = recipe
            
            filtered.append(vc)
            
            navigationController?.setViewControllers(filtered, animated: true)
        }
    }
}

