//
//  CategoriesTableViewController.swift
//  Атипичное Сельцо
//
//  Created by Николай Клёцкин on 10/21/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    // MARK: Properties
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.nDarkColor()
        loadCategories()
    }
    
    func loadCategories() {
        let lohImage = UIImage(named: "loh")
        let people = Category(name: "Люди", previewImage: lohImage)
        categories += [people]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        cell.backgroundColor = UIColor.nDarkThreeColor()
        
        let category = categories[indexPath.row]
        cell.nameLabel.text = category.name
        
        cell.nameLabel.textColor = UIColor.nCoolGreyColor()
        // TODO: change font
        //cell.nameLabel.font = UIFont(name: (cell.nameLabel.font?.fontName)!, size: 20)
        cell.previewImageView.image = category.previewImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "TemplatesTableViewController") as! TemplatesTableViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}
