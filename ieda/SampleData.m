//
//  SampleData.m
//  ieda
//
//  Created by Yu Chen on 8/31/14.
//  Copyright (c) 2014 Tetherless World Constellation. All rights reserved.
//

#import "SampleData.h"
#import "XMLReader.h"

@implementation SampleData
@synthesize sampleDataTemplate;
@synthesize sampleDataTemplateDict;
@synthesize restrictionString;
@synthesize currentEditData;
@synthesize sampleDataSendingQueue;
@synthesize sampleDataQueue;
@synthesize responseData;

static SampleData* _sharedInstance;

- (id)init{
    
    if (self=[super init]) {
        // Init currentEditDate
        currentEditData = [[NSMutableDictionary alloc] init];
        //Parse schema
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"schema" ofType:@"xsd"];
        NSData* schemaData = [NSData dataWithContentsOfFile:filePath];
        sampleDataTemplate = [XMLReader dictionaryForXMLData:schemaData];
        NSLog(@"Loading schema file");
        
        sampleDataTemplateDict = [[NSMutableDictionary alloc] init];
        restrictionString = @"None";
        
        for (int i=1; i<[[[sampleDataTemplate objectForKey:@"xs:schema"] objectForKey:@"xs:element"] count]; i++) {
            NSDictionary* oneAttribute = [[[sampleDataTemplate objectForKey:@"xs:schema"] objectForKey:@"xs:element"] objectAtIndex:i];
            //Check if "type" exists; if not, then should be a complex type...
            NSArray* valArray = [[NSArray alloc] init];
            //restrictionString = [[NSString alloc] init];
            
            if (![oneAttribute objectForKey:@"type"]) {
                //simple type....
                if ([oneAttribute objectForKey:@"xs:simpleType"]) {
                    if ([[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:enumeration"]) {
                        //Enum
                        NSArray* enumArray = [[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:enumeration"];
                        NSMutableArray* enumVal = [[NSMutableArray alloc] init];
                        for (int j = 0; j<[[[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:enumeration"] count]; j++) {
                            [enumVal addObject:[[[[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:enumeration"] objectAtIndex:j] objectForKey:@"value"]];
                        }
                        valArray = [[NSArray alloc] initWithArray:enumVal];
                        [self setRestrictionString:@""];
                        //NSLog(@"1");
                    }else if ([[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:pattern"]){
                        //String with restriction
                        valArray = @[@""];
                        @try {
                            [self setRestrictionString:[[[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:pattern"] objectForKey:@"value"]];
                        }
                        @catch (NSException *exception) {
                            // Weird encoding for the user code...
                            [self setRestrictionString:[[[[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:pattern"] objectAtIndex:0] objectForKey:@"value"] ];
                            [self setRestrictionString:[restrictionString stringByAppendingString:[[[[[oneAttribute objectForKey:@"xs:simpleType"] objectForKey:@"xs:restriction"] objectForKey:@"xs:pattern"] objectAtIndex:1] objectForKey:@"value"]]];
                            
                        }
                        @finally {
                            //NSLog(@"Restriction for %@ is %@",[oneAttribute objectForKey:@"name"],[self restrictionString]);
                            //NSLog(@"2");
                        }
                        
                    }
                }else if ([oneAttribute objectForKey:@"xs:complexType"]){
                    //Do nothing now...
                    //Looks like complex type is similar to string
                    valArray = @[@""];
                    [self setRestrictionString:@""];
                    //NSLog(@"Restriction for %@ is %@",[oneAttribute objectForKey:@"name"],restriction);
                    //NSLog(@"3");
                }
            }else{
                //Simple val,string
                valArray = @[@""];
                [self setRestrictionString:@""];
                //NSLog(@"Restriction for %@ is %@",[oneAttribute objectForKey:@"name"],restriction);
                //NSLog(@"4");
            }
            //NSLog(@"Name:%@,valList:%@,restriction:%@",[oneAttribute objectForKey:@"name"],[valArray description],[self restrictionString]);
            NSDictionary* attributeProp = [[NSDictionary alloc] initWithObjectsAndKeys:[oneAttribute objectForKey:@"use"],@"required",valArray,@"valList",[self restrictionString],@"restriction",nil];
            
            [sampleDataTemplateDict setValue:[NSDictionary dictionaryWithDictionary:attributeProp] forKey:[oneAttribute objectForKey:@"name"]];
            
        }
        //Done with the schema
        //NSLog(@"%@",[sampleDataTemplateDict description]);
        //NSLog(@"%@",[[[sampleDataTemplateDict objectForKey:@"publish_date"] objectForKey:@"restriction"] description]);
        NSLog(@"Loading done");
    }
    
    return self;
    
}

+ (SampleData*) sharedInstance{
    
    if (!_sharedInstance) {
        _sharedInstance = [[SampleData alloc] init];
    }
    
    return _sharedInstance;
}

- (void) doneEditingCurrent{
    //Push current nsmutabledictionary to sending queue
    //Finally add an id to the current data
    NSString* profileId = [NSString stringWithFormat:@"%0.10u", arc4random()];
    [[[SampleData sharedInstance] currentEditData] setValue:profileId forKey:@"ssid"];
    [sampleDataQueue addObject:[NSDictionary dictionaryWithDictionary:currentEditData]];
    [self checkInternetConnectionAndSend];
    currentEditData = [[NSMutableDictionary alloc] init];
}

+(NSString*)ConvertDictionarytoXML:(NSDictionary*)dictionary withStartElement:(NSString*)startele
{
    NSMutableString *xml = [[NSMutableString alloc] initWithString:@""];
    NSArray *arr = [dictionary allKeys];
    [xml appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    [xml appendString:[NSString stringWithFormat:@"<%@>",startele]];
    for(int i=0;i<[arr count];i++)
    {
        id nodeValue = [dictionary objectForKey:[arr objectAtIndex:i]];
        if([nodeValue isKindOfClass:[NSArray class]] )
        {
            if([nodeValue count]>0){
                for(int j=0;j<[nodeValue count];j++)
                {
                    id value = [nodeValue objectAtIndex:j];
                    if([ value isKindOfClass:[NSDictionary class]])
                    {
                        [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                        [xml appendString:[NSString stringWithFormat:@"%@",[value objectForKey:@"text"]]];
                        [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
                    }
                    
                }
            }
        }
        else if([nodeValue isKindOfClass:[NSDictionary class]])
        {
            [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
            if([[nodeValue objectForKey:@"Id"] isKindOfClass:[NSString class]])
                [xml appendString:[NSString stringWithFormat:@"%@",[nodeValue objectForKey:@"Id"]]];
            else
                [xml appendString:[NSString stringWithFormat:@"%@",[[nodeValue objectForKey:@"Id"] objectForKey:@"text"]]];
            [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
        }
        
        else
        {
            if([nodeValue length]>0){
                [xml appendString:[NSString stringWithFormat:@"<%@>",[arr objectAtIndex:i]]];
                [xml appendString:[NSString stringWithFormat:@"%@",[dictionary objectForKey:[arr objectAtIndex:i]]]];
                [xml appendString:[NSString stringWithFormat:@"</%@>",[arr objectAtIndex:i]]];
            }
        }
    }
    
    [xml appendString:[NSString stringWithFormat:@"</%@>",startele]];
    NSString *finalxml=[xml stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
    //  NSLog(@"%@",xml);
    return finalxml;
}


- (BOOL) sendSamples{
    //Make a copy of the sending queue
    self.sampleDataSendingQueue = [self.sampleDataQueue copy];
    
    //Send one object at a time. if successful,remove the object from the data queue;otherwise, keep it there
    NSMutableArray* doneSamples = [[NSMutableArray alloc] init];
    for (int i=0; i<self.sampleDataSendingQueue.count; i++) {
        
        [SampleData ConvertDictionarytoXML:[self.sampleDataSendingQueue objectAtIndex:i] withStartElement:@"sample"];
    }
    return YES;
}

-(BOOL) postDictionaryData:(NSString*)xmlContent withUsername:(NSString*)username password:(NSString*)password{
    
    //username: sesartest@gmail.com password:registersamples
    if ([username length]==0) {
        username = @"sesartest@gmail.com";
        password = @"registersamples";
    }

    NSLog(@"Username:%@, Password:%@",username,password);

    NSString* userAuthenticationAddr = @"http://app.geosamples.org/webservices/uploadservice.php";
    
    NSString *post = [NSString stringWithFormat:@"username=%@&password=%@&content=%@",username,password,xmlContent];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:userAuthenticationAddr]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
    return YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@\n", error.description);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"Got response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"reponse body is %@",responseBody);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[responseData length]);
    NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
}



-(BOOL) checkInternetConnectionAndSend{
    //Check if the web service is available
    
    //Check Internet connection
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Yayyy, we have the interwebs!");
            //Send data
            self.sampleDataSendingQueue = [self.sampleDataQueue copy];
            NSMutableArray* doneSamples = [[NSMutableArray alloc] init];
            for (int i=0; i<[self.sampleDataSendingQueue count]; i++) {
                NSLog(@"Sending %d",i);
                //Send data one by one
                NSMutableDictionary* oneSampleData = [[self.sampleDataSendingQueue objectAtIndex:i] copy];
                NSString* ssid = [oneSampleData objectForKey:@"ssid"];
                [oneSampleData removeObjectForKey:@"ssid"];
                NSString* xmlContent = [SampleData ConvertDictionarytoXML:oneSampleData withStartElement:@"sample"];
                [self postDictionaryData:xmlContent withUsername:@"" password:@""];
                [doneSamples addObject:[ssid copy]];
                
            }
            
        });
    };
    
    // Internet is not reachable
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Someone broke the internet :(");
            
        });
    };
    
    [internetReachableFoo startNotifier];
    
    return YES;
}

@end
