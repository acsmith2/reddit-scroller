//
//  RSRedditPostCell.m
//  RedditScroller
//
//  Created by Adam Smith on 8/18/13.
//  Copyright (c) 2013 Adam Smith. All rights reserved.
//

#import "RSRedditPostCell.h"
#import "UIImageView+AFNetworking.h"

@interface RSRedditPostCell ()

@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* subRedditLabel;
@property (strong, nonatomic) IBOutlet UILabel* nsfwLabel;
@property (strong, nonatomic) IBOutlet UILabel* domainLabel;
@property (strong, nonatomic) IBOutlet UILabel* commentsLabel;
@property (strong, nonatomic) IBOutlet UIImageView* thumbnailImageView;

@end

@implementation RSRedditPostCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRedditPost:(RSRedditPost *)redditPost
{
	NSLog(@"reddit post set to: %@",redditPost.title);
	[self.titleLabel setText:redditPost.title];
	
	[self.subRedditLabel setText:redditPost.subreddit];
	[self.nsfwLabel setHidden:!(redditPost.isNSFW)];
	[self.commentsLabel setText:[NSString stringWithFormat:@"%d comments",redditPost.numberOfComments]];
	[self.domainLabel setText:redditPost.domain];
	[self.thumbnailImageView setContentMode:UIViewContentModeScaleAspectFit];
	if ((redditPost.thumbnail_url != nil) && (![redditPost.thumbnail_url isEqualToString:@""])){
		[self.thumbnailImageView setImageWithURL:[NSURL URLWithString:redditPost.thumbnail_url] placeholderImage:[UIImage imageNamed:@"RedditLogo"]];
	} else {
		[self.thumbnailImageView setImage:[UIImage imageNamed:@"RedditLogo"]];
	}
	_redditPost = redditPost;
}

@end
