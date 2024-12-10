//
//  Driver.swift
//  challenge
//
//  Created by Wagner Sales
//

struct Driver {
    let id: Int
    let minimumDistance: Double
}

extension Driver {
    static var drivers: [Driver] {
        [
            .init(id: 1, minimumDistance: 1),
            .init(id: 2, minimumDistance: 5),
            .init(id: 3, minimumDistance: 10)
        ]
    }
}
