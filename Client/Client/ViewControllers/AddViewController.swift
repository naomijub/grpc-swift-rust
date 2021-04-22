
import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var id: UITextField?;
    @IBOutlet var tile: UITextField?;
    @IBOutlet var content: UITextView?;
    
    private let which: Options
    
    init?(coder: NSCoder, _ which: Options) {
        self.which = which
        super.init(coder: coder)
    }
    
    required init?(coder aCoder: NSCoder) {
        fatalError("Use of `init?(coder: NSCoder)` for AddViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
