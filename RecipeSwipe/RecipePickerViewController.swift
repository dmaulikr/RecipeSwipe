//
//  RecipePickerViewController.swift
//  RecipeSwipe
//
//  Created by Gareth Jones  on 12/26/14.
//  Copyright (c) 2014 GarethPaul. All rights reserved.
//

import UIKit
import Foundation

class RecipePickerViewController: UIViewController, MDCSwipeToChooseDelegate {

    let buttonDiameter: CGFloat = 50
    let buttonHPadding: CGFloat = 90

    var recipes: Array<Recipe> = Array()
    var topCardView: UIView = UIView()
    var bottomCardView: UIView = UIView()
    var savedRecipes: Array<Recipe> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch some lawyers
        APIClient.fetchRecpes({(fetchedRecipes: Array<Recipe>) -> Void in
            self.recipes = fetchedRecipes
        })

        // Setup initial card views
        topCardView = createRecipeView(topCardViewFrame(), recipe: self.recipes.removeAtIndex(0))
        self.view.addSubview(topCardView)

        bottomCardView = createRecipeView(bottomCardViewFrame(), recipe: self.recipes.removeAtIndex(0))
        self.view.insertSubview(bottomCardView, belowSubview: topCardView)

        constructBackground()
        constructNopeButton()
        constructLikeButton()
    }

    // TODO: save in CoreData
    func saveRecipe(recipe: Recipe) -> Void {
        self.savedRecipes.append(recipe)
    }

    // TODO: save in CoreData
    func skipRecipe(recipe: Recipe) -> Void {
        println("skippingr")
    }

    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        let rpv = view as RecipePickerView
        if (direction == MDCSwipeDirection.Right) {
            if(rpv.recipe != nil) {
                saveRecipe(rpv.recipe!)
            }
            println("Recipe saved!")
        } else {
            if(rpv.recipe != nil) {
                skipRecipe(rpv.recipe!)
            }
            println("Recipe skipped!")
        }

        topCardView = bottomCardView

        if(self.recipes.count > 0) {
            // Create a new bottom card view
            bottomCardView = createRecipeView(bottomCardViewFrame(), recipe: self.recipes.removeAtIndex(0))

            bottomCardView.alpha = 0.0
            self.view.insertSubview(bottomCardView, belowSubview: topCardView)

            UIView.animateWithDuration(
                0.5,
                delay: 0.0,
                options: UIViewAnimationOptions.CurveEaseInOut,
                animations: {
                    self.bottomCardView.alpha = 1
                },
                completion: nil
            )
        } else {
            bottomCardView = UIView()
        }
    }

    func topCardViewFrame() -> CGRect {
        let hPadding: CGFloat = 40
        let topPadding:CGFloat = 80
        let bottomPadding:CGFloat = 270

        return CGRectMake(
            hPadding,
            topPadding,
            CGRectGetWidth(self.view.frame) - (hPadding * 2),
            CGRectGetHeight(self.view.frame) - bottomPadding
        )
    }

    func bottomCardViewFrame() -> CGRect {
        let topFrame: CGRect = topCardViewFrame()

        return CGRectMake(
            topFrame.origin.x,
            topFrame.origin.y + 10,
            CGRectGetWidth(topFrame),
            CGRectGetHeight(topFrame)
        )
    }

    func buttonY() -> CGFloat {
        return CGRectGetMaxY(self.bottomCardView.frame) +
            ((CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(self.bottomCardView.frame) - buttonDiameter) / 2)
    }

    func constructNopeButton() {
        let frame: CGRect = CGRectMake(
            buttonHPadding,
            buttonY(),
            buttonDiameter,
            buttonDiameter
        )
        let button: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame

        button.setImage(UIImage(named: "nope"), forState: UIControlState.Normal)

        button.tintColor = UIColor(
            red: 247.0/255.0,
            green: 91.0/255.0,
            blue: 37.0/255.0,
            alpha: 1.0
        )

        button.addTarget(self, action: "nopeTopCardView", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.insertSubview(button, atIndex: 0)
    }

    func constructLikeButton() {
        let frame: CGRect = CGRectMake(
            CGRectGetWidth(self.view.bounds) - buttonDiameter - buttonHPadding,
            buttonY(),
            buttonDiameter,
            buttonDiameter
        )

        let button: UIButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = frame

        button.setImage(UIImage(named: "liked"), forState: UIControlState.Normal)

        button.tintColor = UIColor.blueColor()

        button.addTarget(self, action: "likeTopCardView", forControlEvents: UIControlEvents.TouchUpInside)

        self.view.insertSubview(button, atIndex: 0)
    }

    func nopeTopCardView() {
        self.topCardView.mdc_swipe(MDCSwipeDirection.Left)
    }

    func likeTopCardView() {
        self.topCardView.mdc_swipe(MDCSwipeDirection.Right)
    }

    func constructBackground() {
        let frownView: UIImageView = UIImageView(image: UIImage(named: "frown"))
        frownView.contentMode = UIViewContentMode.Center
        frownView.alpha = 0.5
        frownView.frame = CGRectMake(
            CGRectGetMinX(bottomCardView.frame),
            CGRectGetMinY(bottomCardView.frame),
            CGRectGetWidth(bottomCardView.frame),
            CGRectGetWidth(bottomCardView.frame)
        )

        let noMoreLabel: UILabel = UILabel(frame: CGRectMake(
            CGRectGetMinX(frownView.frame),
            CGRectGetMaxY(frownView.frame),
            CGRectGetWidth(frownView.frame),
            18
            ))
        noMoreLabel.font = UIFont.systemFontOfSize(20)
        noMoreLabel.alpha = 0.5
        noMoreLabel.text = "No more recipes"
        noMoreLabel.textAlignment = NSTextAlignment.Center

        self.view.insertSubview(frownView, atIndex: 0)
        self.view.insertSubview(noMoreLabel, atIndex: 0)
    }

    func createRecipeView(frame: CGRect, recipe: Recipe) -> RecipePickerView {
        var options: MDCSwipeToChooseViewOptions = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.likedText = "Keep"
        options.likedColor = UIColor.blueColor()
        options.nopeText = "Delete"

        options.onPan = {(state: MDCPanState!) -> Void in
            let frame: CGRect = self.bottomCardViewFrame()
            self.bottomCardView.frame = CGRectMake(
                frame.origin.x,
                frame.origin.y - (state.thresholdRatio * 10.0),
                CGRectGetWidth(frame),
                CGRectGetHeight(frame)
            )
        };

        var rpw: RecipePickerView = RecipePickerView(frame: frame, recipe: recipe, options: options)

        return rpw
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("segue")
        //let controller: LikedLawyersTVC = segue.destinationViewController as LikedLawyersTVC
        //controller.lawyers = self.savedLawyers
    }
}
