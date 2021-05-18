//
//  UserInfoOBJ.swift
//  Climcity
//
//  Created by Mervin Flores on 5/17/21.
//

import Foundation
import RealmSwift

struct UserInfo {
    var birthDay: Date?
    var name: String?
    var email: String?
}

final class UserInfoObject: Object {

    @objc dynamic var name = ""
    @objc dynamic var email = ""
    @objc dynamic var birthDay: NSDate?

    override static func primaryKey() -> String? {
        return "name"
    }
}


extension UserInfo: Persistable {

    public init(managedObject: UserInfoObject) {
        self.name = managedObject.name
        self.email = managedObject.email
        self.birthDay = managedObject.birthDay as Date?
    }


    public func managedObject() ->  UserInfoObject {

        let userObj = UserInfoObject()

        userObj.name = self.name ?? ""
        userObj.email = self.email ?? ""
        userObj.birthDay = self.birthDay as NSDate?

        return userObj
    }
}

extension UserInfo {

    public enum Query: QueryType {

        case name(String)

        public var predicate: NSPredicate? {
            switch
                self {
            case .name(let value):
                return NSPredicate(format: "name == %@", value)
            }

        }

        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(keyPath: "name")]
        }
    }

    public enum PropertyValue: PropertyValueType {

        case name(String)

        public var propertyValuePair: PropertyValuePair {8
            switch self {
            case .name(let name):
                return ("name", name)
            }
        }
    }
}

