String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
}
String.prototype.replaceAll = function(str1, str2) {
	var temp_str = "";
	if (this.trim() != "" && str1 != str2) {
	  temp_str = this.trim();
		while (temp_str.indexOf(str1) > -1) {
			temp_str = temp_str.replace(str1, str2);
		}
	}
	return temp_str;
}
String.prototype.encodeHTML = function() {
	return this.replace(/&/g, '&amp;')
			   .replace(/</g, '&lt;')
			   .replace(/>/g, '&gt;')
			   .replace(/"/g, '&quot;')
			   .replace(/'/g, '&apos;');
};

String.prototype.decodeHTML = function() {
	return this.replace(/&apos;/g, "'")
				.replace(/&quot;/g, '"')
				.replace(/&gt;/g, '>')
				.replace(/&lt;/g, '<')
				.replace(/&amp;/g, '&');
};

String.prototype.isNum = function() {
	return (this ^ 0) === +this;
};

String.prototype.startsWith = function(str){
	if (this.length < str.length) { return false; }
	return this.indexOf(str) == 0;
}

String.prototype.endsWith = function(str){
	if (this.length < str.length) { return false; }
	return this.lastIndexOf(str) + str.length == this.length;
}

Date.prototype.format = function(f) {
	if(!this.valueOf()) return ' ';

	var weekName = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
	var d = this;

	return f.replace(/(yyyy|yy|MM|dd|E|HH|hh|mm|ss|a\/p)/gi, function($1) {
		switch ($1) {
			case 'yyyy' : return d.getFullYear();
			case 'yy' : return (d.getFullYear() % 1000).zf(2);
			case 'MM' : return (d.getMonth() + 1).zf(2);
			case 'dd' : return d.getDate().zf(2);
			case 'E' : return weekName[d.getDay()];
			case 'HH' : return d.getHours().zf(2);
			case 'hh' : return ((h = d.getHours() % 12) ? h : 12).zf(2);
			case 'mm' : return d.getMinutes().zf(2);
			case 'ss' : return d.getSeconds().zf(2);
			case 'a/p' : return d.getHours() < 12 ? '오전' : '오후';
			default : return $1;
		}
	});
};

String.prototype.string = function(len) {var s = '', i = 0; while(i++ < len) { s += this; } return s; };
String.prototype.zf = function(len) { return '0'.string(len - this.length) + this; };
Number.prototype.zf = function(len) { return this.toString().zf(len); };

var Box = function () {
	this.box = new Object();
};

Box.prototype = {
	put: function (key, value) {
		this.box[key] = value;
	},
	get: function (key) {
		return this.box[key];
	},
	nvl: function (key, defaultVal) {
		if (!defaultVal) defaultVal = '';
		return (this.box[key]) ? this.box[key] : defaultVal;
	},
	containsKey: function (key) {
		return key in this.box;
	},
	containsValue: function (value) {
		for (var prop in this.box) {
			if (this.box[prop] == value) return true;
		}
		return false;
	},
	isEmpty: function (key) {
		return (this.size() == 0);
	},
	clear: function () {
		for (var prop in this.box) {
			delete this.box[prop];
		}
	},
	remove: function (key) {
		delete this.box[key];
	},
	keys: function () {
		var keys = new Array();
		for (var prop in this.box) {
			keys.push(prop);
		}
		return keys;
	},
	values: function () {
		var values = new Array();
		for (var prop in this.box) {
			values.push(this.box[prop]);
		}
		return values;
	},
	size: function () {
		var count = 0;
		for (var prop in this.box) {
			count++;
		}
		return count;
	}
};
var box = new Box();

var rxDatePattern = /^(\d{4})(\/|-)?(\d{2})(\/|-)?(\d{2})$/;


function comma(val) {
	var parts = val.toString().split('.');
	return parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',') + (parts[1] ? '.' + parts[1] : '');
}

function emailChk(email) {
	return /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i.test(email);
}

function checkSpace(str) {
	if (str.search(/\s/) != -1) {
		return true;
	} else {
		return false;
	}
}

function isHangul(s) {
	var len;
	len = s.length;
	for (var i = 0; i < len; i++) {
		if (s.charCodeAt(i) != 32 && (s.charCodeAt(i) < 44032 || s.charCodeAt(i) > 55203)) {
			return false;
		}
	}
	return true;
}


function isValidDate(txtDate) {
	var currVal = $.trim(txtDate);
	if(!currVal) {
		return false;
	}

	var dtArray = currVal.match(rxDatePattern);

	if (dtArray == null) {
		return false;
	}

	var dtYear = dtArray[1];
	var dtMonth = dtArray[3];
	var dtDay= dtArray[5];

	if (dtMonth < 1 || dtMonth > 12)
		return false;
	else if (dtDay < 1 || dtDay > 31)
		return false;
	else if ((dtMonth==4 || dtMonth==6 || dtMonth==9 || dtMonth==11) && dtDay == 31)
		return false;
	else if (dtMonth == 2) {
		var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
		if (dtDay > 29 || (dtDay == 29 && !isleap))
			return false;
	}
	return true;
}


function strToDateFormat(txtDate) {
	var currVal = $.trim(txtDate);
	if(!currVal) {
		return;
	}

	var dtArray = currVal.match(rxDatePattern);

	if (dtArray == null) {
		return;
	}

	var dtYear = dtArray[1];
	var dtMonth = dtArray[3];
	var dtDay= dtArray[5];

	if (dtMonth < 1 || dtMonth > 12)
		return;
	else if (dtDay < 1 || dtDay > 31)
		return;
	else if ((dtMonth==4 || dtMonth==6 || dtMonth==9 || dtMonth==11) && dtDay == 31)
		return;
	else if (dtMonth == 2) {
		var isleap = (dtYear % 4 == 0 && (dtYear % 100 != 0 || dtYear % 400 == 0));
		if (dtDay > 29 || (dtDay == 29 && !isleap))
			return;
	}
	return dtYear + '-' + dtMonth + '-' + dtDay;
}

function stripDateFormat(txtDate) {
	return txtDate.replace(/-/g, '');
}

function xmlToString(xml) {
	if (window.ActiveXObject) { return xml.xml; }
	return new XMLSerializer().serializeToString(xml);
}

function formatXml(xml) {
	if(jQuery.type(xml) === 'object') {
		xml = xmlToString(xml);
	} else if(jQuery.type(xml) !== 'string') {
		return;
	}

	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node) {
		var indent = 0;
		if (node.match(/.+<\/\w[^>]*>$/)) {
			indent = 0;
		} else if (node.match(/^<\/\w/)) {
			if (pad != 0) {
				pad -= 1;
			}
		} else if (node.match(/^<\w[^>]*[^\/]>.*$/)) {
			indent = 1;
		} else {
			indent = 0;
		}

		var padding = '';
		for (var i = 0; i < pad; i++) {
			padding += '\t';
		}

		formatted += padding + node + '\r\n';
		pad += indent;
	});

	return formatted;
}

