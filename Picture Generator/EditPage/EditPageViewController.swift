//
//  EditPageViewController.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 16/02/24.
//

import UIKit
import Photos

class EditPageViewController: UIViewController {
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var addTextButton: UIButton!
    @IBOutlet weak var addtextLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var addImageLabel: UILabel!
    
    var memesData: Memes?
    var textView: UITextView?
    private var initialImageCenter: CGPoint?
    var combinedData: CombinedData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTextButtonClicked(_ sender: Any) {
        showTextView()
        print("Add Text Button Clicked")
    }
    @IBAction func addImageButtonClicked(_ sender: Any) {
        showImagePicker()
        print("Add Image Button Clicked")
    }
    
    func setup () {
        if let imageURLString = memesData?.url, let imageURL = URL(string: imageURLString) {
            URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.editImage.image = image
                    }
                }
            }.resume()
        }
        editImage.isUserInteractionEnabled = true
    }
    
    //MARK: - Handle add text editing
    func showTextView() {
        print("showTextView")

        let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        textView.center = view.center
        textView.textColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.text = "Your Text Here"
        textView.delegate = self

        // This is gesture recognizers for dragging
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        textView.addGestureRecognizer(panGesture)

        self.view.addSubview(textView)

        self.textView = textView

        textView.isEditable = true

        textView.textAlignment = .center

        textView.backgroundColor = UIColor.clear
        textView.layer.borderWidth = 0.0
        textView.layer.borderColor = UIColor.clear.cgColor
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.rightBarButtonItem = doneButton
    }

    //MARK: - Handle text drag gesture
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let textView = gesture.view as? UITextView else { return }
        let translation = gesture.translation(in: textView)

        textView.center = CGPoint(x: textView.center.x + translation.x, y: textView.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: textView)
    }
    
    //MARK: - Handle image drag gesture
    @objc func handlePanImage(_ gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else { return }

        if gesture.state == .began {
            initialImageCenter = view.center
        }

        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            view.center = CGPoint(x: initialImageCenter!.x + translation.x, y: initialImageCenter!.y + translation.y)
            print("Image Center: \(view.center)")
        }
    }
    
    // MARK: - Handle pinch image from local storage
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }

        if gesture.state == .changed {
            let scale = gesture.scale
            view.transform = view.transform.scaledBy(x: scale, y: scale)
            gesture.scale = 1.0
        }
    }
    
    
    //MARK: - Handle done button
    @objc func doneButtonTapped() {
        if let text = textView?.text,
            let image = editImage.image {
            print("Final text content: \(text)")
            combinedData = CombinedData(text: text, image: image)
            print("Combined Data: \(combinedData)")
        } else {
            print("Error: Image data is nil")
        }

        textView?.resignFirstResponder()

        let viewController = UIStoryboard(name: "SavePage", bundle: nil).instantiateViewController(withIdentifier: "SavePage") as! SavePageViewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
 
}


//MARK: - UITextViewDelegate
extension EditPageViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print("Text view content changed")
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension EditPageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            editImage.image = selectedImage
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanImage(_:)))
            editImage.addGestureRecognizer(panGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
            editImage.addGestureRecognizer(pinchGesture)
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Handle permission
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    if status == .authorized {
                        self.showImagePicker()
                    } else {
                        let alert = UIAlertController(
                            title: "Permission Denied",
                            message: "Please enable photo library access in Settings to choose an image.",
                            preferredStyle: .alert
                        )
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
                            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                            }
                        }
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alert.addAction(settingsAction)
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            showImagePicker()
        case .limited:
            let alert = UIAlertController(
                title: "Limited Access",
                message: "Your device is currently in a restricted mode, and some features may be limited. Please check with the device owner for more information.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
