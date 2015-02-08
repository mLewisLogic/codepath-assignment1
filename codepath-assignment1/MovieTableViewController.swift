import Alamofire
import SVProgressHUD
import SwiftyJSON
import UIKit

class MovieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    var moviesArray: [JSON]?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Set our source and add the tableview to the view
        tableView.dataSource = self
        self.view.addSubview(tableView)

        // Set up our UIRefreshControl for pull-down refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("loadMovieIndex:"), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        self.displayErrorView(false)
        loadMovieIndex(refreshControl)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = self.moviesArray {
            return array.count
        } else {
            return 0
        }
    }

    // Build each cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("com.machel.movie-row") as MovieTableViewCell
        if let movieDetails = self.movieDetailsAtIndex(indexPath.row) {
            if let title = movieDetails["title"].string {
                cell.movieTitleLabel.text = title
            }
            if let description = movieDetails["synopsis"].string {
                cell.movieSynopsisLabel.text = description
            }
            if let mpaaRating = movieDetails["mpaa_rating"].string {
                cell.movieMPAARatingLabel.text = mpaaRating
            }
            if let imageUrl = movieDetails["posters"]["original"].string {
                // Replace the low-res thumbnail with high-res original
                let originalUrl = imageUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
                cell.movieImageView?.setImageWithURL(NSURL(string: originalUrl))
            }
        }
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailsSegue" {
            let movieDetailsViewController = segue.destinationViewController as MovieDetailsViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                movieDetailsViewController.movieData = self.movieDetailsAtIndex(indexPath.row)?.dictionary
            }
        }
    }

    func loadMovieIndex(refreshControl: UIRefreshControl) {
        loadData("lists/dvds/top_rentals", refreshControl: refreshControl)
    }


    /* private */

    // Allow the display of an error message
    private func displayErrorView(display: Bool) {
        var viewFrame = self.errorView.frame
        var labelFrame = self.errorLabel.frame
        if display {
            viewFrame.size.height = 24
            labelFrame.size.height = 21
        } else {
            viewFrame.size.height = 0
            labelFrame.size.height = 0
        }
        errorView.frame = viewFrame
        errorLabel.frame = labelFrame
        errorView.hidden = !display
        errorLabel.hidden = !display
    }

    private func movieDetailsAtIndex(index: Int) -> JSON? {
        if let moviesArray = self.moviesArray {
            // Bounds check for sanity's sake
            if moviesArray.startIndex <= index && index < moviesArray.endIndex {
                // Retrieve the movieDetails
                return moviesArray[index]
            }
        }
        return nil
    }

    // Load data from the server into this table's data source
    private func loadData(pathSuffix: String, refreshControl: UIRefreshControl) {
        SVProgressHUD.showWithStatus("loading", maskType: SVProgressHUDMaskType.Gradient)

        if let apikey = apiKey() {
            let path = "http://api.rottentomatoes.com/api/public/v1.0/\(pathSuffix).json"
            let params = [
                "apikey": apikey,
            ]

            Alamofire.request(.GET, path, parameters: params).responseJSON {
                (request, response, json, error) in
                    sleep(2)
                    // clean up our progress bars
                    refreshControl.endRefreshing()
                    SVProgressHUD.dismiss()

                    if(error != nil) {
                        NSLog("Error: \(error)")
                        self.displayErrorView(true)
                    }
                    else {
                        let jsonData = JSON(json!)
                        if let moviesArray = jsonData["movies"].array {
                            self.moviesArray = moviesArray
                            self.displayErrorView(false)
                            self.tableView.reloadData()
                        }
                    }
            }
        }
    }

    // Extract the API key out of the settings Dictionary
    private func apiKey() -> String? {
        if let settings = loadSettings() {
            return settings["RottenTomatoes"]?["key"] as? String
        } else {
            return nil
        }
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
