(function(q){function r(d,c,a){var b=0,h=0;d=c/d*100;"left"==a||"up"==a?(b=100,h=-d):"right"==a||"down"==a?(b=-d,h=100):"alternate"==a&&(b=0,h=100-d);return{startPos:b+"%",endPos:h+"%"}}function t(d,c,a,b){return"alternate"==b?(d-c)/a:(d+c)/a}function p(d,c){c.width&&d.css("width",c.width);c.height&&d.css("height",c.height)}var u="WebkitAnimation"in document.body.style||"animation"in document.body.style,n="WebkitAnimation"in document.body.style,g=n?"-webkit-":"";u&&q.subscribe("window.resize marquee.reset",
function(){var d=document.getElementById("marqueeStyle");if(!q.isNull(d))for(var d=d.sheet.cssRules,c,a=d.length,b,h;a--;){b=d.item(a);c=b.cssRules;for(var k=jQuery("#"+b.name),e="horizontal"==k.data("direction")?"width":"height",m="width"==e?"left":"top",f=c.length,l=k.data("child"),n=k.find(">:first-child").css(g+"animation-name","none"),p=r(k[e](),l[e],l.direction);f--;)h=c.item(f),"0%"===h.keyText?h.style[m]=p.startPos:"100%"===h.keyText&&(h.style[m]=p.endPos);n.css(g+"animation-duration",t(k[e](),
l[e],l.speed,l.direction)+"s");n.css(g+"animation-name",b.name)}});var v=function(d){return d?function(c,a){var b=c.wrap("<div />").css("display","inline").parent();b.data("direction","up"==a.direction||"down"==a.direction?"vertical":"horizontal");var d="horizontal"==b.data("direction")?"width":"height";p(b,a);var k="marquee"+Date.now(),e="horizontal"==b.data("direction")?"width":"height",m="width"==e?"left":"top",f=r(b[e](),c[e](),a.direction),m="@"+g+"keyframes "+k+"{\t0%{ "+m+":"+f.startPos+"; \t} 100%{ "+
m+":"+f.endPos+"; }}",f=document.getElementById("marqueeStyle");q.isNull(f)&&(f=document.head.appendChild(document.createElement("style")),f.id="marqueeStyle",f.type="text/css");var l={direction:a.direction,speed:a.speed};l[e]=c[e]();b.attr("id",k).data(e,b[e]()).data("lengthName",e).data("child",l);f.sheet.insertRule(m,f.sheet.cssRules.length);c.css(g+"animation-timing-function","linear").css(g+"animation-duration",t(b[d](),c[d](),a.speed,a.direction)+"s").css(g+"animation-iteration-count",a.loop?
a.loop.toString():"infinite").css(g+"animation-delay",a.delay?a.delay+"s":"0").css(g+"animation-direction",a.direction?a.direction:"normal").css(g+"animation-play-state","running").css(g+"animation-name",k);b.css({margin:"0",padding:"0",overflow:"hidden",display:"block",position:"relative","white-space":"nowrap"})}:function(c,a){var b=c.wrap("<marquee />").css("display","inline").parent();p(b,a);b=b.get(0);"left"==a.direction||"right"==a.direction||"up"==a.direction||"down"==a.direction?b.direction=
a.direction:"alternate"==a.direction&&(b.direction="right",b.behavior=a.direction);a.speed&&(b.scrollAmount=85*a.speed/1E3);a.loop&&(b.loop=a.loop)}}(u);q._addFunction(!0,{marquee:function(d){var c=jQuery.extend({},{autoPause:!1,speed:20,direction:"left"},d);this.jq.each(function(){this.isMarquee=!0;v(jQuery(this),c)});c.autoPause&&(this.css("cursor","pointer"),this.bind("mouseenter",function(){var a=this.parentElement;"MARQUEE"==a.tagName?a.stop():this.style[n?"webkitAnimationPlayState":"animationPlayState"]=
"paused";if(c.onPause)c.onPause()}),this.bind("mouseleave",function(){var a=this.parentElement;"MARQUEE"==a.tagName?a.start():this.style[n?"webkitAnimationPlayState":"animationPlayState"]="running";if(c.onResume)c.onResume()}));return this}})})(naw);