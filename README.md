# RecentFlickrPhotos
Demonstration of pulling data from an API to populate a UITableViewController

Downloads recent photo data from Flickr, and displays titles and thumbnail images. Items can be deleted by swiping to the left and selecting delete, or by tapping 'Edit' in the upper right and tapping the red circle. This edit mode will also allow reordering of items by dragging the three line icon. You can also reorder items by long pressing on the row (not in edit mode).

Some items do not have a thumbnail image, large image, or both. Those items are designated by a red 'X' on the image icon.

The network layer is a recent tweak of a system I've been using for the last year. I'm trying to pull most of the network logic out of the controller. My goal is to have the controller simply call a method that does the background networking, JSON parsing, etc, and returns a Model object (or collection of Models) to the View Controller. I like having the JsonRequestHelper class as a single point for all the error checking on the network response, and I like having success and failure blocks passed in from the view controller. I'm not certain that I have the right division of a 'Router' that builds the network requests, and a separate class for 'Endpoints' that does model->JSON and JSON->model translation.

This example does not provide any persistence of the network data. This would be present in a production app, and I have used the Realm database project for my in-app database needs recently. Including the Realm database in this example would make it more difficult to build/run the project, especially if that computer does not have Cocoapods already installed.

One difficulty I had with this type of example is, for the Flickr API, there isn't a clear picture of what should happen when a photo is deleted, or the images are re-ordered. With a different API, I would have deleting an item send a delete request for that item. Similarly, reordering might update the parameters of the two items that was sent to the server. In this example app, these modifications only happen to the in-memory copy, and are not persisted.

There is a basic image cache provided by the built in NSURLSession system, and I have not added any additional caching. This would be an important consideration for this kind of app in a production setting.

Finally, I did not implement paging of the API records, and so am only displaying the first 100 items. In a production app, what I typically do is download the first two pages, then when the user scrolls into the second page of results, download the third and append it to the stored items. For large data sets, this requires purging of earlier records. 

###Update: 25 May 2017

Implemented a basic paging system with a cell in the TableView that says "loading". When that cell is displayed, the next page of results is fetched and appended to the existing data.
