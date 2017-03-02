import UIKit

class TemplatesTableViewController: UITableViewController {
    
    var templates = [Dictionary<String, String>]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.nDarkColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TemplateTableViewCell.height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateTableViewCell", for: indexPath) as! TemplateTableViewCell
        let template = templates[indexPath.row]
        cell.nameLabel.text = template["name"]
        cell.previewImageView.image = UIImage(named: template["image"]!)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var nextViewController: MemViewController?
        switch AppState.shared.memType! {
        case .simpleMem:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "SimpleMemViewController") as! SimpleMemViewController
        case .expression:
            nextViewController = storyboard.instantiateViewController(withIdentifier: "ExpressionViewController") as! ExpressionViewController
        }
        
        if (nextViewController != nil) {
            nextViewController?.image = UIImage(named: templates[indexPath.row]["image"]!)
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
    }
    
}
