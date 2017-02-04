//
//  GnomesListViewController.swift
//  brastlewark
//
//  Created by Abel Osorio on 2/2/17.
//  Copyright © 2017 Abel Osorio. All rights reserved.
//

import UIKit
import RxSwift
import CellRegistrable
import Localize_Swift
import MRProgress
import DZNEmptyDataSet
import RxDataSources
import TextAttributes

class GnomesListViewController: UIViewController {

	// MARK: - IBOutlet
	@IBOutlet weak var tableView: UITableView!
	fileprivate lazy var refreshControl: UIRefreshControl = { [unowned self] in
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
		return refreshControl
	}()
	fileprivate lazy var searchViewController: UISearchController = { [unowned self] in
		let searchController = UISearchController(searchResultsController: nil)
		return searchController
	}()

	// MARK: - Private properties
	fileprivate let disposeBag = DisposeBag()
	fileprivate let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String?, Gnome>>()
	
	// MARK: - Properties
	var viewModel: GnomeListViewModel
	
	// MARK: - Life Cycle
	init(viewModel: GnomeListViewModel) {
		self.viewModel = viewModel
		
		super.init(nibName: String(describing: GnomesListViewController.self), bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - View Life Cycle
	override func viewDidLoad() {
		super.viewDidLoad()
		setupNavigationBarButtons()
		setupTableView()
		setupSearchViewController()
		refresh(force: false)
	}
	
	// MARK: - internal helpers
	func setupNavigationBarButtons(){
		navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
	}
	
	func setupTableView() {
		tableView.registerCell(GnomeTableViewCell.self)
		tableView.rowHeight = 263
		tableView.addSubview(refreshControl)
		tableView.tableFooterView = UIView()
		tableView.backgroundColor = .gnomesNavigationBarColor()
		tableView.rx.setDelegate(self)
			.addDisposableTo(disposeBag)
		dataSource.configureCell = { (_, tableView, indexPath, item) in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: GnomeTableViewCell.reuseIdentifier,
			                                               for: indexPath) as? GnomeTableViewCell else { return UITableViewCell() }
			cell.update(gnome: item)
			return cell
		}
		setupRx()
	}

	func setupSearchViewController() {
		searchViewController.hidesNavigationBarDuringPresentation = false
		searchViewController.dimsBackgroundDuringPresentation = false
		searchViewController.searchBar.sizeToFit()
		definesPresentationContext = true
		navigationItem.titleView = searchViewController.searchBar
	}

	// MARK: - RxSwift Methods
	func setupRx() {
		tableView.rx.itemSelected
			.subscribeNext { [unowned self] (indexPath) in
				self.tableView.deselectRow(at: indexPath, animated: true)
			}
			.addDisposableTo(disposeBag)
		
		tableView.rx.modelSelected(Gnome.self)
			.asObservable()
			.subscribeNext { [unowned self] (gnome) in
				self.viewModel.showDetail(gnome: gnome)
			}
			.addDisposableTo(disposeBag)
		viewModel.gnomes
			.asObservable()
			.map {
				return [SectionModel(model: "", items: $0)]
			}
			.bindTo(tableView.rx.items(dataSource: dataSource))
			.addDisposableTo(disposeBag)
		searchViewController.searchBar.rx.searchButtonClicked
			.subscribeNext { [unowned self] in
				self.searchViewController.searchBar.resignFirstResponder()
			}
			.addDisposableTo(disposeBag)
		searchViewController.searchBar.rx.cancelButtonClicked
			.subscribeNext{ [unowned self] in
				self.viewModel.gnomes.value = self.viewModel.cachedGnomes
				self.searchViewController.searchBar.resignFirstResponder()
			}
			.addDisposableTo(disposeBag)
		searchViewController.searchBar.rx.text
			.map { $0 ?? "" }
			.bindTo(viewModel.query)
			.addDisposableTo(disposeBag)
	}

	// MARK: - Private methods
	fileprivate func refresh(force: Bool) {
		MRProgressOverlayView.showOverlayAdded(to: view, animated: true)
		viewModel.getGnomes()
			.do(onCompleted: { [unowned self] in
				self.refreshControl.endRefreshing()
				MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
			})
			.subscribeError { [unowned self] (error) in
				UIAlertController.showFromViewController(self, forError: error)
				self.refreshControl.endRefreshing()
				MRProgressOverlayView.dismissAllOverlays(for: self.view, animated: true)
			}
			.addDisposableTo(disposeBag)
	}
	
	// MARK: - UIRefreshControl action methods
	func refreshControlValueChanged() {
		refresh(force: true)
	}
}
extension GnomesListViewController: UITableViewDelegate{
	func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		return .none
	}
}
