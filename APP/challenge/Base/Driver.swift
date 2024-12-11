//
//  Driver.swift
//  challenge
//
//  Created by Wagner Sales
//

struct Driver {
    let id: Int
    let name: String
    let minimumDistance: Double
}

extension Driver {
    static var drivers: [Driver] {
        [
            .init(id: 1, name: "James Bond", minimumDistance: 1),
            .init(id: 2, name: "Homer Simpson", minimumDistance: 5),
            .init(id: 3, name: "Dominic Toretto", minimumDistance: 10)
        ]
    }
}
