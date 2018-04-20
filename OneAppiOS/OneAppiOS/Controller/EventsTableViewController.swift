//
//  EventsTableViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/17/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventsTableViewController: UITableViewController {
    
    struct event {
        let start: String
        let end: String
        let summary: String
        let location: String
    }
    
    var events: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        events = NSMutableArray()
        
        let url: String = "https://m7cwj1fy7c.execute-api.us-west-2.amazonaws.com/mlhtest/dayof-events"
        Alamofire.request(url).responseJSON { response in
            let swiftJson = JSON(response.result.value!)
            //print(swiftJson)
            
            if let stausCode = swiftJson["statusCode"].int {
                if stausCode == 200 {
                    if let body = swiftJson["body"].array {
                        print(body)
                        
                        for item in body{
                            
                            //print(item)
                            //print(item["summary"])
                            //print(item["end"].string!)
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
                            let date = dateFormatter.date (from: item["start"]["dateTime"].string!)
                            let dayTimePeriodFormatter = DateFormatter()
                            dayTimePeriodFormatter.dateFormat = "EEE hh:mm a"
                            let dateStringStart = dayTimePeriodFormatter.string(from: (date as Date?)!)
                            
                            
                            let dateFormatterEnd = DateFormatter()
                            dateFormatterEnd.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
                            let dateEnd = dateFormatterEnd.date (from: item["end"]["dateTime"].string!)
                            let dayTimePeriodFormatterEnd = DateFormatter()
                            dayTimePeriodFormatterEnd.dateFormat = "EEE hh:mm a"
                            let dateStringEnd = dayTimePeriodFormatter.string(from: (dateEnd as Date?)!)
                            
                            self.events?.add(event.init(start: dateStringStart, end: dateStringEnd, summary: item["summary"].string!, location: item["location"].string ?? ""))
                            
                            self.tableView.reloadData()
                        }
                    }
                    
                    
                }else{
                    print("Bad Status Code")
                }
            
            
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (events?.count)!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        
        let item = events?.object(at: indexPath.row) as! event
        
        cell.textLabel?.text = item.summary
        cell.textLabel?.textColor = HackRUColor.blue
        
        
        cell.detailTextLabel?.text = item.start
        cell.detailTextLabel?.textColor = HackRUColor.lightBlue
        
      
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDetail"){
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let eventSelected = events?.object(at: indexPath.row) as! event
                EventDetailTableViewController.mutArr.removeAllObjects()
                
                EventDetailTableViewController.mutArr.add("Event: \(eventSelected.summary)")
                EventDetailTableViewController.mutArr.add("Location: \(eventSelected.location)")
                EventDetailTableViewController.mutArr.add("Start: \(eventSelected.start)")
                EventDetailTableViewController.mutArr.add("End: \(eventSelected.end)")
                
                
            }
            
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
