//
//  CommentCell.h
//  SocialSelfie
//
//  Created by Saad Khan on 18/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureComment.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet UITextView *commentTV;
-(void)loadDataWithCommentObject:(PictureComment*)picCmt;
@end
