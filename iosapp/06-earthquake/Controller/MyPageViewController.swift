//
//  MyPageViewController.swift
//  06-earthquake
//
//  Created by koogawa on 2020/01/04.
//  Copyright © 2020 LmLab.net. All rights reserved.
//

import UIKit
import SVProgressHUD

class MyPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var photos: [Photo] = [] {
        didSet {
            tableView?.reloadData()
        }
    }

    var imageCache: [String: UIImage] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    func loadData() {
        guard let userId = UserManager.sharedInstance.userId else {
            return
        }
        PhotoModel().fetchPhotos(userId: userId) { [weak self] result in
            switch result {
            case .success(let photos):
                self?.photos = photos
            case .failure(let error):
                print("error!", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Network Error!")
            }
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PhotoTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none

        let photo = photos[indexPath.row]

        cell.commentLabel.text = photo.comment

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy/M/d HH:mm:ss"
        cell.createdAtLabel.text = dateFormatter.string(from: photo.createdAt.dateValue())

        cell.photoImageView?.contentMode = .scaleAspectFill
        if let image = imageCache[photo.imagePath] {
            cell.photoImageView.image = image
        } else {
            StorageModel().fetchImage(imagePath: photo.imagePath) { [weak self] result in
                switch result {
                case .success(let image):
                    cell.photoImageView.image = image
                    self?.imageCache[photo.imagePath] = image
                case .failure(let error):
                    print("error!", error.localizedDescription)
                }
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let photo = photos[indexPath.row]
            PhotoModel().deletePhoto(id: photo.id) { [weak self] result in
                switch result {
                case .success:
                    self?.photos.remove(at: indexPath.row)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("error!", error.localizedDescription)
                }
            }
        }
    }
}
