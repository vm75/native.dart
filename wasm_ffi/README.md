# wasm_ffi

[![License]](LICENSE)
[![Build]][build_url]
[![Repo]](https://github.com/vm75/native.ffi/tree/main/wasm_ffi)
[![Pub Version](https://img.shields.io/pub/v/wasm_ffi)](https://pub.dev/packages/wasm_ffi)
[![Pub Points](https://img.shields.io/pub/points/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)
[![Pub Popularity](https://img.shields.io/pub/popularity/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)
[![Pub Likes](https://img.shields.io/pub/likes/wasm_ffi)](https://pub.dev/packages/wasm_ffi/score)

`wasm_ffi` intends to be a drop-in replacement for `dart:ffi` on the web platform using wasm. wasm_ffi is built on top of [web_ffi](https://pub.dev/packages/web_ffi).
The general idea is to expose an API that is compatible with `dart:ffi` but translates all calls through `dart:js` to a browser running `WebAssembly`.
Wasm with js helper as well as standalone wasm is supported. For testing emcc is used.

To simplify the usage, [universal_ffi](https://pub.dev/packages/universal_ffi) is provided, which uses `wasm_ffi` on web and `dart:ffi` on other platforms.

## Differences to dart:ffi
While `wasm_ffi` tries to mimic the `dart:ffi` API as close as possible, there are some differences. The list below documents the most importent ones, make sure to read it. For more insight, take a look at the API documentation.

* The [`DynamicLibrary`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibrary-class.html) `open` method is asynchronous. It also accepts some additional optional parameters.
* If more than one library is loaded, the memory will continue to refer to the first library. **This breaks calls to later loaded libraries!** One workaround is to specify the correct library.memory for each usage of `using`.
* Each library has its own memory, so objects cannot be shared between libraries.
* Some advanced types are still unsupported.
* There are some classes and functions that are present in `wasm_ffi` but not in `dart:ffi`; such things are annotated with [`@extra`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi_meta/extra-constant.html).
* There is a new class [`Memory`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi_modules/Memory-class.html) which is **IMPORTANT** and explained in deepth below.
* If you extend the [`Opaque`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/Opaque-class.html) class, you must register the extended class using [`@extra registerOpaqueType<T>()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi_modules/registerOpaqueType.html) before using it! Also, your class MUST NOT have type arguments (what should not be a problem).
* There are some rules concerning interacting with native functions, as listed below.

### Rules for functions
There are some rules and things to notice when working with functions:
* When looking up a function using [`DynamicLibrary.lookup<NativeFunction<NF>>()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibrary/lookup.html) (or [`DynamicLibraryExtension.lookupFunction<T extends Function, F extends Function>()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibraryExtension/lookupFunction.html)) the actuall type argument `NF` (or `T` respectively) of is not used: There is no type checking, if the function exported from `WebAssembly` has the same signature or amount of parameters, only the name is looked up.
* There are special constraints on the return type (not on parameter types) of functions `DF` (or `F` ) if you call [`NativeFunctionPointer.asFunction<DF>()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/NativeFunctionPointer/asFunction.html) (or [`DynamicLibraryExtension.lookupFunction<T extends Function, F extends Function>()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibraryExtension/lookupFunction.html) what uses the former internally):
    * You may nest the pointer type up to two times but not more:
        * e.g. `Pointer<Int32>` and `Pointer<Pointer<Int32>>` are allowed but `Pointer<Pointer<Pointer<Int32>>>` is not.
    * If the return type is `Pointer<NativeFunction>` you MUST use `Pointer<NativeFunction<dynamic>>`, everything else will fail. You can restore the type arguments afterwards yourself using casting. On the other hand, as stated above, type arguments for `NativeFunction`s are just ignored anyway.
    * To concretize the things above, [return_types.md](https://github.com/vm75/native.ffi/blob/main/wasm_ffi/return_types.md) lists what may be used as return type, everyhing else will cause a runtime error.
    * WORKAROUND: If you need something else (e.g. `Pointer<Pointer<Pointer<Double>>>`), use `Pointer<IntPtr>` and cast it yourselfe afterwards using [`Pointer.cast()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/Pointer/cast.html).

### Memory
NOTE: While most of this section is still correct, some of it is now automated.
The first call you sould do when you want to use `wasm_ffi` is [`Memory.init()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi_modules/Memory/init.html). It has an optional parameter where you can adjust your pointer size. The argument defaults to 4 to represent 32bit pointers, if you use wasm64, call `Memory.init(8)`.
Contraty to `dart:ffi` where the dart process shares all the memory, on `WebAssembly`, each instance is bound to a `WebAssembly.Memory` object. For now, we assume that every `WebAssembly` module you use has it's own memory. If you think we should change that, open a issue on [GitHub](https://github.com/vm75/native.ffi/) and report your usecase.
Every pointer you use is bound to a memory object. This memory object is accessible using the [`@extra Pointer.boundMemory`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/Pointer/boundMemory.html) field. If you want to create a Pointer using the [`Pointer.fromAddress()`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/Pointer/Pointer.fromAddress.html) constructor, you may notice the optional `bindTo` parameter. Since each pointer must be bound to a memory object, you can explicitly speficy a memory object here. To match the `dart:ffi` API, the `bindTo` parameter is optional. Because it is optional, there has to be a fallback mechanism if no `bindTo` is specified: The static [`Memory.global`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi_modules/Memory/global.html) field. If that field is also not set, an exception is thrown when invoking the `Pointer.fromAddress()` constructor.
Also, each [`DynamicLibrary`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibrary-class.html) is bound to a memory object, which is again accessible with [`@extra DynamicLibrary.boundMemory`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/DynamicLibrary/boundMemory.html). This might come in handy, since `Memory` implements the [`Allocator`](https://pub.dev/documentation/wasm_ffi/latest/wasm_ffi/Allocator-class.html) class.


## Usage

### Install
```
dart pub add wasm_ffi
```

or
```
flutter pub add wasm_ffi
```

### Usage without ffi bindings
```dart
import 'package:wasm_ffi/ffi.dart' as ffi;

Future<void> main() async {
    final library = await DynamicLibrary.open('path to wasm or js'); // NOTE: It is async
    final func = library.lookupFunction<int Function(), int Function()>('functionName');
    print(func());
}
```

### Usage with ffi bindings
Generates ffi bindings using [`package:ffigen`](https://pub.dev/packages/ffigen) on the header file.
In the generated bindings file, replace `import 'dart:ffi' as ffi;` with `import 'package:wasm_ffi/ffi.dart' as ffi;`

```
import 'package:wasm_ffi/ffi.dart';
import 'package:wasm_ffi/ffi_utils.dart';
import 'native_example_bindings.dart';

...
  final library = await DynamicLibrary.open(libName);
  final bindings = NativeExampleBindings(library);

  // assuming that native library is has a function `hello` which takes a name and returns a string `Hello name!`
  using((Arena arena) {
    final cString = name.toNativeUtf8(allocator: arena).cast<Char>();
    return bindings.hello(cString).cast<Utf8>().toDartString();
  }, library.memory); // library.memory is optional if only one module is loaded
...

```

### build wasm

The generated wasm file needs all exported function. To ensure that, one of the two can be done:
* Use EMSCRIPTEN_KEEPALIVE annotation on all exported functions
* Define EXPORTED_FUNCTIONS when compiling the wasm

---

**wasm_ffi** enables using native code for the web platform with ffi-like bindings. Contributions are welcome! 🚀

[license_url]: https://github.com/vm75/native.ffi/blob/main/LICENSE
[build_url]: https://github.com/vm75/native.ffi/actions

[License]: https://img.shields.io/badge/license-MIT-blue.svg
[Build]: https://img.shields.io/github/actions/workflow/status/vm75/native.ffi/.github/workflows/publish.yml?branch=main
[Repo]: https://img.shields.io/badge/github-gray?style=flat&logo=Github
