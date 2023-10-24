#import <Foundation/Foundation.h>

%hook NSURLSession

- (id)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    void (^customCompletion)(NSData *data, NSURLResponse *response, NSError *error) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (([request.URL.absoluteString containsString:@"subscribers"] || [request.URL.absoluteString containsString:@"receipt"]) && (![request.URL.absoluteString containsString:@"offerings"])) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

            NSDate *currentDate = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *dateComponents = [[NSDateComponents alloc] init];

            // Set the expires_date to a future date (e.g., one year from the current date)
            dateComponents.year = 1;
            NSDate *expiresDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];

            // Set the purchase_date to one year in the past
            dateComponents.year = -1;
            NSDate *purchaseDate = [calendar dateByAddingComponents:dateComponents toDate:currentDate options:0];

            NSDictionary *dict = @{
                @"request_date": [dateFormatter stringFromDate:currentDate],
                @"request_date_ms": @([currentDate timeIntervalSince1970] * 1000),
                @"subscriber": @{
                    @"entitlements": @{
                        @"subscription": @{
                            @"expires_date": [dateFormatter stringFromDate:expiresDate],
                            @"original_purchase_date": [dateFormatter stringFromDate:purchaseDate],
                            @"purchase_date": [dateFormatter stringFromDate:purchaseDate], // Set the purchase date to one year in the past
                            @"product_identifier": @"com.sbs.diet.1m1199.1w0"
                        }
                    },
                    @"first_seen": [dateFormatter stringFromDate:purchaseDate],
                    @"last_seen": [dateFormatter stringFromDate:currentDate],
                    @"management_url": [NSNull null],
                    @"non_subscriptions": [NSNull null],
                    @"original_app_user_id": @"70B24288-83C4-4035-B001-573285B21AE2",
                    @"original_application_version": @"3",
                    @"original_purchase_date": [dateFormatter stringFromDate:purchaseDate],
                    @"other_purchases": [NSNull null],
                    @"subscriptions": @{
                        @"com.sbs.diet.1m1199.1w0": @{
                            @"expires_date": [dateFormatter stringFromDate:expiresDate],
                            @"original_purchase_date": [dateFormatter stringFromDate:purchaseDate],
                            @"purchase_date": [dateFormatter stringFromDate:purchaseDate] // Set the purchase date to one year in the past
                        },
                        @"com.sbs.diet.1y0599.2w0": @{
                            @"expires_date": [dateFormatter stringFromDate:expiresDate],
                            @"original_purchase_date": [dateFormatter stringFromDate:purchaseDate],
                            @"purchase_date": [dateFormatter stringFromDate:purchaseDate] // Set the purchase date to one year in the past
                        }
                    },
                    @"entitlement": [NSNull null]
                }
            };

            data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        }
        completionHandler(data, response, error);
    };

    return %orig(request, customCompletion);
}
%end
