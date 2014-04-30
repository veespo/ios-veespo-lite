//
//  VEVeespoAPIWrapper.h
//  VeespoFramework
//
//  Created by Alessio Roberto on 19/02/14.
//  Copyright (c) 2014 Veespo Ltd. All rights reserved.
//

/**
 *    This class wrap the Veespo APIs. All the requests have the same timeput set to @b 10 seconds.
 */

@interface VEVeespoAPIWrapper : NSObject

/**
 Get a list of all the targets of a category, using a demo code.
 
 @param dataSet 
    A dictrionary that must have two keys: 'democode' and 'userid'. First key is the demo code of the category. Second key is the user id created to identify the user.
 @param success 
    A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the dictionary created from the response data of request and the token fundamental to perform all operations on the category and on target.
 @param failure 
    A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)requestTargetList:(NSDictionary *)dataSet
                  success:(void(^)(id responseData, NSString *token))success
                  failure:(void(^)(id error))failure;


///------------------------------
/// @name Ratings Category
///------------------------------

/**
 *    This method is used to get a list of all the tags voted, for a target.
 *
 *    @param target   The id of the target.
 *    @param category The id of the category.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the responseData with the list of all the tags and the list with the detail of each tags.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getRatingsForTarget:(NSString *)target
                andCategory:(NSString *)category
                  withToken:(NSString *)token
                    success:(void(^)(NSDictionary * responseData))success
                    failure:(void (^)(id error))failure;

/**
 *    This method is used to get rating and information about a tag voted for a target. If the tag request is not voted, the result is an error.
 *
 *    @param tag      The id of the tag.
 *    @param target   The id of the target.
 *    @param category The id of the category.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the responseData with the detail of the tag.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but the tag is not voted. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getRatingTag:(NSString *)tag
           forTarget:(NSString *)target
          inCategory:(NSString *)category
           withToken:(NSString *)token
             success:(void(^)(NSDictionary * responseData))success
             failure:(void (^)(id error))failure;

/**
 *    Request the tags used by a specific user, to rating a target. The token used for the request, must be created for the specific user.
 *
 *    @param user     The user id.
 *    @param target   The id of the target.
 *    @param category The id of the category.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the responseData with the list of the tags.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getUserRatings:(NSString *)user
             forTarget:(NSString *)target
            inCategory:(NSString *)category
             withToken:(NSString *)token
               success:(void(^)(NSDictionary * responseData))success
               failure:(void (^)(id error))failure;

/**
 *    Request all the targets rated for the specific tag.
 *
 *    @param tag      The tag id.
 *    @param category The id of the category.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the responseData with the list of the targets rated.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getTagRated:(NSString *)tag
           inCategory:(NSString *)category
            withToken:(NSString *)token
              success:(void(^)(NSDictionary * responseData))success
              failure:(void (^)(id error))failure;

///------------------------------
/// @name Average Category
///------------------------------

/**
 Get the Overall rating for a target and all the tags voted for the target. Each tags have average and frequency.
 
 @param targetId The id of the target.
 @param category The id of the category.
 @param token The Veespo token for the category.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes two arguments: the result list with all the tags and the overall rating.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)requestAverageForTarget:(NSString *)targertId
                   withCategory:(NSString *)category
                      withToken:(NSString *)token
                        success:(void (^)(id responseData, id overall))success
                        failure:(void (^)(id error))failure;

/**
 *    Requires list of all @b targets for which a @b tag has been voted and the average vote for each targets. The targets are related to a single @b category.
 *
 *    @param tag      The tag id.
 *    @param category The id of the category.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the result list with all the targets. The list is sorted in descending order.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)requestAvgTargetsForTag:(NSString *)tag
                   withCategory:(NSString *)category
                      withToken:(NSString *)token
                        success:(void(^)(id responseData))success
                        failure:(void (^)(id error))failure;


///------------------------------
/// @name Info Category
///------------------------------

/**
 Get a list of all the targets on which the user has expressed his opinion. The targets are related to a single category.
 
 @param user The user id.
 @param category The id of the category.
 @param token The Veespo token for the category.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the result list with all the targets.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)requestTargetsForUser:(NSString *)user
                 withCategory:(NSString *)category
                    withToken:(NSString *)token
                      success:(void(^)(id responseData))success
                      failure:(void (^)(id error))failure;


/**
 Make a request to retry the Category Name.
 
 @param catId The id of the category.
 @param token The Veespo token for the category.
 @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the category name.
 @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 
 */
- (void)getCategoryInfo:(NSString *)catId
              withToken:(NSString *)token
                success:(void(^)(NSString *categoryName))success
                failure:(void (^)(id error))failure;


/**
 *    Request to retrive all @b targets in the @b category.
 *
 *    @param catId   The id of the category.
 *    @param uTk     The Veespo token for the category.
 *    @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the result list with all the targets.
 *    @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getTargets:(NSString *)catId
         userToken:(NSString *)uTk
           success:(void(^)(id responseData))success
           failure:(void (^)(id error))failure;

/**
 *    Request to retrive all @b tag in the @b category
 *
 *    @param catId   The id of the category.
 *    @param uTk     The Veespo token for the category.
 *    @param success A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the result list with all the tags.
 *    @param failure A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getTagsForCategory:(NSString *)catId
                 userToken:(NSString *)uTk
                   success:(void(^)(id responseData))success
                   failure:(void (^)(id error))failure;

///------------------------------
/// @name Count Ratings
///------------------------------

/**
 *    Request general infomation about a specific target. This information are: number of ratings, users, tags, version and windwos.
 *
 *    @param category The id of the category.
 *    @param target   The id of the target.
 *    @param token    The Veespo token for the category.
 *    @param success  A block object to be executed when the request operation finishes successfully. This block has no return value and takes an argument: the NSDictionary with all the information.
 *    @param failure  A block object to be executed when the request operation finishes unsuccessfully, or that finishes successfully, but encountered an error while parsing the response data. This block has no return value and takes one argument: an object describing the network or parsing error that occurred.
 */
- (void)getCountRatingsForCategory:(NSString *)category
                         andTarget:(NSString *)target
                         withToken:(NSString *)token
                           success:(void(^)(id responseData))success
                           failure:(void (^)(id error))failure;
@end
