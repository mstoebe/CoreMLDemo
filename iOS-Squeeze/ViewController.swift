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
		analyze(self.imageView.image!)
	}

	//******************************************************************************************************************
	//* MARK: - Bildanalyse
	//******************************************************************************************************************
	func analyze(_ image :UIImage) {

		self.imageView.image = image
		self.label.text      = "Analyse läuft …"

		let scaledImage = self.scale(image: image, toSize: CGSize(width: 227, height: 227))
		let buffer      = self.pixelBuffer(withImage: scaledImage)

		if let prediction = try? self.model.prediction(image: buffer!) {
			self.label.text = prediction.classLabel
		}

	}

	//******************************************************************************************************************
	//* MARK: - Bild laden/aufnehmen
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

	//******************************************************************************************************************
	//* MARK: - Bild skalieren/konvertieren
	//******************************************************************************************************************
	func scale(image:UIImage, toSize newSize:CGSize) -> UIImage{
		UIGraphicsBeginImageContextWithOptions(newSize, false, image.scale);
		image.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newSize.width, height: newSize.height)))
		let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		return scaledImage
	}

	func pixelBuffer(withImage image:UIImage) -> CVPixelBuffer? {
		guard let cgimage = image.cgImage else {
			return nil
		}

		//neuen PixelBuffer anlegen
		var pixelBuffer:CVPixelBuffer? = nil
		let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(cgimage.width), Int(cgimage.height), kCVPixelFormatType_32BGRA , nil, &pixelBuffer)
		if status != kCVReturnSuccess {
			return nil
		}

		//Pixelbuffer füllen
		let ciimage = CIImage.init(cgImage: cgimage)
		let context = CIContext.init()
		context.render(ciimage, to:pixelBuffer!)

		return pixelBuffer
	}
}

