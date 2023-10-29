//
//  Recipe.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import Foundation
import RealmSwift

class Recipes: Object {
    @Persisted var recipes: List<Recipe> = List()
}

class Recipe: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    let ingredients = List<String>()
    let steps = List<String>()
    @objc dynamic var category = ""
    @objc dynamic var image = Data()

    override class func primaryKey() -> String? {
        return "id"
    }

    convenience init(name: String, ingredients: List<String>, steps: List<String>, category: String, image: Data) {
        self.init()
        self.name = name
        self.ingredients.append(objectsIn: ingredients)
        self.steps.append(objectsIn: steps)
        self.category = category
        self.image = image
    }
}

