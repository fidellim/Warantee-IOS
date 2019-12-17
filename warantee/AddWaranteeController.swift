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
class AddWaranteeController: UIViewController {

    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    
    //Creating a table view
    let tableView = UITableView()
    //to make the screen shaded when selecting category
    let transparentView = UIView()
    var selectedButton = UIButton()
    var dataSource = [String]()
    
    @IBOutlet weak var categorySelect: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CellClass.self, forCellReuseIdentifier: "Cell")
        
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
        let menuVC:Image_VideoController = storyboard.instantiateViewController(withIdentifier: "Image_VideoController") as! Image_VideoController
        
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
