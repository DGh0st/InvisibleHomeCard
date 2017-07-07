@interface SBDisplayItem : NSObject
@property (nonatomic,copy,readonly) NSString * displayIdentifier;
@end

@interface SBDeckSwitcherItemContainer : UIView
@property (nonatomic,readonly) SBDisplayItem * displayItem;
@end

@interface SBDeckSwitcherViewController : UIViewController
@property (nonatomic,copy) NSArray * displayItems;
@property (setter=_setReturnToDisplayItem:,nonatomic,copy) SBDisplayItem * _returnToDisplayItem;
-(void)_updateScrollViewContentOffsetToCenterIndex:(NSUInteger)arg1 animated:(BOOL)arg2 completion:(id)arg3;
-(NSInteger)_topIndexForLocationInScrollView:(CGPoint)arg1;
-(void)_animateWallpaperDismissal;
@end

%hook SBDeckSwitcherViewController
UILabel *label = nil;

-(void)_sendViewPresentingToPageViewsForTransitionRequest:(id)arg1 {
	%orig(arg1);

	if ([self.displayItems count] <= 1) {
		if (label != nil) {
			[label removeFromSuperview];
			[label release];
			label = nil;
		}

		label = [[UILabel alloc] initWithFrame:self.view.frame];
		label.text = @"No Recent Applications";
		label.font = [UIFont systemFontOfSize:24];
		label.numberOfLines = 2;
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self.view addSubview:label];

		label.alpha = 0;
		[UIView animateWithDuration:0.2 animations:^{
			label.alpha = 1;
		} completion:nil];
	}
}

-(void)_sendViewDismissingToPageViewsForTransitionRequest:(id)arg1 {
	%orig(arg1);

	if (label != nil) {
		[label removeFromSuperview];
		[label release];
		label = nil;
	}
}

-(void)removeDisplayItem:(id)arg1 forReason:(NSInteger)arg2 completion:(id)arg3 {
	%orig(arg1, arg2, arg3);

	if ([self.displayItems count] <= 1) {
		if (label != nil) {
			[label removeFromSuperview];
			[label release];
			label = nil;
		}

		label = [[UILabel alloc] initWithFrame:self.view.frame];
		label.text = @"No Recent Applications";
		label.font = [UIFont systemFontOfSize:24];
		label.numberOfLines = 2;
		label.textColor = [UIColor whiteColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self.view addSubview:label];

		label.alpha = 0;
		[UIView animateWithDuration:0.2 animations:^{
			label.alpha = 1;
		} completion:nil];
	}
}

-(NSUInteger)_indexForPresentationOrDismissalIsPresenting:(BOOL)arg1 {
	NSUInteger result = %orig(arg1);
	if (arg1 && [[self _returnToDisplayItem].displayIdentifier isEqualToString:@"com.apple.springboard"])
		result++;
	return result;
}

-(CGFloat)_opacityForIndex:(NSUInteger)arg1 {
	if (arg1 == 0)
		return 0.0;
	else if (arg1 == 1)
		return 1.0;
	return %orig(arg1);
}

-(BOOL)_isItemVisible:(SBDisplayItem *)arg1 {
	if ([arg1.displayIdentifier isEqualToString:@"com.apple.springboard"])
		return NO;
	return %orig(arg1);
}

-(BOOL)_isIndexVisible:(NSUInteger)arg1 {
	if (arg1 == 0)
		return NO;
	else if (arg1 == 1)
		return YES;
	return %orig(arg1);
}

-(CGFloat)_blurForIndex:(NSUInteger)arg1 {
	if (arg1 == 1)
		return %orig(0);
	return %orig(arg1);
}

-(void)scrollViewDidEndDragging:(UIScrollView *)arg1 willDecelerate:(BOOL)arg2 {
	%orig(arg1, arg2);

	if (!arg2 && [self _topIndexForLocationInScrollView:arg1.contentOffset] <= 2)
		[self _updateScrollViewContentOffsetToCenterIndex:1 animated:YES completion:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)arg1 {
	%orig(arg1);

	if ([self _topIndexForLocationInScrollView:arg1.contentOffset] <= 2)
		[self _updateScrollViewContentOffsetToCenterIndex:1 animated:YES completion:nil];
}
%end