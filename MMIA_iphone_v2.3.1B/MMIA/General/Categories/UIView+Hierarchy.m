//
//  NSView+Hierarchy.m

#import "UIView+Hierarchy.h"

@implementation UIView (Hierarchy)

+ (NSString *)hierarchicalDescriptionOfView:(UIView *)view level:(NSUInteger)level
{
    
    // Ready the description string for this level
    NSMutableString * builtHierarchicalString = [NSMutableString string];
    
    // Build the tab string for the current level's indentation
    NSMutableString * tabString = [NSMutableString string];
    for (NSUInteger i = 0; i <= level; i++)
        [tabString appendString:@"\t"];
    
    // Get the view's title string if it has one
    NSString * titleString = ([view respondsToSelector:@selector(title)]) ? [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"\"%@\" ", [(UIButton *)view titleForState:UIControlStateNormal]]] : @"";
    
    // Append our own description at this level
    [builtHierarchicalString appendFormat:@"\n%@<%@: %p> %@(%li subviews)", tabString, NSStringFromClass([view class]), view, titleString, (unsigned long)[[view subviews] count]];
    
    // Recurse for each subview ...
    for (UIView * subview in [view subviews])
        [builtHierarchicalString appendString:[UIView hierarchicalDescriptionOfView:subview
                                                                              level:(level + 1)]];
    
    return builtHierarchicalString;
}

- (void)logHierarchy
{
    NSLog(@"%@", [UIView hierarchicalDescriptionOfView:self level:0]);
}

@end
