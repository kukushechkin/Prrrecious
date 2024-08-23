//
//  IAP.swift
//  Prrrecious
//
//  Created by Vladimir Kukushkin on 22.8.2024.
//

import Foundation
import StoreKit

let manyFilesProductID = "com.kukushechkin.Prrrecious.manyFiles"
let maxFreeFiles = 5

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()

    var products: [String: SKProduct] = [:]
    var manyFilesPurchased = false

    func fetchProducts() {
        // Fetch products
        let request = SKProductsRequest(productIdentifiers: Set([
            manyFilesProductID
        ]))
        request.delegate = self
        request.start()

        // Restore purchases
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func isPurchased(productID: String) -> Bool {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        guard let _ = try? Data(contentsOf: receiptUrl!) else {
            return false
        }
        if productID == manyFilesProductID {
            return self.manyFilesPurchased
        }
        return false
    }

    func purchase(productID: String) {
        guard let product = self.products[productID] else {
            print("Product \(productID) not available")
            return
        }
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            print("User cannot make payments")
        }
    }

    private func enableFeaturesForTransaction(_ transaction: SKPaymentTransaction) {
        if transaction.payment.productIdentifier == manyFilesProductID {
            self.manyFilesPurchased = true
        }
    }
}


// MARK: - SKProductsRequestDelegate, SKPaymentTransactionObserver
extension IAPManager {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        for product in response.products {
            print("Product fetched: \(product.productIdentifier)")
            self.products[product.productIdentifier] = product
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.enableFeaturesForTransaction(transaction)
            case .failed:
                print("Purchase failed: \(transaction.payment.productIdentifier)")
                if let error = transaction.error as? SKError {
                    print("Error: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Purchase restored: \(transaction.payment.productIdentifier)")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.enableFeaturesForTransaction(transaction)
            default:
                break
            }
        }
    }
}
