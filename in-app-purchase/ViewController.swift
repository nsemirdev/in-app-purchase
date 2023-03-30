//
//  ViewController.swift
//  in-app-purchase
//
//  Created by Emir Alkal on 30.03.2023.
//

import UIKit
import StoreKit

class ViewController: UITableViewController, SKPaymentTransactionObserver {
    private let productId = "dev.nsemir.premium_quotes"
    private var quotes = [
        "Quote 1",
        "Quote 2",
        "Quote 3",
        "Quote 4",
        "Quote 5",
        "Quote 6",
    ]
    
    private let premiumQuotes = [
        "Premium Quote 7",
        "Premium Quote 8",
        "Premium Quote 9",
        "Premium Quote 10",
        "Premium Quote 11",
        "Premium Quote 12",
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        
        if isPurchased() {
            showPremiumQotes()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPurchased() {
            return quotes.count
        }
        return quotes.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        
        if indexPath.row >= quotes.count {
            cell.textLabel?.text = "Get more quotes"
            cell.textLabel?.textColor = .blue
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.textLabel?.text = quotes[indexPath.row]
            cell.textLabel?.textColor = .label
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotes.count {
            buyPremiumQuotes()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func restorePressed() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("user can't make payments")
        }
    }
    
    func showPremiumQotes() {
        quotes += premiumQuotes
        tableView.reloadData()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                UserDefaults.standard.set(true, forKey: productId)
                showPremiumQotes()
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .restored {
                UserDefaults.standard.set(true, forKey: productId)
                showPremiumQotes()
                SKPaymentQueue.default().finishTransaction(transaction)
                navigationItem.setRightBarButton(nil, animated: true)
                print("transaction restored")
            }
        }
    }
    
    func isPurchased() -> Bool {
        let ispurchased = UserDefaults.standard.bool(forKey: productId)
        
        if ispurchased {
            print("previously purchased")
            return true
        } else {
            print("never purchased before")
            return false
        }
    }
}

