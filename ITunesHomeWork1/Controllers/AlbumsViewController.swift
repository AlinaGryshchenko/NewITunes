//
//  AlbumsViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 22.12.2022.
//

import UIKit

class AlbumsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
   
    var albums = [Album]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate   = self
     
        searchBar.delegate = self
        
        tableView.register(UINib(nibName: "AlbumsCell", bundle: nil), forCellReuseIdentifier: "AlbumsCell")
    }

    func fetchAlbums(albumName: String) {
        let urlString = "https://itunes.apple.com/search?term=\(albumName)&entity=album&attribute=albumTerm"
        
        NetworkDataFetch.shared.fetchAlbum(urlString: urlString) { [weak self] albumModel, error in
            if error == nil {
                guard let albumModel = albumModel else {return}
                
//                if albumModel.results != [] {
//                    let sortedAlbums = albumModel.results.sorted { firstItem, secondItem in
//                        return firstItem.collectionName.compare(secondItem.collectionName) == ComparisonResult.orderedAscending
//                    }
//                    self?.albums = sortedAlbums
//
                self?.albums = albumModel.results
                print(self?.albums)
                self?.tableView.reloadData()
            }else{
                print(error!.localizedDescription)
            }
//                    self?.tableView.reloadData()
//                }else{
//                    self?.alertOk(title: "Error", massage: "Album not found. Add some words ")
//                }
//            }else{
//                print(error!.localizedDescription)
//            }
        }
    }
}
extension AlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as! AlbumsCell
        let album = albums[indexPath.row]
        cell.configureAlbumCell(album: album)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AlbumsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
      
        if text != "" {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
                self?.fetchAlbums(albumName: text!)
            })
    }
    }
}
