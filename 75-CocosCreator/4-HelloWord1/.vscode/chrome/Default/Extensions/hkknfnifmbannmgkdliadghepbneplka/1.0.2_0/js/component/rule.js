var Fiddler_Rule=function(){"use strict";var e=["onBeforeRequest","onBeforeSendHeaders","onSendHeaders","onHeadersReceived","onBeforeRedirect","onResponseStarted","onErrorOccurred","onCompleted"],t=Fiddler.implement({},Fiddler.CustEvent);e.forEach(function(e){t[e]=function(t){this.on(e,t)}});var n=!1,r=null;return Fiddler.mix(t,{match:function(e,t){return t.patternType=="Method"?this.matchMethod(e,t):t.patternType=="Header"?this.matchHeader(e,t):this.matchUrl(e,t)},matchUrl:function(e,t){var n=e.url,r=t.pattern;if(t.patternType=="String")return n.indexOf(r)>=0;r.indexOf("/")!=0&&(r="/"+r+"/");try{r.replace(/^\/(.*)\/([mig]*)$/g,function(e,t,n){r=new RegExp(t,n||"")});if(r.test(n))return!0}catch(i){}return!1},matchMethod:function(e,t){var n=e.method;return t.replace==e.url?!1:t.pattern.toLowerCase()==n.toLowerCase()},matchHeader:function(e,t){var n=(t.pattern||"").split("="),r=n.shift().toLowerCase(),i=n.join("="),s=e.requestHeaders||[];return s.some(function(e){var t=e.name.toLowerCase(),n=e.value;if(t==r){if(i==n)return!0;if(n.indexOf(i)==0)return!0}return!1})},addFileReplaceRule:function(e){var t=this;this.onBeforeRequest(function(n){var r=Fiddler_Config.getEncoding();if(t.match(n.data,e)){var i=e.replace,s=Fiddler_File.getLocalFile(i,r,n.data.type);return s===!1?(t.fire("fileError",i),!1):{redirectUrl:s}}return!1})},addDirReplaceRule:function(e){var t=this;this.onBeforeRequest(function(n){var r=n.data.url,i=Fiddler_Config.getEncoding(),s=r.indexOf(e.pattern);if(s===0){var o=r.substr(e.pattern.length),u=Fiddler.pathAdd(e.replace,o),a=Fiddler_File.getLocalFile(u,i,n.data.type);return a===!1?(t.fire("fileError",u),!1):{redirectUrl:a}}return!1})},addUrlReplaceRule:function(e){var t=this;this.onBeforeRequest(function(n){if(t.match(n.data,e)){var r=e.replace;return{redirectUrl:r}}return!1})},addDelayRule:function(e){var t=this;this.onBeforeSendHeaders(function(n){if(t.match(n.data,e)){var r=parseInt(e.replace,10)||0;return Fiddler.delay(r),!1}return!1})},addCancelRule:function(e){var t=this;this.onBeforeSendHeaders(function(n){return console.log(n.data),t.match(n.data,e)&&(n.data.cancel=!0),n.data})},addHeaderRule:function(e){var t=this;this.onBeforeSendHeaders(function(n){if(t.match(n.data,e)){var r=n.data.requestHeaders,i=t.headersToObj(r),s=t.parseHeader(e.replace);return i=Fiddler.mix(i,s,!0),r=t.headersToArr(i),n.data.requestHeaders=r,n.data}return!1})},parseHeader:function(e){e=(e||"").split(";");var t={};return e.forEach(function(e){e=e.trim();if(!e)return!1;e=e.split("=");var n=e[0].trim().toLowerCase();n=n.substr(0,1).toUpperCase()+n.substr(1),n=n.replace(/\-(\w)/ig,function(e,t){return"-"+t.toUpperCase()});var r=e[1].trim();if(!n)return!1;t[n]=r}),t},headersToObj:function(e){e=e||[];var t={};return e.forEach(function(e){t[e.name]=e.value}),t},headersToArr:function(e){var t=[];for(var n in e)t.push({name:n,value:e[n]});return t},resouceListening:function(t){if(n&&!t)return!1;n=!0;var r=this;e.forEach(function(e){r[e](function(t){var n=t.data;return Fiddler_Resource.add(n,e),!1})})},fileErrorListening:function(e){e&&(r=e),this.on("fileError",r)},disableCacheRule:function(){var e=this,t=["Cache-Control","Pragma","If-Modified-Since","If-None-Match"],n=["no-cache","no-cache","",""];this.onBeforeSendHeaders(function(r){var i=r.data.requestHeaders,s=e.headersToObj(i),o={};for(var u in s){if(t.indexOf(u)>-1)continue;o[u]=s[u]}return t.forEach(function(e,t){o[e]=n[t]}),i=e.headersToArr(o),r.data.requestHeaders=i,r.data})},userAgentRule:function(e){},parseRule:function(e){var t={File:"addFileReplaceRule",Path:"addDirReplaceRule",Cancel:"addCancelRule",Delay:"addDelayRule",Redirect:"addUrlReplaceRule",Header:"addHeaderRule"};return e.type=t[e.replaceType],e},addRule:function(e){var t=this.parseRule(e),n=t.type;this[n]&&(Fiddler_Config.addRule(t),e.enable&&this[n](t))},saveRules:function(e,t){var n=this;return this.clearAll(),this.resouceListening(!0),this.fileErrorListening(),t?(Fiddler_Config.clearRules(),e=e||[],e.forEach(function(e){n.addRule(e)}),this):this}}),t}()