//
//  EndrCommentsViewController.m
//  SalamPlanet
//
//  Created by Globit on 29/09/2014.
//  Copyright (c) 2014 Globit. All rights reserved.
//

#import "CommentsViewController.h"
#import "Comment.h"
#import "CommentCell.h"
#import "User.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "UtilsFunctions.h"
#import "PictureComment.h"


#define kOFFSET_FOR_KEYBOARD 216.0

@interface CommentsViewController ()
{
    BOOL isKeyBoardAppeared;
    NSMutableArray * mainArray;
    User * meUser;
}

@end

@implementation CommentsViewController
@synthesize picObject;
- (id)initWithPicObjec:(GellaryPicture *)gPic
{
    self = [super initWithNibName:@"CommentsViewController" bundle:Nil];
    if (self) {
        picObject=gPic;
    }
    return self;
}
- (id)initWithImageID:(NSString *)imgID
{
    self = [super initWithNibName:@"CommentsViewController" bundle:Nil];
    if (self) {
        picObject=[[GellaryPicture alloc]initWithImageID:imgID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainArray=[[NSMutableArray alloc]init];
    [self loadMainArray];
    [self getAllPicturesOfMensGalleryWebsrvice];
//    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSNotificationCenter * notifCenter=[NSNotificationCenter defaultCenter];
    [notifCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [notifCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSNotificationCenter * notifCenter=[NSNotificationCenter defaultCenter];
    [notifCenter removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [notifCenter removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark: Keyboard Hide/Show Methods
- (void)keyboardWillHide:(NSNotification *)notif {
    if(isKeyBoardAppeared){
        [self setViewMoveUp:NO];
    }
    isKeyBoardAppeared=NO;
}

- (void)keyboardWillShow:(NSNotification *)notif{
    if(!isKeyBoardAppeared){
        [self setViewMoveUp:YES];
    }
    isKeyBoardAppeared=YES;
    //Scroll the tableview to bottom
    [self scrollTableViewToBottom];
}

-(void)setViewMoveUp:(BOOL)moveUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect rect = self.mainView.frame;
    if (moveUp)
    {
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    self.mainView.frame = rect;
    [UIView commitAnimations];
}

#pragma mark:Custom Methods
-(void)loadMainArray{

}
-(CGSize)calculateSizeForText:(NSString *)txt{
    
    CGSize maximumLabelSize = CGSizeMake(300, 180);
    CGSize expectedSectionSize = [txt sizeWithFont:self.samplLbl.font
                                               constrainedToSize:maximumLabelSize
                                                   lineBreakMode:NSLineBreakByTruncatingTail];
    return expectedSectionSize;
}
-(void)scrollTableViewToBottom{
    //Scroll the tableview to bottom
    if (mainArray.count>0) {
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: mainArray.count-1 inSection: 0];
        [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
    }
}
#pragma mark: UITableView Delegates and Datasource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 112;
//    return 64+[self calculateSizeForText:endrCmt.commentText].height+10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCommentCell=@"commentCell";

    
    CommentCell * cell = [tableView dequeueReusableCellWithIdentifier:identifierCommentCell];
    if (!cell) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:nil options:nil];
        cell = (CommentCell*)[nibArray objectAtIndex:0];
    }
    [cell loadDataWithCommentObject:[mainArray objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark: IBActions and Selector Methods

- (IBAction)addImageCommentAction:(id)sender{
    if (self.commentTF.text.length>0) {
        [self addCommentOnPictureWithCommentText:self.commentTF.text];
        self.commentTF.text=@"";
    }
    [self scrollTableViewToBottom];
    [self.commentTF resignFirstResponder];
}
- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma TextField Delegates
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [self addImageCommentAction:nil];
    return YES;
}
#pragma mark:Websrevices
-(void)getAllPicturesOfMensGalleryWebsrvice{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    if(picObject.imageID){
        [params setObject:picObject.imageID forKey:kImageID];
    }
    [params setObject:kTaskGetCommentByImageID forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLImages parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==14000) {
            if ([responseObject valueForKey:kValue] && ![[responseObject valueForKey:kValue]isEqual:[NSNull null]]) {
                NSArray * array=[responseObject valueForKey:kValue];
                [mainArray removeAllObjects];
                for (NSDictionary * dict in array) {
                    PictureComment * picCmt=[[PictureComment alloc]initWithDictionary:dict];
                    [mainArray addObject:picCmt];
                }
                [self.tableView reloadData];
                [self scrollTableViewToBottom];
            }
        }
        else if ([[responseObject valueForKey:@"statusCode"]integerValue]==15001) {
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
-(void)addCommentOnPictureWithCommentText:(NSString *)cmtText{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (GetStringWithKey(kUserID)) {
        [params setObject:GetStringWithKey(kUserID) forKey:kUserID];
    }
    if(picObject.imageID){
        [params setObject:picObject.imageID forKey:kImageID];
    }
    if (cmtText.length) {
        [params setObject:cmtText forKey:kComment];
    }
    [params setObject:kTaskCommentImage forKey:kTask];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [manager POST:kBaseURLImages parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject valueForKey:kStatusCode]integerValue]==13000) {
            if ([responseObject valueForKey:kValue] && ![[responseObject valueForKey:kValue]isEqual:[NSNull null]]) {
                ShowMessage(kAppName, @"Comment has been added successfully.");
                [self performSelectorOnMainThread:@selector(getAllPicturesOfMensGalleryWebsrvice) withObject:nil waitUntilDone:NO];
            }
        }
        else if ([[responseObject valueForKey:@"statusCode"]integerValue]==13001) {
            ShowMessage(@"Error", @"Please try again.");
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"Error: %@", error);
    }];
}
@end
