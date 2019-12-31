//
//  PurchaseTool.m
//  FunnyCam
//
//  Created by DreamCity on 2019/9/5.
//  Copyright © 2019 funnyCam. All rights reserved.
//

#import "PurchaseTool.h"
#import <StoreKit/StoreKit.h>
#import <SVProgressHUD/SVProgressHUD.h>


@interface PurchaseTool()<SKPaymentTransactionObserver,SKProductsRequestDelegate> {
    NSData *_CRPayData;
    BOOL _PopBusying;
    BOOL _PopCanExist;
    BOOL _PopIsTestServer;
    BOOL _PopCanRestore;
    BOOL _PopIsPaying;
}

@property (copy, nonatomic) IAPPayCompletionHandle PopHandle;

@end

@implementation PurchaseTool

static PurchaseTool *_PopTools = nil;
+ (PurchaseTool *)PopTools {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _PopTools = [[PurchaseTool alloc] init];
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_PopTools];
    });
    return _PopTools;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _PopIsTestServer = NO;
        _PopCanRestore = YES;
        _PopIsPaying = YES;
        
    }
    return self;
}



- (void)dealloc{

    NSLog(@"IAP manager dealloc!~");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

//请求商品列表
- (void)PopRequestProducts:(NSArray *)productIDs andBlock:(IAPProductBlock)block {
    _PopRequestProductsBlock = block;
    NSSet *nsset = [NSSet setWithArray:productIDs];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    request.delegate = self;
    [request start];
}


#pragma mark - Public Method
- (void)PopPayingWithProductID:(NSString *)productID
             andCompleteHandle:(IAPPayCompletionHandle)handle {
    _PopProID = productID;
    [SVProgressHUD showWithStatus:@"Loading..."];
    if (_PopBusying) {
        return;
    }
    _PopBusying = YES;
    _PopCanExist = YES;
    
    
    if ([SKPaymentQueue canMakePayments]) {
        // 开始购买服务
        self.PopHandle = handle;
        NSSet *nsset = [NSSet setWithArray:@[productID]];
        SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
        request.delegate = self;
        
        NSLog(@"IAP purchase request start ~~");
        [request start];
    } else {
        [self PopHandleActionWithType:IAPPayStateTypeNotArrow data:nil];
        NSLog(@"IAP purchase request not allow ~~");
    }
}

- (void)PopRestoreWithCompleteHandle:(IAPPayCompletionHandle)handle {
    if (_PopBusying) {
        return;
    }
    _PopBusying = YES;
    _PopCanExist = YES;
    _PopCanRestore = YES;
     [SVProgressHUD showInfoWithStatus:@"Restore Transaction..."];
    self.PopHandle = handle;
    
    NSLog(@"IAP restore transactions start --");
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (BOOL)PopVerifyPayingStatus {
    _PopIsPaying = NO;
    BOOL isPayed = [self PopVerifyPurchaseWithPaymentTransaction:nil
                                                    isTestServer:_PopIsTestServer];

    return isPayed;
}


#pragma mark ----------> SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if (_PopRequestProductsBlock) {
        _PopRequestProductsBlock(response.products);
        return;
    }
    if([product count] <= 0) {
        NSLog(@"IAP SKProductsRequestDelegate - no product!");
        
        [self PopHandleActionWithType:IAPPayStateTypeFailed data:nil];
        return;
    }
    
    SKProduct *p = nil;
    for(SKProduct *pro in product) {
        if([pro.productIdentifier isEqualToString:_PopProID]){
            p = pro;
            break;
        }
    }
    
    NSLog(@"IAP SKProductsRequestDelegate product info!");
    NSLog(@"IAP productID: %@", response.invalidProductIdentifiers);
    NSLog(@"IAP product pay count: %lu",(unsigned long)[product count]);
    NSLog(@"IAP %@",[p description]);
    NSLog(@"IAP %@",[p localizedTitle]);
    NSLog(@"IAP %@",[p localizedDescription]);
    NSLog(@"IAP %@",[p price]);
    NSLog(@"IAP %@",[p productIdentifier]);
    NSLog(@"IAP Send payment request!");
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    //    NSLog(@"IAP SKRequestDelegate Fail: %@", [error getErrorDescription]);
    [self PopHandleActionWithType:IAPPayStateTypeFailed data:nil];
}


