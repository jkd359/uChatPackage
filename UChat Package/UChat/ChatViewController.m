//
//  ChatViewController.m
//  UChat
//
//  Created by Joel on 17/09/2014.
//  Copyright (c) 2014 HighQuality. All rights reserved.
//

#import "ChatViewController.h"
#import "ProgressHUD.h"

@interface ChatViewController ()
{
	NSTimer *timer;
	BOOL isLoading;
    
	NSString *chatroom;
    
	NSMutableArray *users;
	NSMutableArray *messages;
	NSMutableDictionary *avatars;
    
	UIImageView *outgoingBubbleImageView;
	UIImageView *incomingBubbleImageView;
}
@end

@implementation ChatViewController

- (id)initWith:(NSString *)chatroom_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [super init];
	chatroom = chatroom_;
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"chatroom: %@", chatroom);
    self.title = @"Chat";
    
	users = [[NSMutableArray alloc] init];
	messages = [[NSMutableArray alloc] init];
	avatars = [[NSMutableDictionary alloc] init];
    
	self.sender = [PFUser currentUser].objectId;
    
	outgoingBubbleImageView = [JSQMessagesBubbleImageFactory outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
	incomingBubbleImageView = [JSQMessagesBubbleImageFactory incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
	isLoading = NO;
	[self loadMessages];
	timer = [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
    
	self.collectionView.collectionViewLayout.springinessEnabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	[timer invalidate];
}

- (void)loadMessages
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (isLoading == NO)
	{
		isLoading = YES;
		JSQMessage *message_last = [messages lastObject];
        
		PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
		[query whereKey:@"room" equalTo:chatroom];
		if (message_last != nil) [query whereKey:@"createdAt" greaterThan:message_last.date];
		[query includeKey:@"user"];
		[query orderByAscending:@"createdAt"];
        
		[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
         {    

             if (error == nil)
             {
                 for (PFObject *object in objects)
                 {
                     PFUser *user = object[@"user"];
                     [users addObject:user];
                     
                     JSQMessage *message = [[JSQMessage alloc] initWithText:object[@"text"] sender:user.objectId date:object.createdAt];
                     [messages addObject:message];
                     

                 }
                                  
                 if ([objects count] != 0)
                     
                 [self finishReceivingMessage];
                 
                 isLoading = NO;

             }
             else if (error) {
                 
             [ProgressHUD showError:@"Network error."];
                 
                 isLoading = NO;
                 
             } else
                 
             isLoading = NO;
         }];
	}
}

#pragma mark - JSQMessagesViewController method overrides

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text sender:(NSString *)sender date:(NSDate *)date
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFObject *object = [PFObject objectWithClassName:@"Chat"];
	object[@"room"] = chatroom;
	object[@"user"] = [PFUser currentUser];
	object[@"text"] = text;
	[object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             [self loadMessages];
             [JSQSystemSoundPlayer jsq_playMessageSentSound];
         }
         else [ProgressHUD showError:@"Network error"];;
     }];
	[self finishSendingMessage];
}

- (void)didPressAccessoryButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didPressAccessoryButton");
}

#pragma mark - JSQMessages CollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages objectAtIndex:indexPath.item];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender])
	{
		return [[UIImageView alloc] initWithImage:outgoingBubbleImageView.image highlightedImage:outgoingBubbleImageView.highlightedImage];
	}
	else return [[UIImageView alloc] initWithImage:incomingBubbleImageView.image highlightedImage:incomingBubbleImageView.highlightedImage];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
//Comment this section out to remove user images within the messaging. This will load messages faster but also you don't get a little picture :)

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	PFUser *user = [users objectAtIndex:indexPath.item];
    
	UIImageView *imageView = [[UIImageView alloc] init];
    
	if (avatars[user.objectId] == nil)
	{
		PFFile *filePicture = user[@"thumbnail"];
		[filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error)
         {
             if (error == nil)
             {
                 avatars[user.objectId] = [UIImage imageWithData:imageData];
                                  
                 [imageView setImage:avatars[user.objectId]];
             }
         }];
	}
	else [imageView setImage:avatars[user.objectId]];
    
    //Creates a circle image for user avatar during messaging - comment out to make image square again
	imageView.layer.cornerRadius = imageView.frame.size.width/2;
	imageView.layer.masksToBounds = YES;
    
	return imageView;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		JSQMessage *message = [messages objectAtIndex:indexPath.item];
		return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
	}
	return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender])
	{
		return nil;
	}
	
	if (indexPath.item - 1 > 0)
	{
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:message.sender])
		{
			return nil;
		}
	}
    
	PFUser *user = [users objectAtIndex:indexPath.item];
	return [[NSAttributedString alloc] initWithString:user[@"uChatID"]];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - UICollectionView DataSource

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return [messages count];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
	
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([message.sender isEqualToString:self.sender])
	{
		cell.textView.textColor = [UIColor blackColor];
	}
	else
	{
		cell.textView.textColor = [UIColor whiteColor];
	}
	
	cell.textView.linkTextAttributes = @{NSForegroundColorAttributeName:cell.textView.textColor,
										 NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid)};
	
	return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (indexPath.item % 3 == 0)
	{
		return kJSQMessagesCollectionViewCellLabelHeightDefault;
	}
	return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	JSQMessage *message = [messages objectAtIndex:indexPath.item];
	if ([[message sender] isEqualToString:self.sender])
	{
		return 0.0f;
	}
	
	if (indexPath.item - 1 > 0)
	{
		JSQMessage *previousMessage = [messages objectAtIndex:indexPath.item - 1];
		if ([[previousMessage sender] isEqualToString:[message sender]])
		{
			return 0.0f;
		}
	}
	return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
				   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 0.0f;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)collectionView:(JSQMessagesCollectionView *)collectionView
				header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSLog(@"didTapLoadEarlierMessagesButton");
}


@end
