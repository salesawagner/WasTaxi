//
//  WASTableViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit

class WASViewController: UIViewController {
    // MARK: Properties

    let activityIndicator = UIActivityIndicatorView(style: .large)
    let feedbackView = WASFeedbackView()

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Setups

    func setupUI() {
        view.backgroundColor = .white
        setupNavigationController()
        setupActivityIndicator()
        setupFeedBackView()
    }

    func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 240/255, green: 244/255, blue: 248/255, alpha: 1)
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .footnote)
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .darkText

        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    func setupFeedBackView() {
        feedbackView.isHidden = true
        feedbackView.fill(on: view)
    }

    func showLoading(_ isLoading: Bool) {
        activityIndicator.isHidden = !isLoading

        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showFeedbackView(_ isShowing: Bool) {
        feedbackView.isHidden = !isShowing
    }

    func addBackButton() {
        let backButton = UIButton(type: .custom)
        let backImage = UIImage(named: "ic_chevron-left")
        backButton.setImage(backImage, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