#pragma mark --------> SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    NSLog(@"IAP SKPTObserver updatedTransactions!");
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
                NSLog(@"IAP Transaction is in queue, user has been charged.  Client should complete the transaction.");
                if (_PopIsPaying) {
                     [SVProgressHUD showInfoWithStatus:@"Waiting"];
                }
                [self PopVerifyPurchaseWithPaymentTransaction:tran isTestServer:_PopIsTestServer Compl:^(NSDate *date) {
                }];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"IAP Transaction is being added to the server queue.");
                break;
            case SKPaymentTransactionStateRestored:
                if (_PopCanRestore) {
                    NSLog(@"IAP Transaction was restored from user's purchase history.  Client should complete the transaction.");
                    _PopCanRestore = NO;
                    [self PopVerifyPurchaseWithPaymentTransaction:tran isTestServer:_PopIsTestServer Compl:^(NSDate *date) {
                    }];
                }
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"IAP Transaction was cancelled or failed before being added to the server queue.");
                if (tran.error.code != SKErrorPaymentCancelled) {
                    [self PopHandleActionWithType:IAPPayStateTypeFailed data:nil];
                } else {
                    [self PopHandleActionWithType:IAPPayStateTypeCancel data:nil];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"IAP The transaction is in the queue, but its final status is pending external action.");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            default:
                break;
        }
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    //    NSLog(@"IAP restoreCompletedTransactionsFailedWithError : %@", [error getErrorDescription]);
    
    [self PopHandleActionWithType:IAPPayStateTypeFailed data:nil];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"IAP paymentQueueRestoreCompletedTransactionsFinished.");
    
    [self PopVerifyPurchaseWithPaymentTransaction:nil isTestServer:NO Compl:^(NSDate *date) {
        NSLog(@"IAP Restore completed transactions finished date = %@", date);
    }];
}

#pragma mark - Private Method
/// Final exist method
- (void)PopHandleActionWithType:(IAPPayStateType)type data:(NSData *)data{
    switch (type) {
        case IAPPayStateTypeSuccess:
            NSLog(@"IAP purchase success!");
            break;
        case IAPPayStateTypeFailed:
            NSLog(@"IAP purchase failed!");
            break;
        case IAPPayStateTypeCancel:
            NSLog(@"IAP purchase cancelled!");
            break;
        case IAPPayStateTypeVerFailed:
            NSLog(@"IAP purchase verify failed!");
            break;
        case IAPPayStateTypeVerSuccess:
            NSLog(@"IAP purchase verify success!");
            break;
        case IAPPayStateTypeNotArrow:
            NSLog(@"IAP purchase not allowed!");
            break;
        default:
            break;
    }
    
    _PopBusying = NO;
    _PopCanRestore = YES;
    _PopIsPaying = YES;
    [SVProgressHUD dismiss];
    if(self.PopHandle && _PopCanExist){
        _PopCanExist = NO;
        self.PopHandle(type,data);
    }
}

/// Verify receipt
- (BOOL)PopVerifyReceiptStatus {
    
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    
    
    if(!receipt){
        return NO;
    }
    
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                      @"password": [PurchaseTool PopTools].purchSecret
                                      };
    _CRPayData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    
    if (!_CRPayData) {
        return NO;
    }
    return YES;
}


- (void)PopRequestVerifyDataWithTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)isTestServer {
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (isTestServer) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:_CRPayData];
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:storeRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //NSLog(@"IAP verify fail : %@", [error getErrorDescription]);
            [self PopHandleActionWithType:IAPPayStateTypeVerFailed data:nil];
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                NSLog(@"IAP verify response data is nil");
                [self PopHandleActionWithType:IAPPayStateTypeVerFailed data:nil];
                return;
            }
            
            // 先验证正式服务器，如果正式服务器返回21007再去苹果测试服务器验证，沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@", jsonResponse[@"status"]];
            if (status && [status isEqualToString:@"21007"]) {
                self->_PopIsTestServer = YES;
                [self PopRequestVerifyDataWithTransaction:transaction isTestServer:self->_PopIsTestServer];
            } else if (status && [status isEqualToString:@"0"]) {
                //  验证成功，保存最新的过期时间
                NSDate *currentDate = [self PopGetCurrentDateFromResponse:jsonResponse];
                NSDate *expiresDate = [self PopExpirationDateFromResponse:jsonResponse];
                
                NSLog(@"IAP -------------------");
                NSLog(@"IAP void current date = %@", currentDate);
                NSLog(@"IAP void expires date = %@", expiresDate);
                NSLog(@"IAP -------------------");
                
                if (currentDate &&
                    expiresDate &&
                    ([[currentDate earlierDate:expiresDate] compare:currentDate] == NSOrderedSame)) {
                     [SVProgressHUD showInfoWithStatus:@"Authentication is Successful"];
                    [self PopHandleActionWithType:IAPPayStateTypeVerSuccess data:nil];
                }else{
                    [self PopHandleActionWithType:IAPPayStateTypeVerFailed data:nil];
                }
            } else {
                NSLog(@"IAP jsonResponse status = %@", status);
                [self PopHandleActionWithType:IAPPayStateTypeFailed data:data];
            }
        }
    }];
    [task resume];
    
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
    if (transaction) {
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)PopVerifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)isTestServer Compl:(void (^)(NSDate *))compl{
    
    if (![self PopVerifyReceiptStatus]) {
        [self PopHandleActionWithType:IAPPayStateTypeVerFailed data:nil];
        if (transaction) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        return;
    }
    
    [self PopRequestVerifyDataWithTransaction:transaction isTestServer:isTestServer];
}

