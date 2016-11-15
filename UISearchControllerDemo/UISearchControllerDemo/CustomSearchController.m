//
//  CustomSearchController.m
//  UISearchControllerDemo
//
//  Created by JiangWang on 15/11/2016.
//  Copyright © 2016 JiangWang. All rights reserved.
//

#import "CustomSearchController.h"
#import "DemoSearchBar.h"

@interface CustomSearchController ()
<UISearchBarDelegate>

@property (nonatomic, strong) DemoSearchBar *customSearchBar;

@end

@implementation CustomSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Initialization
- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
                                 searchBarFrame:(CGRect)frame
                                  searchBarFont:(UIFont *)font
                             searchBarTextColor:(UIColor *)textColor
                             searchBarTintColor:(UIColor *)tintColor
{
    self = [super initWithSearchResultsController:searchResultsController];
    if (self)
    {
        [self configureSearchBarWithFrame:frame
                            searchBarFont:font
                       searchBarTextColor:textColor
                       searchBarTintColor:tintColor];
    }
    return self;
}

- (void)configureSearchBarWithFrame:(CGRect)frame
                      searchBarFont:(UIFont *)font
                 searchBarTextColor:(UIColor *)textColor
                 searchBarTintColor:(UIColor *)tintColor
{
    self.customSearchBar = [[DemoSearchBar alloc] initWithFrame:frame
                                                  preferredFont:font
                                             preferredTextColor:textColor];
    
    self.customSearchBar.barTintColor = tintColor;
    self.customSearchBar.tintColor = textColor;
    self.customSearchBar.showsBookmarkButton = NO;
    self.customSearchBar.showsCancelButton = YES;
    self.customSearchBar.delegate = self;
}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if([self.cusSearchConDelegate respondsToSelector:
       @selector(searchControllerDidStartSearching:)])
    {
        [self.cusSearchConDelegate searchControllerDidStartSearching:self];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.cusSearchConDelegate respondsToSelector:
        @selector(searchController:didChangeSearchText:)])
    {
        [self.cusSearchConDelegate searchController:self
                                didChangeSearchText:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.cusSearchConDelegate respondsToSelector:
        @selector(searchControllerDidTapSearchBtn:)])
    {
        [self.cusSearchConDelegate searchControllerDidTapSearchBtn:self];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if ([self.cusSearchConDelegate respondsToSelector:
         @selector(searchBarCancelButtonClicked:)])
    {
        [self.cusSearchConDelegate searchControllerDidTapCancelBtn:self];
    }
}

@end
