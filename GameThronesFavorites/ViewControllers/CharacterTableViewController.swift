//
//  CharacterTableViewController.swift
//  GameThronesFavorites
//
//  Created by Yinhuan Yuan on 5/16/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import CoreData

// this is the delegate for handling cell button click
protocol HandleButtonDelegate: class {
    func handleMark(cell: UITableViewCell)
}

class CharacterTableViewController: UITableViewController, HandleButtonDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let cellId = "cellId"
    var characterList = [Character]()
    var favoriteCharacters = [CharacterEntity]()
     let fetchRequest : NSFetchRequest<CharacterEntity> =  CharacterEntity.fetchRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(CustomCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        readAndParseJson()
        fetchDataFromDataBase()
        
    
    }
    // read Json from bundle and parse the data and create Character Objects
    func readAndParseJson() {
        if let path = Bundle.main.path(forResource: "source", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let jsonResult = jsonResult as? [String: AnyObject], let characters = jsonResult["characters"] as? [[String: AnyObject]] {
                    for character in characters {
                        characterList.append(Character(dictionary: character))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    // fetch data from the core data
    func fetchDataFromDataBase() {
        let sor1 =  NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sor1]
        let persistentContainer = appDelegate.persistentContainer
        do {
            favoriteCharacters = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch let error {
            print((error.localizedDescription))
        }
    }
    // if the person is being liked, then create this person in the core data
    func createFavoriteCharacters(_ characterSelected: Character) {
        let context = appDelegate.persistentContainer.viewContext
        if let character = NSEntityDescription.insertNewObject(forEntityName: "CharacterEntity", into: context) as? CharacterEntity {
            character.name = characterSelected.name
            favoriteCharacters.append(character)
            doTrySaveInContext()
        }
    }
    
    func doTrySaveInContext() {
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        }
        catch let error {
            print(error.localizedDescription)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        
        return characterList.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomCell(style: .subtitle, reuseIdentifier: cellId)
        cell.delegate = self
        var character = characterList[indexPath.row]
        
/* fetch the person in the data base with the character name, if it is in the data base, then it is being liked, the hasFavorited set to true, otherwise, it's false*/
        
     fetchRequest.predicate = NSPredicate(format: "name == %@",character.name)
        do {
            let context = self.appDelegate.persistentContainer.viewContext
            let characters = try context.fetch(fetchRequest)
            if characters.count > 0 {
                    character.hasFavorited = true
                } else {
                    character.hasFavorited = false
                }
            
        } catch let error {
            print(error)
        }
        // configure the cell
         cell.configureCell(character)

        return cell
    }
    
    /* add the detailsViewController on the the navigation stack and pass the character selectd. It is created by code, as I have no idea how to link the CustomCell which was also created by code with the story board */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = DetailsViewController()
        detailsViewController.character = characterList[indexPath.row]
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    func handleMark(cell: UITableViewCell) {
        guard  let indexPathTapped = tableView.indexPath(for: cell) else {
            return
        }
        let character = characterList[indexPathTapped.row]
        let hasBeenliked = character.hasFavorited
        character.hasFavorited = !hasBeenliked
        
        //change the button color
        cell.accessoryView?.tintColor = character.hasFavorited ? .blue : .lightGray
        
        /*if the person is favored, then add this person in the data base, otherwise, if this person is in the data base, then remove the person. I finally got the logic. */
        
        if character.hasFavorited {
            createFavoriteCharacters(character)
        } else {
            fetchRequest.predicate = NSPredicate(format: "name == %@",character.name)
            do {
                let context = self.appDelegate.persistentContainer.viewContext
                let characters = try context.fetch(fetchRequest)
                if characters.count > 0 {
                    for favorite in favoriteCharacters {
                        if favorite.name ==  character.name {
                             appDelegate.persistentContainer.viewContext.delete(favorite)
                            appDelegate.saveContext()
                        }
                    }
                    
                }
                
            } catch let error {
                print(error)
            }
 
    }
  
/* this is the part I did in the exam, but it did not work, so I commented it*/
 

  /*  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailsViewController = segue.destination as? DetailsViewController {
            detailsViewController.character = characterList[tableView.indexPathForSelectedRow!.row]
        }
    }
  
   */
}
}
