var hexcase = 0;
var b64pad = "";
function hex_md5(s){
    return rstr2hex(rstr_md5(str2rstr_utf8(s)));
}

function b64_md5(s){
    return rstr2b64(rstr_md5(str2rstr_utf8(s)));
}

function any_md5(s, e){
    return rstr2any(rstr_md5(str2rstr_utf8(s)), e);
}

function hex_hmac_md5(k, d){
    return rstr2hex(rstr_hmac_md5(str2rstr_utf8(k), str2rstr_utf8(d)));
}

function b64_hmac_md5(k, d){
    return rstr2b64(rstr_hmac_md5(str2rstr_utf8(k), str2rstr_utf8(d)));
}

function any_hmac_md5(k, d, e){
    return rstr2any(rstr_hmac_md5(str2rstr_utf8(k), str2rstr_utf8(d)), e);
}

function md5_vm_test(){
    return hex_md5("abc") == "900150983cd24fb0d6963f7d28e17f72";
}

function rstr_md5(s){
    return binl2rstr(binl_md5(rstr2binl(s), s.length * 8));
}

function rstr_hmac_md5(_d, _e){
    var _f = rstr2binl(_d);
    if (_f.length > 16) {
        _f = binl_md5(_f, _d.length * 8);
    }
    var _10 = Array(16), opad = Array(16);
    for (var i = 0; i < 16; i++) {
        _10[i] = _f[i] ^ 909522486;
        opad[i] = _f[i] ^ 1549556828;
    }
    var _12 = binl_md5(_10.concat(rstr2binl(_e)), 512 + _e.length * 8);
    return binl2rstr(binl_md5(opad.concat(_12), 512 + 128));
}

function rstr2hex(_13){
    var _14 = hexcase ? "0123456789ABCDEF" : "0123456789abcdef";
    var _15 = "";
    var x;
    for (var i = 0; i < _13.length; i++) {
        x = _13.charCodeAt(i);
        _15 += _14.charAt((x >>> 4) & 15) + _14.charAt(x & 15);
    }
    return _15;
}

function rstr2b64(_18){
    var tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    var _1a = "";
    var len = _18.length;
    for (var i = 0; i < len; i += 3) {
        var _1d = (_18.charCodeAt(i) << 16) | (i + 1 < len ? _18.charCodeAt(i + 1) << 8 : 0) | (i + 2 < len ? _18.charCodeAt(i + 2) : 0);
        for (var j = 0; j < 4; j++) {
            if (i * 8 + j * 6 > _18.length * 8) {
                _1a += b64pad;
            }
            else {
                _1a += tab.charAt((_1d >>> 6 * (3 - j)) & 63);
            }
        }
    }
    return _1a;
}

function rstr2any(_1f, _20){
    var _21 = _20.length;
    var i, j, q, x, quotient;
    var _23 = Array(Math.ceil(_1f.length / 2));
    for (i = 0; i < _23.length; i++) {
        _23[i] = (_1f.charCodeAt(i * 2) << 8) | _1f.charCodeAt(i * 2 + 1);
    }
    var _24 = Math.ceil(_1f.length * 8 / (Math.log(_20.length) / Math.log(2)));
    var _25 = Array(_24);
    for (j = 0; j < _24; j++) {
        quotient = Array();
        x = 0;
        for (i = 0; i < _23.length; i++) {
            x = (x << 16) + _23[i];
            q = Math.floor(x / _21);
            x -= q * _21;
            if (quotient.length > 0 || q > 0) {
                quotient[quotient.length] = q;
            }
        }
        _25[j] = x;
        _23 = quotient;
    }
    var _26 = "";
    for (i = _25.length - 1; i >= 0; i--) {
        _26 += _20.charAt(_25[i]);
    }
    return _26;
}

function str2rstr_utf8(_27){
    var _28 = "";
    var i = -1;
    var x, y;
    while (++i < _27.length) {
        x = _27.charCodeAt(i);
        y = i + 1 < _27.length ? _27.charCodeAt(i + 1) : 0;
        if (55296 <= x && x <= 56319 && 56320 <= y && y <= 57343) {
            x = 65536 + ((x & 1023) << 10) + (y & 1023);
            i++;
        }
        if (x <= 127) {
            _28 += String.fromCharCode(x);
        }
        else {
            if (x <= 2047) {
                _28 += String.fromCharCode(192 | ((x >>> 6) & 31), 128 | (x & 63));
            }
            else {
                if (x <= 65535) {
                    _28 += String.fromCharCode(224 | ((x >>> 12) & 15), 128 | ((x >>> 6) & 63), 128 | (x & 63));
                }
                else {
                    if (x <= 2097151) {
                        _28 += String.fromCharCode(240 | ((x >>> 18) & 7), 128 | ((x >>> 12) & 63), 128 | ((x >>> 6) & 63), 128 | (x & 63));
                    }
                }
            }
        }
    }
    return _28;
}

