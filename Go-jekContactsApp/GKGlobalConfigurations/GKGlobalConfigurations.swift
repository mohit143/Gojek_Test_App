//
//  GKGlobalConfigurations.swift
//  Go-jekContactsApp


import Foundation
import UIKit
import MBProgressHUD
let appDelegate = UIApplication.shared.delegate as! AppDelegate

var ACCESS_TOKEN = ""
var ROLE_ID = 0
var ROLE_ACTIVE = 0
var companyCreateRequestFrom = "singup"
var PushDataGlobal = [String:Any]()
var branchInviteLink = false
var addRolePopupFromBranch = false
var showCompanyPopupFromLogin = false
var isSaveTapped = false
var badgeCount = 0

struct K
{
    struct appCONSTANT    {
        static let APP_STORE_ID = 1477996968
        static let kScreenSizeRatioForFontSize = UIScreen.main.bounds.size.height/812.0
        static let kScreenSizeRatioWidth = UIScreen.main.bounds.size.width/375
        static let screenWidth = UIScreen.main.bounds.size.width
        static let screenHeight = UIScreen.main.bounds.size.height
        static let KEY_DEVICE_TOKEN = "deviceToken"
        static let KEY_ACCESS_TOKEN = "accessToken"
        static let KEY_ROLE_ID = "roleId"
        static let KEY_MY_COMPANY_ID = "companyId"
        static let KEY_IS_BOAT  = "isBoat"
        static let KEY_IS_SKIPPED  = "isSkipped"
        static let KEY_USER_TYPE = "userType"
        static let KEY_ROLE_UNACTIVE = "unactiveRole"
        static let KEY_IS_RESET = "isReset"
        static let KEY_USERID = "userID"
        static let KEY_BM_DESC = "bmDesc"
        static let kSectionHeaderReuseIdentifier = "MyContactsListHeaderIdentifier"

        //Test
//        static let KEY_STRIPE = "pk_test_bPDcuVjsJ6RjrWjn0zj8RUSX"
        
        //Live
        static let KEY_STRIPE = "pk_live_MpExsBFTN9sBG4v0TgJgceRU"
        static var versioningDone = false
        static var isVersionApiRunning = false
        static let zipCodeLengthValidate = 5
        static let googlePlaceAutocompleteApi = "https://maps.googleapis.com/maps/api/place/autocomplete/json?"
        static let googleKey = "AIzaSyCQyKTwiG9AtrX-LezD1RtBQShz5cXHF_U"
        static let googlePlaceDetailAPI = "https://maps.googleapis.com/maps/api/place/details/json?"
        static let googlePlaceGeocodingAPI = "https://maps.googleapis.com/maps/api/geocode/json?"
        static let phoneFormat = "(XXX) XXX-XXXX"
    }
    struct appName
    {
        static let APP_NAME = "GOJEK"
        
    }
    
    struct appUrl
    {
        static let mainurl = "http://gojek-contacts-app.herokuapp.com" // NEW LIVE URL
        static let webPagesBaseurl = "http://dynamicwebsite.co.in/gk/fms/" // NEW LIVE URL
        static let contactListUrl                  = "\(mainurl)/contacts.json"
        static let contactDetailUrl                  = "\(mainurl)/contacts/cid.json"
    }
    
    struct StoryBoardNames
    {
       static let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
       
    }
    struct StoryBoardId
    {
        static let CONTACT_LIST_ID                   = "GKContactListViewController"
        static let CONTACT_DETAIL_ID                  = "GKContactDetailViewController"
        static let CONTACT_ADD_EDIT_ID                  = "GKContactAddEditViewController"
    }
    struct GK_Placeholders
    {
        static let PlaceHolder_Firstname = "First name*"
        static let PlaceHolder_Lastname = "Last name*"
        static let PlaceHolder_Mobile = "phone"
        static let PlaceHolder_Email = "email"
    }
    
    struct GK_ColorTheme
    {
        static let inputHeadingBlack        = "#4a4a4a"
        static let headerGrey        = "#e8e8e8"
    }
    struct GK_Message_Local
    {
        static let allFieldsEmpty       = "Please fill atleast one field to save the contact"
        static let invalidEmail       = "Please enter valid email address"
        static let deleteConfirm       = "Are you sure you want to delete this contact?"
        static let deleteSuccess       = "Contact deleted successfully"
    }
}
    extension UIDevice
    {
        var iPhone: Bool {
            return UIDevice().userInterfaceIdiom == .phone
        }
        enum ScreenType: String {
            case iPhone4
            case iPhone5
            case iPhone6
            case iPhone6Plus
            case iPhoneX
            case unknown
        }
        var screenType: ScreenType {
            guard iPhone else { return .unknown }
            switch UIScreen.main.nativeBounds.height {
            case 960:
                return .iPhone4
            case 1136:
                return .iPhone5
            case 1334:
                return .iPhone6
            case 2208:
                return .iPhone6Plus
            case 2436:
                return .iPhoneX
            default:
                return .unknown
            }
        }
    }
    
    extension UIApplication {
        class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
            if let nav = base as? UINavigationController {
                return topViewController(base: nav.visibleViewController)
            }
            if let tab = base as? UITabBarController {
                if let selected = tab.selectedViewController {
                    return topViewController(base: selected)
                }
            }
            if let presented = base?.presentedViewController {
                return topViewController(base: presented)
            }
            return base
        }
    }
public func Show(_ message: String,view:UIViewController!,title:String? = nil,isResend : Bool? = false,email:String? = nil)
    {
        let alert = UIAlertController(title: K.appName.APP_NAME, message: message, preferredStyle: .alert)
        view.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
//            GKUtility.showAlertXib(title: title, des: message, btnOkAction: nil, btnOtherAction: nil, isMaintainance: false, isVertical: false, btnOkTitle: nil, btnOtherTitle: "", emptyLinkDetails: false,isResend: isResend,email: email)
        }

     
    }
    public func ShowWindow(_ message: String)
    {
        let alert = UIAlertController(title: K.appName.APP_NAME, message: message, preferredStyle: .alert)
        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default, handler: nil))
    
    }
public func ShowHUD(loadingText:String? = "Loading")
    {
        DispatchQueue.main.async {
            MBProgressHUD.showAdded(to: (appDelegate.window)!, animated: false).label.text = NSLocalizedString(loadingText!, comment: "")
        }
    }
    
    public func RemoveHUD()
    {
        DispatchQueue.main.async {
            MBProgressHUD.hideAllHUDs(for: (appDelegate.window)!, animated: true)
        }
        
    }


