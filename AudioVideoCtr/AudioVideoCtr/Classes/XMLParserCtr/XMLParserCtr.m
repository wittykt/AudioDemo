//
//  XMLParserCtr.m
//  AudioVideoCtr
//
//  Created by Lokesh on 7/15/16.
//  Copyright © 2016 Practice. All rights reserved.
//

#import "XMLParserCtr.h"
#define GoogleURL @"http://clients1.google.com/complete/search?hl=en&output=toolbar&q="
@interface XMLParserCtr()<NSXMLParserDelegate>
{
    NSXMLParser *obj_XMLParser;
    NSMutableArray *arrayURLData;
}

@end
@implementation XMLParserCtr
-(void)getData:(NSString *)text
{
    
    NSURLSessionConfiguration  *config= [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session= [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GoogleURL,text]];
    NSURLSessionDataTask *dataTask =[session dataTaskWithURL: url completionHandler:^(NSData *  data, NSURLResponse *response, NSError * error) {
        
        if(! error)
        {
            //----NSURLSession creates a new thread when executed.
            dispatch_async(dispatch_get_main_queue(), ^{
                obj_XMLParser = [[NSXMLParser alloc] initWithData:data];
                obj_XMLParser.delegate = self;
                [obj_XMLParser parse];

            }
                           );
                    }
     
        else
        {
            NSLog(@"Error : %@", [error localizedDescription]);
        }
    }
        ];
    [dataTask resume];
    
    
}

#pragma mark - // XMLParserDelegate
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict{
    if ([elementName isEqualToString:@"toplevel"]) {
        
        arrayURLData = [[NSMutableArray alloc] init];
        
    }
    if (attributeDict.count >0 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [arrayURLData addObject:[attributeDict objectForKey:@"data"]];
            NSLog(@"Object : %@",[attributeDict objectForKey:@"data"]);

        });
            }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{
    
    if ([elementName isEqualToString:@"toplevel"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
               [_delegate getAllSuggestions:arrayURLData];
        });
        
     
    }
    
    
}


@end
