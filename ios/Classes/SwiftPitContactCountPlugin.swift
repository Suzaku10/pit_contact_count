import Flutter
import UIKit
import Contacts

public class SwiftPitContactCountPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "pit_contact_count", binaryMessenger: registrar.messenger())
        let instance = SwiftPitContactCountPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        result(FlutterMethodNotImplemented)
    }
    
    public func getContactCount() -> Int {
        var count: Int?
        if #available(iOS 9.0, *) {
            let contactStore = CNContactStore()
            var results: [CNContact] = []
            do {
                try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                    (contact, cursor) -> Void in
                    results.append(contact)
                    count = results.count
                }
            }
            catch{
                print("Handle the error please")
            }
        }
        return count ?? 0
    }
    
    @available(iOS 9.0, *)
    public func getContactList() -> [[String: Any]] {
        var results: [[String: Any]] = []
        if #available(iOS 9.0, *) {
            var contactStore = CNContactStore()
            do {
                try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                    (contact, cursor) -> Void in
                    var res: [String: Any] = [:]
                    res["displayName"] = "\(contact.givenName) \(contact.familyName)"
                    res["phoneNumber"] = contact.phoneNumbers.isEmpty ? "-" :contact.phoneNumbers[0].value.value(forKey: "digits") as! String
                    results.append(res)
                }
            }
            catch{
                print("Handle the error please")
            }
        }
        return results ?? []
    }
}
