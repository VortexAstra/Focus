import UIKit
import RealmSwift

class TodoViewController: UIViewController {

    let realm = try! Realm()
    
    
    @IBAction func tapOnImage(_ sender: UITapGestureRecognizer) {
        print(1)
    }
    
    @IBOutlet weak var UIViewForButton: UIView!
    var arrayOfTask: Results<Task>!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet{
            tableView.separatorStyle = .singleLine
        }
    }
    @IBOutlet weak var addButton: UIButton!
    
    //    MARK: LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configBackgroundColorOnTableView()
        arrayOfTask = realm.objects(Task.self)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        UIViewForButton.layer.cornerRadius = UIViewForButton.frame.height/2
        
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        
    }
    
    @IBAction func addButtonAction(_ sender: UIButton) {
        let textAlertView = UIAlertController(title: "New task", message: nil, preferredStyle: .alert)
        
        textAlertView.addTextField(configurationHandler: nil)
    
        textAlertView.textFields![0].placeholder = "Task"
        
        textAlertView.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            guard (textAlertView.textFields![0].text != "") else {return}
            
            let newTask = Task(name: textAlertView.textFields![0].text!, isCompleted: false)
            
            try! self.realm.write({
                self.realm.add(newTask)
            })
            
            let indexPath = IndexPath(row: self.arrayOfTask.count - 1, section: 0)
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath], with: .top)
            self.tableView.endUpdates()
        }))
        
        textAlertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(textAlertView, animated: true, completion: nil)
    }
    
    
    fileprivate func configBackgroundColorOnTableView() {
        let newView = UIView()
        newView.frame = view.frame
        let gradient = CAGradientLayer()
        gradient.frame = newView.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        newView.layer.insertSublayer(gradient, at: 0)
        tableView.backgroundView = newView
    }
    
    
}

//    MARK: TABLEVIEW METHODS
extension TodoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrayOfTask.count != 0{
            return arrayOfTask.count
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell{
            
            guard !(arrayOfTask.isEmpty) else { return UITableViewCell()}
            cell.config(array: arrayOfTask[indexPath.row])
            if (arrayOfTask[indexPath.row].isCompleted == false){
                cell.taskLabel.alpha = 0.5
            }else{
                cell.taskLabel.alpha = 1
            }
            if (arrayOfTask[indexPath.row].isCompleted == true){
                cell.doneButton.setImage(UIImage(named: "check-box-true"), for: .normal)
            }else
            {
                cell.doneButton.setImage(UIImage(named: "check-box-false"), for: .normal)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try! self.realm.write {
                self.realm.delete(arrayOfTask[indexPath.row])
                tableView.reloadData()
            }
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch
            arrayOfTask[indexPath.row].isCompleted {
        case false:
            try! realm.write {
                arrayOfTask[indexPath.row].isCompleted = true
            }
        case true:
            try! realm.write {
                arrayOfTask[indexPath.row].isCompleted = false
            }
        }
        tableView.reloadData()
    }
    
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
//                cell.taskLabel.transform = .init(scaleX: 0.95, y: 0.95)
//            }
//        }
//    }
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.5) {
//            if let cell = tableView.cellForRow(at: indexPath) as? TableViewCell {
//                cell.taskLabel.transform = .identity
//            }
//        }
//    }
}

