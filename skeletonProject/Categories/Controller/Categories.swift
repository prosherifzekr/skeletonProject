//
//  CountrySections.swift
//  skeletonProject
//
//  Created by Sherif  Wagih on 9/2/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreData
import Firebase
import SDWebImage
class Categories: UIViewController{
    
    @IBOutlet weak var bannerView: GADBannerView!
    var countryName:String?{
        didSet{
            if let name = countryName
            {
                titleLabel.text = name
            }
        }
    }
    var countryId:Int?
    {
        didSet
        {
            if let id = countryId
            {
                APIService.shared.fetchCategories(countryId: id) { (allCategories, loadedSuccessfully) in
                    self.loadedSuccessfully = loadedSuccessfully
                    if loadedSuccessfully
                    {
                        self.allCategories = allCategories
                        self.collectionView?.reloadData()
                    }
                    else
                    {
                        self.present(UIAlertController.showAlert(message: "Error loading data. Please make sure you are connected to the internet"), animated: true, completion: nil)
                    }
                    SVProgressHUD.dismiss()
                }
            }
            else
            {
                return
            }
        }
    }
    
    var imageName:String?
    {
        didSet
        {
            let imageBaseUrl = "https://fitnessksa.com/public/images/countries/"
            if let name = imageName
            {
                let imageurl = imageBaseUrl + name
                if let url = URL(string: imageurl)
                {
                    countryImage.sd_setImage(with: url, completed: nil)
                    //countryImage.downloadImage(from: url)
                }
            }
        }
    }
    var allCategories:[Category]?
    var loadedSuccessfully = false
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "تحميل الاقسام")
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "id")
        setupTitleStack()
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SubCategoriesSegue"
        {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first
            {
                let dest = segue.destination as! SubCategoryViewController
                if let catName = allCategories?[indexPath.item].name
                {
                    dest.categoryName = catName
                }
                if let catId = allCategories?[indexPath.item].id
                {
                    dest.categoryId = catId
                }
                
            }
        }
    }
    let countryImage = UIImageView()
    let titleLabel = UILabel()
    func setupTitleStack()
    {
        countryImage.sd_setIndicatorStyle(.gray)
        countryImage.sd_showActivityIndicatorView()
        let size = (view.frame.size.width - 20)
        navigationItem.hidesBackButton = true
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "ic_white_more"), for: .normal)
        let favButton = UIButton()
        favButton.setImage(UIImage(named: "ic_white_empty_star"), for: .normal)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        countryImage.contentMode = .scaleToFill
        countryImage.clipsToBounds = true
        countryImage.layer.cornerRadius = 20
        let backToPrevious = UIButton()
        backToPrevious.setImage(UIImage(named: "ic_rtl_back"), for: .normal)
        backToPrevious.addTarget(self, action: #selector(goToCountries), for: .touchUpInside)
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        titleView.addSubview(menuButton)
        
        titleView.addSubview(favButton)
        titleView.addSubview(titleLabel)
        titleView.addSubview(countryImage)
        titleView.addSubview(backToPrevious)
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuButton.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
            menuButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            menuButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 60/2)
            ])
        favButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favButton.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor),
            favButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            favButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 60/2)
            ])
        favButton.addTarget(self, action: #selector(favouritePage), for: .touchUpInside)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: size - 130)
            ])
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countryImage.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            countryImage.topAnchor.constraint(equalTo: titleView.topAnchor,constant:0),
            countryImage.bottomAnchor.constraint(equalTo: titleView.bottomAnchor,constant:0),
            countryImage.widthAnchor.constraint(equalToConstant: 40)
            ])
        backToPrevious.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backToPrevious.leadingAnchor.constraint(equalTo: countryImage.trailingAnchor),
            backToPrevious.topAnchor.constraint(equalTo: titleView.topAnchor),
            backToPrevious.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            backToPrevious.widthAnchor.constraint(equalToConstant: 40)
            ])
        
        navigationItem.titleView = titleView
    }
    @objc func goToCountries()
    {
        SVProgressHUD.dismiss()
        navigationController?.popViewController(animated: true)
    }
    @objc func favouritePage()
    {
        let layout = UICollectionViewFlowLayout()
        let controller = ItemDetailsViewController(collectionViewLayout: layout)
        controller.favoriteMode = true
        controller.allListItems = UserDefaults.standard.getFavoritedItems()
        navigationController?.pushViewController(controller, animated: true)
    }
}

