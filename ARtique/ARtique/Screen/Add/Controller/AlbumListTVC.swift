//
//  AlbumListTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/04.
//

import UIKit
import Photos

class AlbumListTVC: UITableViewController {
    var albumList = [PHAssetCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviBar()
        configureTV()
    }
}

// MARK: - Custom Methods
extension AlbumListTVC {
    private func configureNaviBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Albums"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
    }
    private func configureTV() {
        tableView.register(UINib(nibName: Identifiers.albumTVC, bundle: nil), forCellReuseIdentifier: Identifiers.albumTVC)
    }
}

// MARK: - DataSource
extension AlbumListTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.albumTVC, for: indexPath) as? AlbumTVC else { return UITableViewCell() }
        cell.configureCell(with: albumList[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: .whenAlbumChanged, object: indexPath.row)
        dismiss(animated: true)
    }
}
