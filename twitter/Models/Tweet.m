//
//  Tweet.m
//  twitter
//
//  Created by lucjia on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"
#import "NSDate+DateTools.h"

@implementation Tweet

// data models: objects that store data for reusability and to reduce errors in code
// can be used for databases
// data models do all of the work in one single place

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        // Initialize user
        NSDictionary *user = dictionary[@"user"];
        self.user = [[User alloc] initWithDictionary:user];
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configure the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
        // Convert String to Date
        NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Convert Date to String
        self.createdAtString = [NSString stringWithFormat:[date shortTimeAgoSinceNow]];
    }
    return self;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
