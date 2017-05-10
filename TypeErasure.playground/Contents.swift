//: Playground - noun: a place where people can play

import UIKit

/* http://swiftrien.blogspot.com/2015/05/swift-enum-compare-design-pattern.html?m=1 */

func == (left: ValidationResult, right: ValidationResult) -> Bool {
    
    switch left {
    case .valid:
        switch right {
        case .valid: return true
        default: return false
        }
        
    case let .invalid(str1):
        
        switch right {
        case let .invalid(str2) : return (str1 == str2)
        default: return false
        }
    }
}

enum ValidationResult {
    case valid
    case invalid(errorMessage: String)
}

protocol UIFieldType {
    associatedtype DataType
    
    var value: DataType? { get set }
    func validate() -> ValidationResult
}


//MARK: Text Field
class TextField: UIView {
    var value: String?
    typealias DataType = String
}

extension TextField: UIFieldType {
    
    //Add your validation logic
    func validate() -> ValidationResult {
        return .valid
    }
}

//MARK: Date Picker
class DatePicker: UIDatePicker {
    var value: Date?
    typealias DataType = Date
}

extension DatePicker: UIFieldType {
    
    //Add your validation logic
    func validate() -> ValidationResult {
        return .valid
    }
}


let firstName = TextField()
let lastName = TextField()
let date = DatePicker()

//let fields: [UIFieldType] = [firstName, lastName, date]

struct AnyField {
    
    private let _validate: () -> ValidationResult
    
    init<Field: UIFieldType>(_ field: Field) {
        self._validate = field.validate
    }
    
    func validate() -> ValidationResult {
        return _validate()
    }
}

let fields: [AnyField] = [AnyField(firstName), AnyField(lastName), AnyField(date)]
let allValid = fields.reduce(true, { ($1.validate() == .valid) && $0 })

if allValid {
    print("All fields are valid")
}


protocol Mario {
    associatedtype ActionType
    func attack(action: ActionType)
}

class Swim {}
class Fly {}

struct Toad: Mario {
    typealias ActionType = Swim
    
    func attack(action: Swim) {
        print("i can swim")
    }
}

struct Birdo: Mario {
    typealias ActionType = Fly
    
    func attack(action: Fly) {
        print("i can fly")
    }
}

class AnyMario<ActionType>: Mario {
    private let _attack: (ActionType) -> Void
    
    init <M: Mario>(mario: M) where M.ActionType == ActionType {
        _attack = mario.attack
    }
    
    func attack(action: ActionType) {
        return _attack(action)
    }
}

let swim = Swim()
let fly = Fly()

let m1: AnyMario<Swim> = AnyMario(mario: Toad())
m1.attack(action: swim)

let m2: AnyMario<Fly> = AnyMario(mario: Birdo())
m2.attack(action: fly)

