(function($, undefined) {
"use strict";
if (!$.isFunction(Object.create)) {
	Object.create = function(o) {
		function F() {};
		F.prototype = o;
		return new F();
	};
}
if (!window.console) {
	window.console = {
		log: function(msg) {}
	};
}
var AjaxUtil = (function AjaxUtilImpl() {
	var that = Object.create(AjaxUtilImpl.prototype);
	that.ajaxRunningCount = 0;
	that.ajaxJsonSubmitDefaultOptions = {
		type: 'post',
		headers: {'X-Error-Accept': 'application/json'}
	};
	that.ajaxJsonDefaultOptions = $.extend(true, {dataType: 'json'}, that.ajaxJsonSubmitDefaultOptions);
	that.ajaxHtmlDefaultOptions = $.extend(true, {dataType: 'html'}, that.ajaxJsonSubmitDefaultOptions);
	that.loading$ = null;
	that.recordSizeKey = _recordSizeKey_;
	that.ajaxPreSuccess = function(options, data, textStatus, jqXHR) {
		that.ajaxPreComplete();
		var disposition = jqXHR.getResponseHeader('Content-Disposition');
		if (disposition && disposition.indexOf('attachment') !== -1) {
			var filenameRegex = /filename[^;=\n]*=((['']).*?\2|[^;\n]*)/;
			var matches = filenameRegex.exec(disposition);
			if (matches != null && matches[1]) {
				var filename = matches[1].replace(/['']/g, '');
				if (filename) {
					filename = decodeURIComponent(filename);
					var type = jqXHR.getResponseHeader('Content-Type');
			        var blob = new Blob([data], {type: type});
			        if (typeof window.navigator.msSaveBlob !== 'undefined') {
			            window.navigator.msSaveBlob(blob, filename);
			        } else {
			            var url = window.url || window.webkitURL;
			            var downloadUrl = url.createObjectURL(blob);
			            if (filename) {
			                var a = document.createElement('a');
			                if (typeof a.download === 'undefined') {
			                    window.location = downloadUrl;
			                } else {
			                    a.href = downloadUrl;
			                    a.download = filename;
			                    document.body.appendChild(a);
			                    a.click();
			                }
			            } else {
			                window.location = downloadUrl;
			            }
			            setTimeout(function () {
			            	url.revokeObjectURL(downloadUrl);
			            }, 100);
			        }
				}
			}
			return;
		}
		options.data = options.originData || options.data || {};
		if(options.originUrl) {
			options.url = options.originUrl;
			delete options.originUrl;
		}
		if(StringUtil.endsWith(options.url, '.do')) {
			var data$ = $(data);
			var pagination$ = $('.pagination', data$);
			var recordSizeKey, recordSize;
			if(pagination$.length) {
				var pageParam = pagination$.find(':hidden[name=pageParam]').val();
				var suffix = pagination$.find(':hidden[name=suffix]').val();
				recordSizeKey = that.recordSizeKey;
				if(suffix) {
					recordSizeKey = recordSizeKey + '_' + suffix;
				}
				recordSizeKey = StringUtil.camelize(recordSizeKey);
				recordSize = pagination$.find(':hidden[name=recordSize]').val();
				$('a', pagination$).on('click', function(e) {
					e.preventDefault();
					var self$ = $(this);
					var page = self$.attr('data-page');
					if(page) {
						options.data[pageParam] = page;
						options.data[recordSizeKey] = recordSize;
						AjaxUtil.ajaxHtml(options);
					}
				});
				var selectTotalCount$ = $('.select-total-count', data$);
				if(selectTotalCount$.length) {
					selectTotalCount$.find('option[value="' + recordSize + '"]').prop('selected', true);
					selectTotalCount$.on('change', function() {
						var self$ = $(this);
						options.data[pageParam] = 1;
						options.data[recordSizeKey] = self$.val();
						AjaxUtil.ajaxHtml(options);
					});
				}
			}
			if(options.responseTarget) {
				var responseTarget$ = $(options.responseTarget);
				responseTarget$
					.data('ajaxOptions', options)
					.html(data$);
				if(recordSizeKey && recordSize) {
					responseTarget$.data('recordSizeKey', recordSizeKey).data('recordSize', recordSize);
				}
				lupin._objectInitialize(data$);
			}
		}
	};
	that.ajaxPreComplete = function() {
//		that.hideLoading();
	};
	$.ajaxSetup({
		type: 'post',
		async: false,
		traditional: true
	});
	$(document).ajaxSend(function(event, jqXHR, options) {
//		that.showLoading();
		options.ajaxOptions = options;
	});
	$(document).ajaxSuccess(function(event, jqXHR, options, data) {
		/*
		if(options.responseTarget) {
			var data$ = $(data);
			var pagination$ = $('.pagination', data$);
			if(pagination$.length) {
				var pageParam = pagination$.find(':hidden[name=pageParam]').val();
				var suffix = pagination$.find(':hidden[name=suffix]').val();
				var recordSizeKey = that.recordSizeKey;
				if(suffix) {
					recordSizeKey = recordSizeKey + '_' + suffix;
				}
				recordSizeKey = StringUtil.camelize(recordSizeKey);
				var recordSize = pagination$.find(':hidden[name=recordSize]').val();
				var data = ParamUtil.parse(options.data);
				$('a', pagination$).on('click', function(e) {
					e.preventDefault();
					var self$ = $(this);
					var page = self$.attr('data-page');
					if(page) {
						data[pageParam] = page;
						data[recordSizeKey] = recordSize;
						options.data = data;
						AjaxUtil.ajaxHtml(options);
					}
				});
				var selectTotalCount$ = $('.select-total-count', data$);
				if(selectTotalCount$.length) {
					selectTotalCount$.find('option[value="' + recordSize + '"]').prop('selected', true);
					selectTotalCount$.on('change', function() {
						var self$ = $(this);
						data[pageParam] = 1;
						data[recordSizeKey] = self$.val();
						options.data = data;
						AjaxUtil.ajaxHtml(options);
					});
				}
			}
			lupin._objectInitialize(data$);
			$(options.responseTarget).html(data$);

			if(options.finish && $.isFunction(options.finish)) {
				options.finish.apply(this, [event, jqXHR, options, data]);
			}
		}
		*/
	});
	$(document).ajaxError(function(event, jqXHR, options, thrownError) {
		that.handleError(jqXHR.responseText);
	});
	$(document).ajaxComplete(function(event, jqXHR, options) {
		if(options.form$) {
			options.form$.data('isSubmitting', false);
		}
	});
	$.extend(AjaxUtilImpl.prototype, {
		showLoading: function() {
			that.ajaxRunningCount++;
			if(that.ajaxRunningCount === 1) {
//				that.loading$.modal({keyboard:false, backdrop:'static'});
			}
		},
		hideLoading: function() {
			that.ajaxRunningCount--;
			if(that.ajaxRunningCount === 0) {
//				that.loading$.modal('hide');
//				$('#modal-loader').modal('hide');
			}
		},
		setLoading: function(loading$) {
			loading$.on('show.bs.modal', function() {
				loading$.find('.modal-dialog').center();
			});
			that.loading$ = loading$;
		},
		ajaxBefore: function(options) {
			var optSuccess = options.success;
			var originSuccess = options.originSuccess;
			if(originSuccess && $.isFunction(originSuccess)) {
				options.success = originSuccess;
			} else {
				if(optSuccess && $.isFunction(optSuccess)) {
					options.success = function(data, textStatus, jqXHR) {
						that.ajaxPreSuccess(options, data, textStatus, jqXHR);
						optSuccess.apply(this, [data, textStatus, jqXHR]);
					}
				} else {
					options.success = function(data, textStatus, jqXHR) {
						that.ajaxPreSuccess(options, data, textStatus, jqXHR);
					}
				}
				options.originSuccess = options.success;
			}
			var optError = options.error;
			var originError = options.originError;
			if(originError && $.isFunction(originError)) {
				options.error = originError;
			} else {
				if(optError && $.isFunction(optError)) {
					options.error = function(jqXHR, textStatus, errorThrown) {
						that.ajaxPreComplete();
						optError.apply(this, [jqXHR, textStatus, errorThrown]);
					}
				} else {
					options.error = function(jqXHR, textStatus, errorThrown) {
						that.ajaxPreComplete();
					}
				}
				options.originError = options.error;
			}
		},
		ajax: function(options) {
			var settings = {};
			$.extend(true, settings, that.ajaxJsonDefaultOptions, (options || {}));
			that.ajaxBefore(settings);
			return $.ajax(settings);
		},
		ajaxHtml: function(options) {
			var settings = {};
			$.extend(true, settings, that.ajaxHtmlDefaultOptions, (options || {}));
			that.ajaxBefore(settings);
			return $.ajax(settings);
		},
		ajaxSubmit: function(form$, options) {
			if(form$.data('isSubmitting')) {
				return false;
			}
			form$.data('isSubmitting', true);
			var settings = {'form$': form$};
			$.extend(true, settings, that.ajaxJsonSubmitDefaultOptions, (options || {}));
			settings.originData = form$.serializeJson();
			settings.originUrl = form$.attr('action') || settings.url;
			that.ajaxBefore(settings);
			if(settings.responseTarget) {
				var responseTarget$ = $(settings.responseTarget);
				var recordSizeKey = responseTarget$.data('recordSizeKey');
				var recordSize = responseTarget$.data('recordSize');
				if(recordSizeKey && recordSize) {
					if(!settings.data) {
						settings.data = {};
					}
					settings.data[recordSizeKey] = recordSize;
				}
			}
			return form$.ajaxSubmit(settings);
		},
		reload: function(options) {
			var ajaxOptions = that._getAjaxOptions(options);
			return AjaxUtil.ajaxHtml(ajaxOptions);
		},
		recentData: function(options) {
			var ajaxOptions = that._getAjaxOptions(options);
			if(ajaxOptions) {
				return ajaxOptions.data;
			}
		},
		download: function(options) {
			var settings = {
				headers: {'X-Accept': 'application/download'}
			};
			$.extend(true, settings, that.ajaxJsonSubmitDefaultOptions, (options || {}));
			that.ajaxBefore(settings);
			if(settings.downloadTarget) {
				var ajaxData = lupin.ajaxData(settings.downloadTarget);
				if(ajaxData) {
					var data = settings.data || {};
					$.extend(true, data, ajaxData);
					settings.data = data;
				}
			}
			return $.ajax(settings);
		},
		fileDownload: function(options) {
			options = options || {};
			var settings = {};
			$.extend(true, settings, options);
			if(settings.downloadTarget) {
				var ajaxData = lupin.ajaxData(settings.downloadTarget);
				if(ajaxData) {
					var data = settings.data || {};
					$.extend(true, data, ajaxData);
					settings.data = data;
				}
			}
			var settingsSuccess = settings.success;
			if(settingsSuccess && $.isFunction(settingsSuccess)) {
				settings.successCallback = function(url) {
					that.ajaxPreComplete();
					settingsSuccess.apply(this, [url]);
				};
			} else {
				settings.successCallback = function() {
					that.ajaxPreComplete();
				};
			}
	    	var settingsError = settings.error;
	    	if(settingsError && $.isFunction(settingsError)) {
	    		settings.failCallback = function(responseText, url) {
					that.ajaxPreComplete();
					that.handleError(responseText);
					settingsError.apply(this, [responseText, url]);
				}
	    	} else {
	    		settings.failCallback = function(responseText, url) {
					that.ajaxPreComplete();
					that.handleError(responseText);
				}
	    	}
	    	if(!settings.httpMethod && settings.type) {
	    		settings.httpMethod = settings.type;
	    	}
//			that.showLoading();
//	    	console.log(settings);
			$.fileDownload(settings.url, settings);
			return;
		},
		handleError: function(response) {
			if(response) {
				if(lupin._type(response) === 'string') {
					response = $.parseJSON(response);
				}
				if(response.resCd === _unauthorizedCode_) {
					alert('세션이 종료되었습니다.');
//					lupin.goUrl('/member/session/logout/logout.do');
				} else {
					alert('[' + response.resCd + '] ' + response.resMsg);
				}
			}
		},
		_getAjaxOptions: function(options) {
			var responseTarget$ = options.responseTarget;
			if(!responseTarget$) {
				throw Error('This "responseTarget" is empty.');
			}
			if(lupin._type(responseTarget$) !== 'jquery') {
				responseTarget$ = $(responseTarget$);
			}
			return responseTarget$.data('ajaxOptions');
		}
	});
	return that;
}());
var ParamUtil = (function ParamUtilImpl() {
	var that = Object.create(ParamUtilImpl.prototype);
	that.paramPattern = new RegExp(/^(.*)=(.*)$/);
	$.extend(ParamUtilImpl.prototype, {
		parse: function(parameter) {
			var json = {};
			if(parameter) {
				var newParam = parameter.replace(/^\?/, '');
				var newParamToken = newParam.split('&');
				var matcher, value;
				for(var i=0, s=newParamToken.length; i<s; i++) {
					matcher = that.paramPattern.exec(newParamToken[i]);
					if(matcher && matcher.length === 3) {
						if(matcher[2]) {
							value = decodeURIComponent(matcher[2]);
							if(lupin._type(json[matcher[1]]) === 'string') {
								json[matcher[1]] = new Array(json[matcher[1]]);
								json[matcher[1]].push(value);
							} else if(lupin._type(json[matcher[1]]) === 'array') {
								json[matcher[1]].push(value);
							} else {
								json[matcher[1]] = value;
							}
						}
					}
				}
			}
			return json;
		}
	});
	return that;
}());
var StringUtil = (function StringUtilImpl() {
	var that = Object.create(StringUtilImpl.prototype);
	$.extend(StringUtilImpl.prototype, {
		camelize: function(str) {
			return str.toLowerCase()
			.replace(/[-_]+/g, ' ')
			.replace(/[^\w\s]/g, '')
			.replace(/ (.)/g, function($1) {
				return $1.toUpperCase();
			})
			.replace(/ /g, '');
		},
		endsWith: function(str, suffix) {
			if(str) {
				return str.indexOf(suffix, str.length - suffix.length) !== -1;
			}
			return false;
		}
	});
	return that;
}());
$.fn.extend({
	ajax: function(options) {
		if (!this.is('form')) {
			throw Error('This object is not support "ajax" function.');
		}
		return AjaxUtil.ajaxSubmit(this, options);
	},
	serializeJson: function() {
		 var json = {};
		 var arr = $(this).serializeArray();
		 $.each(arr, function(i, v) {
			 if(v.value) {
				 if(lupin._type(json[v.name]) === 'string') {
					 json[v.name] = new Array(json[v.name]);
					 json[v.name].push(v.value);
				 } else if(lupin._type(json[v.name]) === 'array') {
					 json[v.name].push(v.value);
				 } else {
					 json[v.name] = v.value;
				 }
			 }
		 });
		 return json;
	},
	center: function () {
        return this.each(function() {
            var top = ($(window).height() - $(this).outerHeight()) / 2;
            var left = ($(window).width() - $(this).outerWidth()) / 2;
            $(this).css({position:'absolute', margin:0, top: (top > 0 ? top : 0)+'px', left: (left > 0 ? left : 0)+'px'});
        });
    }
});
$.extend(true, window, {
	lupin: {
		ajax: function(options) {
			return AjaxUtil.ajax(options);
		},
		ajaxHtml: function(options) {
			return AjaxUtil.ajaxHtml(options);
		},
		ajaxReload: function(responseTarget) {
			return AjaxUtil.reload({'responseTarget': responseTarget});
		},
		ajaxData: function(responseTarget) {
			return AjaxUtil.recentData({'responseTarget': responseTarget});
		},
		ajaxDownload: function(options) {
			AjaxUtil.download(options);
		},
		ajaxFileDownload: function(options) {
			AjaxUtil.fileDownload(options);
		},
		goUrl: function(path) {
			location.href = _contextPath_ + path;
		},
		_setAjaxLoading: function(loading$) {
//			AjaxUtil.setLoading(loading$);
		},
		_objectInitialize: function(t) {
			var target = $.parseHTML(t) || document;
			$('.select-sort', target).each(function() {
				$(this).mfs({autoWidth: true});
			});
			$('.modal-date', target).Zebra_DatePicker();
		},
		_type: function(obj) {
			var type = $.type(obj);
			if(type === 'object') {
				if(obj instanceof jQuery) {
					type = 'jquery';
				}
			}
			return type;
		}
	}
});
}(jQuery));
//jQuery(function($) {
//	var modalLoader$ = $('#modal-loader');
//	if(modalLoader$.length !== 1) {
//		modalLoader$ = $('<div id="modal-loader" class="modal" role="dialog"><div class="modal-dialog"><img src="' + _contextPath_ + '/resources/images/common/ajax-loading.gif" /></div></div>').appendTo('body');
//	}
//	lupin._setAjaxLoading(modalLoader$);
//	lupin._objectInitialize();
//});

