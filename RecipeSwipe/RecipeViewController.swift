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