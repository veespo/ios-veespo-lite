//
//  VEVeespoViewController.h
//  VeespoFramework
//
//  Created by Alessio Roberto on 1/1/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Veespo/VEConnectionErrorDelegate.h>

/**
 @class VEVeespoViewController 
 @discussion Is the Veespo widget. 
 With the widget you collect opinion of users about a specific item, the Veespo Target.
 */

@interface VEVeespoViewController : UIViewController <UISearchBarDelegate, VEConnectionErrorDelegate>

///---------------------------------------
/// @name Widget Callback Properties
///---------------------------------------

/**
 The callback that the widget calls when user close it. A block that takes a single argument, a NSDictionary with the result of the user operation.
 */
@property (nonatomic, copy) void (^closeVeespoViewController)(NSDictionary *resultData);

///---------------------------------------------
/// @name Creating and Initializing the Widget
///---------------------------------------------

/**
 Initializes a @b VEVeespoViewController object to vote on a target already created.
 
 @param token The token of the category. This argument must not be `nil`.
 @param targetId The identification of the target. This argument must not be `nil`.
 @param targetParam The NSDictionary with the target parameters (keys and version). This argument may be `nil`.
 @param parameters The NSDictionary with the parameters to customize widget apparance. This argument may be `nil`.
 @param detailsView The NSArray with custom detail views. This argument must not be `nil`.
 
 @discussion This is the designated initializer.
 
 @return The newly-initialized Veespo Widget
 */
- (id)initWidgetWithToken:(NSString *)token
                   target:(NSString *)targetId
         targetParameters:(NSDictionary *)targetParam
               parameters:(NSDictionary *)parameters
              detailsView:(NSArray *)detailsView;

/**
 Initializes a `VEVeespoViewController` object to vote a target created by the user.
 
 @param token The token of the category. This argument must not be `nil`.
 @param target The NSDictionary that rappresent the new target. This argument must not be `nil`.
 @param targetParam The NSDictionary with the target parameters (keys and version). This argument may be `nil`.
 @param parameters The NSDictionary with the parameters to customize widget apparance. This argument may be `nil`.
 @param detailsView The NSArray with custom detail views. This argument must not be `nil`.
 
 @discussion This is the initializer to create new target on the Veespo data base.
 
 @return The newly-initialized Veespo Widget
 */
- (id)initWidgetWithToken:(NSString *)token
               targetInfo:(NSDictionary *)target
         targetParameters:(NSDictionary *)targetParam
             parameters:(NSDictionary *)parameters
              detailsView:(NSArray *)detailsView;

///------------------------------
/// @name Showing the widget
///------------------------------

/**
 *    With this method the framework displays the widget.
 *
 *    @param block A block object to be executed when the request operation finishes unsuccessfully
 */
- (void)showWidget:(void(^)(NSDictionary *error))block;

/**
 *    With this method the framework displays the widget with the refer to the UIViewController that manage VEVeespoViewController callback.
 *
 *    @param viewcontroller the UIViewController that manage VEVeespoViewController callback.
 *    @param failure        block A block object to be executed when the request operation finishes unsuccessfully
 */
- (void)showWidget:(UIViewController *)viewcontroller
           failure:(void (^)(NSDictionary *error))failure;

@end
