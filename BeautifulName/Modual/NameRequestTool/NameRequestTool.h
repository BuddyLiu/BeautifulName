//
//  NameRequestTool.h
//  BeautifulName
//
//  Created by Paul on 2019/3/13.
//  Copyright © 2019 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NamesArrBlock)(NSArray *arr);
typedef void(^ErrorBlock)(NSString *msg);

@interface NameRequestTool : NSObject

GD_SINGLETON(NameRequestTool)

-(void)preRequestData;
-(void)requestAllNamesNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock;
-(void)requestAllNamesDetailNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock;
-(void)requestNamesDetailWithWord:(NSString *)word namesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock;
-(void)requestWithGender:(BOOL)isBoy namesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock;
-(void)requestCNAllFirstNameNamesArrBlock:(NamesArrBlock)block errorBlock:(ErrorBlock)errorBlock;


@end

NS_ASSUME_NONNULL_END
