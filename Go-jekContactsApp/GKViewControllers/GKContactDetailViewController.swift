//
//  GKContactDetailViewController.swift
//  Go-jekContactsApp
//
//  Created by Mohit Mathur on 24/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import UIKit
import MessageUI

class GKContactDetailViewController: UIViewController {
    //MARK: - Outlet creations
    @IBOutlet weak var headerHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: GKGradientView!
    @IBOutlet weak var lblFavourite: UILabel!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var favouriteView: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var lblCall: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var tblDetail: UITableView!
    
    //MARK: - Property declarations
    let headerViewMaxHeight: CGFloat = 275 * K.appCONSTANT.kScreenSizeRatioWidth
    let headerViewMinHeight: CGFloat = 175 * K.appCONSTANT.kScreenSizeRatioWidth
    var contactListObject : GKContactList?
    var contactDetailObject:GKContactDetail?
    let arrTitles = ["phone","email"]
    var arrValues : Array<String> = []
    
    //MARK: - View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        lblContact.text = contactListObject!.firstName! + "" + contactListObject!.lastName!
        imgContact.kf.setImage(with: URL(string: K.appUrl.mainurl + contactListObject!.profilePic!))
        imgContact.layer.cornerRadius = imgContact.frame.width/2
        btnFavourite.isSelected = contactListObject!.favorite!
        tblDetail.estimatedRowHeight = 100
        tblDetail.rowHeight = UITableView.automaticDimension
        tblDetail.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fetching contact detail
        getContactDetail()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        lblContact.font = GKUtility.setFontScreenSize(elementFontSize:
            ((20 / 275) * headerHeight.constant),elementFontName:nil)
        imgContact.layer.cornerRadius = imgContact.frame.width/2
        imgContact.layer.borderWidth = 3.0
        imgContact.layer.borderColor = UIColor.init(named: "WhiteDarkModeColor")!.cgColor
    }
    //MARK: - Api Methods
    func getContactDetail()  {
        GKContactManager.sharedInstance.requestContactDetail(contactId: "\(contactListObject!.id!)") { (gkContactDetailModel, error) in
            if error == nil
            {
                self.parseResponse(gkContactDetailModel: gkContactDetailModel, error: error)
            }
        }
    }
    func makeFavourite(){
        contactDetailObject?.favorite = !contactDetailObject!.favorite!
        btnFavourite.isSelected = (contactDetailObject?.favorite)!
        let parameters: [String:Any] = ["favorite" : (contactDetailObject?.favorite == true) ? 1 : 0,"id":"\(contactDetailObject!.id!)"] as [String : Any]
        GKUtility.updateContactDetail(parameters: parameters) { (gkContactDetailModel, error) in
            
            self.parseResponse(gkContactDetailModel: gkContactDetailModel, error: error)
        }
    }
    
    //MARK: - Private Methods

    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            // add error message here
        }
    }
    
    func sendMessage(recipientsNumber : String){
        if (MFMessageComposeViewController.canSendText()) {
            let messageVC = MFMessageComposeViewController()
            messageVC.body = "Enter a message details here";
            messageVC.recipients = [recipientsNumber]
            messageVC.messageComposeDelegate = self
            self.present(messageVC, animated: true, completion: nil)
        }
    }
    func openMailForRecipient(_ email: String) -> Void {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true, completion: nil)
        } else {
            print("Cannot send mail")
            // give feedback to the user
        }
    }
    func parseResponse(gkContactDetailModel:GKContactDetail?,error : Error?){
        if error == nil
        {
            
            self.contactDetailObject=gkContactDetailModel
            self.arrValues = [self.contactDetailObject?.phoneNumber == nil ? "" : self.contactDetailObject?.phoneNumber,self.contactDetailObject?.email == nil ? "" : self.contactDetailObject?.email] as! Array<String>
            DispatchQueue.main.async {
                self.lblContact.text = self.contactDetailObject!.firstName! + " " + self.contactDetailObject!.lastName!
                self.tblDetail.reloadData()
                self.tblDetail.isHidden = false
            }
        }
        else{
            DispatchQueue.main.async {
                self.tblDetail.isHidden = true
            }
        }
    }
    func gotoAddEditPage(){
        let addEditVC : GKContactAddEditViewController = GKUtility.goToViewController(currentVC: self, currentStoryBoard: self.storyboard!, currentNav: self.navigationController!, storyBoardId: K.StoryBoardId.CONTACT_ADD_EDIT_ID, animated: false) as! GKContactAddEditViewController
        addEditVC.contactDetailObject = contactDetailObject
    }
    
    //MARK: - IBActions

    @IBAction func makeContactFavourite(_ sender: Any) {
        makeFavourite()
    }
    
    @IBAction func callAction(_ sender: Any) {
        dialNumber(number: (contactDetailObject?.phoneNumber?.trim())!)
    }
    @IBAction func emailAction(_ sender: Any) {
        openMailForRecipient((contactDetailObject?.email?.trim())!)
    }
    
    @IBAction func messageAction(_ sender: Any) {
        sendMessage(recipientsNumber: (contactDetailObject?.phoneNumber?.trim())!)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editAction(_ sender: Any) {
        gotoAddEditPage()
    }
}
extension GKContactDetailViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if contactDetailObject != nil {
            return arrTitles.count + 1
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : GKContactDetailTableViewCell?
        
        if indexPath.row == arrTitles.count{
            cell = (tableView.dequeueReusableCell(withIdentifier: "GKContactDeleteTableViewCell", for: indexPath) as! GKContactDetailTableViewCell)
        }
        else{
            cell = (tableView.dequeueReusableCell(withIdentifier: "GKContactDetailTableViewCell", for: indexPath) as! GKContactDetailTableViewCell)
            cell!.lblHeading.text = arrTitles[indexPath.row]
            cell!.lblValue.text = arrValues[indexPath.row]
        }
       
        return cell!
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == arrTitles.count{
            let alert = UIAlertController(title: K.appName.APP_NAME, message: K.GK_Message_Local.deleteConfirm, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (action) in
                GKContactManager.sharedInstance.requestContactDetail(contactId: "\(self.contactListObject!.id!)",isDelete: true) { (gkContactDetailModel, error) in
                    if error == nil
                    {
                        Show(K.GK_Message_Local.deleteSuccess, view: self)
                        self.navigationController?.popViewController(animated: true)
                    }
                    else{
                        //This code is implemented just to update the UI since the response is not returning in valid json format.
                        DispatchQueue.main.async{
                            Show(K.GK_Message_Local.deleteSuccess, view: self)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action) in
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension GKContactDetailViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:
            print("Cancelled")
        case MFMailComposeResult.saved.rawValue:
            print("Saved")
        case MFMailComposeResult.sent.rawValue:
            print("Sent")
        case MFMailComposeResult.failed.rawValue:
            print("Error: \(String(describing:error?.localizedDescription))")
        default:
            break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

extension GKContactDetailViewController: MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

}
// MARK: - UIScrollViewDelegate
extension GKContactDetailViewController: UIScrollViewDelegate {
    
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
