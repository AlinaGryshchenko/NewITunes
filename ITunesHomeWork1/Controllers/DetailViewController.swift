//
//  DetailViewController.swift
//  ITunesHomeWork1
//
//  Created by Алина Лошакова on 22.12.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var albumLogo: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var dataReliseLabel: UILabel!
    @IBOutlet weak var trackCountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var album: Album?
    var songs = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "SongsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "SongsCollectionCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setModel()
        fetchSong(album: album)
    }
    
    private func setModel() {
        guard let album = album else { return }
        
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
        guard let album = album else {return}
        
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
        NetworkDataFetch.shared.fetchSongs(urlString: urlString) { [weak self] songModel, error in
            if error == nil {
                guard let songModel = songModel else {return}
                self?.songs = songModel.results
                self?.collectionView.reloadData()
            }else{
                print(error!.localizedDescription)
                self?.alertOk(title: "Error", massage: error!.localizedDescription)
            }
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCollectionCell", for: indexPath) as! SongsCollectionCell
        let song = songs[indexPath.item].trackName
        cell.songsLabel.text = song
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        CGSize(
            width: collectionView.frame.width,
            height: 20)
    }
    
}
