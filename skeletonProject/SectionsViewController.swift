//
//  SectionsViewController.swift
//  skeletonProject
//
//  Created by Sherif  Wagih on 9/2/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
class SectionsViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        navigationItem.hidesBackButton = true
        collectionView?.register(SectionCell.self, forCellWithReuseIdentifier: cellID)
        setupTitleStack()
    }
    let cellID : String = "cellId"
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SectionCell
        cell.sectionTitle.text = "التسويق الالكتروني"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 40) / 3, height: 50)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SectionItemsSegue", sender: self)
    }
    func setupTitleStack()
    {
        let size = (view.frame.size.width - 20)
        navigationItem.hidesBackButton = true
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "ic_white_more"), for: .normal)
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "ic_white_reply"), for: .normal)
        let favButton = UIButton()
        favButton.setImage(UIImage(named: "ic_white_empty_star"), for: .normal)
        let titleLabel = UILabel()
        titleLabel.text = "مصر"
        titleLabel.textAlignment = .right
        titleLabel.textColor = .white
        let backtitleLabel = UILabel()
        backtitleLabel.text = "التسوق \n الالكتروني"
        backtitleLabel.numberOfLines = 2
        backtitleLabel.font = UIFont.boldSystemFont(ofSize: 11)
        backtitleLabel.textAlignment = .center
        backtitleLabel.textColor = .white
        let backToPrevious = UIButton()
        backToPrevious.setImage(UIImage(named: "ic_rtl_back"), for: .normal)
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        titleView.addSubview(menuButton)
        titleView.addSubview(backButton)
        titleView.addSubview(favButton)
        titleView.addSubview(titleLabel)
        titleView.addSubview(backToPrevious)
        titleView.addSubview(backtitleLabel)
        //titleView.backgroundColor = .red
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            menuButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            menuButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 80/3)
            ])
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor),
            backButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 80/3)
            ])
        
        
        favButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favButton.leadingAnchor.constraint(equalTo: backButton.trailingAnchor),
            favButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            favButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 80/3)
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: (size - 130)/2)
            ])
        backtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            backtitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            backtitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            backtitleLabel.widthAnchor.constraint(equalToConstant: (size - 130)/2)
            ])
        backToPrevious.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backToPrevious.leadingAnchor.constraint(equalTo: backtitleLabel.trailingAnchor),
            backToPrevious.topAnchor.constraint(equalTo: titleView.topAnchor),
            backToPrevious.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            backToPrevious.widthAnchor.constraint(equalToConstant: 40)
            ])
        navigationItem.titleView = titleView
    }
}
