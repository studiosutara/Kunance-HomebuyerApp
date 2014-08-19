//
//  userLoansInfo.m
//  HomeBuyer
//
//  Created by Shilpa Modi on 9/8/13.
//  Copyright (c) 2013 Kunance. All rights reserved.
//

#import "usersLoansList.h"
#import "loan.h"

static NSString* const kLoanListClassKey = @"LoansList";
static NSString* const kLoanListArrayKey = @"LoansListArray";
static NSString* const kUserKey = @"user";
@interface usersLoansList()
//For now each user will only have a single loan object
@property (nonatomic, strong) NSMutableArray* mUsersLoans;
@property (nonatomic, strong) PFObject* mLoanListParseObject;
@end

@implementation usersLoansList

-(id) init
{
    self = [super init];
    
    if(self)
    {
        self.mUsersLoans = nil;
        self.mLoanListParseObject = nil;
    }
    
    return self;
}

-(uint) getCurrentLoanCount
{
    if(self.mUsersLoans)
        return self.mUsersLoans.count;
    else
        return 0;
}

-(loan*) getLoanInfo
{
    if(![self getCurrentLoanCount])
        return nil;
    return (loan*)self.mUsersLoans[0];
}

-(BOOL) readLoanInfo
{
    PFQuery* query = [PFQuery queryWithClassName:kLoanListClassKey];
    [query whereKey:kUserKey equalTo:[[kunanceUser getInstance] getUserID]];
    
    NSLog(@"Query: %@", [[kunanceUser getInstance] getUserID]);
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *loansList, NSError *error)
     {
         if(!error && loansList)
         {
             self.mUsersLoans = [[NSMutableArray alloc] init];
             self.mLoanListParseObject = loansList;
             for (NSDictionary* dict in loansList[kLoanListArrayKey])
             {
                 loan* aLoan = [[loan alloc] initWithDictionary:dict];
                 [self.mUsersLoans addObject:aLoan];
             }
         }
         
         if(self.mLoansListDelegate && [self.mLoansListDelegate respondsToSelector:@selector(finishedReadingLoanInfo)])
         {
             [self.mLoansListDelegate finishedReadingLoanInfo];
         }
     }];
    
    return YES;

}

-(BOOL) writeLoanInfo:(loan *)aLoan
{
    if(!aLoan)
        return NO;
    
    if(!self.mLoanListParseObject)
        self.mLoanListParseObject = [PFObject objectWithClassName:kLoanListClassKey];
    
    NSArray* loansListDictArray = [[NSArray alloc] initWithObjects:[aLoan getDictionaryObjectWithLoan], nil];
    self.mLoanListParseObject[kLoanListArrayKey] = loansListDictArray;
    
    if(!self.mLoanListParseObject[kUserKey])
        self.mLoanListParseObject[kUserKey] = [[kunanceUser getInstance] getUserID];
    
    if(!self.mLoanListParseObject.ACL)
    {
        PFACL* loansListACL = [PFACL ACLWithUser:[kunanceUser getInstance].mLoggedInKunanceUser ];
        self.mLoanListParseObject.ACL = loansListACL;
    }
    
    [self.mLoanListParseObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if(succeeded && !error)
         {
             self.mUsersLoans = [[NSMutableArray alloc] init];
             for (NSDictionary* dict in self.mLoanListParseObject[kLoanListArrayKey])
             {
                 loan* aLoan = [[loan alloc] initWithDictionary:dict];
                 
                 [self.mUsersLoans addObject:aLoan];
             }
             
             if(self.mLoansListDelegate &&
                [self.mLoansListDelegate respondsToSelector:@selector(finishedWritingLoanInfo)])
             {
                 [self.mLoansListDelegate finishedWritingLoanInfo];
             }
         }
         
     }];

    return YES;
}

@end
