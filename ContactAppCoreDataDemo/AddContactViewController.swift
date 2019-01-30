//
//  AddContactViewController.swift
//  ContactAppCoreDataDemo
//
//  Created by MAC on 1/20/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var homeTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    var imagePicker: UIImagePickerController?
    
    var isEditContact:Bool = false
    var contact:Contact?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEditContact{
            title = "Update Contact"
            if let contact = contact{
                imageView.image = UIImage(data: contact.image!)
                nameTextField.text = contact.name
                ageTextField.text = "\(contact.age)"
                var Phones = [Phone]()
                if let p = contact.phones{
                    for p in p{
                        Phones.append(p as! Phone)
                    }
                }
                workTextField.text = Phones[0].phone
                homeTextField.text = Phones[1].phone
            }
        }
        else{
            title = "Add New Contact"
        }
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = .photoLibrary
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(browseImage))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    @objc func browseImage()
    {
        present(imagePicker!, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
        }
        imagePicker?.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveButton(_ sender: Any) {
        if isEditContact{
            contact?.name = nameTextField.text
            contact?.age = Int16(ageTextField.text!)!
            contact?.image = UIImage.pngData(imageView.image!)()
            let Phone1 = Phone(context: context)
            let Phone2 = Phone(context: context)
            Phone1.label = "work"
            Phone1.phone = workTextField.text
            Phone2.label = "home"
            Phone2.phone = homeTextField.text
            contact?.addToPhones([Phone1,Phone2])
            try? contact?.managedObjectContext?.save()
            navigationController?.popViewController(animated: true)
        }
        else{
            let contact = Contact(context: context)
            contact.name = nameTextField.text
            contact.age = Int16(ageTextField.text!)!
            contact.image = UIImage.pngData(imageView.image!)()
            let Phone1 = Phone(context: context)
            let Phone2 = Phone(context: context)
            Phone1.label = "work"
            Phone1.phone = workTextField.text
            Phone2.label = "home"
            Phone2.phone = homeTextField.text
            contact.addToPhones([Phone1,Phone2])
            try? contact.managedObjectContext?.save()
            navigationController?.popViewController(animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
