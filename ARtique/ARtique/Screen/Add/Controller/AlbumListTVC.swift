//
//  AlbumListTVC.swift
//  ARtique
//
//  Created by 황윤경 on 2022/04/04.
//

import UIKit
import Photos

class AlbumListTVC: UIViewController {
    @IBOutlet weak var albumListTV: UITableView!
    var albumList = [PHAssetCollection]()
    var delegate: AlbumChangeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
    }
    
    @IBAction func dismissAlbumList(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - Protocol
protocol AlbumChangeDelegate {
    func changeAlbum(albumNum: Int)
}

// MARK: - Custom Methods
extension AlbumListTVC {
    private func configureTV() {
        albumListTV.register(UINib(nibName: Identifiers.albumTVC, bundle: nil), forCellReuseIdentifier: Identifiers.albumTVC)
        albumListTV.dataSource = self
        albumListTV.delegate = self
    }
}

// MARK: - DataSource
extension AlbumListTVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.albumTVC, for: indexPath) as? AlbumTVC else { return UITableViewCell() }
        cell.configureCell(with: albumList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.changeAlbum(albumNum: indexPath.row)
        dismiss(animated: true)
    }
}
