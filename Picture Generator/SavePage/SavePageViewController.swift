//
//  SavePageViewController.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 19/02/24.
//

import UIKit

class SavePageViewController: UIViewController {
    @IBOutlet weak var saveImage: UIImageView!
    @IBOutlet weak var saveButtonLabel: UIButton!
    @IBOutlet weak var shareButtonLabel: UIButton!
    @IBOutlet weak var shareFacebookLabel: UIButton!
    
    var combinedData: CombinedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareToTwitter()
    }
    
    @IBAction func shareFacebookTapped(_ sender: Any) {
        shareToFacebook()
    }
    
    
    func setup() {
        if let text = combinedData?.text {
            print("Text to be saved: \(text)")
        }
        if let image = combinedData?.image {
            print("Image received in SavePageViewController")
            saveImage.image = image
        } else {
            print("Error: Image data in combinedData is nil")
        }
    }
    
    func shareToTwitter() {
        guard let combinedImage = combinedData?.image else {
            print("Error: Combined image is nil")
            return
        }

        let tweetText = "Check out this amazing image!"
        let twitterURLString = "https://twitter.com/intent/tweet?text=\(tweetText)&url=\(combinedImage)"

        if let twitterURL = URL(string: twitterURLString), UIApplication.shared.canOpenURL(twitterURL) {
            UIApplication.shared.open(twitterURL, options: [:], completionHandler: nil)
        } else {
            print("Error: Unable to open Twitter URL")
        }
    }

    func shareToFacebook() {
        guard let combinedImage = combinedData?.image else {
            print("Error: Combined image is nil")
            return
        }

        let facebookURLString = "https://www.facebook.com/sharer/sharer.php?u=\(combinedImage)"

        if let facebookURL = URL(string: facebookURLString), UIApplication.shared.canOpenURL(facebookURL) {
            UIApplication.shared.open(facebookURL, options: [:], completionHandler: nil)
        } else {
            print("Error: Unable to open Facebook URL")
        }
    }

    func saveImageToPhotoLibrary() {
        guard let imageToSave = combinedData?.image else {
            print("Error: Combined image is nil")
            return
        }

        UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("Error saving image: \(error.localizedDescription)")
        } else {
            print("Image saved successfully to photo library.")
        }
    }
}

