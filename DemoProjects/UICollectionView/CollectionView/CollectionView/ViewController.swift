//
//  ViewController.swift
//  CollectionView
//
//  Created by JiangWang on 2019/10/24.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "CollectionViewCell"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [label.topAnchor.constraint(equalTo: contentView.topAnchor),
                           label.leftAnchor.constraint(equalTo: contentView.leftAnchor),
                           label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                           label.rightAnchor.constraint(equalTo: contentView.rightAnchor)]
        contentView.addConstraints(constraints)
        backgroundColor = .gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    var targetIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        flow.itemSize = CGSize(width: 100, height: 100)
        collection.collectionViewLayout = flow
        
        collection.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseId)
        
        collection.delegate = self
        collection.dataSource = self
    }
    
    
    @IBAction func clickToQueryCell() {
        let cases = [5]
        guard !cases.isEmpty else { return }
        let randomIndex = Int(arc4random_uniform(100).remainderReportingOverflow(dividingBy: (UInt32)(cases.count)).partialValue)
        let random = cases[randomIndex]
        let newItem = ((targetIndexPath?.row ?? 0) + 50).remainderReportingOverflow(dividingBy: 100).partialValue //0||50 rotating
        let newIndexPath = IndexPath(item: newItem, section: 0)
        targetIndexPath = newIndexPath
        switch random {
        case 0:
            let cell = collection.cellForItem(at: newIndexPath)
            print("no scrolling \n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
        case 1:
            collection.scrollToItem(at: newIndexPath, at: [.centeredHorizontally], animated: false)
            let cell = collection.cellForItem(at: newIndexPath)
            print("scrolling \n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
        case 2:
            collection.scrollToItem(at: newIndexPath, at: [.centeredHorizontally], animated: false)
            DispatchQueue.main.async {
                let cell = self.collection.cellForItem(at: newIndexPath)
                print("scrolling -> dispatch \n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
            }
        case 3:
            collection.scrollToItem(at: newIndexPath, at: [.centeredHorizontally], animated: false)
            collection.layoutSubviews()
            DispatchQueue.main.async {
                let cell = self.collection.cellForItem(at: newIndexPath)
                print("scrolling -> layout -> dispatch \n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
            }
        case 4:
            collection.scrollToItem(at: newIndexPath, at: [.centeredHorizontally], animated: false)
            collection.layoutSubviews()
            let cell = self.collection.cellForItem(at: newIndexPath)
            print("layout\n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
        case 5:
            collection.scrollToItem(at: newIndexPath, at: [.centeredHorizontally], animated: false)
            collection.layoutIfNeeded()
            let cell = self.collection.cellForItem(at: newIndexPath)
            print("layoutIfNeeded\n queried cell: \(cell.debugDescription) at indexPath: \(newIndexPath.debugDescription)")
        default:
            break
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseId, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell.init(frame: .zero)
        }
        cell.label.text = String(indexPath.row)
        cell.label.textColor = .black
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("will display cell: \(cell.debugDescription) at index path: \(indexPath)")
    }
}

