//
//  ViewController.swift
//  GravitySliderExample
//
//  Created by Artem Tevosyan on 9/27/17.
//  Copyright © 2017 Artem Tevosyan. All rights reserved.
//


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var priceButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productSubtitleLabel: UILabel!
    @IBOutlet weak var productTitleLabel: UILabel!
    
    let images = [UIImage(named: "num1"), UIImage(named: "list"), UIImage(named: "cancer")]
    let titles = ["Medical Authenticator", "Medical Information", "Skin Cancer Detection"]
    let subtitles = ["Scan medicines to see if they are authentic", "Research the medical information for a medication", "Test to check the probability of having skin cancer witht the snap of a picture."]
    let prices = ["s t a r t", "s t a r t", "s t a r t"]
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.85
    let collectionViewCellWidthCoefficient: CGFloat = 0.55
    let priceButtonCornerRadius: CGFloat = 25
    let gradientFirstColor = UIColor(hex: "00ff99").cgColor
    let gradientSecondColor = UIColor(hex: "2eb8b8").cgColor
    let cellsShadowColor = UIColor(hex: "00cc99").cgColor
    let productCellIdentifier = "ProductCollectionViewCell"
    
    private var itemsNumber = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configurePriceButton()
    }
    
    private func configureCollectionView() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
        collectionView.collectionViewLayout = gravitySliderLayout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configurePriceButton() {
        priceButton.layer.cornerRadius = priceButtonCornerRadius
    }
    
    private func configureProductCell(_ cell: ProductCollectionViewCell, for indexPath: IndexPath) {
        cell.clipsToBounds = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
        gradientLayer.cornerRadius = 21
        gradientLayer.masksToBounds = true
        cell.layer.insertSublayer(gradientLayer, at: 0)
        
        cell.layer.shadowColor = cellsShadowColor
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 25
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
        
        cell.productImage.image = images[indexPath.row % images.count]
        
    }
    
    private func animateChangingTitle(for indexPath: IndexPath) {
        UIView.transition(with: productTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.productTitleLabel.text = self.titles[indexPath.row % self.titles.count]
        }, completion: nil)
        UIView.transition(with: productSubtitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.productSubtitleLabel.text = self.subtitles[indexPath.row % self.subtitles.count]
        }, completion: nil)
        UIView.transition(with: priceButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.priceButton.setTitle(self.prices[indexPath.row % self.prices.count], for: .normal)
        }, completion: nil)
    }
    
    
    
    @IBAction func didPressPriceButton(_ sender: Any) {
        if(productTitleLabel.text == "Medical Authenticator"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "codecapture") as! QRCodeCapture
            self.present(vc, animated: false, completion: nil)

        }else if(productTitleLabel.text == "Medical Information"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "information") as! QRCodeInformation
            self.present(vc, animated: false, completion: nil)
        }
        
        else if(productTitleLabel.text == "Skin Cancer Detection"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "cancer") as! CancerViewController
            self.present(vc, animated: false, completion: nil)

        }
        
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellIdentifier, for: indexPath) as! ProductCollectionViewCell
        self.configureProductCell(cell, for: indexPath)
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst), let indexPathSecond = collectionView.indexPathForItem(at: locationSecond), let indexPathThird = collectionView.indexPathForItem(at: locationThird), indexPathFirst.row == indexPathSecond.row && indexPathSecond.row == indexPathThird.row && indexPathFirst.row != pageControl.currentPage {
            pageControl.currentPage = indexPathFirst.row % images.count
            self.animateChangingTitle(for: indexPathFirst)
        }
    }
}

