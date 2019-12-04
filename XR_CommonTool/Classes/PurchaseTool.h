//
//  PurchaseTool.h
//  FunnyCam
//
//  Created by DreamCity on 2019/9/5.
//  Copyright © 2019 funnyCam. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol PurchaseToolDelegate <NSObject>

- (void)popVerifyPayingStatus:(BOOL)status;

@end

typedef NS_ENUM(NSInteger, IAPPayStateType) {
    IAPPayStateTypeSuccess = 0,       // 购买成功
    IAPPayStateTypeFailed = 1,        // 购买失败
    IAPPayStateTypeCancel = 2,        // 取消购买
    IAPPayStateTypeVerFailed = 3,     // 订单校验失败
    IAPPayStateTypeVerSuccess = 4,    // 订单校验成功
    IAPPayStateTypeNotArrow = 5,      // 不允许内购
};

typedef void (^IAPPayCompletionHandle)(IAPPayStateType type,NSData * _Nullable data);
typedef void(^IAPProductBlock)(NSArray * _Nullable products);

@interface PurchaseTool : NSObject

@property (strong, nonatomic) NSString *PopProID;
@property (nullable, copy, nonatomic) IAPProductBlock PopRequestProductsBlock;
@property (nonatomic, weak) id <PurchaseToolDelegate> delegate;

/// AppStore 内购解密串m, 初始化成功后,这个属性一定要赋值
@property (nonatomic, copy) NSString *purchSecret ;

+ (PurchaseTool *)PopTools;

//Purchase
- (void)PopPayingWithProductID:(NSString *)productID andCompleteHandle:(IAPPayCompletionHandle)handle;

//Restore
- (void)PopRestoreWithCompleteHandle:(IAPPayCompletionHandle)handle;

//Verify
- (BOOL)PopVerifyPayingStatus;

- (void)PopRequestProducts:(NSArray *)productIDs andBlock:(IAPProductBlock)block;

@end
NS_ASSUME_NONNULL_END
