//
//  GKContactListViewController.swift
//  Go-jekContactsApp
//


import UIKit
import Kingfisher

class GKContactListViewController: UIViewController {

    //MARK: - Property declarations

    var contactListObject:[GKContactList]?
    var isAPIRunning: Bool = false
    var totalRecordCount: Int = 0
    var pageCount: Int = 1
    var arrSectionHeader = [String]()
    let dictContacts = NSMutableDictionary()
    var selSorting = "first_name"

    //MARK: - Outlet creations

    @IBOutlet weak var tblContactList: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnGroups: UIButton!
    
    //MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblContactList.estimatedRowHeight = 100
        tblContactList.rowHeight = UITableView.automaticDimension
        tblContactList.tableFooterView = UIView(frame: .zero)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Fetching contact list
        getContactList()
    }
   
    //MARK: - Api Methods
    func getContactList()  {
        GKContactManager.sharedInstance.requestContactList { (gkContactListModel, error) in
            if error == nil
            {
                if gkContactListModel?.count != 0
                {
                    
                    self.contactListObject=gkContactListModel
                    self.createSectionedContactsDictionaryAndSectionHeaders(self.contactListObject!, hideLoading: true)
                }
            }
        }
    }
    
    //MARK: - Private Methods

    func createSectionedContactsDictionaryAndSectionHeaders(_ contacts: [GKContactList] , hideLoading : Bool) -> Void {
        self.dictContacts.removeAllObjects()
        self.arrSectionHeader.removeAll()
        
        for user in contacts {
            var firstLetter = ""
            if user.firstName!.isEmpty {
                if user.lastName!.isEmpty == false {
                    firstLetter = String(user.lastName![user.lastName!.startIndex..<user.lastName!.index(user.lastName!.startIndex, offsetBy: 1)])
                }
                else{
                    firstLetter = ""
                    
                }
            }
            else{
                firstLetter = String(user.firstName![user.firstName!.startIndex..<user.firstName!.index(user.firstName!.startIndex, offsetBy: 1)])
                
            }

            var arrOfContacts = NSMutableArray()
            
            if (self.dictContacts[firstLetter] == nil) {
                self.dictContacts.setObject(arrOfContacts, forKey: firstLetter as NSCopying)
            } else {
                arrOfContacts = self.dictContacts[firstLetter] as! NSMutableArray
            }
            arrOfContacts.add(user)
        }
        
        self.arrSectionHeader = self.dictContacts.allKeys as! [String]
        self.arrSectionHeader.sort { $0 < $1 }
        print(self.dictContacts)
        self.tblContactList.reloadData()
        self.view.layoutIfNeeded()
        if hideLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                RemoveHUD()
            }
            
        }
    }
    
    func gotoDetailPage(selectedObject : GKContactList){
        let detailVC : GKContactDetailViewController = GKUtility.goToViewController(currentVC: self, currentStoryBoard: self.storyboard!, currentNav: self.navigationController!, storyBoardId: K.StoryBoardId.CONTACT_DETAIL_ID, animated: true) as! GKContactDetailViewController
        detailVC.contactListObject = selectedObject
    }
    func gotoAddEditPage(){
        _ = GKUtility.goToViewController(currentVC: self, currentStoryBoard: self.storyboard!, currentNav: self.navigationController!, storyBoardId: K.StoryBoardId.CONTACT_ADD_EDIT_ID, animated: true)
    }
    
    //MARK: - IBActions

    @IBAction func addNewContact(_ sender: Any) {
        gotoAddEditPage()
    }
}
extension GKContactListViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dictContacts.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ((self.dictContacts.object(forKey: self.arrSectionHeader[section]) as AnyObject).count)!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return arrSectionHeader
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return arrSectionHeader.index(of: title)!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.appCONSTANT.kSectionHeaderReuseIdentifier)
        if headerView == nil {
            tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: K.appCONSTANT.kSectionHeaderReuseIdentifier)
            headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.appCONSTANT.kSectionHeaderReuseIdentifier)
        }
        
        var titleLabel = headerView!.contentView.viewWithTag(1) as? UILabel
        
        if titleLabel == nil {
            headerView!.contentView.backgroundColor = UIColor.white
            titleLabel = UILabel(frame: CGRect(x: 15.0, y: 0.0, width: 30.0, height: 28.0))
            titleLabel!.textColor = UIColor.colorWithHexString(hexStr: K.GK_ColorTheme.inputHeadingBlack, reqAlpha: 1.0)
            titleLabel!.backgroundColor = UIColor.colorWithHexString(hexStr: K.GK_ColorTheme.headerGrey, reqAlpha: 1.0)
            titleLabel!.shadowOffset = CGSize(width: 0.0, height: 0.0)
            titleLabel!.tag = 1
            titleLabel!.font = UIFont.systemFont(ofSize: 14.0)
            headerView!.contentView.addSubview(titleLabel!)
        }
        
        let sectionTitle = self.arrSectionHeader[section]
        titleLabel!.text = sectionTitle
        headerView!.contentView.backgroundColor = UIColor.colorWithHexString(hexStr: K.GK_ColorTheme.headerGrey, reqAlpha: 1.0)

        return headerView!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: "GKContactListTableViewCell", for: indexPath) as! GKContactListTableViewCell
        if let arrContactsInSection = self.dictContacts.object(forKey: self.arrSectionHeader[indexPath.section]) as? [GKContactList]
        {
            let contactObj = arrContactsInSection[indexPath.row]
            cell.lblContactName.text = contactObj.firstName! + " " + contactObj.lastName!
            cell.imgContact.kf.setImage(with: URL(string: K.appUrl.mainurl + contactObj.profilePic!))
            cell.imgContact.layer.cornerRadius = cell.imgContact.frame.width/2
            cell.imgFavourite.isHidden = !contactObj.favorite!
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            // Get clicked contact
        if let arrContactsInSection = self.dictContacts.object(forKey: self.arrSectionHeader[indexPath.section]) as? [GKContactList] {
            let contactObj = arrContactsInSection[indexPath.row]
            gotoDetailPage(selectedObject: contactObj)
        }
    }
}
