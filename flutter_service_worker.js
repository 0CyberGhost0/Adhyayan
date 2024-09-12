'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"flutter_bootstrap.js": "c654480cfaa42004f267fe1ec2b3ccbf",
"version.json": "409a77c2d908534781b454fecbbdd502",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "c182261c9c2222b7d77ebb875ee26e25",
"assets/AssetManifest.bin.json": "1b2737765d61182e218b99615f44d4e8",
"assets/packages/iconsax/lib/assets/fonts/iconsax.ttf": "071d77779414a409552e0584dcbfd03d",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b93248a553f9e8bc17f1065929d5934b",
"assets/AssetManifest.json": "3d2c06425b7ea4e03d8d1882786f4ec8",
"assets/FontManifest.json": "ad0f5ca8ad5971606e2bebe7ac405fae",
"assets/assets/videos/sampleVideo.mp4": "b750d0d7720a52d0b63037cd4bfe97a7",
"assets/assets/videos/sampleVideo2.mp4": "aba2e5d79e0145665cc4cb6621f1df1b",
"assets/assets/images/upload.png": "178c503042b5f0120877d96e6565bcbe",
"assets/assets/images/lock.png": "db6a8a5ffc8f43c65a0c6d70832851e1",
"assets/assets/images/Code.png": "9023d1d0ffdde7714f4a759b5f680dfc",
"assets/assets/images/success.png": "7e161c0436360cf66bf37d0437208a0c",
"assets/assets/images/Design.png": "a1c9a8202641d6ee72acbb5be8fa7d4b",
"assets/assets/images/tick.png": "17ed97bd9d4313416fa830d70ede38d5",
"assets/assets/images/nothing.png": "e0356016ba6dd5b2e155a81a3fef79da",
"assets/assets/images/warning.png": "ca4e68cca5fcf2a52987b9ca665346ad",
"assets/assets/images/failure.png": "64e8b5f258b3369a05b9696097f2b2d2",
"assets/assets/images/uploadedVideo.png": "5229132bda4b3f230bd6e833174ed730",
"assets/assets/images/newimage.jpg": "2c1e069c7ee5c93d1a431d5e83563f78",
"assets/assets/images/google.png": "1b943d724cb2d7c49f888f750ce3a479",
"assets/assets/images/icon.png": "b68e0bfa4cec8262820c6ec58b419373",
"assets/assets/images/Data.png": "0277a2e7558376f56d5185a0966b3528",
"assets/assets/images/uiux.png": "328871542e20fc4877e564a93a45bd6e",
"assets/assets/images/searchImage.png": "825cad02a1df25fa23f47e6d6ac63d60",
"assets/assets/images/Business.png": "099a29326f6454fa9b3fe5da7b0a2c0b",
"assets/assets/images/play.png": "2a2b53ec55c1eb515db66851267fa8f0",
"assets/assets/images/Finance.png": "e2e79167b23f112e0409a92fa8eb67e2",
"assets/assets/images/search.png": "c02fc5fcd5920b8766c73f4c701edd64",
"assets/assets/images/notification.png": "cb6234d340fdce1beae3bb17a1a6df21",
"assets/assets/images/background1.jpg": "fa8c061a3d37081ab0d0629b72019356",
"assets/assets/images/background.png": "fa907247df3e3571c9243a77627b2757",
"assets/assets/images/animations/141594-animation-of-docer.json": "0447d6592aa7c62f7464b5a867a18bf7",
"assets/assets/images/animations/order-complete-car-delivery-animation.json": "f4ac9e34a730c64dad0940752f2438bd",
"assets/assets/images/animations/sammy-line-travel-backpack-with-passport-and-air-ticket.gif": "a691c26c3c08c432f68ce4b117dcb6a0",
"assets/assets/images/animations/136491-animation-lottie-car-rides.json": "c7be1f7cd21460d83e7af61b45c23294",
"assets/assets/images/animations/sammy-line-come-back-later.png": "bb489d0ad837808917ed0b3bd2c17d97",
"assets/assets/images/animations/110052-paper-plane.json": "f37753fd6490213aafe42c28ce082860",
"assets/assets/images/animations/53207-empty-file.json": "798eedcbdacc86b43851c8f678c4eb83",
"assets/assets/images/animations/sammy-line-success.png": "4aaf57cacb9b7514f345bd45cea880e1",
"assets/assets/images/animations/72785-searching.json": "42d6b09696a19c24719a8102a4f093c9",
"assets/assets/images/animations/lady-adding-product-in-cart-animation.json": "fa6f9ae5b579cf56ade9fec2d74010af",
"assets/assets/images/animations/sammy-line-man-receives-a-mail.png": "05ecfa9b154cb7fe1d4f4339119a3b45",
"assets/assets/images/animations/140429-pencil-drawing.json": "ad496d8fba433f392cac58a28f592c5a",
"assets/assets/images/animations/sammy-line-workout.gif": "32c3916fc369a730a7aa7a6c24b9583e",
"assets/assets/images/animations/72462-check-register.json": "f025dd10b211685777be1fc8b9d43f37",
"assets/assets/images/animations/loader-animation.json": "2f4d8873f57c144c9c1cc001c19fd2fd",
"assets/assets/images/animations/sammy-line-sale.png": "c8cf76d47496487772f231d41e3673ed",
"assets/assets/images/animations/cloud-uploading-animation.json": "1cd38deb1399a0368a650d21dc2fdcab",
"assets/assets/images/animations/141397-loading-juggle.json": "18cd80a46915ce96176088f6de32cc17",
"assets/assets/images/animations/98783-packaging-in-progress.json": "ad95f6974da0dbcbb295e6ca62997668",
"assets/assets/images/animations/104368-thank-you.json": "cb41def8492745f6da17aa174f24bc18",
"assets/assets/images/animations/120978-payment-successful.json": "23257c5bfbb6517be2883084bac86fe7",
"assets/assets/images/animations/67263-security-icon-transparent.json": "c6aa8a75f3bdf204d2c7fe86a68076e0",
"assets/assets/images/bookmark2.png": "e2788a0df7f8fe9ab4b927794df653b1",
"assets/assets/images/mentor.png": "b907dc756c5ac066437b40a2dd900187",
"assets/assets/images/bookmark1.png": "be4b890465cbd844ce481a7162c996d6",
"assets/assets/images/blender.jpg": "4985002256c2197078152028a82e577d",
"assets/assets/fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/fonts/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/NOTICES": "c85134a9ed95f173f00fc5b1590b0bea",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/AssetManifest.bin": "3208da0cd8ea68ec55db8b99c505f164",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"index.html": "8c37378e80791d91c49fa89892efed64",
"/": "8c37378e80791d91c49fa89892efed64",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"manifest.json": "b8e1a2ba2b821b8c63e255572922785c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
