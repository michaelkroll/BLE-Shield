/*
 PTSMessagingCell.h
 
Copyright (C) 2012 pontius software GmbH

This program is free software: you can redistribute and/or modify
it under the terms of the Createive Commons (CC BY-SA 3.0) license
*/

#import <UIKit/UIKit.h>

/** \class PTSMessagingCell
    \brief This class extends a UITableViewCell with a style similar to that of the SMS-App (iOS). It displays a text-message of any size (only limited by the capabilities of UIView), a timestamp (if given) and an avatar-Image (if given). 
 
    The cell will properly respond to orientation-changes and can be displayed on iPhones and iPads. The usage of this class is very simple: Initialize it, using the initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier-Method and afterwards set its properties, as you would with a commom UITabelViewCell.
 
    The class also implements behaviour regarding gesture recognizers and Copy/Paste. The PTSMessagingCells are selectable and its content can be copied to the clipboard.
 
    @author Ralph Gasser
    @date 2011-08-08
    @version 1.5
    @copyright Copyright 2012, pontius software GmbH
 */

@interface PTSMessagingCell : UITableViewCell {
    /*Subview of the MessaginCell, containing the Avatar-Image (if specified). It can be set in the cellForRowAtIndexPath:-Method.*/
    UIImageView* avatarImageView;
    
    /*Subview of the MessaginCell, containing the timestamp (if specified). It can be set in the cellForRowAtIndexPath:-Method.*/
    UILabel* timeLabel;
    
    /*Subview of the MessagingCell, containing the actual message. It can be set in the cellForRowAtIndexPath:-Method.*/
    UILabel* messageLabel;
    
    /*Specifies, if the message of the current cell was received or sent. This influences the way, the cell is rendered.*/
    BOOL sent;
    
    /*This is a private subview of the MessagingCell. It is not intended do be editable.*/
    @private UIView * messageView;
    
    /*This is a private subview of the MessagingCell, containing the ballon-graphic. It is not intended do be editable.*/
    @private UIImageView * balloonView;
}


@property (nonatomic, readonly) UIView * messageView;

@property (nonatomic, readonly) UILabel * messageLabel;

@property (nonatomic, readonly) UILabel * timeLabel;

@property (nonatomic, readonly) UIImageView * avatarImageView;

@property (nonatomic, readonly) UIImageView * balloonView;

@property (assign) BOOL sent;


/**Returns the text margin in horizontal direction.
 @return CGFloat containing the horizontal text margin.
 */
+(CGFloat)textMarginHorizontal;

/**Returns the text margin in vertical direction.
    @return CGFloat containing the vertical text margin.
*/
+(CGFloat)textMarginVertical;

/** Returns the maximum width for a single message. The size depends on the UIInterfaceIdeom (iPhone/iPad). FOR CUSTOMIZATION: To edit the maximum width, edit this method.
 @return CGFloat containing the maximal width.
 */
+(CGFloat)maxTextWidth;

/** Calculates and returns the size of a frame containing the message, that is given as a parameter.
    @param message NSString containing the message string.
    @return CGSize containing the size of the message (w/h).
 */
+(CGSize)messageSize:(NSString*)message;

/**  Returns the ballon-Image for specified conditions.
    @param sent Indicates, wheather the message has been sent or received.
    @param selected Indicates, wheather the cell has been selected.
 FOR CUSTOMIZATION: To edit the image, user your own names in this method.
*/
+(UIImage*)balloonImage:(BOOL)sent isSelected:(BOOL)selected;

/**Initializes the PTSMessagingCell.
    @param reuseIdentifier NSString* containing a reuse Identifier.
    @return Instanze of the initialized PTSMessagingCell. 
*/
-(id)initMessagingCellWithReuseIdentifier:(NSString*)reuseIdentifier;

@end

