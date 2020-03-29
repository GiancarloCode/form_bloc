'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "c646e0841a2cc552c40c8e32dffd7693",
"manifest.json": "c45571e2d84148a6242f43f0b88a4ee1",
"index.html": "83fc3c8c3037f770d8b55bf058ece138",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/FontManifest.json": "c249dd39ffe903ef334b7d7296fb1700",
"assets/LICENSE": "66208be64cc470d4fa4c5147299a27c7",
"assets/packages/flutter_markdown/assets/logo.png": "67642a0b80f3d50277c44cde8f450e50",
"assets/lib/examples/loading_and_initializing_form.dart": "1b6b88277052b23c35a667cd33bcdc09",
"assets/lib/examples/submission_error_to_field_form.dart": "192d2c0714edcf42d11ead70a75f66b8",
"assets/lib/examples/all_fields_form.dart": "952562ae9335687b5ac92b25474156dd",
"assets/lib/examples/submission_progress_form.dart": "ff0c7884fc01e7ccf403792885a1244c",
"assets/lib/examples/crud_from.dart": "d41d8cd98f00b204e9800998ecf8427e",
"assets/lib/examples/wizard_form.dart": "9eb0d9f7251fbe5cf15155326f00357d",
"assets/lib/examples/async_field_validation_form.dart": "817318fe666a6f8b4f2bd2e6da5443ec",
"assets/lib/examples/serialized_form.dart": "54ebeea60c5a13fc13724ac1fa6d365c",
"assets/lib/examples/simple_form.dart": "130d969c08b00e847b1db0f8826b5097",
"assets/lib/examples/list_fields_form.dart": "6204a9e473c5f449a41629e643af2388",
"assets/lib/examples/conditional_fields_form.dart": "da0aa4addd807cc30ff1d52da27a38e3",
"assets/lib/examples/validation_based_on_other_field.dart": "add7a6b3e888b964c089bb012d9ef3e5",
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
