//
//  MyPhotoCell.h
//  SocialSelfie
//
//  Created by Saad Khan on 27/10/2014.
//  Copyright (c) 2014 SocialSelfie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPhotoesPic.h"

@protocol MyPhotoCellDelegate
-(void)gotoLikesDetailForPhotoID:(NSString *)photoID;
-(void)gotoCommentsDetailForPhotoID:(NSString *)photoID;
-(void)gotoShareForPhotoID:(NSString *)photoID;
@end


@interface MyPhotoCell : UITableViewCell
@property (weak, nonatomic) id<MyPhotoCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *lblLikeCOunt;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCount;
@property (weak, nonatomic) IBOutlet UILabel *lblShare;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

-(void)loadDataWithImageURL:(MyPhotoesPic *)picData;

- (IBAction)likeBtnAction:(id)sender;
- (IBAction)commentBtnAction:(id)sender;
- (IBAction)shareBtnAction:(id)sender;

@end
