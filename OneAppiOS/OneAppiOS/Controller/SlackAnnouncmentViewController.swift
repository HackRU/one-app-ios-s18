//
//  SlackAnnouncmentViewController.swift
//  OneAppiOS
//
//  Created by Qasim Abbas on 4/17/18.
//  Copyright © 2018 Qasim Abbas. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SlackAnnouncmentViewController: UITableViewController {

    struct announce {
        let user: String
        let text: String
        let ts: String
    }

    var announceArray: NSMutableArray?

    override func viewDidLoad() {
        super.viewDidLoad()

        announceArray = NSMutableArray()

        let url: String = "https://7c5l6v7ip3.execute-api.us-west-2.amazonaws.com/lcs-test/dayof-slack"
        Alamofire.request(url).responseJSON { response in
            // handle JSON
            let swiftJson = JSON(response.result.value!)
            if(swiftJson["statusCode"].int == 200) {
                //print(swiftJson)
                print("SUCCESSFUL STATUS CODE")
                if let body = swiftJson["body"].array {
                    //print(body)

                    for item in body {
                        //print(item["user"].string!)
                        //print(item["text"].string!)

                        print(item)
                        let itemText = self.cleanString(s: item["text"].string ?? "")
                        if(itemText != "") {
                            let itemAnnounce = announce(user: item["user"].string!, text: item["text"].string!, ts: item["ts"].string!)
                            self.announceArray?.add(itemAnnounce)
                            self.tableView.reloadData()
                        }

                    }
                }
            } else {
                print("Please connect to the internet")
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
        return announceArray!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventsTableViewCell

        let item = announceArray?.object(at: indexPath.row) as! announce
        var itemText = item.text
        itemText = cleanString(s: itemText)

        let timeStamp = Double(item.ts)

        let date = NSDate(timeIntervalSince1970: TimeInterval(timeStamp!))

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"

        let dateString = dayTimePeriodFormatter.string(from: date as Date)

        print( " value is \(dateString)")

        cell.txtInfo.text = itemText
        cell.txtInfo.textColor = HackRUColor.blue

        cell.txtTime.text = dateString
        cell.txtTime.textColor = HackRUColor.lightBlue

        //cell.detailTextLabel?.text = dateString

        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }

    func cleanString (s: String) -> String {
        var res = ""
        var openBracColon = false

        for c in s {
            if(openBracColon) {
                if(c == ">" || c == ":") {
                    openBracColon = false
                }
            } else {
                if(c == "<" || c == ":") {
                    openBracColon = true
                } else {
                    res = res + "\(c)"
                }
            }

        }

        print(res)
        return res
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
