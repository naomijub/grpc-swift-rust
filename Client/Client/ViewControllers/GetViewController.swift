import UIKit

class GetViewController: UIViewController {
    @IBOutlet var id: UITextField?
    
    private let which: Options
    
    init?(coder: NSCoder, _ which: Options) {
        self.which = which
        super.init(coder: coder)
    }
    
    required init?(coder aCoder: NSCoder) {
        fatalError("Use of `init?(coder: NSCoder)` for GetViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}
