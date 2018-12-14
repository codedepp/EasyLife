import UIKit

class FatalViewController: UIViewController {
    @IBOutlet weak var label: UILabel!

    var error: Error?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let error = error {
            label.text = L10n.errorLoadingDataMessage(error.localizedDescription)
        }
    }
}
