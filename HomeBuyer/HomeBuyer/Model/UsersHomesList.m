//
//  UsersHomesList.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "UsersHomesList.h"
#import <Parse/Parse.h>

static NSString* const kHomesListClassKey = @"HomesList";
static NSString* const kHomesArrayKey = @"HomesArray";

static NSString* const kUserKey          = @"User";
static NSString* const kNumberOfHomesKey = @"NumberOfHomes";

static NSString* const kHomeInfoClassKey = @"HomeInfo";


@interface UsersHomesList ()
@property (nonatomic, strong) PFObject* mParseHomesListObject;
@property (nonatomic, strong) NSMutableArray* mHomesList;
@end

@implementation UsersHomesList

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mParseHomesListObject = nil;
        self.mHomesList = nil;
    }
    
    return self;
}

-(BOOL) readHomesInfo
{
    PFQuery* query = [PFQuery queryWithClassName:kHomesListClassKey];
    [query whereKey:kUserKey equalTo:[[kunanceUser getInstance] getUserID]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *homesList, NSError *error)
     {
         if(!error && homesList)
         {
             self.mParseHomesListObject = homesList;
             [self processHomesList];
         }
         
         if(self.mUsersHomesListDelegate && [self.mUsersHomesListDelegate respondsToSelector:@selector(finishedReadingHomeInfo)])
         {
             [self.mUsersHomesListDelegate finishedReadingHomeInfo];
         }
     }];
    
    return YES;
}

-(BOOL) createNewHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo || !aHomeInfo.mIdentifiyingHomeFeature || !aHomeInfo.mHomeListPrice || !aHomeInfo.mHomeId)
        return NO;

    if([self getCurrentHomesCount] == MAX_NUMBER_OF_HOMES_PER_USER)
        return NO;
    
    __block PFObject* parseHomesListObj = nil;
    
    if(!self.mParseHomesListObject)
    {
        parseHomesListObj = [PFObject objectWithClassName:kHomesListClassKey];
    }
    else
    {
        parseHomesListObj = self.mParseHomesListObject;
    }
    
    if(!self.mHomesList)
        self.mHomesList = [[NSMutableArray alloc] init];
    [self.mHomesList insertObject:aHomeInfo atIndex:self.mHomesList.count];
    
    NSMutableArray* homesDictArray = [[NSMutableArray alloc] init];
    
    for (homeInfo* aHome in self.mHomesList)
    {
        NSDictionary* ahomeDict = [aHome getDictionaryHomeObjectFromHomeInfo];
        [homesDictArray addObject:ahomeDict];
    }
    
    parseHomesListObj[kHomesArrayKey] = homesDictArray;
    
    if(!parseHomesListObj[kUserKey])
        parseHomesListObj[kUserKey] = [[kunanceUser getInstance] getUserID];
    
    if(!parseHomesListObj.ACL)
    {
        PFACL* homesListACL = [PFACL ACLWithUser:[kunanceUser getInstance].mLoggedInKunanceUser];
        parseHomesListObj.ACL = homesListACL;
    }
    
    NSLog(@"Uploading: %@", parseHomesListObj);
    
    [self uploadObject:parseHomesListObj];
    return YES;
}

-(BOOL) updateExistingHomeInfo:(homeInfo*) aHomeInfo
{
    if(!aHomeInfo)
        return NO;
    
    uint homeIndex = aHomeInfo.mHomeId;
    //home ID starts from 1 not 0. THis is bad, need to change this to 0 later
    homeIndex--;
    
    [self.mHomesList replaceObjectAtIndex:homeIndex withObject:aHomeInfo];
    
    NSMutableArray* homesDictArray = [[NSMutableArray alloc] init];
    
    for (homeInfo* aHome in self.mHomesList)
    {
        NSDictionary* ahomeDict = [aHome getDictionaryHomeObjectFromHomeInfo];
        [homesDictArray addObject:ahomeDict];
    }
    
    self.mParseHomesListObject[kHomesArrayKey] = homesDictArray;
    [self uploadObject:self.mParseHomesListObject];
    
    return YES;
}

-(void) uploadObject:(PFObject*) parseHomesListObject
{
    if(!parseHomesListObject)
        return;
    
    [parseHomesListObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if(succeeded && !error)
         {
             self.mParseHomesListObject = parseHomesListObject;
             [self processHomesList];

             if(self.mUsersHomesListDelegate &&
                [self.mUsersHomesListDelegate respondsToSelector:@selector(finishedWritingHomeInfo)])
             {
                 [self.mUsersHomesListDelegate finishedWritingHomeInfo];
             }
         }
         
     }];
}

-(void) processHomesList
{
    NSArray* homes = self.mParseHomesListObject[kHomesArrayKey];
    if(homes && homes.count > 0)
    {
        self.mHomesList = [[NSMutableArray alloc] init];
        
        for (NSDictionary* aHome in homes)
        {
            homeInfo* aHomeInfo = [[homeInfo alloc] initWithDictionary:aHome];
            [self.mHomesList addObject:aHomeInfo];
        }
    }
    else
        self.mHomesList = nil;
}

-(uint) getCurrentHomesCount
{
    if(self.mHomesList)
        return self.mHomesList.count;
    else
        return 0;
}

-(homeInfo*) getHomeAtIndex:(uint) index
{
    if(index >= [self getCurrentHomesCount])
        return nil;
    else
    {
        return (homeInfo*) self.mHomesList[index];
    }

    return nil;
}

-(homeType) getTypeForHomeAtIndex:(uint) index
{
    homeInfo* home = [self getHomeAtIndex:index];
    if(home)
        return home.mHomeType;
    else
        return homeTypeNotDefined;
}
@end
