import UIKit

class ViewController: UIViewController, CrudUI {
    @IBAction func add() {
        let addViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AddViewControllerID", creator: { coder -> AddViewController? in
            AddViewController(coder: coder, Options.Add)
        })
        present(addViewController, animated: true, completion: nil)
    }
    
    @IBAction func get() {
        let getViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "GetViewControllerID", creator: { coder -> GetViewController? in
            GetViewController(coder: coder, Options.Get)
        })
        present(getViewController, animated: true, completion: nil)
    }
    
    @IBAction func delete() {
        let getViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "GetViewControllerID", creator: { coder -> GetViewController? in
            GetViewController(coder: coder, Options.Delete)
        })
        present(getViewController, animated: true, completion: nil)
    }
    
    @IBAction func update() {
        let addViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "AddViewControllerID", creator: { coder -> AddViewController? in
            AddViewController(coder: coder, Options.Update)
        })
        present(addViewController, animated: true, completion: nil)
    }
    
    @IBAction func list() {
        let rep = DataRepository.init()
        let notes = rep.list()
        
        let listViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ListViewControllerID", creator: { coder -> ListViewController? in
            ListViewController(coder: coder, notes)
        })
        present(listViewController, animated: true, completion: nil)
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

