//
//  GistsViewModel.swift
//  GitHubGist
//
//  Created by Scott Gardner on 5/10/17.
//  Copyright © 2017 Scott Gardner. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class GistsViewModel {
    
    enum ApiKeys: String {
        var $: String {
            return rawValue
        }
        
        case id, url, htmlUrl = "html_url", owner, login, avatarUrl = "avatar_url", files, filename, description, comments, createdAt = "created_at"
    }
    
    enum TimeIntervals: TimeInterval {
        var $: TimeInterval {
            return rawValue
        }
        
        case fifteenMinutes = 900.0
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
    
    let since = BehaviorSubject(value: GistsViewModel.dateFormatter.string(from: Date(timeIntervalSinceNow: -TimeIntervals.fifteenMinutes.$)))
    let refreshing = BehaviorSubject(value: false)
    let fifteenMinutes: TimeInterval = TimeIntervals.fifteenMinutes.$
    let disposeBag = DisposeBag()
    
    lazy var data: Observable<Results<Gist>> = Observable.collection(from: self.realm.objects(Gist.self).sorted(byKeyPath: Gist.Keys.createdAt.$, ascending: false))
    
    var nowString: String {
        return GistsViewModel.dateFormatter.string(from: Date())
    }
    
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    init() {
        since
            .debounce(0.3, scheduler: MainScheduler.instance)
            .flatMapLatest(gists)
            .subscribe(onNext: { [unowned self] gists in
                do {
                    try self.realm.write {
                        self.realm.add(gists, update: true)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(fifteenMinutes, scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .bind(onNext: { [unowned self] _ in
                self.since.onNext(self.nowString)
            })
            .disposed(by: disposeBag)
    }
    
    func url(since: String) -> URL? {
        return URL(string: "https://api.github.com/gists/public?since=\(since)")
    }
    
    func gists(since: String) -> Observable<[Gist]> {
        guard let url = url(since: since) else { return Observable.just([]) }
        refreshing.onNext(true)
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .do(
                onNext: { _ in self.refreshing.onNext(false) },
                onError: { _ in self.refreshing.onNext(false) },
                onCompleted: { self.refreshing.onNext(false) }
            )
            .catchErrorJustReturn([])
            .map(parse)
    }
    
    func parse(_ json: Any) -> [Gist] {
        guard let items = json as? [[String: Any]] else { return [] }
        
        var gists = [Gist]()
        
        items.forEach { item in
            guard let id = item[ApiKeys.id.$] as? String,
                let urlString = item[ApiKeys.url.$] as? String,
                let htmlUrlString = item[ApiKeys.htmlUrl.$] as? String,
                let description = item[ApiKeys.description.$] as? String,
                let commentsCount = item[ApiKeys.comments.$] as? Int,
                let owner = item[ApiKeys.owner.$] as? [String: Any],
                let login = owner[ApiKeys.login.$] as? String,
                let avatarString = owner[ApiKeys.avatarUrl.$] as? String,
                let files = item[ApiKeys.files.$] as? [String: Any],
                let fileKey = files.keys.first,
                let fileValues = files[fileKey] as? [String: Any],
                let filename = fileValues[ApiKeys.filename.$] as? String,
                let createdAtString = item[ApiKeys.createdAt.$] as? String,
                let createdAt = GistsViewModel.dateFormatter.date(from: createdAtString)
                else { return }
            
            gists.append(Gist(
                id: id,
                urlString: urlString,
                htmlUrlString: htmlUrlString,
                avatarUrlString: avatarString,
                ownerLogin: login,
                filename: filename,
                description: description,
                commentsCount: commentsCount,
                createdAt: createdAt
            ))
        }
        
        return gists
    }
}
