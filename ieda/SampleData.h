//
//  SampleData.h
//  ieda
//
//  Created by Yu Chen on 8/31/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SampleData : NSObject<NSURLConnectionDataDelegate>{
    NSString* restrictionString;
    Reachability* internetReachableFoo;
}

@property (nonatomic,retain) NSXMLParser* schemaParser;
@property (nonatomic,retain) NSMutableArray* sampleDataQueue;
@property (nonatomic,retain) NSMutableArray* sampleDataSendingQueue;
@property (nonatomic,retain) NSMutableDictionary* sampleData;
@property (nonatomic,retain) NSDictionary* sampleDataTemplate;
@property (nonatomic,retain) NSMutableDictionary* sampleDataTemplateDict;
@property (nonatomic,retain) NSString* currentElement;
@property (nonatomic,retain) NSMutableString* ElementValue;
@property (nonatomic) BOOL errorParsing;
@property (nonatomic,retain) NSString* restrictionString;
@property (nonatomic,retain) NSMutableDictionary* currentEditData;
@property (nonatomic, retain) NSMutableData* responseData;

+ (SampleData*) sharedInstance;
+(NSString*)ConvertDictionarytoXML:(NSDictionary*)dictionary withStartElement:(NSString*)startele;
- (NSMutableDictionary*) newSampleInstance;
- (BOOL) addSampleInstanceToQueue:(NSMutableDictionary*) newSample;
- (BOOL) sendSamples;
- (void) doneEditingCurrent;

@end
