import UIKit
import XCTest
import CloudContactSDK

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testCCContact() {
        let contact = CCContact(name: "nome", telephone: "12345", user: 1)
        XCTAssertEqual("nome", contact.name)
        XCTAssertEqual("12345", contact.telephone)
        XCTAssertEqual(1, contact.user)
    }
}
