'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "bc901e8428d1dcfc38045ac4dbeb01ad",
"assets/assets/jpg/header_main_image.jpg": "974a990da443826c7d59029b7b069221",
"assets/assets/jpg/image_slide_a.jpeg": "597b90718c4355a56c09d4dcac0a7222",
"assets/assets/jpg/image_slide_a.jpg": "9546904b67e558e7d83bef9572012796",
"assets/assets/jpg/image_slide_b.jpeg": "2b88ceece28cf52e07e0e59e83a5e724",
"assets/assets/jpg/image_slide_b.jpg": "9d6635dd9c37bea21216998e10a7d82f",
"assets/assets/jpg/image_slide_c.jpg": "130383a015430377d76851078835a5af",
"assets/assets/jpg/logo_escuela.jpeg": "91bb1ed74428eba5732e5a89e2e0bfc4",
"assets/assets/jpg/logo_escuela_b.jpeg": "96dcdf493d8a9a9fb4da4a4b69ead6aa",
"assets/assets/svg/a%25C3%25B1adir.svg": "7069dc0e83e0f4f00c019d16857db6f7",
"assets/assets/svg/books.svg": "e09539c77da21ce93f83a4d6e1418cde",
"assets/assets/svg/buscar.svg": "d0d2f4ffd2b2c097b582dfcbf1f7d29d",
"assets/assets/svg/cerebro.svg": "58964e9a7b58ab16d63b979f1ebb2bbb",
"assets/assets/svg/correo.svg": "a9dd6e51abdf3039fefe7d4cc4917ebc",
"assets/assets/svg/editar.svg": "4ff5eb5ff459a7e3e3dc0f8f8c1e7f4d",
"assets/assets/svg/eliminar.svg": "5ecec402b3f4c2c9a9f833d4911bcca1",
"assets/assets/svg/encuestas.svg": "76a4a990134aa6aac0cf9b832d1382d8",
"assets/assets/svg/examen.svg": "8e6994dee90e39bb5356fb2f8beb79c4",
"assets/assets/svg/fb.svg": "83f1566d1b38373f758fc5dbe54b31fb",
"assets/assets/svg/home.svg": "c1d4acac766093700479c160d75c1b44",
"assets/assets/svg/Icono_ArrowL.svg": "46a983e499a68fb9ecb5a9571a6b9cd3",
"assets/assets/svg/Icono_ArrowR.svg": "8504ada62c6ea2bc2f15c77aef805ac3",
"assets/assets/svg/Icono_Facebook.svg": "3b702af1b3cad5de4bd6dcd5432a5d71",
"assets/assets/svg/Icono_Mail.svg": "27e5fb4abafd59964f32c51433c52505",
"assets/assets/svg/Icono_Maps.svg": "2afd719f78b53ea254f4b2d75d6ca545",
"assets/assets/svg/Icono_Menu.svg": "651a893fc4d9aa9fa3263a07de45609b",
"assets/assets/svg/Icono_Paint.svg": "7937b92980dc7a46eba0cb1b64a4cc97",
"assets/assets/svg/Icono_Pencil.svg": "fa78cfca65ab4cb088fdbbe650068257",
"assets/assets/svg/Icono_What.svg": "812b867f87f90ea8010b3731dd97ba7a",
"assets/assets/svg/idea.svg": "17511862c0f180079605e14caef36cf8",
"assets/assets/svg/insta.svg": "c145287af0ce22d9de84b6396fa01d51",
"assets/assets/svg/Logo-footer.svg": "98fce3cfe0e4d1c4cef36cf1ca7091d1",
"assets/assets/svg/Logo_Escuela.svg": "2c7c8002456e2aac6e1a38ed198d3510",
"assets/assets/svg/maps.svg": "c1e7dc8ccb98a7dc386da574569586d7",
"assets/assets/svg/notificacion.svg": "b7ccc66e618905091d69d4527f053934",
"assets/assets/svg/psicologia.svg": "8a75e76f5dc1cf47be2e870fc6813e97",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "7e7a6cccddf6d7b20012a548461d5d81",
"assets/NOTICES": "aac91ef5e94c7b6aa184ab205f2ea6b8",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "c2b4e5f3d7a3d82aed024e7249a78487",
"canvaskit/canvaskit.wasm": "4b83d89d9fecbea8ca46f2f760c5a9ba",
"canvaskit/profiling/canvaskit.js": "ae2949af4efc61d28a4a80fffa1db900",
"canvaskit/profiling/canvaskit.wasm": "95e736ab31147d1b2c7b25f11d4c32cd",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "41b646b059278730dec5ef7cd5f7c80b",
"/": "41b646b059278730dec5ef7cd5f7c80b",
"main.dart.js": "9d62cb571e2d769c16427cfdc6b4a072",
"manifest.json": "389d5f37931d304a37313c40304e263b",
"version.json": "bccc4b74ae6257754e315659eeba6575"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
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
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
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
