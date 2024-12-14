
var example_ffi_plugin = (() => {
  var _scriptName = typeof document != 'undefined' ? document.currentScript?.src : undefined;
  if (typeof __filename != 'undefined') _scriptName = _scriptName || __filename;
  return (
    function (moduleArg = {}) {
      var moduleRtn;

      var Module = moduleArg; var readyPromiseResolve, readyPromiseReject; var readyPromise = new Promise((resolve, reject) => { readyPromiseResolve = resolve; readyPromiseReject = reject }); var ENVIRONMENT_IS_WEB = typeof window == "object"; var ENVIRONMENT_IS_WORKER = typeof WorkerGlobalScope != "undefined"; var ENVIRONMENT_IS_NODE = typeof process == "object" && typeof process.versions == "object" && typeof process.versions.node == "string" && process.type != "renderer"; if (ENVIRONMENT_IS_NODE) { } var moduleOverrides = Object.assign({}, Module); var arguments_ = []; var thisProgram = "./this.program"; var quit_ = (status, toThrow) => { throw toThrow }; var scriptDirectory = ""; function locateFile(path) { if (Module["locateFile"]) { return Module["locateFile"](path, scriptDirectory) } return scriptDirectory + path } var readAsync, readBinary; if (ENVIRONMENT_IS_NODE) { var fs = require("fs"); var nodePath = require("path"); scriptDirectory = __dirname + "/"; readBinary = filename => { filename = isFileURI(filename) ? new URL(filename) : nodePath.normalize(filename); var ret = fs.readFileSync(filename); return ret }; readAsync = (filename, binary = true) => { filename = isFileURI(filename) ? new URL(filename) : nodePath.normalize(filename); return new Promise((resolve, reject) => { fs.readFile(filename, binary ? undefined : "utf8", (err, data) => { if (err) reject(err); else resolve(binary ? data.buffer : data) }) }) }; if (!Module["thisProgram"] && process.argv.length > 1) { thisProgram = process.argv[1].replace(/\\/g, "/") } arguments_ = process.argv.slice(2); quit_ = (status, toThrow) => { process.exitCode = status; throw toThrow } } else if (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER) { if (ENVIRONMENT_IS_WORKER) { scriptDirectory = self.location.href } else if (typeof document != "undefined" && document.currentScript) { scriptDirectory = document.currentScript.src } if (_scriptName) { scriptDirectory = _scriptName } if (scriptDirectory.startsWith("blob:")) { scriptDirectory = "" } else { scriptDirectory = scriptDirectory.substr(0, scriptDirectory.replace(/[?#].*/, "").lastIndexOf("/") + 1) } { if (ENVIRONMENT_IS_WORKER) { readBinary = url => { var xhr = new XMLHttpRequest; xhr.open("GET", url, false); xhr.responseType = "arraybuffer"; xhr.send(null); return new Uint8Array(xhr.response) } } readAsync = url => { if (isFileURI(url)) { return new Promise((resolve, reject) => { var xhr = new XMLHttpRequest; xhr.open("GET", url, true); xhr.responseType = "arraybuffer"; xhr.onload = () => { if (xhr.status == 200 || xhr.status == 0 && xhr.response) { resolve(xhr.response); return } reject(xhr.status) }; xhr.onerror = reject; xhr.send(null) }) } return fetch(url, { credentials: "same-origin" }).then(response => { if (response.ok) { return response.arrayBuffer() } return Promise.reject(new Error(response.status + " : " + response.url)) }) } } } else { } var out = Module["print"] || console.log.bind(console); var err = Module["printErr"] || console.error.bind(console); Object.assign(Module, moduleOverrides); moduleOverrides = null; if (Module["arguments"]) arguments_ = Module["arguments"]; if (Module["thisProgram"]) thisProgram = Module["thisProgram"]; var wasmBinary = Module["wasmBinary"]; var wasmMemory; var ABORT = false; var HEAP8, HEAPU8, HEAP16, HEAPU16, HEAP32, HEAPU32, HEAPF32, HEAPF64; function updateMemoryViews() { var b = wasmMemory.buffer; Module["HEAP8"] = HEAP8 = new Int8Array(b); Module["HEAP16"] = HEAP16 = new Int16Array(b); Module["HEAPU8"] = HEAPU8 = new Uint8Array(b); Module["HEAPU16"] = HEAPU16 = new Uint16Array(b); Module["HEAP32"] = HEAP32 = new Int32Array(b); Module["HEAPU32"] = HEAPU32 = new Uint32Array(b); Module["HEAPF32"] = HEAPF32 = new Float32Array(b); Module["HEAPF64"] = HEAPF64 = new Float64Array(b) } var __ATPRERUN__ = []; var __ATINIT__ = []; var __ATPOSTRUN__ = []; var runtimeInitialized = false; function preRun() { if (Module["preRun"]) { if (typeof Module["preRun"] == "function") Module["preRun"] = [Module["preRun"]]; while (Module["preRun"].length) { addOnPreRun(Module["preRun"].shift()) } } callRuntimeCallbacks(__ATPRERUN__) } function initRuntime() { runtimeInitialized = true; callRuntimeCallbacks(__ATINIT__) } function postRun() { if (Module["postRun"]) { if (typeof Module["postRun"] == "function") Module["postRun"] = [Module["postRun"]]; while (Module["postRun"].length) { addOnPostRun(Module["postRun"].shift()) } } callRuntimeCallbacks(__ATPOSTRUN__) } function addOnPreRun(cb) { __ATPRERUN__.unshift(cb) } function addOnInit(cb) { __ATINIT__.unshift(cb) } function addOnPostRun(cb) { __ATPOSTRUN__.unshift(cb) } var runDependencies = 0; var runDependencyWatcher = null; var dependenciesFulfilled = null; function addRunDependency(id) { runDependencies++; Module["monitorRunDependencies"]?.(runDependencies) } function removeRunDependency(id) { runDependencies--; Module["monitorRunDependencies"]?.(runDependencies); if (runDependencies == 0) { if (runDependencyWatcher !== null) { clearInterval(runDependencyWatcher); runDependencyWatcher = null } if (dependenciesFulfilled) { var callback = dependenciesFulfilled; dependenciesFulfilled = null; callback() } } } function abort(what) { Module["onAbort"]?.(what); what = "Aborted(" + what + ")"; err(what); ABORT = true; what += ". Build with -sASSERTIONS for more info."; var e = new WebAssembly.RuntimeError(what); readyPromiseReject(e); throw e } var dataURIPrefix = "data:application/octet-stream;base64,"; var isDataURI = filename => filename.startsWith(dataURIPrefix); var isFileURI = filename => filename.startsWith("file://"); function findWasmBinary() { var f = "example_ffi_plugin.wasm"; if (!isDataURI(f)) { return locateFile(f) } return f } var wasmBinaryFile; function getBinarySync(file) { if (file == wasmBinaryFile && wasmBinary) { return new Uint8Array(wasmBinary) } if (readBinary) { return readBinary(file) } throw "both async and sync fetching of the wasm failed" } function getBinaryPromise(binaryFile) { if (!wasmBinary) { return readAsync(binaryFile).then(response => new Uint8Array(response), () => getBinarySync(binaryFile)) } return Promise.resolve().then(() => getBinarySync(binaryFile)) } function instantiateArrayBuffer(binaryFile, imports, receiver) { return getBinaryPromise(binaryFile).then(binary => WebAssembly.instantiate(binary, imports)).then(receiver, reason => { err(`failed to asynchronously prepare wasm: ${reason}`); abort(reason) }) } function instantiateAsync(binary, binaryFile, imports, callback) { if (!binary && typeof WebAssembly.instantiateStreaming == "function" && !isDataURI(binaryFile) && !isFileURI(binaryFile) && !ENVIRONMENT_IS_NODE && typeof fetch == "function") { return fetch(binaryFile, { credentials: "same-origin" }).then(response => { var result = WebAssembly.instantiateStreaming(response, imports); return result.then(callback, function (reason) { err(`wasm streaming compile failed: ${reason}`); err("falling back to ArrayBuffer instantiation"); return instantiateArrayBuffer(binaryFile, imports, callback) }) }) } return instantiateArrayBuffer(binaryFile, imports, callback) } function getWasmImports() { return { a: wasmImports } } function createWasm() { function receiveInstance(instance, module) { wasmExports = instance.exports; wasmMemory = wasmExports["b"]; updateMemoryViews(); addOnInit(wasmExports["c"]); removeRunDependency("wasm-instantiate"); return wasmExports } addRunDependency("wasm-instantiate"); function receiveInstantiationResult(result) { receiveInstance(result["instance"]) } var info = getWasmImports(); if (Module["instantiateWasm"]) { try { return Module["instantiateWasm"](info, receiveInstance) } catch (e) { err(`Module.instantiateWasm callback failed with error: ${e}`); readyPromiseReject(e) } } wasmBinaryFile ??= findWasmBinary(); instantiateAsync(wasmBinary, wasmBinaryFile, info, receiveInstantiationResult).catch(readyPromiseReject); return {} } class ExitStatus { name = "ExitStatus"; constructor(status) { this.message = `Program terminated with exit(${status})`; this.status = status } } var callRuntimeCallbacks = callbacks => { while (callbacks.length > 0) { callbacks.shift()(Module) } }; var noExitRuntime = Module["noExitRuntime"] || true; var getHeapMax = () => 2147483648; var alignMemory = (size, alignment) => Math.ceil(size / alignment) * alignment; var growMemory = size => { var b = wasmMemory.buffer; var pages = (size - b.byteLength + 65535) / 65536 | 0; try { wasmMemory.grow(pages); updateMemoryViews(); return 1 } catch (e) { } }; var _emscripten_resize_heap = requestedSize => { var oldSize = HEAPU8.length; requestedSize >>>= 0; var maxHeapSize = getHeapMax(); if (requestedSize > maxHeapSize) { return false } for (var cutDown = 1; cutDown <= 4; cutDown *= 2) { var overGrownHeapSize = oldSize * (1 + .2 / cutDown); overGrownHeapSize = Math.min(overGrownHeapSize, requestedSize + 100663296); var newSize = Math.min(maxHeapSize, alignMemory(Math.max(requestedSize, overGrownHeapSize), 65536)); var replacement = growMemory(newSize); if (replacement) { return true } } return false }; var wasmImports = { a: _emscripten_resize_heap }; var wasmExports = createWasm(); var ___wasm_call_ctors = () => (___wasm_call_ctors = wasmExports["c"])(); var _getLibraryName = Module["_getLibraryName"] = () => (_getLibraryName = Module["_getLibraryName"] = wasmExports["d"])(); var _hello = Module["_hello"] = a0 => (_hello = Module["_hello"] = wasmExports["e"])(a0); var _malloc = Module["_malloc"] = a0 => (_malloc = Module["_malloc"] = wasmExports["f"])(a0); var _freeMemory = Module["_freeMemory"] = a0 => (_freeMemory = Module["_freeMemory"] = wasmExports["g"])(a0); var _free = Module["_free"] = a0 => (_free = Module["_free"] = wasmExports["h"])(a0); var _intSize = Module["_intSize"] = () => (_intSize = Module["_intSize"] = wasmExports["i"])(); var _boolSize = Module["_boolSize"] = () => (_boolSize = Module["_boolSize"] = wasmExports["j"])(); var _pointerSize = Module["_pointerSize"] = () => (_pointerSize = Module["_pointerSize"] = wasmExports["k"])(); var calledRun; dependenciesFulfilled = function runCaller() { if (!calledRun) run(); if (!calledRun) dependenciesFulfilled = runCaller }; function run() { if (runDependencies > 0) { return } preRun(); if (runDependencies > 0) { return } function doRun() { if (calledRun) return; calledRun = true; Module["calledRun"] = true; if (ABORT) return; initRuntime(); readyPromiseResolve(Module); Module["onRuntimeInitialized"]?.(); postRun() } if (Module["setStatus"]) { Module["setStatus"]("Running..."); setTimeout(() => { setTimeout(() => Module["setStatus"](""), 1); doRun() }, 1) } else { doRun() } } if (Module["preInit"]) { if (typeof Module["preInit"] == "function") Module["preInit"] = [Module["preInit"]]; while (Module["preInit"].length > 0) { Module["preInit"].pop()() } } run(); moduleRtn = readyPromise;


      return moduleRtn;
    }
  );
})();
if (typeof exports === 'object' && typeof module === 'object')
  module.exports = example_ffi_plugin;
else if (typeof define === 'function' && define['amd'])
  define([], () => example_ffi_plugin);
