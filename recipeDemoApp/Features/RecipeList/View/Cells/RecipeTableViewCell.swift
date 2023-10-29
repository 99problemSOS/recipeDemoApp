//
//  RecipeTableViewCell.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import UIKit
import SnapKit

class RecipeTableViewCell: UITableViewCell {
    private let stackViewContainer = UIStackView()
    private let imageViewRecipe = UIImageView()
    private let labelRecipe = UILabel()
    private let labelRecipeType = UILabel()

    var recipe: Recipe? {
        didSet {
            if let recipe = recipe {
                imageViewRecipe.image = UIImage(data: recipe.image, scale: AppConstant.defaultImageScale)
                labelRecipe.text = recipe.name
                labelRecipeType.text = recipe.category
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    override func prepareForReuse() {
        imageViewRecipe.image = UIImage()
        labelRecipe.text = ""
        labelRecipeType.text = ""

        super.prepareForReuse()
    }

    private func commonInit() {
        setup()
        addView()
        addConstraint()
    }

    private func setup() {
        backgroundColor = .clear

        stackViewContainer.axis = .horizontal
        stackViewContainer.alignment = .fill
        stackViewContainer.distribution = .fill
        stackViewContainer.spacing = AppConstant.margin

        imageViewRecipe.contentMode = .scaleAspectFit

        labelRecipe.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        labelRecipe.setContentHuggingPriority(.defaultLow, for: .horizontal)

        labelRecipeType.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    private func addView() {
        contentView.addSubview(stackViewContainer)
        stackViewContainer.addArrangedSubview(imageViewRecipe)
        stackViewContainer.addArrangedSubview(labelRecipe)
        stackViewContainer.addArrangedSubview(labelRecipeType)
    }

    private func addConstraint() {
        stackViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.high)
            make.leading.equalToSuperview().offset(AppConstant.margin)
            make.trailing.equalToSuperview().inset(AppConstant.margin)
        }

        imageViewRecipe.snp.makeConstraints { make in
            make.width.height.equalTo(AppConstant.defaultCellImageSize)
        }
    }
}

