//
//  AStore.swift
//  Aquarius
//
//  Created by SONG JIN on 2025/5/7.
//
import StoreKit
import Foundation

/// 错误信息
public enum AIapError: Error {
    /// 验证失败
    case Fail
    /// 没有产品
    case NoProduct
}
/// 支付状态
public enum AIapState: Int64 {
    /// 开始
    case Start
    /// 支付
    case Pay
    /// 服务器校验
    case Verified
    /// 取消
    case Cancelled
    /// 等待（家庭用户有）
    case Pending
    case Unowned
}
/// 退款错误信息
public enum RefundError: Error {
    /// 重复请求
    case Duplicate
    /// 退款失败
    case Fail
    /// 其它
    case Other
}
/// 退款错误信息
public enum RefundState: Int64 {
    /// 退款成功
    case Success
    /// 取消退款
    case Cancel
    /// 未知
    case Unknown
}

open class AIap {
    public static var shared: AIap = AIap()
    
    typealias KIAPStateBlock = (_ state: AIapState, _ param: [String : Any]?) -> ()
    /// 支付状态回调
    private var iapStateBlock: KIAPStateBlock!
    typealias KRefundStateBlock = (_ state: RefundState, _ param: [String : Any]?) -> ()
    /// 支付状态回调
    private var refundStateBlock: KRefundStateBlock!
    /// 支付事件
    private var updateListenerTask: Task<Void, Error>? = nil
    /// 已购买的商品数组
    public var allRestoreProducts: [Transaction] = []
    /// 获取的商品数组
    ///
    /// **Note: 需执行<doc:products(_:)>方法后，此变量才有值**
    ///
    public var allProducts: [Product]?
    /// 消耗型商品列表
    ///
    /// **Note: 需<doc:allProducts>有值，此处才有值**
    ///
    public var consumableProducts: [Product]? {
        guard allProducts != nil else {
            return nil
        }
            
        return allProducts?.filter({ product in
            product.type == .consumable
        })
    }
    /// 非消耗型商品数组
    ///
    /// **Note: 需<doc:allProducts>有值，此处才有值**
    ///
    public var nonConsumbaleProducts: [Product]? {
        guard allProducts != nil else {
            return nil
        }
            
        return allProducts?.filter({ product in
            product.type == .nonConsumable
        })
    }
    /// 订阅型商品数组
    ///
    /// **Note: 需<doc:allProducts>有值，此处才有值**
    ///
    public var subscriptionProducts: [Product]? {
        guard allProducts != nil else {
            return nil
        }
        
        return allProducts?.filter({ product in
            product.type == .autoRenewable
        })
    }
    /// 非订阅型商品数组
    ///
    /// **Note: 需<doc:allProducts>有值，此处才有值**
    ///
    public var nonSubscriptionProducts: [Product]? {
        guard allProducts != nil else {
            return nil
        }
        
        return allProducts?.filter({ product in
            product.type == .nonRenewable
        })
    }
    
