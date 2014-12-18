//
//  CommentsViewController.h
//  SalamPlanet
//
//  Created by Globit on 29/09/2014.
//  Copyright (c) 2014 Globit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GellaryPicture.h"

@interface CommentsViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *samplLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (strong, nonatomic) GellaryPicture * picObject;
- (IBAction)goBackAction:(id)sender;
- (IBAction)addImageCommentAction:(id)sender;
- (id)initWithPicObjec:(GellaryPicture *)gPic;
- (id)initWithImageID:(NSString *)imgID;
@end
