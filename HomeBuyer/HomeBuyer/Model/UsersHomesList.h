//
//  UsersHomesList.h
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "homeInfo.h"

#define MAX_NUMBER_OF_HOMES_PER_USER 2

@protocol UsersHomesListDelegate <NSObject>
@optional
-(void) finishedWritingHomeInfo;
-(void) finishedReadingHomeInfo;
@end


@interface UsersHomesList : NSObject
@property (nonatomic, weak) id <UsersHomesListDelegate> mUsersHomesListDelegate;

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo;
-(BOOL) updateExistingHomeInfo:(homeInfo*) aHomeInfo;
-(BOOL) readHomesInfo;

-(uint) getCurrentHomesCount;
-(homeInfo*) getHomeAtIndex:(uint) index;
-(homeType) getTypeForHomeAtIndex:(uint) index;
@end
