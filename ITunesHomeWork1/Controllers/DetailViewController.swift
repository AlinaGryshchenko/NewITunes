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
    }
    
    private func setModel() {
        
        albumNameLabel.text = "Album"
        artistNameLabel.text = "Artist"
        dataReliseLabel.text = "Data relise"
        trackCountLabel.text = "Track count"
        
    }
    
    private func fetchSong(album: Album?) {
        guard let album = album else {return}
        let idAlbum = album.collectionId
        let urlString = "https://itunes.apple.com/lookup?id=\(idAlbum)&entity=song"
        
    }
    
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SongsCollectionCell", for: indexPath) as! SongsCollectionCell
        cell.songsLabel.text = "12345"
        return cell
    }
    
    
    
}
