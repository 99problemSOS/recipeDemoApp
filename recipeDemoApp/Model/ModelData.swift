//
//  DataModel.swift
//  recipeDemoApp
//
//  Created by Jay Liew on 26/10/2023.
//

import Foundation
import XMLParsing

final class ModelData: ObservableObject {
    var modelRecipeTypes: RecipeTypes = load("recipeTypes.xml")
    var modelRecipes: Recipes = Recipes()
    
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        return try XMLDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
