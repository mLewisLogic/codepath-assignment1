import UIKit

class MovieTableViewController: UITableViewController {

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.machel.movie-row") as MovieTableViewCell
        cell.movieTitleLabel.text = "Row: \(indexPath.row)"
        return cell
    }

    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Did tap row: \(indexPath.row)")
    }


    // Load data from the server
    private func loadData(pathSuffix: String) -> Dictionary<String, AnyObject>? {
        if let apikey = apiKey() {
            let fullPath = "http://api.rottentomatoes.com/api/public/v1.0/\(pathSuffix).json?apikey=\(apikey)"
            NSLog(fullPath)

            let components = NSURLComponents()
            components.scheme = "http"
            components.host = "api.rottentomatoes.com"
            components.path = "/api/public/v1.0/\(pathSuffix).json"
            components.queryItems = [
                NSURLQueryItem(name: "apikey", value: apikey),
            ]

            let request = NSMutableURLRequest(URL: NSURL(string: fullPath)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response, data, error) in
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            })
        }
        return nil
    }

    // Extract the API key out of the settings Dictionary
    private func apiKey() -> String? {
        if let settings = loadSettings() {
            return settings["RottenTomatoes"]?["key"] as? String
        }

        return nil
    }

    // Pull our private credendtial settings as a Dictionary.
    private func loadSettings() -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource("private", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject> {
                // If we got this far, we have a valid dict
                return dict
            }
        }

        return nil
    }
}
