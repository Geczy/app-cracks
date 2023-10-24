#import <Foundation/Foundation.h>


%hook NSURLSession

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    void (^customCompletion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {

        if (([request.URL.absoluteString containsString:@"subscriptions"]) && (![request.URL.absoluteString containsString:@"offerings"])) {
            NSDictionary *dict = @{
                @"data": @{
                    @"subscriptions": @[
                        @{
                            @"id": @134293,
                            @"user_id": @"f8ed7725-22d7-46e0-8768-bb0a3edb200b",
                            @"source": @"stripe",
                            @"is_subscribed": @YES,
                            @"subscribed_at": @1602947987000,
                            @"subscribed_at_date": @"2020-10-17T15:19:47Z",
                            @"expiration_at": @1697555987000,
                            @"expiration_at_date": @"2099-10-17T15:19:47Z",
                            @"renewable": @NO,
                            @"canceled_at": @"2023-06-20T19:50:07Z",
                            @"product": @"com-fitbod-web-yearly-44_99-discount-25",
                            @"stripe_subscription_id": @"sub_123",
                            @"stripe_customer_id": @"cus_123",
                            @"prepaid_code_id": @0
                        }
                    ]
                },
                @"error": @""
            };
            data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        }
        completionHandler(data, response, error);
    };

    return %orig(request, customCompletion);
}
%end
