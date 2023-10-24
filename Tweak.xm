#import <Foundation/Foundation.h>


%hook NSURLSession

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    void (^customCompletion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {

        if (([request.URL.absoluteString containsString:@"subscribers"] || [request.URL.absoluteString containsString:@"receipt"]) && (![request.URL.absoluteString containsString:@"offerings"])) {
            NSDictionary *dict = @{
    @"request_date": @"2023-08-02T02:21:57Z",
    @"request_date_ms": @1690942917283,
    @"subscriber": @{
        @"entitlements": @{
            @"premium": @{
                @"expires_date": @"2099-02-18T07:52:54Z",
                @"original_purchase_date": @"2020-02-11T07:52:55Z",
                @"purchase_date": @"2020-02-11T07:52:54Z",
                @"product_identifier": @"com.touchbyte.PhotoSync.PremiumLifetime"
            }
        },
        @"first_seen": @"2023-07-27T12:47:03Z",
        @"last_seen": @"2023-08-02T01:57:17Z",
        @"management_url": NSNull.null,
        @"non_subscriptions": @{
        },
        @"original_app_user_id": @"70B24288-83C4-4035-B001-573285B21AE2",
        @"original_application_version": @"3",
        @"original_purchase_date": @"2023-07-26T17:04:14Z",
        @"other_purchases": @{
        },
        @"subscriptions": @{
            @"com.touchbyte.PhotoSync.PremiumLifetime": @{
                @"expires_date": @"2099-02-18T07:52:54Z",
                @"original_purchase_date": @"2020-02-11T07:52:55Z",
                @"purchase_date": @"2020-02-11T07:52:54Z"
            }
        },
        @"entitlement": @{
        }
    }
};
            data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        }
        completionHandler(data, response, error);
    };

    return %orig(request, customCompletion);
}
%end
