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
        view.backgroundColor = Colors.background
        setupNavigationController()
        setupActivityIndicator()
        setupFeedBackView()
    }

    func setupNavigationController() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = Colors.surface
        appearance.titleTextAttributes = [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .foregroundColor: Colors.onSurface
        ]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = Colors.onBackground

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
        let button = UIButton(type: .custom)
        let image = UIImage(resource: .icChevronLeft).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = Colors.onSurface
        button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }

    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
