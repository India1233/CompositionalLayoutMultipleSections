//
//  ViewController.swift
//  CompositionalLayoutMultipleSections
//
//  Created by Sachin Dumal on 13/12/19.
//  Copyright © 2019 Sachin Dumal. All rights reserved.
//

import UIKit

// MARK:- Model
struct Colors:Hashable{
    let id = UUID()
    let color:UIColor
}
//MARK:- Enum
extension ViewController {
    fileprivate enum Section {
        case One
    }
}

//MARK:- typealias
fileprivate  typealias DiffableDataSource = UICollectionViewDiffableDataSource<ViewController.Section, Colors>
fileprivate typealias SnapshotDataSource  = NSDiffableDataSourceSnapshot<ViewController.Section, Colors>

// MARK:- Viewcontroller Class
class ViewController: UIViewController {
    
    //MARK:- Properties
    private var colors = [Colors]()
    private var collectionView: UICollectionView! = nil
    private var dataSource: DiffableDataSource!
    private var snapSourceData = SnapshotDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCollectionView()
        addColorsData()
//        setupDataSource()
//        setupSnapshot()
    }

// MARK:- Create CollectionView
    private func setupCollectionView(){
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createLayoutDiffSection())
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        setupLayout()
    }
    
    // MARK:- Create Diff Section layout
    
    private func createLayoutDiffSection() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex:Int , layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var columns = 0
            
            switch sectionIndex {
                
            case 1:
                columns = 3
            case 2:
                columns = 5
            default:
                columns = 3
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupeHeight = columns == 1 ? NSCollectionLayoutDimension.absolute(44) : NSCollectionLayoutDimension.fractionalWidth(0.2)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupeHeight)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            
            return section
        }
        return layout
    }
    
    // MARK:- CollectionViewLayout
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item     = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupeSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.15))
        
        let groupe = NSCollectionLayoutGroup.horizontal(layoutSize:groupeSize , subitems: [item])
        
        let section = NSCollectionLayoutSection(group: groupe)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
       
        return layout
    }
    
    // MARK:- Create Diffable DataSource
    
    private func setupDataSource() {
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, color) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = color.color
            return cell
        })
    }
    
    // MARK:- Create Snapshot
    
    private func setupSnapshot(){
        snapSourceData.appendSections([Section.One])
        snapSourceData.appendItems(colors)
        dataSource.apply(snapSourceData, animatingDifferences: true)
    }
    
    
    // MARK:- Constraint Setup
    private func setupLayout() {
        NSLayoutConstraint.activate([
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        ])
    }
    
    // MARK:- Add colors data to colors array
    
    private func addColorsData() {
        colors = [Colors(color: .red), Colors(color: .black), Colors(color: .blue), Colors(color: .brown),Colors(color: .cyan),Colors(color: .darkGray),Colors(color: .darkText),Colors(color: .gray),Colors(color: .green),Colors(color: .lightGray),Colors(color: .lightText),Colors(color: .link),Colors(color: .magenta)].shuffled()
    }
}



//MARK:- Extension CollectionView DataSource

extension ViewController:UICollectionViewDataSource {
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
       }
       
       
       func numberOfSections(in collectionView: UICollectionView) -> Int {
           return 3
       }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch indexPath.row%10 {
               case 0:
                   cell.backgroundColor = .blue
               case 1:
                   cell.backgroundColor = .yellow
               case 2:
                   cell.backgroundColor = .green
               case 3:
                   cell.backgroundColor = .orange
               case 4:
                   cell.backgroundColor = .systemBlue
               case 5:
                   cell.backgroundColor = .darkGray
               case 6:
                   cell.backgroundColor = .systemPink
               case 7:
                   cell.backgroundColor = .systemRed
               case 8:
                   cell.backgroundColor = .magenta
               case 9:
                   cell.backgroundColor = .systemIndigo
               default:
                   cell.backgroundColor = .white
               }
        return cell
    }
}
