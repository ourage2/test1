(function(l,c){l.namespace("widget.minicalendar");if(!m)var m={};m.check1="minicalendar : 크기가 작습니다.(59em 이상 width,height를 설정하세요)";m.check2="minicalendar : 콜벡함수를 정의하시기 바랍니다.";l.widget.minicalendar=l.widget.calendar.extend({init:function(q,r){this.setName("minicalendar");var b=this._getTemplate(q),g=this;b.renderTo=r.id;var t=c("#"+b.renderTo).css({width:b.width,height:b.height}).removeAttr("id"),p=c("<input/>").attr("id",b.renderTo).css("display","none");t.append(p);var n=b.callback||b.callBackFuntion;
if(null==n)l.showSlideMessage(m.create2);else{var a={format:"yyyymmdd",selectors:!0,yearRange:[-100,100],lang:"en",offset:[5,5],speed:"",firstDay:0,min:void 0,max:void 0,trigger:!1,viewer:"1",week:"0",css:{prefix:"calmini",input:"date",root:0,head:0,title:0,prev:0,next:0,month:0,year:0,days:0,body:0,weeks:0,today:0,current:0,week:0,off:0,sunday:0,focus:0,disabled:0,trigger:0},change:function(d,u){var f=this._format(u,a.format,a.lang),h=c("#"+a.css.root).data("key"),e="",b="",g="";if(h){for(var k=
0;k<h.length;k++)if(h[k].day==f){e=h[k].mark1;b=h[k].mark2;g=h[k].content;break}n.call("",f,e,b,g)}else n.call("",f);return!1}},a=c.extend({},a,a);c.each(a.css,function(d,c){c||"prefix"==d||(a.css[d]=(a.css.prefix||"")+(c||d))});this._super(p,a);this.show();c("#"+a.css.root).css({position:"",top:"",left:""});c.extend(g,{addContent:function(d,b){c("#"+a.css.root).data("key","");b?g.setValue(b.substr(0,4),b.substr(4,2)-1):g.setValue(g.getCurrYear(),g.getCurrMonth());c("#"+a.css.root).data("key",d);
c("#calminiweeks a").each(function(){for(var f=c(this),h=g._format(f.data("date"),a.format,a.lang),e=0;e<d.length;e++)d[e].day==h&&(f.find("span").text(d[e].mark1+"/"+d[e].mark2),f.data("mark1",d[e].mark1),f.data("mark2",d[e].mark2),f.data("content",d[e].content));h==b&&f.attr("id",a.css.current)})}})}}});l._addWidget("minicalendar",naw.widget.minicalendar)})(naw,jQuery);