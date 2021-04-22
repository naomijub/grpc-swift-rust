
import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var id: UITextField?;
    @IBOutlet var noteTitle: UITextField?;
    @IBOutlet var content: UITextView?;
    @IBOutlet var buttton: UIButton?
    @IBOutlet var okLabel: UILabel?
    
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
        if which == Options.Add {
            buttton?.setTitle("Add", for: .normal)
        } else if which == Options.Update {
            buttton?.setTitle("Update", for: .normal)
        }
    }
    
    @IBAction func action() {
        let rep = DataRepository.init()
        var note = Notes_Note.init();
        
        if self.id?.text == nil || self.noteTitle?.text == nil || self.content?.text == nil {
            return
        }
        note.id = self.id?.text ?? ""
        note.title = self.noteTitle?.text ?? ""
        note.content = self.content?.text ?? ""
        
        if (which == Options.Add || which == Options.Update) && id != nil {
            let note = rep.addOrUpdate(note: note, which: which)
            
            if note.error != nil {
                okLabel?.text = "Failed"
            } else {
                okLabel?.text = "Succeeded"
            }
            
        } else {
            return
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
