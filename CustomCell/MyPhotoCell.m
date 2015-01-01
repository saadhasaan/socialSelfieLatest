//
//  MyPhotoCell.m
//  SocialSelfie
//
//  Created by Saad Khan on 27/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import "MyPhotoCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MyPhotoCell
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

-(void)loadDataWithImageURL:(MyPhotoesPic *)picData{
    
    [self.imgView setImageWithURL:[NSURL URLWithString:picData.imageURL]];
    self.lblLikeCOunt.text=[NSString stringWithFormat:@"%li",(long)picData.likeCount];
    if (picData.likeCount>0){
        [self.btnLike setImage:[UIImage imageNamed:@"hart_pressed_state"] forState:UIControlStateNormal];
    }
    self.lblCommentCount.text=[NSString stringWithFormat:@"%li",(long)picData.commentCount];
    self.picID=picData.imageID;
}
- (IBAction)likeBtnAction:(id)sender {
    [delegate gotoLikesDetailForPhotoID:self.tag];
}

- (IBAction)commentBtnAction:(id)sender {
    [delegate gotoCommentsDetailForPhotoID:self.picID];
}

- (IBAction)shareBtnAction:(id)sender {
    [delegate gotoShareForPhotoID:self.tag];
}
@end