function fnAuthCdList(div) {
	var list = [];
	var centerIdx = 0;
	var agentIdx = 0;
	for (var idx = 0; idx < com.getCdList('AUTH_CD').length; idx++) {
		if (div == 'C') {
			if (!(com.getCdList('AUTH_CD')[idx].cd).startsWith('6')) {
				list[centerIdx++] = com.getCdList('AUTH_CD')[idx];
			}
		}
		if (div == 'A') {
			if ((com.getCdList('AUTH_CD')[idx].cd).startsWith('6')) {
				list[agentIdx++] = com.getCdList('AUTH_CD')[idx];
			}
		}
	}
	return list;
}

function fnRemove(arrOriginal, elementToRemove){
	return arrOriginal.filter(function(el){return el !== elementToRemove});
}

function fnAllTabClose() {
	if(!confirm('모든 메뉴를 닫겠습니까?')) { return false; }
	$('#ui-id-1').trigger('click');
	var tabId;
	$('div.ui-icon-close').each(function() {
		tabId = $(this).closest('li').attr('aria-controls');
		if (tabId != 'tab-1') {
			$(this).closest('li').remove();
			$('#' + tabId).remove();
		}
	});
	$('#menuTab').tabs('refresh');
}

function fnValidCarNo(carNo) {
	var pattern1 = /\d{2}[가-힣ㄱ-ㅎㅏ-ㅣ\x20]\d{4}/g; // 12저1234
	var pattern2 = /[가-힣ㄱ-ㅎㅏ-ㅣ\x20]{2}\d{2}[가-힣ㄱ-ㅎㅏ-ㅣ\x20]\d{4}/g; // 서울12치1233

	if (pattern1.test(carNo) && carNo.length == 7) {
		return true;
	} else if (pattern2.test(carNo) && carNo.length == 9) {
		return true;
	} else {
		return false;
	}
}