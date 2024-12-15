<div align="center">
  <h1>Dart plugins for native code</h1>
</div>
<div align="center">

[![license_badge]][license_url]
[![build_badge]][build_url]

</div>

This repo contains Dart plugins to easily incorporate native(C/C++) code into Dart/Flutter projects.

# wasm_ffi

[![github_badge]][wasm_ffi_github_url]
[![wasm_ffi_pub_ver]][wasm_ffi_pub_url]
[![wasm_ffi_pub_points]][wasm_ffi_pub_score_url]
[![wasm_ffi_pub_popularity]][wasm_ffi_pub_score_url]
[![wasm_ffi_pub_likes]][wasm_ffi_pub_score_url]

[wasm_ffi][wasm_ffi_github_url] is a `dart:ffi` replacement for the web platform. `dart:ffi` is presently not available for the web. `wasm_ffi` enables using the same native(C/C++) code across all platforms.

# universal_ffi

[![github_badge]](https://github.com/vm75/native.ffi/tree/main/universal_ffi)
[![universal_ffi_pub_ver]][universal_ffi_pub_url]
[![universal_ffi_pub_points]][universal_ffi_pub_score_url]
[![universal_ffi_pub_popularity]][universal_ffi_pub_score_url]
[![universal_ffi_pub_likes]][universal_ffi_pub_score_url]

[universal_ffi](https://github.com/vm75/native.ffi/tree/main/universal_ffi) is a wrapper on top of `wasm_ffi` and `dart:ffi` to provide unified way to use ffi-like bindings for all platforms using the same native code.
It also has some helper methods to make it easier to use.

---

Contributions are welcome! 🚀

[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_url]: https://github.com/vm75/native.ffi/blob/main/LICENSE

[build_badge]: https://img.shields.io/github/actions/workflow/status/vm75/native.ffi/.github/workflows/publish.yml?branch=main
[build_url]: https://github.com/vm75/native.ffi/actions

[github_badge]: https://img.shields.io/badge/github-gray?style=flat&logo=Github

[wasm_ffi_pub_ver]: https://img.shields.io/pub/v/wasm_ffi
[wasm_ffi_pub_points]: https://img.shields.io/pub/points/wasm_ffi
[wasm_ffi_pub_popularity]: https://img.shields.io/pub/popularity/wasm_ffi
[wasm_ffi_pub_likes]: https://img.shields.io/pub/likes/wasm_ffi
[wasm_ffi_github_url]: https://github.com/vm75/native.ffi/tree/main/wasm_ffi
[wasm_ffi_pub_url]: https://pub.dev/packages/wasm_ffi
[wasm_ffi_pub_score_url]: https://pub.dev/packages/wasm_ffi/score

[universal_ffi_pub_ver]: https://img.shields.io/pub/v/universal_ffi
[universal_ffi_pub_points]: https://img.shields.io/pub/points/universal_ffi
[universal_ffi_pub_popularity]: https://img.shields.io/pub/popularity/universal_ffi
[universal_ffi_pub_likes]: https://img.shields.io/pub/likes/universal_ffi
[universal_ffi_github_url]: https://github.com/vm75/native.ffi/tree/main/universal_ffi
[universal_ffi_pub_url]: https://pub.dev/packages/universal_ffi
[universal_ffi_pub_score_url]: https://pub.dev/packages/universal_ffi/score