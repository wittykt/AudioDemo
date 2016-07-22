//
//  XMLParserCtr.h
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol XMLParserCtrDelegate<NSObject>

-(void)getAllSuggestions:(NSMutableArray *)array;

@end
@interface XMLParserCtr : NSObject
-(void)getData:(NSString *)text;
@property(strong,nonatomic)  id<XMLParserCtrDelegate>delegate;
@end
