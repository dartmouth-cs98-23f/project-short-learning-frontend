//
//  Loadable.swift
//  Discite
//
//  Created by Jessie Li on 3/18/24.
//
//  Based on:
//      Alexey Naumov
//      Loadable.swift, CountriesSwiftUI
//      23.10.2019
//      https://github.com/nalexn/clean-architecture-swiftui/blob/master/CountriesSwiftUI/Utilities/Loadable.swift

import Foundation
import SwiftUI

typealias LoadableSubject<Value> = Binding<Loadable<Value>>

enum Loadable<T> {

    case notRequested
    // Using Decodable instead of T for Task for map function
    case isLoading(last: T?)
    case loaded(T)
    case failed(Error)

    var value: T? {
        switch self {
        case let .loaded(value): return value
        case let .isLoading(last): return last
        default: return nil
        }
    }
    var error: Error? {
        switch self {
        case let .failed(error): return error
        default: return nil
        }
    }
}

extension Loadable {
    
    mutating func setIsLoading() {
        print("in setIsLoading")
        self = .isLoading(last: value)
    }
    
    mutating func cancelLoading() {
        switch self {
        case let .isLoading(last):
            if let last = last {
                self = .loaded(last)
            } else {
                let error = NSError(
                    domain: NSCocoaErrorDomain, code: NSUserCancelledError,
                    userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Canceled by user",
                                                                            comment: "")])
                self = .failed(error)
            }
        default: break
        }
    }
    
    func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .notRequested: return .notRequested
            case let .failed(error): return .failed(error)
            case let .isLoading(value):
                return .isLoading(last: try value.map { try transform($0) })
            case let .loaded(value):
                return .loaded(try transform(value))
            }
        } catch {
            return .failed(error)
        }
    }
}

protocol SomeOptional {
    associatedtype Wrapped
    func unwrap() throws -> Wrapped
}

struct ValueIsMissingError: Error {
    var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}

extension Optional: SomeOptional {
    func unwrap() throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw ValueIsMissingError()
        }
    }
}

extension Loadable where T: SomeOptional {
    func unwrap() -> Loadable<T.Wrapped> {
        map { try $0.unwrap() }
    }
}

extension Loadable: Equatable where T: Equatable {
    static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case let (.isLoading(lhsV), .isLoading(rhsV)):
            return lhsV == rhsV
        case let (.loaded(lhsV), .loaded(rhsV)): return lhsV == rhsV
        case let (.failed(lhsE), .failed(rhsE)):
            return lhsE.localizedDescription == rhsE.localizedDescription
        default: return false
        }
    }
}

// MARK: -
// https://github.com/nalexn/clean-architecture-swiftui/blob/mvvm/CountriesSwiftUI/Utilities/Store.swift

extension ObservableObject {
    func loadableSubject<Value>(_ keyPath: WritableKeyPath<Self, Loadable<Value>>) -> LoadableSubject<Value> {
        let defaultValue = self[keyPath: keyPath]
        return .init(get: { [weak self] in
            self?[keyPath: keyPath] ?? defaultValue
        }, set: { [weak self] in
            self?[keyPath: keyPath] = $0
        })
    }
}

extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}