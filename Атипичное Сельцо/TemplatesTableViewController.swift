//
//  TemplatesTableViewController.swift
//  Атипичное Сельцо
//
//  Created by Nikolay Kletskin on 11/9/16.
//  Copyright © 2016 Nikolay Kletskin. All rights reserved.
//

import UIKit

class TemplatesTableViewController: UITableViewController {
    
    var templates = [Template]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.nDarkColor()
        loadTemplates()
    }
    
    func loadTemplates() {
        let lohImage = UIImage(named: "loh")
        let loh = Template(name: "Ебать ты лох", previewImage: lohImage)
        templates += [loh]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateTableViewCell", for: indexPath) as! TemplateTableViewCell
        
        cell.backgroundColor = UIColor.nDarkThreeColor()
        
        let template = templates[indexPath.row]
        cell.nameLabel.text = template.name
        
        cell.nameLabel.textColor = UIColor.nCoolGreyColor()
        // TODO: change font
        // cell.nameLabel.font = UIFont(name: (cell.nameLabel.font?.fontName)!, size: 20)
        cell.previewImageView.image = template.previewImage
        
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
            nextViewController?.image = templates[indexPath.row].previewImage!
            self.navigationController?.pushViewController(nextViewController!, animated: true)
        }
    }
    
}
