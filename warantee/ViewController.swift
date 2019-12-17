//
//  ViewController.swift
//  warantee
//
//  Created by student on 07/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import CoreData

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

   
    @IBOutlet weak var picker: UIPickerView!
    //logout
    @IBAction func signOut(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            print("user logged out")
            self.deleteAllData(entity: "Waranty")
            //dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
        //logs out google account
        GIDSignIn.sharedInstance().signOut()
        
    }
    func deleteAllData(entity: String)
       {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
           fetchRequest.returnsObjectsAsFaults = false
           do {
               let results = try context.fetch(fetchRequest)
               for object in results {
                   guard let objectData = object as? NSManagedObject else {continue}
                   context.delete(objectData)
               }
           } catch let error {
               print("Detele all data in \(entity) error :", error)
           }
       }
    struct Warantee: Codable { // or Decodable
        let id: Int
        let uid: String
        let date: String
        let amount: Float
        let category: Int
        let warantyPeriod: Int
        let sellerName: String
        let sellerPhone: String
        let sellerEmail: String
        let location: String
        let createdAt: String
        let updatedAt: String
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //if user logs out
        Auth.auth().addStateDidChangeListener
        { (auth, user) in
            
            if user == nil {
              self.goToLogin()
            }
            
        }
        picker.delegate = self
        picker.dataSource = self
    }

    
    func goToLogin(){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC:LoginController = storyboard.instantiateViewController(withIdentifier: "LoginController") as! LoginController
        
        //go to new screen in fullscreen
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    // UIPickerViewDatasource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 6
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    // UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let myView = UIView()
        myView.frame = CGRect(x:0, y:0, width:pickerView.bounds.width - 30, height:60)
        let myImageView = UIImageView()
        myImageView.frame = CGRect(x:0, y:0, width:50, height:50)
       var rowString = String()
       switch row {
        case 0:
            rowString = "all"
            myImageView.image = UIImage(named:"warantee")
       case 1:
           rowString = "food"
           myImageView.image = UIImage(named:"food")
       case 2:
           rowString = "grocery"
           myImageView.image = UIImage(named:"grocery")
        case 3:
            rowString = "travel"
            myImageView.image = UIImage(named:"travel")
        case 4:
            rowString = "electronics"
            myImageView.image = UIImage(named:"electronics")
        case 5:
            rowString = "others"
            myImageView.image = UIImage(named:"others")
        
       default:
           rowString = "Error: too many rows"
           myImageView.image = nil
       }
       let myLabel = UILabel()
        myLabel.frame = CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 )
       myLabel.font = UIFont(name:"Helvetica", size: 18)
       myLabel.text = rowString

       myView.addSubview(myLabel)
       myView.addSubview(myImageView)

       return myView
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //self.category = row
        var tv = self.children[0] as! WaranteeTableViewController
        tv.WaranteeList.removeAll()
        tv.tableView.reloadData()
        print(tv.WaranteeList.isEmpty)
        let thisAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = thisAppDelegate.persistentContainer.viewContext
        
        let req:NSFetchRequest<Waranty> = Waranty.fetchRequest()
        if(row != 0) {
            req.predicate = NSPredicate(format: "category = %@", NSNumber(integerLiteral:row - 1))
        }
        do{
            let warantees = try context.fetch(req)
            print(warantees.count)
            for w in warantees {
                tv.WaranteeList.append(WaranteeTableViewController.Warantee(id: Int(w.id), uid: w.uid!, date: w.date!, amount: w.amount, category: Int(w.category), warantyPeriod: Int(w.warantyPeriod), sellerName: w.sellerName!, sellerPhone: w.sellerPhone!, sellerEmail: w.sellerEmail!, location: w.location!, createdAt: w.createdAt!, updatedAt: w.updatedAt!))
            }
            tv.tableView.reloadData()
        }
        catch let error {
           print(error)
        }
        
        
      //self.performSegue(withIdentifier: "sendResult", sender: row)
//        if(row == 5) {
//            self.performSegue(withIdentifier: "sendResult", sender: self)
//        } else {
//
//        }
    }
  
    @IBAction func addButtonPressed(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let form1:AddWaranteeController = storyboard.instantiateViewController(withIdentifier: "AddWaranteeController") as! AddWaranteeController
//        form1.x = 5
        
        //go to new screen in fullscreen
        form1.modalPresentationStyle = .fullScreen
        self.present(form1, animated: true, completion: nil)
    }
    
}

