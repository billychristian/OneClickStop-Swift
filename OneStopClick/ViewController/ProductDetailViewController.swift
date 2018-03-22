//
//  ProductDetailViewController.swift
//  OneStopClick
//
//  Created by Billy Christian on 07/03/18.
//  Copyright © 2018 Billy Christian. All rights reserved.
//

import UIKit
import WebKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var trailerButton: UIButton!
    @IBOutlet weak var productDesc: UILabel!
    @IBOutlet weak var productCompatibility: UILabel!
    @IBOutlet weak var productCreatedAt: UILabel!
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var reviewView: UIView!
    @IBOutlet weak var trailerView: UIView!
    
    @IBOutlet weak var reviewUser: UILabel!
    @IBOutlet weak var reviewDescription: UILabel!
    
    @IBOutlet weak var moreReviewBtn: UIButton!
    
    @IBOutlet weak var webView: WKWebView!
    
    var product : Product!
    var reviews : [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getReviews()
        
        self.setTrailer()
        
        productTitle.text = product.productName
        
        if  product.price != 0 {
            let priceValue = String(format: "%.2f", product.price)
            buyButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 12)
            let icon = String.fontAwesomeIcon(code: "fa-shopping-cart")
            buyButton.setTitle(icon! + " Buy this product for Rp. \(priceValue)", for: .normal)
        }
        else{
            buyButton.setTitle("Get it for FREE", for: .normal)
        }
        
        setButtonTitle(button: detailButton, icon: "fa-info", text: "details")
        setButtonTitle(button: reviewButton, icon: "fa-star", text: "reviews")
        setButtonTitle(button: trailerButton, icon: "fa-film", text: "trailer")
        
        setActiveSection(button: detailButton)
        
        setProductDetail()

        if let imageUrl = URL(string: (product.productImage?.first?.imageUrl)!){
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: imageUrl) { (data, response, error) in
                if let e = error {
                    print("Error downloading product picture: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Downloaded product picture with response code \(res.statusCode)")
                        if let imageData = data {
                            DispatchQueue.main.async(execute: {
                                let image = UIImage(data: imageData)
                                self.productImage.image = image
                            })
                        } else {
                            print("Couldn't get image: Image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getReviews(){
        ReviewAPIClient.getProductReview(productId: self.product.id){ (reviews) in
            self.reviews = reviews!
            DispatchQueue.main.async(execute: {
                if self.reviews.count > 0{
                    self.reviewUser.text = self.reviews.first?.user.name
                    self.reviewDescription.text = self.reviews.first?.reviewDescription
                } else{
                    self.reviewDescription.isHidden = true
                    self.moreReviewBtn.isHidden = true
                }
            })
        }
    }
    
    func setTrailer(){
        let url = URL(string : "https://www.youtube.com/embed/2UCPMRM-kHk")
        
        let request = URLRequest(url: url!)
        
        webView.load(request)
    }
    
    func setButtonTitle(button: UIButton, icon: String, text: String){
        let icon = String.fontAwesomeIcon(code: icon)
        let text = icon! + "\n" + text
        
        let buttonStringAttributed = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font:UIFont(name: "HelveticaNeue", size: 11.00)!])
        buttonStringAttributed.addAttribute(NSAttributedStringKey.font, value: UIFont.fontAwesome(ofSize: 20), range: NSRange(location: 0,length: 1))
        
        
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        
        button.setAttributedTitle(buttonStringAttributed, for: .normal)
    }
    
    @IBAction func changeSection(_ sender: UIButton) {
        setActiveSection(button: sender)
    }
    
    func setActiveSection(button: UIButton){
        detailButton.isSelected = false
        reviewButton.isSelected = false
        trailerButton.isSelected = false
        
        button.isSelected = true
        
        descriptionView.isHidden = true
        reviewView.isHidden = true
        trailerView.isHidden = true
        
        switch button {
        case detailButton:
            descriptionView.isHidden = false
        case reviewButton:
            reviewView.isHidden = false
        case trailerButton:
            trailerView.isHidden = false
        default:
            break
        }
        
    }
    
    func setProductDetail(){
        self.productDesc.text = self.product.productDescription
        
        self.productCompatibility.text = self.product.compatibility
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let dateString = dateFormatter.string(from:self.product.createdDate)
        
        self.productCreatedAt.text = dateString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
