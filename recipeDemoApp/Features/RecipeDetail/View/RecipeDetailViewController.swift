//
//  RecipeDetailViewController.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit

class RecipeDetailViewController: BaseViewController {
    let scrollViewContainer = BaseScrollView(direction: .vertical)
    let stackViewContainer = UIStackView()
    let imageViewRecipe = UIImageView()
    let labelName = UILabel()
    let labelIngredient = UILabel()
    let labelIngredients = UILabel()
    let labelStep = UILabel()
    let labelSteps = UILabel()

    let modelData = ModelData()
    let recipeService = RecipeService()
    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                imageViewRecipe.image = UIImage(data: recipe.image, scale: AppConstant.defaultImageScale)
                labelName.text = "\(recipe.category) \(recipe.name)"
                labelIngredients.addBulletPoints(stringList: Array(recipe.ingredients), font: .systemFont(ofSize: AppConstant.defaultFontSize))
                labelSteps.addNumberedList(stringList: Array(recipe.steps), font: .systemFont(ofSize: AppConstant.defaultFontSize))
            }
        }
    }

    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }

    override func viewDidLoad() {
        commonInit()

        super.viewDidLoad()
    }

    private func setup() {
        navigationController?.isToolbarHidden = false

        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(barButtonSystemItem: .edit , target: self, action: #selector(editRecipeAction)))
        items.append(UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil))
        items.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRecipeAction)))
        items[0].accessibilityLabel = "editButton"
        items[2].accessibilityLabel = "deleteButton"

        toolbarItems = items

        stackViewContainer.axis = .vertical
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = AppConstant.margin

        labelName.font = .systemFont(ofSize: AppConstant.defaultBigFontSize)
        labelName.textAlignment = .center
        labelName.adjustsFontSizeToFitWidth = true

        imageViewRecipe.contentMode = .scaleAspectFit

        labelIngredient.font = .systemFont(ofSize: AppConstant.defaultMediumFontSize)
        labelIngredient.text = "Ingredients:"
        
        labelIngredients.numberOfLines = 0

        labelStep.font = .systemFont(ofSize: AppConstant.defaultMediumFontSize)
        labelStep.text = "Steps:"
        
        labelSteps.numberOfLines = 0
    }

    private func addView() {
        safeAreaView.addSubview(scrollViewContainer)
        scrollViewContainer.contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(labelName)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        stackViewContainer.addArrangedSubview(labelIngredient)
        stackViewContainer.addArrangedSubview(labelIngredients)
        stackViewContainer.addArrangedSubview(labelStep)
        stackViewContainer.addArrangedSubview(labelSteps)
    }

    private func addConstraint() {
        scrollViewContainer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackViewContainer.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(AppConstant.margin)
            make.trailing.equalToSuperview().inset(AppConstant.margin)
        }

        imageViewRecipe.snp.makeConstraints { make in
            make.height.equalTo(AppConstant.defaultImageHeight)
        }
    }
}

extension RecipeDetailViewController {
    @objc private func editRecipeAction() {
        if let recipe = recipe {
            let vc = EditRecipeViewController(recipeAction: .edit, recipe: recipe)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func deleteRecipeAction() {
        if let recipe = recipe {
            let alert = UIAlertController(title: "Alert", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            let alertOK = UIAlertAction(title: "OK", style: .default, handler: { [weak self] action in
                guard let self = self else { return }
                self.recipeService.deleteRecipe(recipe: recipe)
                self.navigationController?.popViewController(animated: true)
            })
            alertOK.accessibilityLabel = "alertOK"
            alert.addAction(alertOK)
            present(alert, animated: true, completion: nil)
        }
    }
}
