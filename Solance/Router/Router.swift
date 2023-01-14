//
//  Router.swift
//  Solance
//
//  Created by Alexander Senin on 22.12.2022.
//

import Combine

final class Router<T: Hashable>: ObservableObject {
    
    @Published var root: T
    @Published var paths: [T] = []

    init(root: T) {
        self.root = root
    }

    func push(_ path: T) {
        paths.append(path)
    }

    func pop() {
        paths.removeLast()
    }

    func updateRoot(root: T) {
        self.root = root
    }

    func popToRoot(){
       paths = []
    }
}
