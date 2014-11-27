//
//  FriendReqCell.h
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendReq.h"

@protocol FriendReqCellDelegate
-(void)actionOnFriendReqWithValue:(BOOL)isAccepted ANDReqID:(NSString *)rID;
@end

@interface FriendReqCell : UITableViewCell
@property (weak, nonatomic) id<FriendReqCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UIImageView *userImgV;
@property (strong, nonatomic)NSString * reqID;
- (IBAction)rejectAction:(id)sender;
- (IBAction)acceptAction:(id)sender;
-(void)loadDataWithWithData:(FriendReq*)friendReqObj;
@end
