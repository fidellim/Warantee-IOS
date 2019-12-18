//
//  AddWaranteeController.swift
//  warantee
//
//  Created by Mahmoud Elmohtasseb on 2019-12-17.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit


class CellClass: UITableViewCell {
    
}
class AddWaranteeController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var txtPeriod: UITextField!

    @IBOutlet weak var picker: UIPickerView!
    //Creating a table view
    let tableView = UITableView()
    //to make the screen shaded when selecting category
    let transparentView = UIView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    var category = 0
    @IBOutlet weak var categorySelect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       picker.delegate = self
        picker.dataSource = self
        
        //this is to pick on the text field and shows the calander
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action:#selector(AddWaranteeController.dateChanged(datePicker:)), for: .valueChanged)
        
        //this is to recognize when you click anywhewre on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddWaranteeController.viewTapped(gestureRecognaizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        //Display the date in the text field
        txtDate.inputView = datePicker
        
    }
    
    
    //Category Button
    @IBAction func selectCategory(_ sender: Any) {
        
        dataSource = ["Food","Grocery","Travel","Electronics","Others"]
        selectedButton = categorySelect
        //Function to view the list
        addTrasnparentView(frames: categorySelect.frame)
        
    }
    
    func addTrasnparentView(frames: CGRect){
        
        let window = UIApplication.shared.keyWindow
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        //add table view
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        
        //setting the shade colour of the screen background
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        tableView.reloadData()
        
        //this is to recognize when you click anywhewre on the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        
        //tab anywhere on the page to close the menu
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        //How the category list will be viewed
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{ self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.dataSource.count * 50) )
        }, completion: nil)
    }
    
    //Function to remove the animation of the view
    @objc func removeTransparentView (){
        let frames  = selectedButton.frame
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations:{ self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
        
    }
    
    //Functtion to go to the next page
    @IBAction func NextPage(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuVC:Image_VideoController = storyboard.instantiateViewController(withIdentifier: "WaranteeForm2") as! Image_VideoController
        menuVC.warantyDate = txtDate.text ?? "17/12/2019"
        menuVC.warantyAmount = Float(self.txtAmount.text ?? "5.5")!
        menuVC.warantyCategory = self.category
        menuVC.warantyPeriod = Int(Int64(self.txtPeriod.text ?? "3")!)
        menuVC.warantySellerName = txtName.text ?? "John"
        menuVC.warantySellerPhone = txtPhone.text ?? "992424"
        menuVC.warantySellerEmail = txtEmail.text ?? "jonfh@hc.com"
        menuVC.warantyLocation = txtLocation.text ?? "Burj al arab"
        //go to new screen in fullscreen
        menuVC.modalPresentationStyle = .fullScreen
        self.present(menuVC, animated: true, completion: nil)
    }
    
   private var datePicker: UIDatePicker?
    
    
    
    
    
    //function to dismiss the datepicker when click on the screen
    @objc func viewTapped(gestureRecognaizer: UITapGestureRecognizer){
         view.endEditing(true)
     }
     
    //to get and display the date after it is has been changed
    @objc func dateChanged(datePicker: UIDatePicker)
     {
         let dateFormater = DateFormatter()
         dateFormater.dateFormat = "MM/dd/yyyy"
         
         txtDate.text = dateFormater.string(from: datePicker.date)
         view.endEditing(true)
         
     }
    
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
           self.category = row
    }
           

    
}

extension AddWaranteeController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedButton.setTitle(dataSource[indexPath.row], for: .normal)
        removeTransparentView()
    }
}

