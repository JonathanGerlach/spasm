// File is autogenerated with `dub run spasm:webpack-bootstrap`
const abort = (what,file,line) => {
    throw `ABORT: $what @ $file:$line`;
}

const utf8Decoder = new TextDecoder('utf-8');
const utf8Encoder = new TextEncoder();
const memory = new WebAssembly.Memory({initial:16*16, maximum:16*16});

let lastPtr = 2;
let objects = {1: document, 2: window};
let buffer = memory.buffer,
    addObject = (value) => {
        if (value === null || value == undefined) return 0;
        objects[++lastPtr] = value;
        return lastPtr;
    },
    getObject = (ptr) => objects[ptr];
const spasm = {
    memory: memory,
    heapi32s: new Int32Array(buffer),
    heapi32u: new Uint32Array(buffer),
    heapi16s: new Int16Array(buffer),
    heapi16u: new Uint16Array(buffer),
    heapi8s: new Int8Array(buffer),
    heapi8u: new Uint8Array(buffer),
    heapf32: new Float32Array(buffer),
    heapf64: new Float64Array(buffer),
    instance: null,
    init: (modules) => {
        let exports = {env: Object.assign.apply(null,modules.map(m=>m.jsExports).filter(a=>!!a))};
        if ('undefined' === typeof WebAssembly.instantiateStreaming) {
            fetch('@@targetProjectName@@')
                .then(request => request.arrayBuffer())
                .then(bytes => WebAssembly.compile(bytes))
                .then(module => {
                    let instance = new WebAssembly.Instance(module, exports);
                    spasm.instance = instance
                    instance.exports._start();
                });
        } else {
            WebAssembly.instantiateStreaming(fetch('@@targetProjectName@@'), exports)
                .then(obj => {
                    spasm.instance = obj.instance;
                    obj.instance.exports._start();
                });
        }
    },
    objects,
    addObject: addObject,
}

let encoders = {
    string: (ptr, val) => {
        const encodedString = utf8Encoder.encode(val);
        const wasmPtr = spasm.instance.exports.allocString(encodedString.length);
        const asBytes = new Uint8Array(buffer, wasmPtr, encodedString.length);
        spasm.heapi32u[ptr / 4] = encodedString.length;
        spasm.heapi32u[(ptr / 4)+1] = wasmPtr;
        asBytes.set(encodedString);
        return ptr;
    }
}
let decoders = {
    string: (len, offset) => {
        if (offset == null) {
            offset = spasm.heapi32u[(len+4)/4];
            len = spasm.heapi32u[(len/4)];
        }
        return utf8Decoder.decode(new DataView(buffer,offset,len));
    }
}
let jsExports = {
    onOutOfMemoryError: () => abort("Out of memory exception"),
    _d_assert: (file,line) => abort("assert",file,line),
    doLog: arg => console.log(arg),
    memory: spasm.memory,
    __assert: () => {},
    _Unwind_Resume: () => {
        console.log(arguments);
    },
    _d_dynamic_cast: () => {
        console.log(arguments)
    },
    spasm_add__bool: (b)=>addObject(!!b),
    spasm_add__int: addObject,
    spasm_add__uint: addObject,
    spasm_add__long: addObject,
    spasm_add__ulong: addObject,
    spasm_add__short: addObject,
    spasm_add__ushort: addObject,
    spasm_add__byte: addObject,
    spasm_add__ubyte: addObject,
    spasm_add__float: addObject,
    spasm_add__double: addObject,
    spasm_add__object: () => addObject({}),
    spasm_add__string: (len, offset) => {
        return addObject(decoders.string(len, offset));
    },
    spasm_get__field: (handle, len, offset) => {
        return addObject(getObject(handle)[decoders.string(len,offset)]);
    },
    spasm_get__int: getObject,
    spasm_get__uint: getObject,
    spasm_get__long: getObject,
    spasm_get__ulong: getObject,
    spasm_get__short: getObject,
    spasm_get__ushort: getObject,
    spasm_get__float: getObject,
    spasm_get__double: getObject,
    spasm_get__byte: getObject,
    spasm_get__ubyte: getObject,
    spasm_get__string: (rawResult, ptr) => {
        encoders.string(rawResult, getObject(ptr));
    },
    spasm_removeObject: (ctx) => {
        delete objects[ctx]
    }
};

export {spasm, encoders, decoders, jsExports};
