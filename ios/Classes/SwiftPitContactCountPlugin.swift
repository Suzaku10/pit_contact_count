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
        if(call.method.elementsEqual("getContactCount")){
            result(getContactCount())
            
        } else if(call.method.elementsEqual("getContactStringJson")){
            var contact: [[String: Any]]
            let jsonString: String
            guard let args = call.arguments as? [String: String] else {
             return result("")
            }
            let param: String = args["param"] ?? "CONTACT_ONLY"
            switch param {
                case "CONTACT_ONLY":
                    contact = getContactOnly()
                case "ALL_DATA":
                    contact = getListAllContactInfo()
                case "CONTACT_EMAIL_ADDRESS":
                    contact = getListContactAndEmailAddress()
                default:
                    contact = getContactOnly()
            }
            jsonString = getContactStringJson(contact: contact)
            result(jsonString)
        } else if(call.method.elementsEqual("getListContactOnly")){
            result(getContactOnly())
            
        } else if(call.method.elementsEqual("getListAddressEmail")) {
            
            result(getListContactAndEmailAddress())
        } else if(call.method.elementsEqual("getListAllContact")){
            
            result(getListAllContactInfo())
        } else {
            result(FlutterMethodNotImplemented)
        }
       
    }
    
    @available(iOS 9.0, *)
    public func getEmailAddress(contact:CNContact) ->[String]{
        var results: [String] = []
        for email in contact.emailAddresses{
            let res = "\(email.value)"
            results.append(res)
        }
        return results
    }
    
    @available(iOS 9.0, *)
    public func getAddress(contact:CNContact) ->[[String: Any]]{
        var results: [[String: Any]] = []
        for address in contact.postalAddresses{
            var res: [String: Any] = [:]
            res["data4"] = "\(address.value.street)"
            res["data7"] = "\(address.value.city)"
            res["data9"] = "\(address.value.postalCode)"
            res["data10"] = "\(address.value.country)"
            results.append(res)
        }
        return results
    }
    
    @available(iOS 9.0, *)
    public func getOrganization(contact: CNContact) ->[String: Any]{
        var results: [String: Any] = [:]
        results["data1"] = "\(contact.organizationName)"
        results["data4"] = "\(contact.jobTitle)"
        
        return results
    }
    
    @available(iOS 9.0, *)
    public func getContactRelation(contact: CNContact) ->[[String: Any]] {
        var results: [[String: Any]] = []
        for item in contact.contactRelations {
            var res: [String: Any] = [:]
            res["data1"] = "\(item.value.name)"
            results.append(res)
        }
       return results
    }
    
    public func getListAllContactInfo() -> [[String: Any]] {
        var results: [[String: Any]] = []
            if #available(iOS 9.0, *) {
                    let contactStore = CNContactStore()
                    do {
                        try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPostalAddressesKey as CNKeyDescriptor, CNContactOrganizationNameKey as CNKeyDescriptor, CNContactJobTitleKey as CNKeyDescriptor, CNContactRelationsKey as CNKeyDescriptor])) {
                            (contact, cursor) -> Void in
                            var res: [String: Any] = [:]
                            res["contact_id"] = contact.identifier
                            res["display_name"] = "\(contact.givenName) \(contact.familyName)"
                            res["relation"] = self.getContactRelation(contact: contact)
                            res["organization"] = self.getOrganization(contact: contact)
                            res["email"] = self.getEmailAddress(contact: contact)
                            res["address"] = self.getAddress(contact: contact)
                            res["data1"] = contact.phoneNumbers.isEmpty ? "-" :contact.phoneNumbers[0].value.value(forKey: "digits") as! String
                            results.append(res)
                        }
                    }
                    catch {
                        print("Handle the error please")
                    }
                }
        return results
    }
    
    public func getListContactAndEmailAddress() -> [[String: Any]]{
        var results: [[String: Any]] = []
               if #available(iOS 9.0, *) {
                   let contactStore = CNContactStore()
                   do {
                       try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor, CNContactPostalAddressesKey as CNKeyDescriptor])) {
                           (contact, cursor) -> Void in
                           var res: [String: Any] = [:]
                           res["contact_id"] = contact.identifier
                           res["display_name"] = "\(contact.givenName) \(contact.familyName)"
                           res["email"] = self.getEmailAddress(contact: contact)
                           res["address"] = self.getAddress(contact: contact)
                           res["data1"] = contact.phoneNumbers.isEmpty ? "-" :contact.phoneNumbers[0].value.value(forKey: "digits") as! String
                           results.append(res)
                       }
                   }
                   catch{
                       print("Handle the error please")
                   }
               }
               return results
    }
    
    public func getContactStringJson(contact: [[String: Any]]) -> String{
        var stringJson: String = ""
        do {
           let jsonData = try JSONSerialization.data(withJSONObject: contact, options: [])
           stringJson =  String(data: jsonData, encoding: .utf8)!
        
        } catch {
            print(error.localizedDescription)
      
        }
        
        return stringJson
        
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
    

    public func getContactOnly() -> [[String: Any]] {
        var results: [[String: Any]] = []
        if #available(iOS 9.0, *) {
            let contactStore = CNContactStore()
            do {
                try contactStore.enumerateContacts(with: CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor])) {
                    (contact, cursor) -> Void in
                    var res: [String: Any] = [:]
                    res["contact_id"] = contact.identifier
                    res["display_name"] = "\(contact.givenName) \(contact.familyName)"
                    res["data1"] = contact.phoneNumbers.isEmpty ? "-" :contact.phoneNumbers[0].value.value(forKey: "digits") as! String
                    results.append(res)
                }
            }
            catch{
                print("Handle the error please")
            }
        }
        return results
    }
}
