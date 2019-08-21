//
//  JWCollectionViewController.swift
//  JWHorizaontalPageCollectionLayout
//
//  Created by JiangWang on 2019/8/1.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class TestCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.textColor = .black
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [label.topAnchor.constraint(equalTo: contentView.topAnchor),
                           label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                           label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                           label.rightAnchor.constraint(equalTo: contentView.rightAnchor)]
        contentView.addConstraints(constraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("not implemented.")
    }
}

class JWCollectionViewController: UIViewController {
    
    /// 是否删除的标志
    private var delete: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        //添加collectionView
        let layout: UICollectionViewFlowLayout = {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: 50, height: 50)
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            return flowLayout
        }()
        
        let collectionView: UICollectionView = {
            let frame = CGRect(x: 0, y: 100, width: view.bounds.width, height: 50)
            let view = UICollectionView(frame: frame, collectionViewLayout: layout)
            view.register(TestCollectionViewCell.self, forCellWithReuseIdentifier: "TestCollectionViewCell")
            view.delegate = self
            view.dataSource = self
            view.backgroundColor = .gray
            view.bounces = true
            view.alwaysBounceHorizontal = true
            return view
        }()
        
        view.addSubview(collectionView)
    }
}

extension JWCollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delete ? 9 : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCollectionViewCell", for: indexPath) as? TestCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.label.text = "\(indexPath.item)"
        return cell
    }
}

extension JWCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            delete = !self.delete
//        collectionView.alpha = 0
        collectionView.performBatchUpdates({

            if delete {
                collectionView.deleteItems(at: [indexPath])
            }
            else {
                collectionView.insertItems(at: [indexPath])
            }
        }, completion: nil)
        
//                    delete = !self.delete
//
//                    if delete {
//                        collectionView.deleteItems(at: [indexPath])
//                    }
//                    else {
//                        collectionView.insertItems(at: [indexPath])
//                    }
        

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
//            collectionView.alpha = 1
                collectionView.setContentOffset(CGPoint(x: 1000, y: 0), animated: true)
//            UIView.animate(withDuration: 0.3, animations: {
//                collectionView.contentOffset = CGPoint(x: 1000, y: 0)
//            })
        }
    }
}
