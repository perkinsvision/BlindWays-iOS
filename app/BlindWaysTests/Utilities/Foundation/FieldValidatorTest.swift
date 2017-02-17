//
//  FieldValidatorTest.swift
//  BlindWaysTests
//
//  Created by Nicholas Bonatsakis on 5/25/16.
//  Copyright© 2016 Perkins School for the Blind
//
//  All "Perkins Bus Stop App" Software is licensed under Apache Version 2.0.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import XCTest
@testable import BlindWays
import Nimble

class FieldValidatorTest: XCTestCase {

    func testNonEmpty() {
        let validator = FieldValidator(fieldName: "email", rules: [
            ValidationRule.nonEmpty,
            ])

        expect(validator.validate("something")).to(beNil())

        let error = validator.validate("") as! NSError
        expect(error).notTo(beNil())
        expect(error.domain).to(equal("org.perkins.FieldValidationError"))
        expect(error.code).to(equal(ValidationRule.Code.nonEmpty.rawValue))
        expect(error.localizedDescription).to(equal("Email is required"))
        expect(error.localizedRecoverySuggestion).to(equal("Please enter a valid email."))
    }

    func testMinLength() {
        let validator = FieldValidator(fieldName: "email", rules: [
            ValidationRule.minLength(length: 2),
            ])

        expect(validator.validate("ABC")).to(beNil())

        let error = validator.validate("A") as! NSError
        expect(error).notTo(beNil())
        expect(error.domain).to(equal("org.perkins.FieldValidationError"))
        expect(error.code).to(equal(ValidationRule.Code.minLength.rawValue))
        expect(error.localizedDescription).to(equal("Email is too short"))
        expect(error.localizedRecoverySuggestion).to(equal("Email must be at least 2 characters in length."))
    }

    func testValidEmail() {
        let validator = FieldValidator(fieldName: "email", rules: [
            ValidationRule.validEmail,
            ])

        expect(validator.validate("test@perkins.org")).to(beNil())
        expect(validator.validate("test+foo@perkins.org")).to(beNil())

        let error = validator.validate("A") as! NSError
        expect(error).notTo(beNil())
        expect(error.domain).to(equal("org.perkins.FieldValidationError"))
        expect(error.code).to(equal(ValidationRule.Code.validEmail.rawValue))
        expect(error.localizedDescription).to(equal("Email is not valid"))
        expect(error.localizedRecoverySuggestion).to(equal("Please enter a valid email."))
        expect(validator.validate("test!!$%@test.com")).notTo(beNil())
    }

    func testMulti() {
        let validator = FieldValidator(fieldName: "email", rules: [
            ValidationRule.nonEmpty,
            ValidationRule.validEmail,
            ])

        expect(validator.validate("test@perkins.org")).to(beNil())

        var error = validator.validate("") as! NSError
        expect(error).notTo(beNil())
        expect(error.code).to(equal(ValidationRule.Code.nonEmpty.rawValue))

        error = validator.validate("foo") as! NSError
        expect(error).notTo(beNil())
        expect(error.code).to(equal(ValidationRule.Code.validEmail.rawValue))
    }

}
