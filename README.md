<div align="center">
  <h1>Dart plugins for native code</h1>
</div>
<div align="center">

[![License]](LICENSE)
[![Build]][build_url]

</div>

This repo contains Dart plugins to easily incorporate native(C/C++) code into Dart/Flutter projects.

# wasm_ffi

[![Repo]](https://github.com/vm75/native.ffi/tree/main/wasm_ffi)
[![Pub Version](https://img.shields.io/pub/v/wasm_ffi)](https://pub.dev/packages/wasm_ffi)
[![Pub Points](https://img.shields.io/pub/points/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)
[![Pub Likes](https://img.shields.io/pub/likes/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)

[wasm_ffi](https://github.com/vm75/native.ffi/tree/main/wasm_ffi) is a `dart:ffi` replacement for the web platform. `dart:ffi` is presently not available for the web. `wasm_ffi` enables using the same native(C/C++) code across all platforms.

# universal_ffi

[![Repo]](https://github.com/vm75/native.ffi/tree/main/universal_ffi)
[![Pub Version](https://img.shields.io/pub/v/universal_ffi)](https://pub.dev/packages/universal_ffi)
[![Pub Points](https://img.shields.io/pub/points/universal_ffi)](https://pub.dev/packages/universal_ffi/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/universal_ffi)](https://pub.dev/packages/universal_ffi/score)
[![Pub Likes](https://img.shields.io/pub/likes/universal_ffi)](https://pub.dev/packages/universal_ffi/score)

[universal_ffi](https://github.com/vm75/native.ffi/tree/main/universal_ffi) is a wrapper on top of `wasm_ffi` and `dart:ffi` to provide unified way to use ffi-like bindings for all platforms using the same native code.
It also has some helper methods to make it easier to use.

---

Contributions are welcome! 🚀

[license_url]: https://github.com/vm75/native.ffi/blob/main/LICENSE
[build_url]: https://github.com/vm75/native.ffi/actions

[License]: https://img.shields.io/badge/license-MIT-blue.svg
[Build]: https://img.shields.io/github/actions/workflow/status/vm75/native.ffi/.github/workflows/publish.yml?branch=main
[Repo]: https://img.shields.io/badge/github-gray?style=flat&logo=Github
