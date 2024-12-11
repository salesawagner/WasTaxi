//
//  ConfirmViewController.swift
//  challenge
//
//  Created by Wagner Sales
//

import UIKit
import MapKit

final class ConfirmViewController: WASViewController {
    // MARK: Properties

    var viewModel: ConfirmViewModelProtocol

    let contentView = UIView()
    let mapView = MKMapView()
    let tableView = UITableView()

    // MARK: Constructors

    init(viewModel: ConfirmViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.didChangeState = { [weak self] state in
            self?.handleStateChange(state)
        }
    }

    override func setupUI() {
        super.setupUI()
        title = "select_driver".localized
        addBackButton()
        setupContentView()
        setupMapView()
        setupTableView()
        setupConstraints()
        showRouteOnMap()
    }

    // MARK: Setups

    private func setupContentView() {
        contentView.fill(on: view)
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mapView)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false

        tableView.dataSource = self
        tableView.register(ConfirmCell.self, forCellReuseIdentifier: ConfirmCell.identifier)
        contentView.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),

            tableView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    // MARK: Private Methods

    private func createAnnotation(for placemark: MKPlacemark, title: String) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = title

        return annotation
    }

    private func showRouteOnMap() {
        guard let polyline = viewModel.estimate.routeResponse?.encodedPolylines.first else {
            return
        }

        let originCoordinate = viewModel.estimate.origin.toCoordinate2D
        let originPlacemark = MKPlacemark(coordinate: originCoordinate)

        let destinationCoordinate = viewModel.estimate.destination.toCoordinate2D
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)

        mapView.addAnnotations([
            createAnnotation(for: originPlacemark, title: "Início"),
            createAnnotation(for: destinationPlacemark, title: "Fim")
        ])

        displayRoute(coordinates: polyline.toCoordinates)
    }

    private func displayRoute(coordinates: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        mapView.addOverlay(polyline)
        mapView.setVisibleMapRect(
            polyline.boundingMapRect,
            edgePadding: UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50),
            animated: true
        )
    }

    private func showContentView(_ isShowing: Bool) {
        contentView.isHidden = !isShowing
    }

    private func showAlert(title: String, message: String, actionHandler: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { _ in
            actionHandler?()
        }
        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)
    }

    // MARK: Internal Methods

    func handleStateChange(_ state: ConfirmState) {
        switch state {
        case .idle:
            showLoading(false)
            showContentView(true)

        case .loading:
            showLoading(true)
            showContentView(false)

        case .success(let customerId):
            showLoading(false)
            showContentView(true)
            let viewModel = RidesViewModel(customerId: customerId)
            let viewController = RidesViewController(viewModel: viewModel)
            navigationController?.pushViewController(viewController, animated: true)

        case .failure(let error):
            showLoading(false)
            showContentView(true)
            showAlert(title: "Erro", message: error.description)
        }
    }

    func didSelectDriver(index: Int) {
        viewModel.didSelectDriver(index: index)
    }
}

extension ConfirmViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = Colors.primary
        renderer.lineWidth = 4.0
        return renderer
    }
}

// MARK: - UITableViewDataSource

extension ConfirmViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmCell.identifier) as? ConfirmCell
        if let row = viewModel.row(at: indexPath.row) {
            cell?.setup(with: row, action: { [weak self] in
                self?.didSelectDriver(index: indexPath.row)
            })
        }

        return cell ?? UITableViewCell()
    }
}
