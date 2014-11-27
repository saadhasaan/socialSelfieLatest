//
//  FriendReqCell.m
//  SocialSelfie
//
//  Created by Saad Khan on 15/11/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "FriendReqCell.h"
#import "FriendReq.h"
#import "UIImageView+AFNetworking.h"
#import "UtilsFunctions.h"

@implementation FriendReqCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadDataWithWithData:(FriendReq*)friendReqObj{
    self.reqID=friendReqObj.reqID;
    self.nameLbl.text=friendReqObj.reqUserName;
    [self.userImgV setImageWithURL:[NSURL URLWithString:friendReqObj.reqUserPicURL] placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
    if (!friendReqObj.isRecieved) {
        [self.acceptBtn setHidden:YES];
    }
    else{
        [self.acceptBtn setHidden:NO];
    }
    [UtilsFunctions makeUIImageViewRound:self.userImgV ANDRadius:2];
}
- (IBAction)rejectAction:(id)sender {
    [delegate actionOnFriendReqWithValue:NO ANDReqID:self.reqID];
}

- (IBAction)acceptAction:(id)sender {
    [delegate actionOnFriendReqWithValue:YES ANDReqID:self.reqID];
}
@end
