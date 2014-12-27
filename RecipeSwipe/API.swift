//
//  API.swift
//  RecipeSwipe
//
//  Created by Gareth Jones  on 12/26/14.
//  Copyright (c) 2014 GarethPaul. All rights reserved.
//

import Foundation

class APIClient {

    class func fetchRecpes(recipeHandler: (Array<Recipe>) -> ()) -> Void {
        var recipes: Array<Recipe> = [
            Recipe(name: "Pasta",
                image: UIImage(named: "photo")!
            ),
            Recipe(name: "Pasta #2",
                image: UIImage(named: "photo")!
            )]
        recipeHandler(recipes)
    }
}