    private init() {
        Task {
            updateListenerTask = listenForTransactions()
        }
    }
    /// 获取商品数组
    /// - Parameter productIDs: 商品ID数组
    /// - Returns: 商品数组
    @discardableResult
    public func products(_ productIDs: [String]) async -> [Product]? {
        allProducts = try? await Product.products(for: Set.init(productIDs))
        
        return allProducts
    }
    /// 获取产品的订阅信息
    /// - Parameter product: Product
    /// - Returns: 订阅信息
    public func getSubscriptionInfo(_ product: Product) -> Product.SubscriptionInfo? {
        let subscriptionInfo: Product.SubscriptionInfo? = product.subscription
        return subscriptionInfo
    }
    /// 获取订阅的更新信息
    /// - Parameter subscriptionInfo: 订阅信息
    /// - Returns: 订阅更新信息
    public func getRenewalInfo(_ subscriptionInfo: Product.SubscriptionInfo) async throws -> Product.SubscriptionInfo.RenewalInfo? {
        do {
            let allStatus: [Product.SubscriptionInfo.Status]? = try await subscriptionInfo.status
            let status: Product.SubscriptionInfo.Status = allStatus![0]
            let renewalInfo: Product.SubscriptionInfo.RenewalInfo = try check(status.renewalInfo)
            
            return renewalInfo
        } catch {
            throw AIapError.NoProduct
        }
    }
    /// 获取订阅的更新信息
    ///
    /// **Sample**
    ///
    /// `swift
    /// let info: Product.SubscriptionInfo.RenewalInfo? = try await renewalInfo(product)
    /// let autoRenewPreference: String? = info?.autoRenewPreference
    /// A.log.info(autoRenewPreference)
    /// `
    /// - Parameter product: product
    /// - Returns: 订阅更新信息
    public func getRenewalInfo(_ product: Product) async throws -> Product.SubscriptionInfo.RenewalInfo? {
        let subscriptionInfo: Product.SubscriptionInfo? = getSubscriptionInfo(product)
        do {
            let allStatus: [Product.SubscriptionInfo.Status]? = try await subscriptionInfo?.status
            let status: Product.SubscriptionInfo.Status = allStatus![0]
            let renewalInfo: Product.SubscriptionInfo.RenewalInfo = try check(status.renewalInfo)
            
            return renewalInfo
        } catch {
            throw AIapError.NoProduct
        }
    }
    /// 获取所有已经购买过的非消耗品和订阅类商品的记录
    ///
    /// **Note: 恢复的商品记录会保存在<doc:allRestoreProducts>中**
    ///
    /// - Parameter isSyncAppStore: 是否到appstore同步
    /// - Returns: 已购买的产品Transaction
    @discardableResult
    public func restoredProducts(_ isSyncAppStore: Bool = false) async throws -> [Transaction] {
        allRestoreProducts.removeAll()
        
        do {
            if isSyncAppStore {
                try await AppStore.sync()
            }
            
            for await entitlement in Transaction.currentEntitlements {
                let transaction = try await verifiedAndFinish(entitlement)
                if transaction == nil {
                    continue
                }
                if transaction!.revocationDate != nil || transaction!.isUpgraded {
                    continue
                }
                // Check if the subscription is expired
                if let expirationDate = transaction!.expirationDate, expirationDate < Date() {
                    continue
                }
                if transaction!.productType == .nonConsumable || transaction!.productType == .autoRenewable {
                    allRestoreProducts.append(transaction!)
                }
            }
            
            return allRestoreProducts
        } catch {
            throw AIapError.Fail
        }
    }
    /// 检查所有交易，如果用户退款，则取消内购标识。
    public func checkAllTransactions() async throws -> [Transaction] {
        var latestTransactions: [String : Transaction] = [ : ]

        for await transaction in Transaction.all {
            do {
                let verifiedTransaction = try check(transaction)
                // 只保留最新的交易
                if let existingTransaction = latestTransactions[verifiedTransaction.productID] {
                    if verifiedTransaction.purchaseDate > existingTransaction.purchaseDate {
                        latestTransactions[verifiedTransaction.productID] = verifiedTransaction
                    }
                } else {
                    latestTransactions[verifiedTransaction.productID] = verifiedTransaction
                }
            } catch {
                print("交易验证失败：\(error)")
                throw AIapError.NoProduct
            }
        }

        var validPurchasedProducts: [Transaction] = []
        
        // 处理最新的交易
        for (_, transaction) in latestTransactions {
            let revocationDate = transaction.revocationDate
            
            if revocationDate == nil {
                validPurchasedProducts.append(transaction)
            }
        }
        
        return validPurchasedProducts

        // **移除所有未在最新交易中的商品**
        /*
        let allPossibleProductIDs: Set<String> = Set(productID) // 所有可能的商品 ID
        let productsToRemove = allPossibleProductIDs.subtracting(validPurchasedProducts)

        for id in productsToRemove {
            removePurchasedState(for: id)
        }
         */
    }
    /// 应用内弹出管理订阅类商品的界面
    /// - Parameter windowScene: scene
    public func showManageSubscriptions() async throws {
        do {
            let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
            try await AppStore.showManageSubscriptions(in: windowScene!)
        } catch {
            throw AIapError.NoProduct
        }
    }
    @available(iOS 17.0, *)
    public func showManageSubscriptions(_ groupID: String) async throws {
        do {
            let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
            try await AppStore.showManageSubscriptions(in: windowScene!, subscriptionGroupID: groupID)
        } catch {
            throw AIapError.NoProduct
        }
    }
    /// 购买某个产品
    /// - Parameter productID: 产品ID
    /// - Returns: 购买结果
    public func purchaseProduct(_ productID: String) async throws -> Transaction? {
        if iapStateBlock != nil {
            iapStateBlock(AIapState.Start,nil)
        }
        
        do {
            let storeProducts = await products([productID]) ?? []
            
            if storeProducts.count > 0 {
                return try await purchase(storeProducts[0])
            } else {
                throw AIapError.NoProduct
            }
        } catch {
            throw AIapError.NoProduct
        }
    }
    /// 购买某个产品
    /// - Parameter product: 产品
    /// - Returns: 购买结果
    public func purchaseProduct(_ product: Product) async throws -> Transaction? {
        if iapStateBlock != nil {
            iapStateBlock(AIapState.Start,nil)
        }
        
        do {
            return try await purchase(product)
        } catch {
            throw AIapError.NoProduct
        }
    }
    
