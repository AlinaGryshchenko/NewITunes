//
//  DetailSongsViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 25.01.2023.
//

import UIKit

class DetailSongsViewController: UIViewController {

    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var dataReliseLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album?
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        setModel()
        fetchSong(album: album)
    }
    
    func setDelegate(){
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setModel() {
     guard let album = album else {return}
        
        albumNameLabel.text = album.collectionName
        artistNameLabel.text = album.artistName
        trackCountLabel.text = "\(album.trackCount) tracks:"
        dataReliseLabel.text = setDateFormat(date: album.releaseDate)
      
        guard let url = album.artworkUrl100 else { return }
        setImage(urlString: url)
    }
    
    private func setDateFormat(date: String) -> String {
        
        //"2000-06-26T07:00:00Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        guard let backendDate = dateFormatter.date(from: date) else { return ""}
   
        let formatDate = DateFormatter()
        formatDate.dateFormat = "dd-MM-yyyy"
        let date = formatDate.string(from: backendDate)
        return date
    }
    
    private func setImage(urlString: String?) {
        
        if let url = urlString {
            NetworkRequest.shared.requestData(urlString: url) { [weak self] result in
                switch result {
                case .success(let data):
                    let image = UIImage(data: data)
                    self?.albumLogo.image = image
                case .failure(let error):
                    self?.albumLogo.image = nil
                    print("No album logo" + error.localizedDescription)
                }
            }
        } else {
            albumLogo.image = nil
        }
    }
    
    
    private func fetchSong(album: Album?) {
        guard let album = album else { return }
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else { return }
                self?.songs = songModel.results
                self?.tableView.reloadData()
                //self?.collectionView.reloadData()
            }else{
                print(error!.localizedDescription)
                self?.alertOk(title: "Error", massage: error!.localizedDescription)
            }
        }
        
    }
    
}

extension DetailSongsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let song = songs[indexPath.row].trackName
        cell.songsLabel.text = song
        cell.backgroundColor = .clear

        return cell
    }
    
    
    
}
