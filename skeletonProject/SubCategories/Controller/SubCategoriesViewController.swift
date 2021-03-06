//
//  SectionsViewController.swift
//  skeletonProject
//
//  Created by Sherif  Wagih on 9/2/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD
class SubCategoryViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var allSubCategories:[SubCategory]?
    var loadedSuccessfully = false
    var categoryName:String?{
        didSet{
            if let name = categoryName
            {
                backtitleLabel.text = name
            }
        }
    }
    var subCategoriesMode:Bool = true
    var categoryId:Int?{
        didSet{
            if let id = categoryId
            {
                APIService.shared.fetchSubCategories(categoryId: id) { (allSubCategories, loadedSuccessfully) in
                    self.loadedSuccessfully = loadedSuccessfully
                    if loadedSuccessfully
                    {
                        self.allSubCategories = allSubCategories
                        self.collectionView?.reloadData()
                    }
                    else
                    {
                      let alert = UIAlertController.showAlert(message: "Something Went Wrong! Please make sure you are connected to the internet. ")
                       self.present(alert, animated: true, completion: nil)
                    }
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show(withStatus: "تحميل الاقسام الفرعية")
        navigationItem.hidesBackButton = true
        collectionView?.register(SectionCell.self, forCellWithReuseIdentifier: cellID)
        setupTitleStack()
    }
    let cellID : String = "cellId"
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if subCategoriesMode
        {
            if let count =  allSubCategories?.count
            {
                return count
            }
        }
        else
        {
            if let count =  allSubSubCategories?.count
            {
                return count
            }
        }
        return 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SectionCell
        if subCategoriesMode
        {
            if let subCategory = allSubCategories?[indexPath.item]
            {
                cell.sectionTitle.text = subCategory.name
            }
        }
        else
        {
            if let subSubCategory = allSubSubCategories?[indexPath.item]
            {
                cell.sectionTitle.text = subSubCategory.name
            }
        }
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width - 50) / 3, height: 50)
    }
    var allSubSubCategories:[ItemDetails]?
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        SVProgressHUD.show()
        if subCategoriesMode && allSubCategories?[indexPath.item].id == 1
        {
            if let id = allSubCategories?[indexPath.item].id
            {
                loadSubSubCategories(subcategoryId: id)
            }
            subCategoriesMode = false
            backtitleLabel.text = allSubCategories?[indexPath.item].name
        }
        else
        {
            SVProgressHUD.dismiss()
            performSegue(withIdentifier: "SectionItemsSegue", sender: self)
        }
    }
    func loadSubSubCategories(subcategoryId:Int)
    {
        APIService.shared.fetchSubSubCategories(subcategoryId: subcategoryId)
        { (subSubCategories, completed) in
            if completed
            {
                self.allSubSubCategories = subSubCategories
                self.collectionView?.reloadData()
                SVProgressHUD.dismiss()
            }
            else
            {
                print("something went wrong")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SectionItemsSegue"
        {
            if let dest = segue.destination as? ItemDetailsViewController
            {
                if let index = (collectionView?.indexPathsForSelectedItems?.first?.item)
                {
                    if subCategoriesMode
                    {
                        if let subCategory = allSubCategories?[index]
                        {
                            dest.subCategory = subCategory
                        }
                    }
                    else
                    {
                        if let subSubCategory = allSubSubCategories?[index]
                        {
                            dest.subSubCategory = subSubCategory
                        }
                    }
                }
            }
        }
    }
    var backtitleLabel = UILabel()
    func setupTitleStack()
    {
        let size = (view.frame.size.width - 20)
        navigationItem.hidesBackButton = true
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "ic_white_more"), for: .normal)
        let favButton = UIButton()
        favButton.setImage(UIImage(named: "ic_white_empty_star"), for: .normal)
        favButton.addTarget(self, action: #selector(favouritePage), for: .touchUpInside)
        let titleLabel = UIImageView()
        titleLabel.image = UIImage(named: "open_web")
        titleLabel.isUserInteractionEnabled = true
        titleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(visitWebsite)))
        backtitleLabel.numberOfLines = 2
        backtitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        backtitleLabel.textAlignment = .center
        backtitleLabel.textColor = .white
        let backToPrevious = UIButton()
        backToPrevious.setImage(UIImage(named: "ic_rtl_back"), for: .normal)
        backToPrevious.addTarget(self, action: #selector(backToCategories), for: .touchUpInside)
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        titleView.addSubview(menuButton)
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
            menuButton.widthAnchor.constraint(equalToConstant: 60/2)
            ])
        
        favButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favButton.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor),
            favButton.topAnchor.constraint(equalTo: titleView.topAnchor),
            favButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            favButton.widthAnchor.constraint(equalToConstant: 60/2)
            ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: favButton.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: (size - 100)/2)
            ])
        backtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            backtitleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
            backtitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor),
            backtitleLabel.widthAnchor.constraint(equalToConstant: (size - 100)/2)
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
    @objc func backToCategories()
    {
        if subCategoriesMode
        {
            SVProgressHUD.dismiss()
            navigationController?.popViewController(animated: true)
        }
        else
        {
            subCategoriesMode = true
            backtitleLabel.text = categoryName
            self.collectionView?.reloadData()
        }
    }
    @objc func favouritePage()
    {
        let layout = UICollectionViewFlowLayout()
        let controller = ItemDetailsViewController(collectionViewLayout: layout)
        controller.favoriteMode = true
        controller.allListItems = UserDefaults.standard.getFavoritedItems()
        navigationController?.pushViewController(controller, animated: true)
    }
    @objc func visitWebsite()
    {
        print("here")
        if let url = URL(string: "http://fitnessksa.com/public/web-form/create")
        {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
