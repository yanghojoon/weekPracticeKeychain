//
//  KeychainError.swift
//  WeekPracticeKeychain
//
//  Created by 양호준 on 2022/01/22.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}
