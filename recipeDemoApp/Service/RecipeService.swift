//
//  RecipeService.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import Foundation
import RealmSwift
import UIKit

class RecipeService {
    let localRealm: Realm
    
    init(realm: Realm = try! Realm()) {
        self.localRealm = realm
    }

    func insertRecipe(recipe: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.add(recipe)
        }
    }

    func retrieveRecipes() -> Results<Recipe> {
        return localRealm.objects(Recipe.self)
    }

    func modifyRecipe(recipeToUpdate: Recipe, newValue: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write {
            recipeToUpdate.name = newValue.name
            recipeToUpdate.category = newValue.category
            recipeToUpdate.ingredients.removeAll()
            recipeToUpdate.ingredients.append(objectsIn: newValue.ingredients)
            recipeToUpdate.steps.removeAll()
            recipeToUpdate.steps.append(objectsIn: newValue.steps)
            recipeToUpdate.image = newValue.image
        }
    }

    func deleteRecipe(recipe: Recipe) {
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.delete(recipe)
        }
    }
    
    func insertListOfRecipe(recipes: [Recipe]) {
        let localRealm = try! Realm()
        try! localRealm.write {
            recipes.forEach { recipe in
                localRealm.add(recipe)
            }
        }
    }
    
}

extension RecipeService {
    func generateRecipe(){
        let modelData = ModelData()
        var recipes = [Recipe]()
        let recipeTypes: [String] = modelData.modelRecipeTypes.category
        for i in 0..<8 {
            let sampleList = List<String>()
            sampleList.append("Vegetable \(i)")
            let recipe = Recipe(name: "Food \(i)",
                                ingredients: sampleList,
                                steps: sampleList,
                                category: recipeTypes[i],
                                image: (UIImage(named: "food_sample")?.pngData())!)
            recipes.append(recipe)
        }
        self.insertListOfRecipe(recipes: recipes)
    }
}

