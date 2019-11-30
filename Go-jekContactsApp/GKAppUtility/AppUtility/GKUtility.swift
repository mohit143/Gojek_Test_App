//
//  GKUtility.swift
//  FirstMateServices
//

import UIKit
import Reachability
import UserNotifications


class GKUtility: NSObject
{
    
    class func checkInternetConneciton()
    {
        let reachability = Reachability()!
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
        
    }
    class func getInternetStatus() -> Bool{
        let reachability = Reachability()
        if (reachability?.connection == .none || (reachability?.connection.description)! == "No Connection")
        {
            RemoveHUD()
            Show("The Internet connection appears to be offline.", view: appDelegate.window?.rootViewController)
            return false
        }
        return true
    }
    //Dynamically change font size according to screen size
    
    class func setFontScreenSize(elementFontSize: CGFloat ,elementFontName:String?) -> UIFont   {
        let fontSize = elementFontSize * K.appCONSTANT.kScreenSizeRatioWidth
        let titleFont : UIFont = elementFontName == nil ? UIFont.systemFont(ofSize: fontSize) : UIFont(name: elementFontName!, size: fontSize)!
        return titleFont
    }
    
    //Go to a specific view controller
    class func goToViewController(currentVC:UIViewController,currentStoryBoard: UIStoryboard,currentNav:UINavigationController,storyBoardId:String,animated:Bool?=true) ->UIViewController{
        let destinationVC = currentStoryBoard.instantiateViewController(withIdentifier: storyBoardId)
        currentNav.pushViewController(destinationVC, animated: animated!)
        return destinationVC
    }
    
    //Creating action sheet for choosing photo or clicking photo
    class func showPhotoOptions(currController:UIViewController,imagePicker:UIImagePickerController){
        let photoActionSheet = UIAlertController(title: "Please Select an Option", message: "", preferredStyle: .actionSheet)
        photoActionSheet.navigationController?.navigationBar.isTranslucent = false
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        photoActionSheet.addAction(cancelAction)
        
        //Create and add first option action
        let takePictureAction: UIAlertAction = UIAlertAction(title: "Take photo", style: .default)
        { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                
                imagePicker.delegate = currController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = true
                imagePicker.navigationBar.isTranslucent = false
                //                self.imagePicker.navigationBar.barTintColor = KStudi.appColor.blueLightTheam
                imagePicker.navigationBar.tintColor = UIColor.blue
                currController.present(imagePicker, animated: true, completion: nil)
                
            }else{
                print("Camera not awailable")
            }
        }
        photoActionSheet.addAction(takePictureAction)
        
        //Create and add a second option action
        let choosePictureAction: UIAlertAction = UIAlertAction(title: "Choose from Gallery", style: .default)
        { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                
                imagePicker.delegate = currController as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                imagePicker.navigationBar.isTranslucent = false
                //                self.imagePicker.navigationBar.barTintColor = KStudi.appColor.blueLightTheam
                imagePicker.navigationBar.tintColor = UIColor.blue
                currController.present(imagePicker, animated: true, completion: nil)
            }
        }
        photoActionSheet.addAction(choosePictureAction)
        
        //Present the AlertController
        currController.present(photoActionSheet, animated: true, completion: nil)
    }
    
    //Updating desired contact detail
    class func updateContactDetail(parameters : [String: Any],imageData : Data? = nil,completion: @escaping (GKContactDetail?, Error?) -> ())  {
        GKContactManager.sharedInstance.saveContactDetail(params: parameters,imageData: imageData) { (gkContactDetailModel, error) in
            if error == nil
            {
                completion(gkContactDetailModel,error)
            }
        }
    }
     // MARK: - convert Json
        
    class func jsonConevert(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters:allowed as CharacterSet)
    }
}
extension UIColor {
    
    // custom color methods
    class func colorWithHex(rgbValue: UInt32,reqAlpha : CGFloat) -> UIColor {
        ////        return UIColor( red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        //                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        ////                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        //                      alpha: CGFloat(1.0))
        let mask = 0x000000FF
        let r = Int(rgbValue >> 16) & mask
        let g = Int(rgbValue >> 8) & mask
        let b = Int(rgbValue) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        return UIColor.init(red:red, green:green, blue:blue, alpha:reqAlpha)
    }
    
    class func colorWithHexString(hexStr: String,reqAlpha : CGFloat? = 1.0) -> UIColor {
        var cString:String = hexStr.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexStr.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.isEmpty || (cString.count) != 6) {
            return colorWithHex(rgbValue: 0xFF5300,reqAlpha: reqAlpha!);
        } else {
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            return colorWithHex(rgbValue: rgbValue,reqAlpha: reqAlpha!);
        }
    }
}
extension UIImage {
    func compressTo(_ expectedSizeBytes:Double) -> Data? {
        let sizeInBytes = expectedSizeBytes
        var needCompress:Bool = true
        var imgData:Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < Int(sizeInBytes) {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < Int(sizeInBytes)) {
                return data
            }
        }
        return nil
    }
}
