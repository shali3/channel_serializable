// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ObjCGenerator
// **************************************************************************

#import "example.g.h"

@implementation CNLPerson

- (instancetype) initWithChannelDict:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.firstName = dict[@"firstName"];
    self.middleName = dict[@"middleName"];
    self.lastName = dict[@"lastName"];
    self.dateOfBirth = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[@"dateOfBirth"] longValue]/1000000.0];
    self.lastOrder = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[@"lastOrder"] longValue]/1000000.0];
    self.idToDate = [self deserialize_idToDate:dict[@"idToDate"]];
    self.orders = [self deserialize_orders:dict[@"orders"]];
  }
  return self;

}
- (NSDictionary *) toChannelDict {
  return @{
    @"firstName": self.firstName,
    @"middleName": self.middleName,
    @"lastName": self.lastName,
    @"dateOfBirth": @(self.dateOfBirth.timeIntervalSince1970*1000000),
    @"lastOrder": @(self.lastOrder.timeIntervalSince1970*1000000),
    @"idToDate": [self serialize_idToDate],
    @"orders": [self serialize_orders]
  };
}

-(NSDictionary<NSString *,NSDate *> *) deserialize_idToDate:(NSDictionary *)dict {
  NSMutableDictionary * retVal = [NSMutableDictionary new];
  for (id key in dict) {
    id deserializedKey = key;
    id deserializedVal = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[key] longValue]/1000000.0];      
    retVal[deserializedKey] = deserializedVal;
  }
  return retVal;
}

-(NSDictionary *) serialize_idToDate {
  NSMutableDictionary * retVal = [NSMutableDictionary new];
  for (id key in self.idToDate) {
    id serializedKey = key;
    id serializedVal = @(self.idToDate[key].timeIntervalSince1970*1000000);      
    retVal[serializedKey] = serializedVal;
  }
  return retVal;
}

-(NSArray<CNLOrder *> *) deserialize_orders:(NSArray *)array {
  NSMutableArray * retVal = [NSMutableArray new];
  for (id item in array) {
    [retVal addObject:[[CNLOrder alloc] initWithChannelDict:item]];
  }
  return retVal;
}

-(NSArray *) serialize_orders {
  NSMutableArray * retVal = [NSMutableArray new];
  for (id item in self.orders) {
    [retVal addObject:[item toChannelDict]];
  }
  return retVal;
}

@end

@implementation CNLOrder

- (instancetype) initWithChannelDict:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.count = [dict[@"count"] longValue];
    self.itemNumber = [dict[@"itemNumber"] longValue];
    self.isRushed = [dict[@"isRushed"] boolValue];
    self.item = [[CNLItem alloc] initWithChannelDict:dict[@"item"]];
    self.prepTime = [dict[@"prepTime"] longValue]/1000000.0;
    self.date = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[@"date"] longValue]/1000000.0];
  }
  return self;

}
- (NSDictionary *) toChannelDict {
  return @{
    @"count": @(self.count),
    @"itemNumber": @(self.itemNumber),
    @"isRushed": @(self.isRushed),
    @"item": [self.item toChannelDict],
    @"prepTime": @(self.prepTime*1000000),
    @"date": @(self.date.timeIntervalSince1970*1000000)
  };
}


@end

@implementation CNLItem

- (instancetype) initWithChannelDict:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.count = [dict[@"count"] longValue];
    self.itemNumber = [dict[@"itemNumber"] longValue];
    self.isRushed = [dict[@"isRushed"] boolValue];
  }
  return self;

}
- (NSDictionary *) toChannelDict {
  return @{
    @"count": @(self.count),
    @"itemNumber": @(self.itemNumber),
    @"isRushed": @(self.isRushed)
  };
}


@end
