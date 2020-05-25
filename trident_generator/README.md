## trident_generator

```dart
abstract class Service {
  
  @GET('/api/user')
  Future<User> getUser(@Query('id') String id);
  
  @POST('/api/user')
  Future<void> updateUsername(@Field('name') String name);
}
```
