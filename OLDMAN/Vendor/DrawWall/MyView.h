//
//  MyView.h
//  DrawWall
//
//

#import <UIKit/UIKit.h>
@interface MyView : UIView

@property(nonatomic,retain)NSMutableArray * MyLineArray;

// get point  in view
-(void)addPA:(CGPoint)nPoint;
-(void)addLA;
-(void)revocation;
-(void)refrom;
-(void)clear;
-(void)setLineColor:(NSInteger)color;
-(void)setlineWidth:(NSInteger)width;
@end
