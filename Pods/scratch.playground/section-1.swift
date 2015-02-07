import AFNetworking
import Foundation
import UIKit
import XCPlayground
XCPSetExecutionShouldContinueIndefinitely()

let pathSuffix = "lists/dvds/top_rentals"
let apikey = "9keu59h7cunzptdnjujnapdq"

let components = NSURLComponents()
components.scheme = "http"
components.host = "api.rottentomatoes.com"
components.path = "/api/public/v1.0/\(pathSuffix).json"
components.queryItems = [
    NSURLQueryItem(name: "apikey", value: apikey),
]
components.query
components.URL
components.string
components.percentEncodedPath

AFHTTPRequestOperationManager