#import "VEConnection.h"
#import "VEETargetObj.h"

@implementation VEConnection

#pragma mark - Public
- (void)veespoCodeTargetsList:(NSString *)veespoCode
                 userIdentify:(NSString *)userid
                      success:(void(^)(id responseData))success
                      failure:(void (^)(id error))failure
{
    VEVeespoAPIWrapper *veespo = [[VEVeespoAPIWrapper alloc] init];
    
    [veespo requestTargetList:[NSDictionary dictionaryWithObjectsAndKeys:veespoCode, @"democode", userid, @"userid", nil]
                      success:^(id responseData, NSString *token) {
                          
                          __block NSMutableDictionary *targetList = [[NSMutableDictionary alloc] init];
                          
                          [targetList setValue:token forKeyPath:@"token"];
                          [targetList setValue:responseData[@"categoryname"] forKeyPath:@"title"];
                          
                          // Inizializzo TargetObj
                          __block NSMutableArray *tList = [NSMutableArray new];
                          for (int i = 0; i < ((NSArray *)responseData[@"targets"]).count; i++) {
                              VEETargetObj *tobj = [[VEETargetObj alloc] initWithDictionary:[responseData[@"targets"] objectAtIndex:i]];
                              [tList addObject:tobj];
                          }
                          [targetList setValue:tList forKeyPath:@"targetlist"];
                          
                          // Verifico se ci sono target già votati dall'utente e li ordino alfabeticamente
                          [veespo requestTargetsForUser:userid withCategory:responseData[@"category"] withToken:token success:^(id responseData) {
                              
                              if (((NSArray *)responseData).count > 0) {
                                  NSArray *userTargetsList = [NSArray new];
                                  
                                  NSArray *list = [[NSArray alloc] initWithArray:responseData];
                                  userTargetsList = [list sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                                      NSString *name1 = obj1[@"desc1"];
                                      NSString *name2 = obj2[@"desc1"];
                                      return [name1 compare:name2];
                                  }];
                                  
                                  for (int i = 0; i < userTargetsList.count; i++) {
                                      for (int j = 0; j < tList.count; j++) {
                                          VEETargetObj *tobj = [tList objectAtIndex:j];
                                          if ([[userTargetsList objectAtIndex:i][@"target"] isEqualToString:tobj.targetId]) {
                                              tobj.voted = YES;
                                          }
                                      }
                                  }
                                  
                                  [targetList setValue:tList forKeyPath:@"targetlist"];
                              }
                              success(targetList);
                          } failure:^(id error) {
                              failure(nil);
                          }];
                          
                      } failure:^(id error) {
                          failure(nil);
                      }];
}

@end
