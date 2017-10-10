//
//  ViewController.swift
//  iOS-Squeeze
//
//  Created by Markus Stöbe on 08.10.17.
//  Copyright © 2017 Markus Stöbe. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var label: UILabel!

	let model = SqueezeNet()

	override func viewDidLoad() {
		super .viewDidLoad()
		self.imageView.image = UIImage(named: "ort.jpg")
		self.label.text      = "Analyze steht noch aus"
	}

	//******************************************************************************************************************
	//* MARK: - Bildanalyse
	//******************************************************************************************************************
	func analyze(_ image :UIImage) {

		self.imageView.image = image
		self.label.text      = "Neues Bild"

		//let buffer = pixelBuffer(from: image)

//		if let prediction = try? self.model.prediction(image: buffer) {
//			print ("Dies ist ein \(prediction.classLabel)")
//			self.label.text = prediction.classLabel
//		}
	}

	//******************************************************************************************************************
	//* MARK: - Bild laden/aufnehmen/konvertieren
	//******************************************************************************************************************
	@IBAction func getImage(_ sender: Any) {
		let imagePickerController = UIImagePickerController()
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imagePickerController.sourceType = .camera
		}
		imagePickerController.delegate = self
		imagePickerController.allowsEditing = true
		present(imagePickerController, animated: true, completion: nil)
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else {
			return
		}
		analyze(image)
		picker.dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}

//	func pixelBuffer(from image:UIImage) -> CVPixelBuffer {
//
//	}


}

