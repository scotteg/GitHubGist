//
//  GistsViewController.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/10/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import UIKit
import RxSwift
import KFSwiftImageLoader

final class GistsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let viewModel = GistsViewModel()
    let disposeBag = DisposeBag()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "\(GistViewController.self)",
            let controller = (segue.destination as? UINavigationController)?.topViewController as? GistViewController,
            let sender = sender as? Gist
            else { return }
        
        controller.gist = sender
    }
    
    func configureTableView() {
        refreshControl.addTarget(self, action: #selector(update), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 88.0
    }
    
    func update() {
        viewModel.since.onNext(viewModel.nowString)
    }
    
    func bind() {
        viewModel.data
            .bind(to: tableView.rx.items) { [unowned self] tableView, indexPath, gist in
                let cell = tableView.dequeueReusableCell(withIdentifier: "GistCell") as! GistCell
                
                cell.avatarImageView.loadImage(urlString: gist.avatarUrlString, placeholderImage: GitHubGistStyleKit.imageOfDefaultUserAvatar)
                
                cell.filenameLabel.text = gist.filename
                cell.ownerAndCreatedLabel.text = "by \(gist.ownerLogin) on \(self.dateFormatter.string(from: gist.createdAt))"
                cell.descriptionLabel.text = gist.desc
                cell.commentsBubble.count = gist.commentsCount
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshing
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Gist.self)
            .debounce(0.3, scheduler: MainScheduler.instance)
            .bind(onNext: { [unowned self] in
                self.performSegue(withIdentifier: "\(GistViewController.self)", sender: $0)
            })
            .disposed(by: disposeBag)
    }
}
