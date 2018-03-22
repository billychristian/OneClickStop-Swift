//
//  FirstViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 26/01/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit
import FontAwesome_swift

class FirstViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var musicsCollectionView: UICollectionView!
    @IBOutlet weak var booksCollectionView: UICollectionView!
    @IBOutlet weak var applicationsCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var searchButton: UIButton!
    
    var categories : [Category] = []
    var products : [Product] = []
    var movies : [Product] = []
    var musics : [Product] = []
    var books : [Product] = []
    var apps : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for category in CategoryHelper.categories {
            let newCategory = Category(id: category.key, name: category.value)
            self.categories.append(newCategory)
        }
        
        ProductAPIClient.getProductHomeAPI{ (products) in
            self.products = products!
            self.movies = self.products.filter{CategoryHelper.getCategoryName(categoryId: $0.categoryId) == "Movies"}
            self.musics = self.products.filter{CategoryHelper.getCategoryName(categoryId: $0.categoryId) == "Music"}
            self.books = self.products.filter{CategoryHelper.getCategoryName(categoryId: $0.categoryId) == "Books"}
            self.apps = self.products.filter{CategoryHelper.getCategoryName(categoryId: $0.categoryId) == "Applications"}
            DispatchQueue.main.async(execute: {
                self.moviesCollectionView.reloadData()
                self.musicsCollectionView.reloadData()
                self.booksCollectionView.reloadData()
                self.applicationsCollectionView.reloadData()
            })
        }
        
        var contentRect = CGRect.zero
        
        for view in self.mainScrollView.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.mainScrollView.contentSize = contentRect.size
        
        self.searchButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30)
        self.searchButton.setTitle(String.fontAwesomeIcon(name: FontAwesome.search), for: .normal)
        
       
            
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.categoryCollectionView:
            return self.categories.count
        case self.moviesCollectionView:
            return self.movies.count
        case self.musicsCollectionView:
            return self.musics.count
        case self.booksCollectionView:
            return self.books.count
        case self.applicationsCollectionView:
            return self.apps.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.categoryCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
            let category = self.categories[indexPath.row]
            
            cell.displayContent(name: category.name)
            cell.layer.cornerRadius = 8
            
            return cell
        }
        else if(collectionView == self.moviesCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCollectionCell", for: indexPath) as! ProductHomeCollectionViewCell
                
            let movie = self.movies[indexPath.row]
                
            cell.displayContent(title: movie.productName, price: movie.price, imageUrlString: movie.productImage?.first?.imageUrl)
            
            return cell
        }
        else if(collectionView == self.musicsCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "musicsCollectionCell", for: indexPath) as! ProductHomeCollectionViewCell
            
            let music = self.musics[indexPath.row]
            
            cell.displayContent(title: music.productName, price: music.price, imageUrlString: music.productImage?.first?.imageUrl)
            
            return cell
        }
        else if(collectionView == self.booksCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "booksCollectionCell", for: indexPath) as! ProductHomeCollectionViewCell
            
            let book = self.books[indexPath.row]
            
            cell.displayContent(title: book.productName, price: book.price, imageUrlString: book.productImage?.first?.imageUrl)
            
            return cell
        }
        else if(collectionView == self.applicationsCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "appsCollectionCell", for: indexPath) as! ProductHomeCollectionViewCell
            
            let app = self.apps[indexPath.row]
            
            cell.displayContent(title: app.productName, price: app.price, imageUrlString: app.productImage?.first?.imageUrl)
            
            return cell
        }
        else{
          return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "toProductsFromCategoryHome")
        {
            let productListController = segue.destination as! ProductsViewController
            let cell = sender as! CategoryCollectionViewCell
            let indexPath = self.categoryCollectionView.indexPath(for: cell)!
            let category = self.categories[indexPath.row]
            productListController.category = category
        }
        else if segue.identifier == "showMovieDetail"{
            let productDetailController = segue.destination as! ProductDetailViewController
            let cell = sender as! ProductHomeCollectionViewCell
            let indexPath = self.moviesCollectionView.indexPath(for: cell)!
            let movie = self.movies[indexPath.row]
            productDetailController.product = movie
        }
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 2
        let paddingSpace = 10 * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }*/
}

