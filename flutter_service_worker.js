'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "e35c48a24cce527584de467860868dce",
"manifest.json": "c45571e2d84148a6242f43f0b88a4ee1",
"index.html": "83fc3c8c3037f770d8b55bf058ece138",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "c249dd39ffe903ef334b7d7296fb1700",
"assets/LICENSE": "66208be64cc470d4fa4c5147299a27c7",
"assets/packages/flutter_markdown/assets/logo.png": "67642a0b80f3d50277c44cde8f450e50",
"assets/lib/examples/loading_and_initializing_form.dart": "1b6b88277052b23c35a667cd33bcdc09",
"assets/lib/examples/submission_error_to_field_form.dart": "192d2c0714edcf42d11ead70a75f66b8",
"assets/lib/examples/all_fields_form.dart": "952562ae9335687b5ac92b25474156dd",
"assets/lib/examples/submission_progress_form.dart": "732715f72fcd14d74f6ca3cf78b6a626",
"assets/lib/examples/crud_from.dart": "d41d8cd98f00b204e9800998ecf8427e",
"assets/lib/examples/wizard_form.dart": "4deecf511e33739ed97f99b276bb5708",
"assets/lib/examples/async_field_validation_form.dart": "2cb3a6152e14dcb5a55bd4da3189565e",
"assets/lib/examples/serialized_form.dart": "54ebeea60c5a13fc13724ac1fa6d365c",
"assets/lib/examples/simple_form.dart": "7847b85e02690da24bb088f8c8c14f45",
"assets/lib/examples/list_fields_form.dart": "6204a9e473c5f449a41629e643af2388",
"assets/lib/examples/conditional_fields_form.dart": "2468dc3253d435358b39036c360972b9",
"assets/lib/examples/validation_based_on_other_field.dart": "4475d783860c25f40b5fc13c874171e1",
"assets/assets/fonts/JosefinSans-Bold.ttf": "0fce6d85ecbbf3d97e0d848824454600",
"assets/assets/fonts/JosefinSans-Regular.ttf": "70e2eb768304d11812d28e33e91ecac5",
"assets/AssetManifest.json": "8c3aca620607ed91685e7a9034cb9d69"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request);
      })
  );
});