function str2rstr_utf16le(_2b){
    var _2c = "";
    for (var i = 0; i < _2b.length; i++) {
        _2c += String.fromCharCode(_2b.charCodeAt(i) & 255, (_2b.charCodeAt(i) >>> 8) & 255);
    }
    return _2c;
}

function str2rstr_utf16be(_2e){
    var _2f = "";
    for (var i = 0; i < _2e.length; i++) {
        _2f += String.fromCharCode((_2e.charCodeAt(i) >>> 8) & 255, _2e.charCodeAt(i) & 255);
    }
    return _2f;
}

function rstr2binl(_31){
    var _32 = Array(_31.length >> 2);
    for (var i = 0; i < _32.length; i++) {
        _32[i] = 0;
    }
    for (var i = 0; i < _31.length * 8; i += 8) {
        _32[i >> 5] |= (_31.charCodeAt(i / 8) & 255) << (i % 32);
    }
    return _32;
}

function binl2rstr(_34){
    var _35 = "";
    for (var i = 0; i < _34.length * 32; i += 8) {
        _35 += String.fromCharCode((_34[i >> 5] >>> (i % 32)) & 255);
    }
    return _35;
}

function binl_md5(x, len){
    x[len >> 5] |= 128 << ((len) % 32);
    x[(((len + 64) >>> 9) << 4) + 14] = len;
    var a = 1732584193;
    var b = -271733879;
    var c = -1732584194;
    var d = 271733878;
    for (var i = 0; i < x.length; i += 16) {
        var _3e = a;
        var _3f = b;
        var _40 = c;
        var _41 = d;
        a = md5_ff(a, b, c, d, x[i + 0], 7, -680876936);
        d = md5_ff(d, a, b, c, x[i + 1], 12, -389564586);
        c = md5_ff(c, d, a, b, x[i + 2], 17, 606105819);
        b = md5_ff(b, c, d, a, x[i + 3], 22, -1044525330);
        a = md5_ff(a, b, c, d, x[i + 4], 7, -176418897);
        d = md5_ff(d, a, b, c, x[i + 5], 12, 1200080426);
        c = md5_ff(c, d, a, b, x[i + 6], 17, -1473231341);
        b = md5_ff(b, c, d, a, x[i + 7], 22, -45705983);
        a = md5_ff(a, b, c, d, x[i + 8], 7, 1770035416);
        d = md5_ff(d, a, b, c, x[i + 9], 12, -1958414417);
        c = md5_ff(c, d, a, b, x[i + 10], 17, -42063);
        b = md5_ff(b, c, d, a, x[i + 11], 22, -1990404162);
        a = md5_ff(a, b, c, d, x[i + 12], 7, 1804603682);
        d = md5_ff(d, a, b, c, x[i + 13], 12, -40341101);
        c = md5_ff(c, d, a, b, x[i + 14], 17, -1502002290);
        b = md5_ff(b, c, d, a, x[i + 15], 22, 1236535329);
        a = md5_gg(a, b, c, d, x[i + 1], 5, -165796510);
        d = md5_gg(d, a, b, c, x[i + 6], 9, -1069501632);
        c = md5_gg(c, d, a, b, x[i + 11], 14, 643717713);
        b = md5_gg(b, c, d, a, x[i + 0], 20, -373897302);
        a = md5_gg(a, b, c, d, x[i + 5], 5, -701558691);
        d = md5_gg(d, a, b, c, x[i + 10], 9, 38016083);
        c = md5_gg(c, d, a, b, x[i + 15], 14, -660478335);
        b = md5_gg(b, c, d, a, x[i + 4], 20, -405537848);
        a = md5_gg(a, b, c, d, x[i + 9], 5, 568446438);
        d = md5_gg(d, a, b, c, x[i + 14], 9, -1019803690);
        c = md5_gg(c, d, a, b, x[i + 3], 14, -187363961);
        b = md5_gg(b, c, d, a, x[i + 8], 20, 1163531501);
        a = md5_gg(a, b, c, d, x[i + 13], 5, -1444681467);
        d = md5_gg(d, a, b, c, x[i + 2], 9, -51403784);
        c = md5_gg(c, d, a, b, x[i + 7], 14, 1735328473);
        b = md5_gg(b, c, d, a, x[i + 12], 20, -1926607734);
        a = md5_hh(a, b, c, d, x[i + 5], 4, -378558);
        d = md5_hh(d, a, b, c, x[i + 8], 11, -2022574463);
        c = md5_hh(c, d, a, b, x[i + 11], 16, 1839030562);
        b = md5_hh(b, c, d, a, x[i + 14], 23, -35309556);
        a = md5_hh(a, b, c, d, x[i + 1], 4, -1530992060);
        d = md5_hh(d, a, b, c, x[i + 4], 11, 1272893353);
        c = md5_hh(c, d, a, b, x[i + 7], 16, -155497632);
        b = md5_hh(b, c, d, a, x[i + 10], 23, -1094730640);
        a = md5_hh(a, b, c, d, x[i + 13], 4, 681279174);
        d = md5_hh(d, a, b, c, x[i + 0], 11, -358537222);
        c = md5_hh(c, d, a, b, x[i + 3], 16, -722521979);
        b = md5_hh(b, c, d, a, x[i + 6], 23, 76029189);
        a = md5_hh(a, b, c, d, x[i + 9], 4, -640364487);
        d = md5_hh(d, a, b, c, x[i + 12], 11, -421815835);
        c = md5_hh(c, d, a, b, x[i + 15], 16, 530742520);
        b = md5_hh(b, c, d, a, x[i + 2], 23, -995338651);
        a = md5_ii(a, b, c, d, x[i + 0], 6, -198630844);
        d = md5_ii(d, a, b, c, x[i + 7], 10, 1126891415);
        c = md5_ii(c, d, a, b, x[i + 14], 15, -1416354905);
        b = md5_ii(b, c, d, a, x[i + 5], 21, -57434055);
        a = md5_ii(a, b, c, d, x[i + 12], 6, 1700485571);
        d = md5_ii(d, a, b, c, x[i + 3], 10, -1894986606);
        c = md5_ii(c, d, a, b, x[i + 10], 15, -1051523);
        b = md5_ii(b, c, d, a, x[i + 1], 21, -2054922799);
        a = md5_ii(a, b, c, d, x[i + 8], 6, 1873313359);
        d = md5_ii(d, a, b, c, x[i + 15], 10, -30611744);
        c = md5_ii(c, d, a, b, x[i + 6], 15, -1560198380);
        b = md5_ii(b, c, d, a, x[i + 13], 21, 1309151649);
        a = md5_ii(a, b, c, d, x[i + 4], 6, -145523070);
        d = md5_ii(d, a, b, c, x[i + 11], 10, -1120210379);
        c = md5_ii(c, d, a, b, x[i + 2], 15, 718787259);
        b = md5_ii(b, c, d, a, x[i + 9], 21, -343485551);
        a = safe_add(a, _3e);
        b = safe_add(b, _3f);
        c = safe_add(c, _40);
        d = safe_add(d, _41);
    }
    return Array(a, b, c, d);
}

function md5_cmn(q, a, b, x, s, t){
    return safe_add(bit_rol(safe_add(safe_add(a, q), safe_add(x, t)), s), b);
}

function md5_ff(a, b, c, d, x, s, t){
    return md5_cmn((b & c) | ((~ b) & d), a, b, x, s, t);
}

function md5_gg(a, b, c, d, x, s, t){
    return md5_cmn((b & d) | (c & (~ d)), a, b, x, s, t);
}

function md5_hh(a, b, c, d, x, s, t){
    return md5_cmn(b ^ c ^ d, a, b, x, s, t);
}

function md5_ii(a, b, c, d, x, s, t){
    return md5_cmn(c ^ (b | (~ d)), a, b, x, s, t);
}

function safe_add(x, y){
    var lsw = (x & 65535) + (y & 65535);
    var msw = (x >> 16) + (y >> 16) + (lsw >> 16);
    return (msw << 16) | (lsw & 65535);
}

function bit_rol(num, cnt){
    return (num << cnt) | (num >>> (32 - cnt));
}
