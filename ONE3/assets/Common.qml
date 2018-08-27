import bb.cascades 1.4

QtObject {
    property bool networkCacheEnabled
    onCreationCompleted: {
        try {
            networkCacheEnabled = _app.getv("ncache", "true") == "true"
        } catch (e) {
            networkCacheEnabled = false
        }
    }
    function ajax(method, endpoint, paramsArray, callback, customheader, form, cache) {
        console.log(method + "//" + endpoint + JSON.stringify(paramsArray))
        var cacheid = "CACHE-" + Qt.md5(endpoint);
        // network cache
        if (networkCacheEnabled && cache) {
            var cached = _app.getv(cacheid, "");
            if (cached.length > 0) {
                console.log("CACHE HIT.")
                callback(true, cached)
                return;
            }
        }
        // append
        /*
         * var request = new XMLHttpRequest();
         * request.onreadystatechange = function() {
         * if (request.readyState === XMLHttpRequest.DONE) {
         * if (request.status == 200) {
         * //                    console.log("[AJAX]Response = " + request.responseText);
         * if (networkCacheEnabled && cache) {
         * _app.setv(cacheid, request.responseText);
         * }
         * if (request.responseText == "0") {
         * callback(false, "Network unreachable");
         * } else {
         * callback(true, request.responseText);
         * }
         * } else {
         * console.log("[AJAX]Status: " + request.status + ", Status Text: " + request.statusText);
         * callback(false, request.statusText);
         * }
         * }
         * };
         */
        var params = paramsArray.join("&");
        var url = endpoint;
        if (method == "GET" && params.length > 0) {
            url = url + "?" + params;
        }

        var response = _app.fetch(url);
        if (networkCacheEnabled && cache) {
            _app.setv(cacheid, response);
        }
        callback(response.length > 0, response);

        /*
         * request.open(method, url, true);
         * if (form) {
         * request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
         * }
         * request.setRequestHeader("Platform", "BlackBerry 10");
         * 
         * if (customheader) {
         * for (var i = 0; i < customheader.length; i ++) {
         * request.setRequestHeader(customheader[i].k, customheader[i].v);
         * }
         * }
         * if (method == "GET") {
         * request.send();
         * } else {
         * request.send(params);
         * }
         */

    }

    function onPopTransitionEnded(page, nav, next) {
        page.destroy();
        if (nav.count() == 1) {
            Application.menuEnabled = true;
        }
        if (nav.top && nav.top.setActive) {
            nav.top.setActive()
        }
        if (next) {
            try {
                next();
            } catch (e) {

            }

        }
    }
    function onPushTransitionEnded(page, nav, next) {
        if (nav.count() != 1) {
            Application.menuEnabled = false;
        }
        if (page.setActive) {
            page.setActive();
        }
        if (next) {
            try {
                next();
            } catch (e) {

            }
        }
    }
    function valueOrEmpty(e) {
        return e ? e : ""
    }
    function genStr(d) {
        var p = d.toDateString().split(" ");
        return p[1] + " " + p[3];
    }
}
