(function(g,f){function z(a,b,f){a.attachEvent?a.attachEvent("on"+b,f):a.addEventListener(b,f,!1)}g.namespace("autocomplete");g.widget.autocomplete=g.widget.Base.extend({init:function(a,b){this.setName("autocomplete");this._super();this.options=this._getOptions(this._getTemplate(a));var g=f("#"+b.id);this._create(g,this.options)},_create:function(a,b){function w(){var e=n.selected();if(!e){if(b.useNonSelected&&""!=c.val())b.onClick(e,c.val());return!1}var d=e.result;t=d;if(b.multiple){var p=x(c.val());
if(1<p.length){var h=b.multipleSeparator.length,q=g(a).selection().start,l,k=0;f.each(p,function(a,b){k+=b.length;if(q<=k)return l=a,!1;k+=h});p[l]=d;d=p.join(b.multipleSeparator)}d+=b.multipleSeparator}c.val(d);c.attr("menuId",e.menuId);u();f.data(c,"autocompleteData",e);c.trigger("result",[e.data,e.value]);if(f.isFunction(b.onSelect))b.onSelect(e);return!0}function v(a,f){if(p==d.DEL)n.hide();else{var e=c.val();if(f||e!=t||0!=b.minChars||""==e)if(b.transform&&("uppercase"==b.transform?c.val(e.toUpperCase()):
"lowercas"==b.transform&&c.val(e.toLowerCase())),t=e,e=r(e),e.length>=b.minChars)if(c.addClass(b.loadingClass),b.matchCase||(e=e.toLowerCase()),b.isObject){var k=b.searchType?b.searchType:"menuId";b.searchType||(k=/^[0-9a-zA-Z]+$/.test(e)?k:"menuTitle");var l=e;b.useTrimSearch&&(l=naw.trim(l),k=/^[0-9a-zA-Z]+$/.test(l)?"menuId":"menuTitle","menuId"==k&&(e=l));l=m.tranSearch(e,k);h(e,l,k)}else q(e,h,u);else c.removeClass(b.loadingClass),n.hide()}}function x(a){return a?b.multiple?f.map(a.split(b.multipleSeparator),
function(b){return f.trim(a).length?f.trim(b):null}):[f.trim(a)]:[""]}function r(e){if(!b.multiple)return e;var d=x(e);if(1==d.length)return d[0];d=g(a).selection().start;d=d==e.length?x(e):x(e.replace(e.substring(d),""));return d[d.length-1]}function u(){b.useResults||(n.visible(),n.hide(),clearTimeout(k),c.removeClass(b.loadingClass),b.mustMatch&&c.search(function(a){a||(b.multiple?(a=x(c.val()).slice(0,-1),c.val(a.join(b.multipleSeparator)+(a.length?b.multipleSeparator:""))):(c.val(""),c.trigger("result",
null)))}))}function h(e,h,f){h&&h.length?(c.removeClass(b.loadingClass),n.display(h,e,f),h=h[0].value,b.autoFill&&r(c.val()).toLowerCase()==e.toLowerCase()&&p!=d.BACKSPACE&&(c.val(c.val()+h.substring(r(t).length)),g(a).selection(t.length,t.length+h.length)),n.show()):u()}function q(e,d,h){b.matchCase||(e=e.toLowerCase());var p=m.load(e);if(p&&p.length)d(e,p);else if("string"==typeof b.url&&0<b.url.length){var c={timestamp:+new Date};f.each(b.extraParams,function(a,b){c[a]="function"==typeof b?b():
b});f.ajax({mode:"abort",port:"autocomplete"+a.name,dataType:b.dataType,url:b.url,data:f.extend({q:r(e),limit:b.max},c),success:function(a){var p;if(!(p=b.parse&&b.parse(a))){p=[];a=a.split("\n");for(var h=0;h<a.length;h++){var c=f.trim(a[h]);c&&(c=c.split("|"),p[p.length]={data:c,value:c[0],result:b.formatResult&&b.formatResult(c,c[0])||c[0]})}}m.add(e,p);d(e,p)}})}else n.emptyList(),h(e)}var d={UP:38,DOWN:40,DEL:46,TAB:9,RETURN:13,ESC:27,COMMA:188,PAGEUP:33,PAGEDOWN:34,BACKSPACE:8},c=a.attr("autocomplete",
"off").addClass(b.inputClass);c.attr("placeholder",b.placeholder);this.$input=c;this.val=function(a){if(a)c.val(a);else return c.val()};var k,t="",m=this._cache(b);this.cache=m;var l=0,p,A={mouseDownOnSelect:!1},n=this._select(b,a,w,A);(naw.agent.mobile&&"safari"==naw.agent.browser||"mozilla"==g.agent.browser||"opera"==g.agent.browser)&&new B(c.get(0));var y=0;c.bind("keydown.autocomplete",function(a){l=1;p=a.keyCode;switch(a.keyCode){case d.UP:a.preventDefault();n.visible()?(n.prev(),clearTimeout(k)):
v(0,!0);break;case d.DOWN:a.preventDefault();n.visible()?(n.next(),clearTimeout(k)):v(0,!0);break;case d.PAGEUP:a.preventDefault();n.visible()?(n.pageUp(),clearTimeout(k)):v(0,!0);break;case d.PAGEDOWN:a.preventDefault();n.visible()?(n.pageDown(),clearTimeout(k)):v(0,!0);break;case b.multiple&&","==f.trim(b.multipleSeparator)&&d.COMMA:case d.TAB:case d.RETURN:case 13:if(naw.agent.mobile&&"safari"==naw.agent.browser||"mozilla"==g.agent.browser||"opera"==g.agent.browser)y=a.keyCode;if(w()||13==a.keyCode)return a.preventDefault(),
!1;break;case d.ESC:n.hide();break;default:(naw.agent.mobile&&"safari"==naw.agent.browser||"mozilla"==g.agent.browser||"opera"==g.agent.browser)&&13==y&&65==a.keyCode?y=0:(y=a.keyCode,clearTimeout(k),k=setTimeout(v,b.delay))}}).focus(function(){l++;1<l++&&!n.visible()&&""==c.val()&&v(0,!0)}).blur(function(){l=0;A.mouseDownOnSelect||(clearTimeout(k),k=setTimeout(u,200))}).click(function(){1<l++&&!n.visible()&&v(0,!0)});b.expandSpan&&f(b.expandSpan).unbind("click").bind("click",function(a){c.blur();
c.focus();n.visible()?n.hide():setTimeout(function(){v(0,!0);if(b.useNonSelected&&""!=c.val())b.onClick(!1,c.val())},b.delay)});b.excuteSpan&&f(b.excuteSpan).unbind("click").bind("click",function(a){if(a=f.data(c,"autocompleteData"))b.useAllSelected&&!n.visible()&&setTimeout(function(){c.val("").focus();v(0,!0)},b.delay);else{if(b.useNonSelected&&""!=c.val())b.onClick(a,c.val());else b.useAllSelected&&!n.visible()&&(c.focus(),v(0,!0));return!1}if(f.isFunction(b.onClick))b.onClick(a)});g.subscribe("theme.change",
function(a){self.changeTheme(a.themeName,a.themeBasePath)});g.publish("window.resize",a.attr("id"));g.subscribe("window.resize",function(a){n.visible()&&n.show()});return n},_getOptions:function(a){var b={inputClass:"autocomplete-input",resultsClass:"autocomplete-results",loadingClass:"autocomplete-loading",minChars:1,delay:400,matchCase:!1,matchSubset:!0,matchContains:!1,cacheLength:10,max:100,mustMatch:!1,extraParams:{},selectFirst:!0,formatItem:function(a){return a[0]},formatMatch:null,autoFill:!1,
width:0,multiple:!1,multipleSeparator:", ",highlight:function(a,b){return a.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)("+b.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi,"\\$1")+")(?![^<>]*>)(?![^&;]+;)","gi"),"<span class='autocomplete-search-word'>$1</span>")},scroll:!0,scrollHeight:180},w="string"==typeof a.urlOrData,b=f.extend({},b,{url:w?a.urlOrData:null,data:w?null:a.urlOrData,delay:w?g.autocomplete.options.delay:10,max:150,isObject:!0,onComplete:null},a);b.highlight=b.highlight||function(a){return a};
b.formatMatch=b.formatMatch||b.formatItem;return b},changeOptions:function(a){var b=this.options;if(a.urlOrData||""==a.urlOrData){var g="string"==typeof a.urlOrData;a.url=g?a.urlOrData:null;a.data=g?null:a.urlOrData}this.options=b=f.extend(b,a)},_select:function(a,b,w,v){function x(){t&&(a.useResults?m=f(a.useResults):(m=f("<div/>").hide().addClass(a.resultsClass),a.useSubClass&&m.addClass(a.subClassNm),m.appendTo(a.appendResults?a.appendResults:document.body)),l=f("<ul/>").appendTo(m).mouseover(function(a){r(a).nodeName&&
"LI"==r(a).nodeName.toUpperCase()&&(d=f("li",l).removeClass(h.ACTIVE).index(r(a)),f(r(a)).addClass(h.ACTIVE))}).click(function(a){f(r(a)).addClass(h.ACTIVE);w();b.focus();return!1}).mousedown(function(){v.mouseDownOnSelect=!0}).mouseup(function(){v.mouseDownOnSelect=!1}),t=!1)}function r(a){for(a=a.target;a&&"LI"!=a.tagName;)a=a.parentNode;return a?a:[]}function u(b){q.slice(d,d+1).removeClass(h.ACTIVE);d+=b;0>d?d=q.length-1:d>=q.length&&(d=0);b=q.slice(d,d+1).addClass(h.ACTIVE);if(a.scroll){var c=
0;q.slice(0,d).each(function(){c+=this.offsetHeight});c+b[0].offsetHeight-l.scrollTop()>l[0].clientHeight?l.scrollTop(c+b[0].offsetHeight-l.innerHeight()):c<l.scrollTop()&&l.scrollTop(c)}}var h={ACTIVE:"autocomplete-over"},q,d=-1,c,k="",t=!0,m,l;return{display:function(b,m,n){x();c=b;k=m;b=c;m=k;l.empty();var p;p=b.length;p=a.max&&a.max<p?a.max:p;n=a.displayTitle?a.displayTitle:n;for(var e=0;e<p;e++)if(b[e]){if(a.isObject)var g=b[e][n],t=b[e].result=g,t=a.useHighlight?a.highlight(g,m):t,g=f("<li>"+
t+"</li>").addClass(0==e%2?"autocomplete-even":"autocomplete-odd").appendTo(l)[0];else{g=a.formatItem(b[e].data,e+1,p,b[e].value,m);if(!1===g)continue;g=f("<li/>").html(a.highlight(g,m)).addClass(0==e%2?"autocomplete-even":"autocomplete-odd").appendTo(l)[0]}f.data(g,"autocompleteData",b[e])}q=l.find("li");a.selectFirst&&(q.slice(0,1).addClass(h.ACTIVE),d=0);f.fn.bgiframe&&l.bgiframe()},next:function(){u(1)},prev:function(){u(-1)},pageUp:function(){0!=d&&0>d-8?u(-d):u(-8)},pageDown:function(){d!=q.length-
1&&d+8>q.length?u(q.length-1-d):u(8)},hide:function(){m&&m.hide();q&&q.removeClass(h.ACTIVE);d=-1},visible:function(){return m&&m.is(":visible")},current:function(){return this.visible()&&(q.filter("."+h.ACTIVE)[0]||a.selectFirst&&q[0])},show:function(){g.behavior.IApplyBlockUI&&g.behavior.IApplyBlockUI(m,!0,{callWidget:"autocomplete",type:"content"});b.offset();"string"==typeof a.width||0<a.width||b.width();b.parent().height();m.show();parseInt(q.css("padding-left"),10);jQuery("body").offset();m.show();
a.scroll&&l.scrollTop(0)},selected:function(){var a=q&&q.filter("."+h.ACTIVE).removeClass(h.ACTIVE);return a&&a.length&&f.data(a[0],"autocompleteData")},emptyList:function(){l&&l.empty()},unbind:function(){m&&m.remove()}}},_cache:function(a){function b(b,f){a.matchCase||(b=b.toLowerCase());var d=b.indexOf(f);"word"==a.matchContains&&(d=b.toLowerCase().search("\\b"+f.toLowerCase()));return-1==d?!1:0==d||a.matchContains}function w(b,f){u>a.cacheLength&&x();r[b]||u++;r[b]=f}function v(){if(!a.data)return!1;
var b={},g=0;a.url||(a.cacheLength=1);b[""]=[];for(var d=0,c=a.data.length;d<c;d++){var k=a.data[d],k="string"==typeof k?[k]:k,t=a.formatMatch(k,d+1,a.data.length);if(!1!==t){var m=t.charAt(0).toLowerCase();b[m]||(b[m]=[]);k={value:t,data:k,result:a.formatResult&&a.formatResult(k)||t};b[m].push(k);g++<a.max&&b[""].push(k)}}f.each(b,function(b,c){a.cacheLength++;w(b,c)})}function x(){r={};u=0}var r={},u=0;a.isObject||setTimeout(v,25);return{flush:x,add:w,populate:v,tranSearch:function(b,f,d){var c=
a.data,k="//MenuItem",h=null,m=[],l={};"uppercase"==a.searchTransform&&(b=void 0==b?"":b.toUpperCase());h=c.xpath(k+"[contains("+(void 0==b?"":"menuId"==f||"page"==f?"@menuId, '"+b+"'":"@menuTitle, '"+b+"'")+")]");if(d)return h;g.foreach(h,function(){var a=this.jq.get(0);if(0==a.childNodes.length){l={};for(var b=0;b<a.attributes.length;b++)l[a.attributes[b].nodeName]=this.attr(a.attributes[b].nodeName);m.push(l)}});return m},load:function(h){if(!a.cacheLength||!u)return null;if(!a.url&&a.matchContains){var g=
[],d;for(d in r)if(0<d.length){var c=r[d];f.each(c,function(a,c){b(c.value,h)&&g.push(c)})}return g}if(r[h])return r[h];if(a.matchSubset)for(d=h.length-1;d>=a.minChars;d--)if(c=r[h.substr(0,d)])return g=[],f.each(c,function(a,c){b(c.value,h)&&(g[g.length]=c)}),g;return null}}},getSelect:function(){var a=f.data(this.$input,"autocompleteData");return a?a:null}});var B=function(a){this.obj=a;this.val=a.value;this.bindEvent()};B.prototype={bindEvent:function(){var a=this;fn=function(){a._timer&&window.clearInterval(a._timer);
setFn=function(){a.val!=a.obj.value&&(a.val=a.obj.value,a.keyDownEvent())};a._timer=window.setInterval(setFn,50)};z(this.obj,"focus",fn);fn=function(){a._timer&&window.clearInterval(a._timer);a._timer=null};z(this.obj,"blur",fn)},keyDownEvent:function(){if(document.createEvent){var a;window.KeyEvent?(a=document.createEvent("KeyEvents"),a.initKeyEvent("keydown",!0,!0,window,!1,!1,!1,!1,65,0)):(a=document.createEvent("UIEvents"),a.initUIEvent("keydown",!0,!0,window,1),a.keyCode=65);this.obj.dispatchEvent(a)}else a=
document.createEventObject(),a.keyCode=65,this.obj.fireEvent("onkeydown",a)}};g._addWidget("autocomplete",naw.widget.autocomplete)})(naw,jQuery);