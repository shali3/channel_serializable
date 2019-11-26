// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ObjCGenerator
// **************************************************************************

@implementation CNLPerson

- (instancetype) initWithChannelDict:(NSDictionary *)dict {
  self = [super init];
  if (self) {
    self.firstName = dict[@"firstName"];
    self.middleName = dict[@"middleName"];
    self.lastName = dict[@"lastName"];
    self.dateOfBirth = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[@"dateOfBirth"] longValue]/1000000.0];
    self.lastOrder = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[@"lastOrder"] longValue]/1000000.0];
    self.idToDate = [self build_idToDate_from:dict[@"idToDate"];
    self.orders = [self build_orders_from:dict[@"orders"];
  }
  return self;

}
- (NSDictionary *) toChannelDict {
}

-(NSDictionary<NSString *,NSDate *> *) build_idToDate_from:(NSDictionary *)dict {
  NSMutableDictionary * retVal = [NSMutableDictionary new];
  for (id key in dict) {
    id deserializedKey = key;
    id deserializedVal = [[NSDate alloc] initWithTimeIntervalSince1970:[dict[key] longValue]/1000000.0];      
    retVal[deserializedKey] = deserializedVal;
  }
}
-(NSArray<CNLOrder *> *) build_orders_from:(NSArray *)array {
  NSMutableArray * retVal = [NSMutableArray new];
  for (id item in array) {
    [retVal addObject:[[CNLOrder alloc] initWithChannelDict:item];
  }
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
}


@end
