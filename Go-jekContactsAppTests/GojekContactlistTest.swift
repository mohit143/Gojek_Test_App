//
//  GojekContactTest.swift
//  Go-jekContactsAppTests
//
//  Created by Mohit Mathur on 30/11/19.
//  Copyright © 2019 Mohit Mathur. All rights reserved.
//

import XCTest
@testable import Go_jekContactsApp

class GojekContactTest: XCTestCase {
    var listViewController : GKContactListViewController!
    var detailViewController : GKContactDetailViewController!
    var contactDetailObject:GKContactDetail?
    var contactListObject : GKContactList?
    
    override func setUp() {
        listViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GKContactListViewController") as! GKContactListViewController)
        detailViewController = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GKContactDetailViewController") as! GKContactDetailViewController)
        contactDetailObject = GKContactDetail(id: 14077, firstName: "ankit", lastName: "kapoor", email: "anki.kapoor@gmail.com", phoneNumber: "9999999999", profilePic: "/images/missing.png", favorite: false, createdAt: "2019-11-24T19:06:37.089", updatedAt: "2019-11-27T04:33:11.569Z")
        contactListObject = GKContactList(id: 14077, firstName: "ankit", lastName: "kapoor", profilePic: "/images/missing.png", favorite: true, url: "http://gojek-contacts-app.herokuapp.com/contacts/14077.json")
        detailViewController.contactListObject = contactListObject
        detailViewController.contactDetailObject = contactDetailObject
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testAddButtonItemsAreSet() {
        let _ = listViewController.view
        
        let rightAddButton = listViewController.btnAdd
        
        XCTAssertNotNil(rightAddButton, "Should not be nil")
        XCTAssertTrue((rightAddButton?.actions(forTarget: listViewController, forControlEvent: .touchUpInside)?.contains("addNewContact:"))!)
    }
    func testMakeFavouriteItemAreSet() {
        let _ = detailViewController.view
        
        let favAddButton = detailViewController.btnFavourite
        
        XCTAssertNotNil(favAddButton, "Should not be nil")
        XCTAssertTrue((favAddButton?.actions(forTarget: detailViewController, forControlEvent: .touchUpInside)?.contains("makeContactFavourite:"))!)
    }
}

