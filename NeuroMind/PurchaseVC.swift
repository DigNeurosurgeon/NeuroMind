//
//  PurchaseVC.swift
//  NeuroMind
//
//  Created by Pieter Kubben on 07-12-15.
//  Copyright © 2015 DigitalNeurosurgeon.com. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseVC: UIViewController, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    var score: Score!
    var product: SKProduct?
    var productID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            let request = SKProductsRequest(productIdentifiers: NSSet(objects: self.productID!) as! Set<String>)
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
            
            let productTitle = product!.localizedTitle
            let productDescription = product!.localizedDescription
            purchaseButton.setTitle("Buy now for \(product!.localizedPrice())!", forState: .Normal)
            print("Item found with title \"\(productTitle)\" and description \"\(productDescription)\"")
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
                print("Purchase failed")
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
        NSUserDefaults.standardUserDefaults().setValue(productID, forKey: productID!)
        purchaseButton.setTitle("Thank you!", forState: .Normal)
        purchaseButton.enabled = false
        restorePurchaseButton.enabled = false
        
        // Load CDSS
        let storyboard = UIStoryboard(name: "PHASES", bundle: nil)
        let controller = storyboard.instantiateInitialViewController() as! PHASES_TVC
        controller.title = score.name
        controller.score = score
        let navigationController = UINavigationController(rootViewController: controller)
        splitViewController?.showDetailViewController(navigationController, sender: nil)
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

