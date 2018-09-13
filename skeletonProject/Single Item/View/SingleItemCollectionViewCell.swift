//
//  SingleItemCollectionViewCell.swift
//  skeletonProject
//
//  Created by Sherif  Wagih on 9/13/18.
//  Copyright © 2018 Sherif  Wagih. All rights reserved.
//

import UIKit

class SingleItemCollectionViewCell: UICollectionViewCell {
    
    var height:CGFloat?{
        didSet{
            setupLayout()
        }
    }
    var listItem:ListItem?{
        didSet{
            
            if let title = listItem?.title
            {
                let attributedText = NSMutableAttributedString(string: title, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)])
                guard let subTitle = listItem?.details else {return }
                if subTitle != ""
                {
                    attributedText.append(NSAttributedString(string: "\n\(subTitle)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13),NSAttributedStringKey.foregroundColor:UIColor.darkGray]))
                }
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedText.length))
                titleLabel.attributedText = attributedText
                titleLabel.textAlignment = .right
                let size = CGSize(width: frame.width - 55, height: 10000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: titleLabel.text ?? "").boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 17)], context: nil)
                if Int(estimatedRect.size.height) > 100
                {
                    height = estimatedRect.size.height
                }
                else
                {
                    height = 100
                }
            }
        }
    }
    let titleLabel : UILabel = {
        let label = UILabel();
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let starButton : UIButton = {
        let startButton = UIButton(type: .system)
        startButton.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        startButton.setImage(UIImage(named: "ic_white_empty_star"), for: .normal)
        startButton.tintColor = UIColor.darkGray
        startButton.contentMode = .scaleAspectFit
        startButton.translatesAutoresizingMaskIntoConstraints = false
        return startButton
    }()
    
    let itemImage : CustomImageView = {
        let image = CustomImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "img_blank")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let containerView:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
       // container.backgroundColor = .red
        return container
    }()
    let socialContainer:UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    func setupLayout()
    {
        let actualHeight = (frame.height - height!) / 2
        addSubview(itemImage)
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo: topAnchor),
            itemImage.leftAnchor.constraint(equalTo: leftAnchor),
            itemImage.rightAnchor.constraint(equalTo: rightAnchor),
            itemImage.heightAnchor.constraint(equalToConstant: actualHeight)
            ])
        addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: itemImage.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo: leftAnchor),
            containerView.rightAnchor.constraint(equalTo: rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: height ?? 100)
            ])
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant:-5),
            titleLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant:50),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        containerView.addSubview(starButton)
        NSLayoutConstraint.activate([
            starButton.leftAnchor.constraint(equalTo: leftAnchor),
            starButton.heightAnchor.constraint(equalToConstant: 50),
            starButton.centerYAnchor.constraint(equalTo: centerYAnchor),
           /* starButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            starButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),*/
            starButton.widthAnchor.constraint(equalToConstant: 50)
            ])
        addSubview(socialContainer)
        socialContainer.backgroundColor = .red
        NSLayoutConstraint.activate([
            socialContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            socialContainer.leftAnchor.constraint(equalTo: leftAnchor),
            socialContainer.rightAnchor.constraint(equalTo: rightAnchor),
            socialContainer.heightAnchor.constraint(equalToConstant: actualHeight)
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}