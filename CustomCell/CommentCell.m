//
//  CommentCell.m
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "CommentCell.h"
#import "UtilsFunctions.h"
#import "UIImageView+AFNetworking.h"


@implementation CommentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)loadDataWithCommentObject:(PictureComment*)picCmt{
    [self.userImgView setImageWithURL:[NSURL URLWithString:picCmt.commentByImgURL] placeholderImage:[UIImage imageNamed:@"parallax_avatar"]];
    self.userNameLbl.text=picCmt.commentBy;
    self.commentTV.text=picCmt.commenText;
    self.timeDateLabel.text=picCmt.commentDate;
    
    [UtilsFunctions makeUIImageViewRound:self.userImgView ANDRadius:2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
