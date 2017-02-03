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
import RxDataSources
import Localize_Swift
import MRProgress
import DZNEmptyDataSet
import TextAttributes

class GnomesListViewController: UIViewController {

	// MARK: - IBOutlet
	@IBOutlet weak var tableView: UITableView!
	fileprivate lazy var refreshControl: UIRefreshControl = { [unowned self] in
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshControlValueChanged), for: .valueChanged)
		return refreshControl
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
		setupRx()
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
		dataSource.configureCell = { (_, tableView, indexPath, item) in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: GnomeTableViewCell.reuseIdentifier,
			                                               for: indexPath) as? GnomeTableViewCell else { return UITableViewCell() }
			cell.update(gnome: item)
			return cell
		}
		dataSource.canEditRowAtIndexPath = { _ in
			return true
		}
		tableView.rx.itemSelected
			.asObservable()
			.subscribeNext { [unowned self] (indexPath) in
				self.viewModel.showDetailForGnome(atIndex: indexPath.row)
				
			}.addDisposableTo(disposeBag)
		NotificationCenter.default.rx.notification(Notification.Name(rawValue: LCLLanguageChangeNotification))
			.subscribeNext { (_) in
				self.setupRx()
			}
			.addDisposableTo(disposeBag)
	}
	
	func setupRx() {
		title = "Gnomes".localized()
		// TableView setup
		viewModel.gnomes
			.asObservable()
			.map {
				var sections: [SectionModel<String?, Gnome>] = []
				sections.append(SectionModel(model: nil, items: $0))
				return sections
			}
			.bindTo(tableView.rx.items(dataSource: dataSource))
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
