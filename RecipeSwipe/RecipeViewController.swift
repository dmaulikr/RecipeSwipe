//
//  LawyerViewController.swift
//  Linder
//
//  Created by Jeffrey Ching on 10/17/14.
//  Copyright (c) 2014 Jeffrey Ching. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var recipe: Recipe?

    override func viewDidLoad() {
        super.viewDidLoad()

        if(self.recipe != nil) {
            self.imageView.image = recipe!.image
        }
    }
}