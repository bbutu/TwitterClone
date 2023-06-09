//
//  ProfileViewController.swift
//  TwitterClone
//
//  Created by Beka Buturishvili on 27.11.22.
//

import UIKit
import Combine
import SDWebImage

class ProfileViewController: UIViewController {
    
    private var isStatusBarHidden: Bool = true
    private var viewModel = ProfileViewViewModel()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private let statusBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.opacity = 0
        return view
    }()
    
    private lazy var headerView = ProfileTableViewHeader(frame: CGRect(x: 0, y: 0, width: profileTableView.frame.width, height: 380))
    
    private let profileTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TweetTableViewCell.self, forCellReuseIdentifier: TweetTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Profile"
        view.addSubview(profileTableView)
        view.addSubview(statusBar)
        profileTableView.tableHeaderView = headerView
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.contentInsetAdjustmentBehavior = .never
        navigationController?.navigationBar.isHidden = true
        configureConstraints()
        bindViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.retrieveUser()
    }
    
    private func bindViews() {
        viewModel.$user.sink { [weak self] user in
            guard let user = user else { return }
            self?.headerView.displayNameLabel.text = user.displayName
            self?.headerView.userBioLabel.text = user.bio
            self?.headerView.usernameLabel.text = "@\(user.userName)"
            self?.headerView.followingCountLabel.text = "\(user.followingCount)"
            self?.headerView.followersCountLabel.text = "\(user.followersCount)"
            self?.headerView.profileAvatarImageView.sd_setImage(with: URL(string: user.avatarPath))
            self?.headerView.joinDateLabel.text = "Joined \(self?.viewModel.getFormattedDate(with: user.createdOn) ?? "")"
        }
        .store(in: &subscriptions)
    }
    
    private func configureConstraints() {
        let profileTableViewConstraints = [
            profileTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileTableView.topAnchor.constraint(equalTo: view.topAnchor),
            profileTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        let statusBarConstraints = [
            statusBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            statusBar.topAnchor.constraint(equalTo: view.topAnchor),
            statusBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            statusBar.heightAnchor.constraint(equalToConstant: view.bounds.height > 800 ? 40 : 20)
        ]
        
        NSLayoutConstraint.activate(profileTableViewConstraints)
        NSLayoutConstraint.activate(statusBarConstraints)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TweetTableViewCell.identifier, for: indexPath) as? TweetTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition > 150 && isStatusBarHidden {
            isStatusBarHidden = false
            UIView.animate(withDuration: 0.25, delay: 0) { [weak self] in
                self?.statusBar.layer.opacity = 1
            }
        }else if yPosition < 0 && !isStatusBarHidden{
            isStatusBarHidden = true
            UIView.animate(withDuration: 0.25, delay: 0) { [weak self] in
                self?.statusBar.layer.opacity = 0
            }
        }
    }
    
}
