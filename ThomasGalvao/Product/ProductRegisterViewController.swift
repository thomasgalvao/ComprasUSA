//
//  ShoppingViewController.swift
//  ThomasGalvao
//
//  Created by Thomas Galvão on 18/04/2018.
//  Copyright © 2018 Thomas Galvao. All rights reserved.
//

import UIKit
import CoreMotion

class ProductRegisterViewController: UIViewController {
    
    @IBOutlet weak var tfProductName: UITextField!
    @IBOutlet weak var ivProductImage: UIImageView!
    @IBOutlet weak var tfProductState: UITextField!
    @IBOutlet weak var tfProductPriceInDolar: UITextField!
    @IBOutlet weak var swProductCard: UISwitch!
    @IBOutlet weak var btProductAddEdit: UIButton!
    
    var pickerView: UIPickerView!
    var dataSource:[String] = ["California", "New York", "Texas"]
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView = UIPickerView() //Instanciando o UIPickerView
        pickerView.backgroundColor = .white
        pickerView.delegate = self  //Definindo seu delegate
        pickerView.dataSource = self  //Definindo seu dataSource
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.items = [btCancel, btSpace, btDone]
        
        tfProductState.inputAccessoryView = toolbar
        tfProductState.inputView = pickerView
        
        if product != nil {
            tfProductName.text = product.title
            if let image = product.poster as? UIImage {
                ivProductImage.image = image
            }
            tfProductPriceInDolar.text = String(product.dolar)
            tfProductState.text = "Brasil"
            swProductCard.isOn = product.card
        }
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tfProductState.text = UserDefaults.standard.string(forKey: "state")
    }
    
    @objc func cancel() {
        tfProductState.resignFirstResponder()
    }
    
    @objc func done() {
        tfProductState.text = dataSource[pickerView.selectedRow(inComponent: 0)]
        UserDefaults.standard.set(tfProductState.text!, forKey: "state")
        cancel()
    }
    
    // MARK:  Methods
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    // MARK: IBAction
    @IBAction func btAddProduct(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar Imagem", message: "De onde você quer escolher a Imagem?", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addUpdateProduct(_ sender: UIButton) {
        
        if product == nil {
            product = Product(context: context)
        }
        
        
        product.title = tfProductName.text!
        
        if let dolar = Double(tfProductPriceInDolar.text!) {
            product.dolar = dolar
        }
        //product.dolar = Double(tfProductPriceInDolar.text!)!
        product.poster = ivProductImage.image
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
 

}



// MARK: - UIImagePickerControllerDelegate
extension ProductRegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        ivProductImage.image = image
        dismiss(animated: true, completion: nil)
    }
}

extension ProductRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
}

extension ProductRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
}


