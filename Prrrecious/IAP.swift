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

//// Fetch the product details
//IAPManager.shared.fetchProduct(productID: productID)
//
//// Check if the product is purchased
//if IAPManager.shared.isPurchased(productID: productID) {
//    print("Product already purchased")
//    // Unlock content
//} else {
//    // Trigger the purchase sheet
//    IAPManager.shared.purchaseProduct()
//}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = IAPManager()

    var product: SKProduct?

    func fetchProduct(productID: String) {
        let request = SKProductsRequest(productIdentifiers: Set([productID]))
        request.delegate = self
        request.start()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            print("Product not found")
            return
        }
        self.product = product
        print("Product fetched: \(product.localizedTitle)")
    }

    func isPurchased(productID: String) -> Bool {
        let receiptUrl = Bundle.main.appStoreReceiptURL
        guard let receipt = try? Data(contentsOf: receiptUrl!) else {
            return false
        }
        let receiptString = receipt.base64EncodedString(options: [])
        // Here, you would send the receiptString to your server to validate the purchase.
        // For simplicity, we assume the purchase is valid if the receipt exists.
        return receiptString.contains(productID)
    }

    func purchaseProduct() {
        guard let product = self.product else {
            print("Product not available")
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

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Purchase successful")
                SKPaymentQueue.default().finishTransaction(transaction)
                // Unlock the purchased content here
            case .failed:
                print("Purchase failed")
                if let error = transaction.error as? SKError {
                    print("Error: \(error.localizedDescription)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                print("Purchase restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                // Restore the purchased content here
            default:
                break
            }
        }
    }
}
