import UIKit

class GetViewController: UIViewController {
    @IBOutlet var id: UITextField?
    @IBOutlet var noteInfo: UITextView?
    @IBOutlet var buttton: UIButton?
    
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
        noteInfo?.isHidden = true
        
        if which == Options.Delete {
            buttton?.setTitle("Delete", for: .normal)
        } else if which == Options.Get {
            buttton?.setTitle("Get", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func action() {
        let id = self.id?.text
        let rep = DataRepository.init()
        
        if which == Options.Get && id != nil{
            let note = rep.get(id: id!)
            let str = " ID: \(note.id) \n Title: \(note.title) \n Content: \(note.content)"
            noteInfo?.isHidden = false
            noteInfo?.text = str
        } else if which == Options.Delete && id != nil {
            let _ = rep.get(id: id!)
            noteInfo?.isHidden = false
            noteInfo?.text = "Done"
        } else {
            return
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