- (BOOL)PopVerifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)isTestServer {
    
    if (![self PopVerifyReceiptStatus]) {
        return NO;
    }
    
    return [self PopRequestVerifyStatusWithTransaction:transaction isTestServer:isTestServer];
}

- (BOOL)PopRequestVerifyStatusWithTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)isTestServer {
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (isTestServer) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:_CRPayData];
    
    NSURLResponse *resp;
    NSError *sessionErr;
    NSData *backData = [self PopSendSynchronousRequest:storeRequest returningResponse:&resp error:&sessionErr];
    if (sessionErr) {
        return NO;
    } else {
        NSError *error;
        NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:backData options:0 error:&error];
        if (!jsonResponse) {
            // 苹果服务器校验数据返回为空校验失败
            return NO;
        }
        
        // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
        NSString *status = [NSString stringWithFormat:@"%@", jsonResponse[@"status"]];
        NSLog(@"%@", jsonResponse);
        if (status && [status isEqualToString:@"21007"]) {
            _PopIsTestServer = YES;
            return [self PopVerifyPurchaseWithPaymentTransaction:transaction isTestServer:_PopIsTestServer];
        } else if(status && [status isEqualToString:@"0"]){
            //  验证成功，保存最新的过期时间
            //            NSLog(@"%@", jsonResponse);
            
            NSDate *currentDate = [self PopGetCurrentDateFromResponse:jsonResponse];
            NSDate *expiresDate = [self PopExpirationDateFromResponse:jsonResponse];
            
            NSLog(@"IAP -------------------");
            NSLog(@"IAP BOOL current date = %@", currentDate);
            NSLog(@"IAP BOOL expires date = %@", expiresDate);
            NSLog(@"IAP -------------------");
            
            BOOL invalidDate = currentDate && expiresDate && ([[currentDate earlierDate:expiresDate] compare:currentDate] == NSOrderedSame);
            return invalidDate;
        } else {
            return NO;
        }
    }
    return NO;
}


#pragma mark - date   setting
- (NSDate *)PopExpirationDateFromResponse:(NSDictionary *)jsonResponse{
    
    NSArray* receiptInfo = jsonResponse[@"latest_receipt_info"];
    if(receiptInfo){
        NSDictionary* lastReceipt = receiptInfo.lastObject;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss VV";
        
        NSDate* expirationDate  = [formatter dateFromString:lastReceipt[@"expires_date"]];
        
        return expirationDate;
    } else {
        return nil;
    }
}

- (NSDate *)PopGetCurrentDateFromResponse:(NSDictionary *)jsonResponse{
    
    NSDictionary* receipt = jsonResponse[@"receipt"];
    if(receipt){
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss VV";
        
        NSDate* expirationDate  = [formatter dateFromString:receipt[@"request_date"]];
        
        return expirationDate;
    } else {
        return nil;
    }
}


#pragma mark - session sys
- (NSData *)PopSendSynchronousRequest:(NSURLRequest *)request returningResponse:(NSURLResponse **)response error:(NSError **)error{
    NSError __block *err = NULL;
    NSData __block *data;
    BOOL __block reqProcessed = false;
    NSURLResponse __block *resp;
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable _data, NSURLResponse * _Nullable _response, NSError * _Nullable _error) {
        resp = _response;
        err = _error;
        data = _data;
        reqProcessed = true;
    }] resume];
    
    while (!reqProcessed) {
        [NSThread sleepForTimeInterval:0];
    }
    *response = resp;
    *error = err;
    return data;
}

@end
