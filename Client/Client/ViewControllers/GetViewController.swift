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
    }
    
    @IBAction func action() {
        let id = self.id?.text
        let rep = DataRepository.init()
        
        if which == Options.Get && id != nil{
            noteInfo?.isHidden = false
            let result = rep.get(id: id!)
            switch result {
                case .success(let note):
                    let str = " ID: \(note.id) \n Title: \(note.title) \n Content: \(note.content)"
                    noteInfo?.text = str
                case .failure(_):
                    noteInfo?.text = "Failed"
            }
        } else if which == Options.Delete && id != nil {
            let result = rep.get(id: id!)
            
            switch result {
                case .success(_):
                    noteInfo?.text = "Succeeded"
                case .failure(_):
                    noteInfo?.text = "Failed"
            }
        } else {
            return
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }
}
