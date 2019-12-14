//
//  WaranteeTableViewController.swift
//  warantee
//
//  Created by Humaid Khan on 13/12/2019.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class WaranteeTableViewController: UITableViewController {
    var WaranteeList:[Warantee] = []

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
        deleteAllData(entity: "Waranty")
        Auth.auth().currentUser?.getIDToken(completion: warantyRequest)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    func warantyRequest(token:String?, error: Error?) {
        let thisAppDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = thisAppDelegate.persistentContainer.viewContext
        if let url = URL(string: "https://www.vrpacman.com/waranty") {
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField:"AuthToken")
            request.httpMethod = "GET"
            URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                  do {
                    _ = String(data: data,encoding:String.Encoding.utf8) as String?
                     let res = try JSONDecoder().decode([Warantee].self, from: data)
                    print(res.count)
                    for i in stride(from: 0, to: res.count, by:1){
                        let w = res[i]
                        let waranty = Waranty(context:context)
                        waranty.id = Int64(w.id)
                        waranty.uid = w.uid
                        waranty.date = w.date
                        waranty.amount = w.amount
                        waranty.category = Int16(w.category)
                        waranty.warantyPeriod = Int64(w.warantyPeriod)
                        waranty.sellerName = w.sellerName
                        waranty.sellerPhone = w.sellerPhone
                        waranty.sellerEmail = w.sellerEmail
                        waranty.location = w.location
                        waranty.createdAt = w.createdAt
                        waranty.updatedAt = w.updatedAt
                        print(w.sellerEmail)
                        self.WaranteeList.append(Warantee(id: w.id, uid: w.uid, date: w.date, amount: w.amount, category: w.category, warantyPeriod: w.warantyPeriod, sellerName: w.sellerName, sellerPhone: w.sellerPhone, sellerEmail: w.sellerEmail, location: w.location, createdAt: w.createdAt, updatedAt: w.updatedAt))
                        self.warantyImageRequest(token:token, error: error, waranty: w, count: i, totalCount: res.count)
                    }
                    thisAppDelegate.saveContext()
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }
    func warantyImageRequest(token:String?, error: Error?, waranty:Warantee, count: Int, totalCount: Int) {
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationFileUrl = documentsUrl.appendingPathComponent(String(waranty.id) + ".jpg")
        if let url = URL(string: "https://www.vrpacman.com/s3proxy?fileKey=" + waranty.uid + String(waranty.id) + ".jpg") {
            var request = URLRequest(url: url)
            request.setValue(token, forHTTPHeaderField:"AuthToken")
            request.httpMethod = "GET"
            URLSession.shared.downloadTask(with: request) { localURL, response, error in
            if let localURL = localURL {
                  do {
                    try? FileManager.default.removeItem(at: destinationFileUrl)
                    try FileManager.default.moveItem(at: localURL, to: destinationFileUrl)
                    if(count == totalCount - 1) {
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                  } catch let error {
                     print(error)
                  }
               }
           }.resume()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return WaranteeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WaranteeCell", for: indexPath) as? WaranteeCell else {
            fatalError("The dequeued cell is not an instance of WaranteeCell")
        }
        let warantee = WaranteeList[indexPath.row]
        cell.sellerNameLabel.text = warantee.sellerName
        cell.amountLabel.text = String(warantee.amount)
        cell.periodLabel.text = String(warantee.warantyPeriod)
        switch warantee.category {
         
        case 0:
            cell.iconLabel.image = UIImage(named:"food")
        case 1:
            cell.iconLabel.image = UIImage(named:"grocery")
         case 2:
             cell.iconLabel.image = UIImage(named:"travel")
         case 3:
             cell.iconLabel.image = UIImage(named:"electronics")
         case 4:
             cell.iconLabel.image = UIImage(named:"others")
        default:
            cell.iconLabel.image = UIImage(named:"warantee")
        }
        let documentsUrl:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsUrl.appendingPathComponent(String(warantee.id) + ".jpg")
        do{
            let imageData = try Data(contentsOf: fileURL)
            cell.waranteeImage.image = UIImage(data: imageData)
        } catch {
            print("Error loading image: \(error)")
        }
        return cell
    }

    override func tableView(_ tableView:UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell selected")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let warantyInfoVC:WarantyInfoViewController = storyboard.instantiateViewController(withIdentifier: "WarantyInfo") as! WarantyInfoViewController
        warantyInfoVC.warantyId = self.WaranteeList[indexPath.row].id
        
        //go to new screen in fullscreen
        warantyInfoVC.modalPresentationStyle = .fullScreen
        self.present(warantyInfoVC, animated: true, completion: nil)
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
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//        if(segue.identifier == "sendResult") {
//            var picker:UIPickerView = sender as! UIPickerView
//            print(picker.selectedRow(inComponent: 0))
//        }
//        
//    }
    

}
