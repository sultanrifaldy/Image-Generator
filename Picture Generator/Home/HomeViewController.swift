//
//  HomeViewController.swift
//  Picture Generator
//
//  Created by Sultan Rifaldy on 06/02/24.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    weak var refreshControl: UIRefreshControl!
    
    var memesData: [Memes] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        refreshControl.beginRefreshing()
        fetchMemes()
    }
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate =  self
    }
    
    func fetchMemes() {
        ApiServices.shared.loadMemes{ result in
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let memeList):
                self.memesData =  memeList
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    
    }
    
    @objc func refresh(_ sender: Any) {
        fetchMemes()
    }

}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! HomeCollectionViewCell
        
        let memeList = memesData[indexPath.row]
        
        cell.imageView.kf.setImage(with: URL(string: memeList.url))
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = memesData[indexPath.row]
        let viewController = UIStoryboard(name: "EditPage", bundle: nil).instantiateViewController(withIdentifier: "EditPage") as! EditPageViewController
        viewController.memesData = selectedImage
        navigationController?.pushViewController(viewController, animated: true)
//        let storyBoard = UIStoryboard(name: "EditPage", bundle: nil)
//        let viewController = storyBoard.instantiateViewController(withIdentifier: "EditPage")
//        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = view.window?.windowScene?.screen.bounds.width ?? 0
        let column: CGFloat = 3
        let cellWidth = floor (screenWidth - (2*8) - ((column - 1) * 8)) / column
        
        return CGSize(width: cellWidth, height: 120.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
}
