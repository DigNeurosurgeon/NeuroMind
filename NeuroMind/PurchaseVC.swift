//
//  PurchaseVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 07-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseVC: UIViewController, ContainsScore, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    @IBOutlet weak var textVersionButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    var descriptionText = ""
    
    var score = Score()
    var product: SKProduct?

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionText = "\(score.name) is available for purchase as interactive clinical decision support.\n\n"
        let additionalText = "A description is being loaded from the App Store..."
        descriptionTextView.text = descriptionText.stringByAppendingString(additionalText)
        
        // Configure navigation bar
        navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        navigationItem.leftItemsSupplementBackButton = true
        
        // Activate StoreKit
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        getProductInfo()
    }
    
    
    // MARK:- StoreKit
    
    
    func getProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: score.productID) as! Set<String>)
            request.delegate = self
            request.start()
        } else {
            print("Please enable In App Purchase in Settings")
        }
    }
    
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        var products = response.products
        if products.count > 0 {
            product = products[0]
            purchaseButton.enabled = true
            restorePurchaseButton.enabled = true
            
//            let productTitle = product!.localizedTitle
//            let productDescription = product!.localizedDescription
//            print("Item found with title \"\(productTitle)\" and description \"\(productDescription)\"")
            
            descriptionTextView.text = "\(descriptionText)Description: \(product!.localizedDescription)"
            purchaseButton.setTitle("Buy now for \(product!.localizedPrice())!", forState: .Normal)
        } else {
            print("Item not found")
        }
        
        for item in response.invalidProductIdentifiers {
            print("Item not found: \(item)")
        }
    }
    
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .Purchased:
                unlockItem()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            case .Failed:
                showPurchaseFailedAlert()
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    
    // MARK:- Process purchase
    
    
    func purchaseOrRestoreItem() {
        let payment = SKPayment(product: product!)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }


    func unlockItem() {
        // Save purchase and say thanks
        NSUserDefaults.standardUserDefaults().setValue(score.productID, forKey: score.productID)
        purchaseButton.setTitle("Thank you!", forState: .Normal)
        purchaseButton.enabled = false
        textVersionButton.hidden = true
        restorePurchaseButton.hidden = true
        
        // Load CDSS
        switch score.id {
        case 83:
            openStoryboardWithName("SINS", asType: SINS_TVC.self, forScore: score)
        case 180:
            openStoryboardWithName("PHASES", asType: PHASES_TVC.self, forScore: score)
        default:
            openStoryboardWithName("ScoreDetail", asType: ScoreDetailVC.self, forScore: score)
        }
    }
    
    
    func openStoryboardWithName<T: UIViewController where T: ContainsScore>(name: String, asType type: T.Type, forScore score: Score) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! T
        controller.title = score.name
        controller.score = score
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }
    
    
    func showPurchaseFailedAlert() {
        let alertController = UIAlertController(title: "Error", message: "Sorry, your purchase failed. Please try again.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // MARK:- Button actions
    
    
    @IBAction func purchaseButtonTapped(sender: AnyObject) {
        purchaseOrRestoreItem()
    }
    

    @IBAction func textVersionButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "ScoreDetail", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! ScoreDetailVC
        controller.score = score
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
    }

    
    @IBAction func restorePurchaseButtonTapped(sender: AnyObject) {
        purchaseOrRestoreItem()
    }
    
}


// MARK:- SKProduct extension


extension SKProduct {
    
    func localizedPrice() -> String {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        formatter.locale = self.priceLocale
        return formatter.stringFromNumber(self.price)!
    }
    
}

