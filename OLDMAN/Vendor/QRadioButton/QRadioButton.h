//
//  EIRadioButton.h
//  EInsure
//
//

#import <UIKit/UIKit.h>

@protocol QRadioButtonDelegate;

@interface QRadioButton : UIButton {
    NSString                        *_groupId;
    BOOL                            _checked;
    id<QRadioButtonDelegate>       _delegate;
}

@property(nonatomic, assign)id<QRadioButtonDelegate>   delegate;
@property(nonatomic, copy, readonly)NSString            *groupId;
@property(nonatomic, assign)BOOL checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId;

- (void)getGroupId:(NSString*)groupId;

@end

@protocol QRadioButtonDelegate <NSObject>

@optional

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId;



@end
