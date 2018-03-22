//
//  ProductsViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 05/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var productListTable: UITableView!
    
    var category : Category!
    var products : [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.category.name
        
        ProductAPIClient.getProductListFromCategoryId(categoryId: self.category.id){ (products) in
            self.products = products!
            DispatchQueue.main.async(execute: {
                self.productListTable.reloadData()
            })
            print(self.products.count)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productListTableCell", for: indexPath) as? ProductListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let product = self.products[indexPath.row]
        
        cell.displayContent(title: product.productName, price: product.price, imageUrlString: product.productImage?.first?.imageUrl)
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toProductDetail"){
            let productDetailController = segue.destination as! ProductDetailViewController
            let cell = sender as! ProductListTableViewCell
            let indexPath = self.productListTable.indexPath(for: cell)!
            let product = self.products[indexPath.row]
            productDetailController.product = product
        }
    }
    

}
