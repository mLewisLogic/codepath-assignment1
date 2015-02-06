import UIKit

class MovieTableViewController: UITableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.machel.movie-row") as UITableViewCell
        return cell
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Did tap row: \(indexPath.row)")
    }

    func loadData(pathSuffix: String) {
        if let path = NSBundle.mainBundle().pathForResource("private", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                let apiKey = dict["RottenTomatoes"]?["key"]

                let fullPath = "http://api.rottentomatoes.com/api/public/v1.0/\(pathSuffix).json?apikey=\(apiKey)"
                NSLog(fullPath)

                let request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response, data, error) in
                    var errorValue: NSError? = nil
                    let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                })
            }
        }
    }
}
