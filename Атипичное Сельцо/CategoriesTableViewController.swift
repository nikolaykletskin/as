import UIKit

class CategoriesTableViewController: UITableViewController {
    
    // MARK: Properties
    var categories = [Dictionary<String, Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.nDarkColor()
        
        categories = [
            [
                "name": "Люди",
                "previewImage": "loh",
                "templates": [
                    ["name": "Ебать ты лох", "image": "loh"]
                ]
            ],
            [
                "name": "Сельцо",
                "previewImage": "pogrebok",
                "templates": [
                    ["name": "Погребок", "image": "pogrebok"]
                ]
            ]
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryTableViewCell.height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
        cell.nameLabel.text = category["name"] as! String?
        cell.previewImageView.image = UIImage(named: category["previewImage"]! as! String)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "TemplatesTableViewController") as! TemplatesTableViewController
        
        nextViewController.templates = categories[indexPath.row]["templates"] as! [Dictionary<String, String>]
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
