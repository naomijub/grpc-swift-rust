import UIKit

class ListViewController: UITableViewController {
    private let notes: Array<Notes_Note>
    private let cellStyle = UITableViewCell.CellStyle.default;
    
    init?(coder: NSCoder, _ notes: Array<Notes_Note>) {
        self.notes = notes
        super.init(coder: coder)
    }
    
    required init?(coder aCoder: NSCoder) {
        fatalError("Use of `init?(coder: NSCoder)` for ListViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let note = notes[row]
    
        let cell = UITableViewCell(style: cellStyle, reuseIdentifier: nil)
        cell.textLabel?.text = note.title
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeList))
        cell.addGestureRecognizer(tap)
        
        return cell
    }
    
    @objc func closeList() {
        self.dismiss(animated: true, completion: nil)
    }
}
