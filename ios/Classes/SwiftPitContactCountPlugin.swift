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
        if call.method.elementsEqual("getContactCount"){
            let count = getContactCount()
            result(count)
        }
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
}