    private func purchase(_ product: Product) async throws -> Transaction? {
        if iapStateBlock != nil {
            iapStateBlock(.Pay, nil)
        }
            
        let result = try await product.purchase()
            
        switch result {
        case .success(let verification):
            let transaction = try await verifiedAndFinish(verification)
            await transaction?.finish()
            return transaction
        case .userCancelled:
            if iapStateBlock != nil {
                iapStateBlock(.Cancelled, nil)
            }
            return nil
        case .pending:
            if iapStateBlock != nil {
                iapStateBlock(.Pending, nil)
            }
            return nil
        default:
            if iapStateBlock != nil {
                iapStateBlock(.Unowned, nil)
            }
            return nil
        }
    }
    /// 退款
    /// - Parameters:
    ///   - productID: 订阅的产品ID
    /// - Returns: 退款状态
    public func refundProduct(_ productID: String) async throws -> RefundState {
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .Unknown
        }
        
        guard case .verified(let transaction) = await Transaction.latest(for: productID) else {
            return .Unknown
        }
        
        do {
            let res = try await transaction.beginRefundRequest(in: windowScene)
            switch res {
            case .userCancelled:
                // Customer cancelled refund request.
                print("用户取消退款。")
                if refundStateBlock != nil {
                    refundStateBlock(RefundState.Cancel,nil)
                }
                
                return .Cancel
            case .success:
                print("退款提交成功。")
                // Refund request was successfully submitted.
                if refundStateBlock != nil {
                    refundStateBlock(RefundState.Success,nil)
                }
                
                return .Success
            @unknown default:
                print("退款返回错误：未知")
                if refundStateBlock != nil {
                    refundStateBlock(RefundState.Unknown,nil)
                }
                
                return .Unknown
            }
        } catch StoreKit.Transaction.RefundRequestError.duplicateRequest {
            print("退款请求错误：重复请求")
            throw RefundError.Duplicate
        } catch StoreKit.Transaction.RefundRequestError.failed {
            print("退款请求错误：失败")
            throw RefundError.Fail
        } catch {
            print("退款请求错误：其他")
            throw RefundError.Other
        }
    }
    // 校验
    private func check<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw AIapError.Fail
        case .verified(let safe):
            print("iap: verified success")
            return safe
        }
    }
    // 校验&完成后传给服务器
    public func verifiedAndFinish(_ verification: VerificationResult<Transaction>) async throws -> Transaction? {
        do {
            let transaction = try check(verification)
            let transactionId = try verification.payloadValue.id
            
            await uploadServer(for: transactionId)
            
            return transaction
        } catch {
            throw AIapError.Fail
        }
    }
    /// 支付监听
    /// - Parameter handler: 回调函数
    /// - Returns: 监听结果
    @discardableResult
    public func listenForTransactions(_ handler: (() -> Void)? = nil) -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.verifiedAndFinish(result)
                    if handler != nil {
                        handler!()
                    }
                    await transaction?.finish()
                } catch {
                    A.log.error("Transaction failed verification")
                }
            }
        }
    }
    @MainActor
    private func uploadServer(for transactionID: UInt64) async {
        let dic: [String : Any] = ["transactionId" : transactionID]
        if iapStateBlock != nil {
            iapStateBlock(.Verified, dic)
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
}
