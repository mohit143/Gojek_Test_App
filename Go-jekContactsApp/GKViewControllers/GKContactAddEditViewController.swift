//
//  GKContactAddEditViewController.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 25/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import UIKit

class GKContactAddEditViewController: UIViewController,UINavigationControllerDelegate {
    //MARK: - Outlet creations
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: GKGradientView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var tblAddEdit: UITableView!
    
    //MARK: - Property declarations
    let headerViewMaxHeight: CGFloat = 250 * K.appCONSTANT.kScreenSizeRatioWidth
    let headerViewMinHeight: CGFloat = 65 * K.appCONSTANT.kScreenSizeRatioWidth
    var contactDetailObject:GKContactDetail?
    let fieldsArr = [["title":K.GK_Placeholders.PlaceHolder_Firstname,"keyboardType":UIKeyboardType.default,"autocapitalizationType" : UITextAutocapitalizationType.words],["title":K.GK_Placeholders.PlaceHolder_Lastname,"keyboardType":UIKeyboardType.default,"autocapitalizationType" : UITextAutocapitalizationType.words],["title":K.GK_Placeholders.PlaceHolder_Mobile,"keyboardType":UIKeyboardType.phonePad,"autocapitalizationType" : UITextAutocapitalizationType.none],["title":K.GK_Placeholders.PlaceHolder_Email,"keyboardType":UIKeyboardType.emailAddress,"autocapitalizationType" : UITextAutocapitalizationType.none]]
    var arrValues = [String]()
    var imagePicker = UIImagePickerController()
    var imageData : Data?

    //MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if contactDetailObject != nil {
            imgContact.kf.setImage(with: URL(string: K.appUrl.mainurl + contactDetailObject!.profilePic!))
        }
        else{
            contactDetailObject = GKContactDetail(id: -1, firstName: "", lastName: "", email: "", phoneNumber: "", profilePic: "", favorite: false, createdAt: "", updatedAt: "")
        }
        arrValues = [contactDetailObject?.firstName == nil ? "" : contactDetailObject!.firstName!,contactDetailObject?.lastName == nil ? "" : contactDetailObject!.lastName!,contactDetailObject?.phoneNumber == nil ? "" : contactDetailObject!.phoneNumber!,contactDetailObject?.email == nil ? "" : contactDetailObject!.email!]
        imgContact.layer.cornerRadius = imgContact.frame.width/2
        tblAddEdit.estimatedRowHeight = 100
        tblAddEdit.rowHeight = UITableView.automaticDimension
        tblAddEdit.tableFooterView = UIView(frame: .zero)
        tblAddEdit.reloadData()
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        imgContact.layer.cornerRadius = imgContact.frame.width/2
        imgContact.layer.borderWidth = 3.0
        imgContact.layer.borderColor = UIColor.init(named: "WhiteDarkModeColor")!.cgColor
    }
    //MARK: - IBActions

    @IBAction func cancelAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        self.view.endEditing(true)
        GKUtility.showPhotoOptions(currController: self, imagePicker: self.imagePicker)
    }
    @IBAction func doneAction(_ sender: Any) {
        self.view.endEditing(true)
        contactDetailObject?.firstName = arrValues[0]
        contactDetailObject?.lastName = arrValues[1]
        contactDetailObject?.email = arrValues[3]
        contactDetailObject?.phoneNumber = arrValues[2]
        if ((contactDetailObject?.firstName!.isEmpty)!) && ((contactDetailObject?.lastName!.isEmpty)!) && (contactDetailObject!.email!.isEmpty) && ((contactDetailObject?.phoneNumber!.isEmpty)!){
            Show(K.GK_Message_Local.allFieldsEmpty, view: self)
            return
        }
        if (contactDetailObject?.email?.isEmpty)! == false{
            if GKValidationManager.isValidEmail((contactDetailObject?.email)!) == false{
                Show(K.GK_Message_Local.invalidEmail, view: self)
                return
            }
        }
        let parameters: [String:Any] = ["first_name": contactDetailObject!.firstName!,"last_name": contactDetailObject!.lastName!,"email": contactDetailObject!.email!,"phone_number": contactDetailObject!.phoneNumber!,"id":"\(contactDetailObject!.id!)","favorite" : (contactDetailObject?.favorite == true) ? 1 : 0] as [String : Any]
        GKUtility.updateContactDetail(parameters: parameters, imageData: imageData) { (gkcontactDetailModel, error) in
            if error == nil
            {
                DispatchQueue.main.async {
                    RemoveHUD()
                    self.navigationController?.popViewController(animated: false)
                }
            }
        }
    }
}
extension GKContactAddEditViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fieldsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "GKContactAddEditTableViewCell", for: indexPath) as! GKContactDetailTableViewCell
        cell.txtInput.labelText = ((fieldsArr[indexPath.row])["title"] as! String)
        cell.txtInput.placeholder = ((fieldsArr[indexPath.row])["title"] as! String)
        cell.txtInput.delegate = self
        cell.txtInput.autocapitalizationType = (fieldsArr[indexPath.row])["autocapitalizationType"] as! UITextAutocapitalizationType
        if arrValues.count > 0 {
            cell.txtInput.text = arrValues[indexPath.row]
        }
        cell.txtInput.tag = indexPath.row
        cell.txtInput.keyboardType = (fieldsArr[indexPath.row])["keyboardType"] as! UIKeyboardType
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        if let dataArr = boatListObject?.data
    //        {
    //            let boatObj = dataArr[indexPath.row]
    //            createBoatObjects(boatObj: boatObj)
    //        }
    //    }
}
// MARK: - UIScrollViewDelegate
extension GKContactAddEditViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y: CGFloat = scrollView.contentOffset.y
        let newHeaderViewHeight: CGFloat = headerHeight.constant - y
        
        if newHeaderViewHeight > headerViewMaxHeight {
            headerHeight.constant = headerViewMaxHeight
        } else if newHeaderViewHeight < headerViewMinHeight {
            headerHeight.constant = headerViewMinHeight
        } else {
            headerHeight.constant = newHeaderViewHeight
            scrollView.contentOffset.y = 0 // block scroll view
        }
    }
}
// MARK: - image picker delegate

extension GKContactAddEditViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[.editedImage] as? UIImage {
            imgContact.image = editedImage
            imageData  = editedImage.compressTo(1048576)!
        } else if let originalImage = info[.originalImage] as? UIImage {
            imgContact.image = originalImage
            imageData  = originalImage.compressTo(1048576)!
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
}
extension GKContactAddEditViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        arrValues[textField.tag] = newString as String
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
}
