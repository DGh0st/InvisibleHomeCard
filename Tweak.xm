%hook SBDeckSwitcherViewController
-(CGFloat)_opacityForIndex:(NSUInteger)arg1 {
	if (arg1 == 0)
		return 0.0;
	return %orig(arg1);
}
%end