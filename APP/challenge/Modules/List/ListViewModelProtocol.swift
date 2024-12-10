//
//  ListProtocols.swift
//  challenge
//
//  Created by Wagner Sales
//

import Foundation

protocol ListViewModelProtocol {
    var state: ListState { get }
    var didChangeState: ((ListState) -> Void)? { get set }

    func numberOfRows() -> Int
    func row(at index: Int) -> ListRow?
    func didTapReload()
    func pullToRefresh()
    func viewDidLoad()
}
