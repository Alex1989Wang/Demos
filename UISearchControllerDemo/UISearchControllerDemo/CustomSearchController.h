//
//  CustomSearchController.h
//  UISearchControllerDemo
//
//  Created by JiangWang on 15/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DemoSearchBar;
@class CustomSearchController;

@protocol CustomSearchControllerDelegate <NSObject>

- (void)searchControllerDidStartSearching:(CustomSearchController *)cusSearchCon;
- (void)searchControllerDidTapCancelBtn:(CustomSearchController *)cusSearchCon;
- (void)searchController:(CustomSearchController *)cusSearchCon
     didChangeSearchText:(NSString *)searchText;
- (void)searchControllerDidTapSearchBtn:(CustomSearchController *)cusSearchCon;

@end

@interface CustomSearchController : UISearchController

@property (nonatomic, strong, readonly) DemoSearchBar *customSearchBar;
@property (nonatomic, weak) id<CustomSearchControllerDelegate> cusSearchConDelegate;

#pragma mark - Methods
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
                                 searchBarFrame:(CGRect)frame
                                  searchBarFont:(UIFont *)font
                             searchBarTextColor:(UIColor *)textColor
                             searchBarTintColor:(UIColor *)tintColor;

@end
