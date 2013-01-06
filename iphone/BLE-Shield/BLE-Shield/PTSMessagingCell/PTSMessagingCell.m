/*
 PTSMessagingCell.m
 
 Copyright (C) 2012 pontius software GmbH
 
 This program is free software: you can redistribute and/or modify
 it under the terms of the Createive Commons (CC BY-SA 3.0) license
*/

#import "PTSMessagingCell.h"

@implementation PTSMessagingCell

static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 11.0;

@synthesize sent, messageLabel, messageView, timeLabel, avatarImageView, balloonView;

#pragma mark -
#pragma mark Static methods

+(CGFloat)textMarginHorizontal {
    return textMarginHorizontal;
}

+(CGFloat)textMarginVertical {
    return textMarginVertical;
}

+(CGFloat)maxTextWidth {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 220.0f;
    } else {
        return 400.0f;
    }
}

+(CGSize)messageSize:(NSString*)message {
    return [message sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake([PTSMessagingCell maxTextWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

+(UIImage*)balloonImage:(BOOL)sent isSelected:(BOOL)selected {
    if (sent == YES && selected == YES) {
        return [[UIImage imageNamed:@"balloon_selected_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else if (sent == YES && selected == NO) {
        return [[UIImage imageNamed:@"balloon_read_right"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else if (sent == NO && selected == YES) {
        return [[UIImage imageNamed:@"balloon_selected_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    } else {
        return [[UIImage imageNamed:@"balloon_read_left"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
    }
}

#pragma mark -
#pragma mark Object-Lifecycle/Memory management

-(id)initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        /*Selection-Style of the TableViewCell will be 'None' as it implements its own selection-style.*/
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        /*Now the basic view-lements are initialized...*/
        messageView = [[UIView alloc] initWithFrame:CGRectZero];
        messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        balloonView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        avatarImageView = [[UIImageView alloc] initWithImage:nil];
       
        /*Message-Label*/
        self.messageLabel.backgroundColor = [UIColor clearColor];
        self.messageLabel.font = [UIFont systemFontOfSize:messageTextSize];
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.numberOfLines = 0;
        
        /*Time-Label*/
        self.timeLabel.font = [UIFont boldSystemFontOfSize:12.0f];
        self.timeLabel.textColor = [UIColor darkGrayColor];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        
        /*...and adds them to the view.*/
        [self.messageView addSubview: self.balloonView];
        [self.messageView addSubview: self.messageLabel];
        
        [self.contentView addSubview: self.timeLabel];
        [self.contentView addSubview: self.messageView];
        [self.contentView addSubview: self.avatarImageView];
        
        /*...and a gesture-recognizer, for LongPressure is added to the view.*/
        UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [recognizer setMinimumPressDuration:1.0f];
        [self addGestureRecognizer:recognizer];
    }
    
    return self;
}


#pragma mark -
#pragma mark Layouting

- (void)layoutSubviews {
    /*This method layouts the TableViewCell. It calculates the frame for the different subviews, to set the layout according to size and orientation.*/
    
    /*Calculates the size of the message. */
    CGSize textSize = [PTSMessagingCell messageSize:self.messageLabel.text];
    
    /*Calculates the size of the timestamp.*/
    CGSize dateSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font forWidth:[PTSMessagingCell maxTextWidth] lineBreakMode:NSLineBreakByClipping];
    
    /*Initializes the different frames , that need to be calculated.*/
    CGRect ballonViewFrame = CGRectZero;
    CGRect messageLabelFrame = CGRectZero;
    CGRect timeLabelFrame = CGRectZero;
    CGRect avatarImageFrame = CGRectZero;

    timeLabelFrame = CGRectMake(self.frame.size.width/2 - dateSize.width/2, textMarginVertical, dateSize.width, dateSize.height);
    
    if (self.sent == YES) {

        ballonViewFrame = CGRectMake(self.frame.size.width - (textSize.width + 3*textMarginHorizontal) - 40.0f, timeLabelFrame.size.height + 2*textMarginVertical, textSize.width + 2*textMarginHorizontal, textSize.height + 2*textMarginVertical);
        messageLabelFrame = CGRectMake(self.frame.size.width - (textSize.width + 2 * textMarginHorizontal) - 40.0f - 3.0f, ballonViewFrame.origin.y + 7, textSize.width, textSize.height);
        
        avatarImageFrame = CGRectMake(self.frame.size.width - 40.0f - textMarginHorizontal, timeLabelFrame.size.height + 20, 50.0f, 50.0f);

    } else {
        ballonViewFrame = CGRectMake(textMarginHorizontal + 55.0f, timeLabelFrame.size.height + 2*textMarginVertical, textSize.width + 2*textMarginHorizontal, textSize.height + 2*textMarginVertical);
        
        messageLabelFrame = CGRectMake(textMarginHorizontal*2 + 55.0f, ballonViewFrame.origin.y + 5, textSize.width, textSize.height);
        avatarImageFrame = CGRectMake(textMarginHorizontal, timeLabelFrame.size.height + 20, 50.0f, 50.0f);
    }
    
    self.balloonView.image = [PTSMessagingCell balloonImage:self.sent isSelected:self.selected];
    
    /*Sets the pre-initialized frames  for the balloonView and messageView.*/
    self.balloonView.frame = ballonViewFrame;
    self.messageLabel.frame = messageLabelFrame;
    
    /*If shown (and loaded), sets the frame for the avatarImageView*/
    if (self.avatarImageView.image != nil) {
        self.avatarImageView.frame = avatarImageFrame;
    }
    
    /*If there is next for the timeLabel, sets the frame of the timeLabel.*/
    
    if (self.timeLabel.text != nil) {
        self.timeLabel.frame = timeLabelFrame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	/*Selecting a UIMessagingCell will cause its subviews to be re-layouted. This process will not be animated! So handing animated = YES to this method will do nothing.*/
    [super setSelected:selected animated:NO];
    
    [self setNeedsLayout];
    
    /*Furthermore, the cell becomes first responder when selected.*/
    if (selected == YES) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
}

#pragma mark -
#pragma mark UIGestureRecognizer-Handling

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    /*When a LongPress is recognized, the copy-menu will be displayed.*/
    if (longPressRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    if ([self becomeFirstResponder] == NO) {
        return;
    }
    
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.balloonView.frame inView:self];
    
    [menu setMenuVisible:YES animated:YES];
}

-(BOOL)canBecomeFirstResponder {
    /*This cell can become first-responder*/
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    /*Allows the copy-Action on this cell.*/
    if (action == @selector(copy:)) {
        return YES;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

-(void)copy:(id)sender {
    /**Copys the messageString to the clipboard.*/
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.messageLabel.text];
}
@end


