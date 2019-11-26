// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ObjCGenerator
// **************************************************************************

@interface CNLPerson : NSObject

- (instancetype) initWithChannelDict:(NSDictionary *)dict;
- (NSDictionary *) toChannelDict;
    
@property(nonatomic) NSString *firstName;
@property(nonatomic) NSString *middleName;
@property(nonatomic) NSString *lastName;
@property(nonatomic) NSDate *dateOfBirth;
@property(nonatomic) NSDate *lastOrder;
@property(nonatomic) NSDictionary<NSString *,NSDate *> *idToDate;
@property(nonatomic) NSArray<CNLOrder *> *orders;
@end

@interface CNLOrder : NSObject

- (instancetype) initWithChannelDict:(NSDictionary *)dict;
- (NSDictionary *) toChannelDict;
    
@property(nonatomic) long count;
@property(nonatomic) long itemNumber;
@property(nonatomic) bool isRushed;
@property(nonatomic) CNLItem *item;
@property(nonatomic) NSTimeInterval prepTime;
@property(nonatomic) NSDate *date;
@end

@interface CNLItem : NSObject

- (instancetype) initWithChannelDict:(NSDictionary *)dict;
- (NSDictionary *) toChannelDict;
    
@property(nonatomic) long count;
@property(nonatomic) long itemNumber;
@property(nonatomic) bool isRushed;
@end
