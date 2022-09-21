//
//  Store.swift
//  TimeIt
//
//  Created by Subhash on 21/09/22.
//

import Foundation

import StoreKit

class PurchaseManager : ObservableObject {
    @Published var products : [Product] = []
    @Published var purchasedIds : [String] = []
    
    func fetchProduct(){
        Task.init{
            do{
                let productIdentifiers = ["in.pseudocoder.timeit"]
                let products = try await Product.products(for: productIdentifiers)
                DispatchQueue.main.async {
                    self.products = products
                }
                if let product = products.first {
                    await isPurchased(product: product)
                }
            } catch{
                print(error)
            }
        }
    }
    
    func isPurchased(product: Product) async{
        guard let state = await product.currentEntitlement else {
            return
        }
        switch state {
        case .verified(let transaction):
            DispatchQueue.main.async {
                self.purchasedIds.append(transaction.productID)
            }
            break
        case .unverified(_):
            break
        }
    }
    
    func purchase() {
        Task.init {
            guard let product = products.first else {return}
            do {
                let result = try await product.purchase()
                switch result {
                case .success(let verification):
                    switch verification{
                    case .verified(let transaction):
                        DispatchQueue.main.async {
                            self.purchasedIds.append(transaction.productID)
                        }
                        break
                    case .unverified(_):
                        break
                    }
                    break
                case .pending:
                    break
                case .userCancelled:
                    break
                @unknown default:
                    break
                }
            } catch {
                print(error)
            }
        }
    }
}
