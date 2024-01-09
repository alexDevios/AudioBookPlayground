//
//  BoundariesAction.swift
//  BookAudio
//
//  Created by alexdevios on 09.01.2024.
//

import ComposableArchitecture

public protocol BoundariesAction: Equatable {
    associatedtype ViewAction
    associatedtype DelegateAction
    associatedtype InternalAction

    static func view(_: ViewAction) -> Self
    static func delegate(_: DelegateAction) -> Self
    static func `internal`(_: InternalAction) -> Self
 }
