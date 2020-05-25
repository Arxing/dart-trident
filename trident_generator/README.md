## trident_generator

`trident_generator` can generate restful api by simple ways, 
use with [trident](https://pub.dev/packages/trident/versions/1.0.0),
 a example is [telebot](https://pub
.dev/packages/telebot).

## Part Example from `telebot` 

```dart
@Trident()
abstract class TelegramBotClient {
  
  @GET("/getUpdates")
  Future<List<Update>> getUpdates(
      {@Query("offset") int offset,
      @Query("limit") int limit,
      @Query("timeout") int timeout,
      @Query("allowed_updates") List<String> allowedUpdates});

  @GET("/setWebhook")
  Future<bool> setWebhook(
      {@Query("url") @required String url,
      @Query("certificate") File certificate,
      @Query("max_connections") int maxConnections,
      @Query("allowed_updates") List<String> allowedUpdates});

  @GET("/deleteWebhook")
  Future<bool> deleteWebhook();

  @GET("/getWebhookInfo")
  Future<WebhookInfo> getWebhookInfo();

  @GET("/getMe")
  Future<User> getMe();
}
```


