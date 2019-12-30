//
//  SignUpViewModel.swift
//  SwiftUI-Combine-Validation
//
//  Created by Mikiya Abe on 2019/12/29.
//  Copyright © 2019 Mikiya Abe. All rights reserved.
//

import Combine
import SwiftUI

final class SignUpViewModel: ObservableObject {
    
    enum Status {
        case OK
        case NG
        
        var content: String {
            switch self {
            case .OK: return "OK"
            case .NG: return "NG"
            }
        }
        var color: Color {
            switch self {
            case .OK: return .green
            case .NG: return .red
            }
        }
    }
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var status: Status = Status.NG
    
    private var cancellables = [AnyCancellable]()
    private var validatedUsername: AnyPublisher<String?, Never> {
        return $username
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (username) -> AnyPublisher<String?, Never> in
                Future<String?, Never> { (promise) in
                    if 1...10 ~= username.count {
                        promise(.success(username))
                    } else {
                        promise(.success(nil))
                    }
                }
                .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
    private(set) lazy var onAppear: () -> Void = { [weak self] in
        guard let self = self else { return }
        
        self.validatedUsername
            .sink(receiveValue: { [weak self] (value) in
                if let value = value {
                    self?.username = value
                } else {
                    print("validatedUsername.receiveValue: Invalid username")
                }
            })
            .store(in: &self.cancellables)
        
        self.validatedUsername
            .map { (value) -> Status in
                if let _ = value {
                    return Status.OK
                } else {
                    return Status.NG
                }}
            .sink(receiveValue: { [weak self] (status) in
                self?.status = status
            })
            .store(in: &self.cancellables)
    }
    private(set) lazy var onDisappear: () -> Void = { [weak self] in
        guard let self = self else { return }
        self.cancellables.forEach { $0.cancel() }
        self.cancellables = []
    }
}
