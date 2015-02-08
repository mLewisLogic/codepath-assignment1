import SwiftyJSON
import UIKit

class MovieDetailsViewController: UIViewController {

    var movieData: Dictionary<String, JSON>?

    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var criticsRatingLabel: UILabel!
    @IBOutlet weak var audienceRatingLabel: UILabel!
    @IBOutlet weak var mpaaRatingLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let movieDetails = self.movieData {
            if let imageUrl = movieDetails["posters"]?["original"].string {
                // Replace the low-res thumbnail with high-res original
                let originalUrl = imageUrl.stringByReplacingOccurrencesOfString("_tmb", withString: "_ori")
                self.movieImageView?.setImageWithURL(NSURL(string: originalUrl))
            }
            if let title = movieDetails["title"]?.string {
                self.navBarItem.title = title
                if let year = movieDetails["year"]?.int {
                    self.movieTitleLabel.text = "\(title) (\(year))"
                }
            }
            if let criticsRating = movieDetails["ratings"]?["critics_score"].int {
                self.criticsRatingLabel.text = "Critic's rating: \(criticsRating)%"
            }
            if let audienceRating = movieDetails["ratings"]?["audience_score"].int {
                self.audienceRatingLabel.text = "Audience rating: \(audienceRating)%"
            }
            if let mpaaRating = movieDetails["mpaa_rating"]?.string {
                self.mpaaRatingLabel.text = mpaaRating
            }
            if let synopsis = movieDetails["synopsis"]?.string {
                self.synopsisLabel.text = synopsis
                self.synopsisLabel.sizeToFit()
            }
        }
    }
}
