(function (a, C) {
	a.isFunction(Object.create) || (Object.create = function (a) {
		function h() {}
		h.prototype = a;
		return new h;
	});
	window.console || (window.console = {
		log: function (a) {
			alert(a)
		}
	});
	var w = function D() {
		var h = Object.create(D.prototype);
		h.FUNCTION_NAME_STRING_REGEXP = /^function\s?([^\s(]*)/;
		a.extend(D.prototype, {
			goUrl: function (a, k, d) {
				a = _contextPath_ + a;
				if (k && "_self" !== k) return "top" === k ? (window.top.location.href = a, window) : d ? window.open(a, k, d) : window.open(a, k);
				window.location.href = a;
				return window
			},
			functionName: function (a, k) {
				var d = "";
				"function" === typeof a ? d = a.name || a.toString().match(h.FUNCTION_NAME_STRING_REGEXP)[1] : "function" === typeof a.constructor && (d = functionName(a.constructor, k));
				return d || k
			},
			startsWith: function (a, k) {
				a = h.toString(a);
				return 0 === a.indexOf(k) ? !0 : !1
			},
			getUrl: function (a) {
				if (a) {
					var k = a.indexOf("?"); - 1 < k && (a = a.substring(0, k))
				}
				return a
			}
		});
		return h
	} (),
	r = function E() {
		var m = Object.create(E.prototype);
		//2018-10-15 : beforeSend에 삽입(custom source)
		var uri = location.href;
		uri = uri.substring(uri.lastIndexOf("/") + 1, uri.lastIndexOf("."));

		m.INITIALIZE_FORM_CHECK = "initializeForm";
		m.ENABLE_LOADING_BAR = !0;
		m.IS_SUBMITTING = !1;
		m.AJAX_DEFAULT_OPTIONS = {
			type: "post",
			headers: {
				"menuCd": uri,
				"X-Error-Accept": "application/json"
			},
			traditional: !0,
			success: function (a, d, c) {
				m.AJAX_DEFAULT_OPTIONS.ajaxComplete()
			},
			error: function (a, d, c, e) {
				m.AJAX_DEFAULT_OPTIONS.ajaxComplete();
				m.errorHandle(a, d, c, e)
			},
			ajaxComplete: function () {
				m.IS_SUBMITTING = !1;
				m.ENABLE_LOADING_BAR && m.hideLoadingBar();
				B.resetTimer()
			}
		};
		m.POPUP_DEFAULT_OPTIONS = {
			dialogOption: {
				resizable: !1
			},
			open: function () {
				try {
					a.isFunction(open) && open.apply(this)
				} catch(k) {}
			}
		};
		m.DIALOG_LIST = {};
		a.extend(E.prototype, {
			ajaxBefore: function (k) {
				var d = k.success,
				c = k.error,
				e = k.errorBlank;
				k = a.extend(!0, k || {},
				m.AJAX_DEFAULT_OPTIONS);
				a.isFunction(d) && (k.success = function (c, e, f) {
					m.AJAX_DEFAULT_OPTIONS.ajaxComplete.apply(this);
					"json" === k.dataType && (null === c ? c = {}: "string" === typeof c && (c = {
						message: c
					}));
					d.apply(this, [c, e, f])
				});
				a.isFunction(c) && (k.error = function (e, d, f) {
					m.AJAX_DEFAULT_OPTIONS.error.apply(this, [e, d, f]);
					c.apply(this, [e, d, f])
				});
				a.isFunction(e) && (k.error = function (c, d, f) {
					m.AJAX_DEFAULT_OPTIONS.ajaxComplete.apply(this);
					e.apply(this, [c, d, f])
				});
				delete k.ajaxComplete;
				if (m.IS_SUBMITTING) return ! 1;
				m.IS_SUBMITTING = !0;
				m.ENABLE_LOADING_BAR && m.showLoadingBar();
				return k
			},
			ajaxPopupBefore: function (k) {
				var d;
				try {
					k.popupKey = k.id || w.getUrl(k.url);
					var c = k.dialogOptions;
					c ? delete k.dialogOptions: c = {};
					var e = k.callback;
					a.isFunction(e) && (k.callback = function () {
						e.apply(this, arguments);
						d.dialog("close")
					});
					a.extend(!0, k, {
						success: function (e, f, b) {
							d = a("<div />", {
								"class": "popup-carousel"
							}).append(e);
							f = a(".popup-content:first", d);
							f.length || (f = a("<div />", {
								"class": "popup-content"
							}).append(e), d = f.wrap('<div class="popup-carousel"></div>'));
							var g = c.close;
							c.close = function () {
								d.remove();
								delete m.DIALOG_LIST[k.popupKey];
								g && a.isFunction(g) && g.apply(this)
							};
							e = {};
							a.extend(!0, e, m.POPUP_DEFAULT_OPTIONS, c);
							b = f.find("h1");
							b.remove();
							b.length && (b.remove(), e.title = b.text());
							if (b = l.parseInt(f.css("width")) || e.width) e.width = b,
							f.css("width", "100%");
							if (b = l.parseInt(f.css("height")) || e.height) e.height = b,
							f.css("height", "auto");
							b = l.parseInt(f.css("maxWidth")) || e.maxWidth;
							e.maxWidth = b ? b: a(document).width();
							b = l.parseInt(f.css("maxHeight")) || e.maxHeight;
							e.maxHeight = b ? b: a(document).height();
							if (b = m.DIALOG_LIST[k.popupKey]) b.remove(),
							delete m.DIALOG_LIST[k.popupKey];
							m.initializeForm(d.find("form"));
							d.appendTo("body").dialog(e);
							f.find(".popup-close").on("click", function (b) {
								b.preventDefault();
								com.editDel();
								d.dialog("close")
							});
							f.data("callback", k.callback);
							m.DIALOG_LIST[k.popupKey] = d;
							d.attr({
								"popup-key": k.popupKey
							})
						}
					})
				} catch(t) {
					d && d.remove()
				}
			},
			addJsonOption: function (k) {
				k = k || {};
				a.extend(!0, k, {
					dataType: "json"
				})
			},
			addHtmlOption: function (k) {
				k = k || {};
				a.extend(!0, k, {
					dataType: "html"
				});
				var d = k.complete;
				k.complete = function (c, e) {
					if (k.dialogId) {
						var t = m.DIALOG_LIST[k.dialogId];
						t && (t.dialog({
							position: {
								my: "center",
								at: "center",
								of: window
							}
						}), t = t.closest(".ui-dialog"), 0 > t.position().top && t.css({
							top: 0
						}))
					}
					a.isFunction(d) && d.apply(this, [c, e])
				}
			},
			ajaxSubmit: function (a, d) {
				m.addJsonOption(d);
				m.ajaxBefore(d);
				a.ajaxSubmit(d)
			},
			ajax: function (k) {
				m.addJsonOption(k);
				m.ajaxBefore(k);
				a.ajax(k)
			},
			ajaxHtml: function (k) {
				m.addHtmlOption(k);
				m.ajaxBefore(k);
				a.ajax(k)
			},
			ajaxPopup: function (k) {
				var d = {};
				a.extend(!0, d, k, m.POPUP_DEFAULT_OPTIONS);
				m.ajaxPopupBefore(d);
				m.ajaxHtml(d)
			},
			removePopup: function () {
				a.each(m.DIALOG_LIST, function (a) {
					m.DIALOG_LIST[a].remove();
					delete m.DIALOG_LIST[a]
				})
			},
			handleInternalServerError: function (k, d) {
				try {
					var c = a.parseJSON(k);
					if (c) {
						if ("E817" === c.reseCd || "F502" === c.resCd) return h.alertError(c, function () {
							c.goUrl ? w.goUrl(c.goUrl) : w.goUrl("/main/login.do")
						}),
						!0;
						if (d && a.isFunction(d) && !1 === d(c)) return ! 0;
						h.alertError(c);
						return ! 0
					}
				} catch(e) {}
				return ! 1
			},
			initializeForm: function (k) { (k || a("form")).each(function () {
					var d = a(this);
					d.data(m.INITIALIZE_FORM_CHECK) || m.bindEvent(d)
				})
			},
			bindEvent: function (k) {
				var d = k.get(0);
				a.each(d.elements, function () {
					n.bindValidationRulesToElement(this)
				});
				k.data(m.INITIALIZE_FORM_CHECK, !0)
			},
			showLoadingBar: function (k) {
				var d, c = !1;
				window.self !== window.top ? d = window.top: (d = window, c = !0);
				k = c ? a("#loading_bar") : a("#loading_bar", d.document);
				1 > k.length && (k = c ? m.createLoadingBar().attr({
					id: "loading_bar"
				}).appendTo("body") : m.createLoadingBar().attr({
					id: "loading_bar"
				}).appendTo(a("body", d)));
				var c = a(d).scrollTop() || 0,
				c = c + (a(d).height() - k.outerHeight()) / 2,
				e = a(d).scrollLeft() || 0,
				e = e + (a(d).width() - k.outerWidth()) / 2;
				k.css({
					top: (0 < c ? c: 0) + "px",
					left: (0 < e ? e: 0) + "px",
					display: "inline-block"
				})
			},
			createLoadingBar: function () {
				return a("<div />", {
					"class": "loading_bar"
				}).append(a("<img />", {
					src: _contextPath_ + "/resources/image/cmn/loadingbar.gif",
					css: {
						width: 75,
						height: 44
					}
				}))
			},
			hideLoadingBar: function () {
				window.self !== window.top ? a(".loading_bar", top.document).hide() : a(".loading_bar").hide()
			},
			errorHandle: function (a, d, c, e) {
				if (500 !== a.status || !0 !== m.handleInternalServerError(a.responseText, e)) 400 <= a.status && 600 > a.status ? h.alertError({
					messageId: "HTTP-" + a.status,
					message: c
				}) : h.alertError({
					messageId: "ERROR",
					message: "Unavailable data received."
				})
			}
		});
		return m
	} (),
	n = function m() {
		var k = Object.create(m.prototype);
		k.SELECTOR_INPUT_DATE_PICKER = ".inputDatePicker";
		k.SELECTOR_INPUT_NUMBER = ".inputNumber";
		k.SELECTOR_INPUT_EN_NUM = ".inputEnNum";
		k.SELECTOR_INPUT_AMOUT = ".inputAmount";
		a.extend(m.prototype, {
			forceToTrimmed: function (d) {
				var c = a.trim(d.val());
				c !== d.val() && d.val(c)
			},
			focusOnInvalid: function (d) {
				try {
					d[0].focus()
				} catch(c) {}
			},
			bindValidationRulesToElement: function (d) {
				var c = a(d);
				if (c.is(":text") || c.is(":password")) {
					var e = d.onfocus;
					d.onfocus = null;
					var t = d.onblur;
					d.onblur = null;
					c.on("focus", x.onFocus);
					e && c.on("focus", e);
					c.on("blur", x.onBlur);
					t && c.on("blur", t);
					c.is(k.SELECTOR_INPUT_DATE_PICKER) ? (c.attr("maxlength", "10").css("width", "75"), x.formatDateOnBlur(c), c.datepicker({
						onSelect: function (e, d) {
							c.trigger("onSelect")
						}
					})) : c.is(k.SELECTOR_INPUT_AMOUT) ? (c.addClass("txtR"), x.formatAmountOnBlur(c)) : c.is(k.SELECTOR_INPUT_NUMBER) && (c.addClass("txtR"), x.forceToNumber(c));
					c.addClass("bindValidationRulesToElement")
				} else c.is(".multi:file") && (c.MultiFile(), c.addClass("bindValidationRulesToElement"))
			},
			checkRequired: function (d, c) {
				c = c || k.getElementTitle(d);
				if (d.is(":text") || d.is(":password") || d.is("textarea")) {
					if (!a.trim(d.val())) return h.alert(h.getMessage(h.INVALID_REQUIRED_INPUT, c), function () {
						k.focusOnInvalid(d)
					}),
					!1
				} else if (d.is("select")) {
					if (!d.find("option:selected").val()) return h.alert(h.getMessage(h.INVALID_REQUIRED_SELECT, c), function () {
						k.focusOnInvalid(d)
					}),
					!1
				} else if (d.is(":checkbox") || d.is(":radio")) {
					if (!d.is(":checked")) return h.alert(h.getMessage(h.INVALID_REQUIRED_SELECT, c), function () {
						k.focusOnInvalid(d)
					}),
					!1
				} else if (d.is(":hidden") && !a.trim(d.val())) return h.alert(h.getMessage(h.INVALID_REQUIRED_SELECT, c)),
				!1;
				return ! 0
			},
			checkRequiredNum: function (d, c) {
				c = c || k.getElementTitle(d);
				return ! d.is(":text") || d.val() && "0" !== d.val() ? !0 : (h.alert(h.getMessage(h.INVALID_REQUIRED_INPUT, c), function () {
					k.focusOnInvalid(d)
				}), !1)
			},
			checkRequiredFile: function (d, c) {
				return d ? 2 > d.n ? (c ? h.alert(h.getMessage(h.INVALID_REQUIRED_SELECT, c)) : h.alert(h.INVALID_REQUIRED_FILE), !1) : !0 : (h.alert("\ucca8\ubd80\ud30c\uc77c Object \uc9c0\uc815\uc774 \uc798\ubabb\ub418\uc5c8\uc2b5\ub2c8\ub2e4."), !1)
			},
			isEmail: function (d) {
				return /^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i.test(d) ? !0 : !1
			},
			checkNumber: function (d, c) {
				c = c || k.getElementTitle(d);
				return ! d.is(":text") && !d.is(":password") || k.isNumber(d.val()) ? !0 : (h.alert(h.getMessage(h.INVALID_NUMBER, c), function () {
					k.focusOnInvalid(d)
				}), !1)
			},
			isNumber: function (d) {
				return /^[\d]*$/.test(d) ? !0 : !1
			},
			checkEnNum: function (d, c) {
				c = c || k.getElementTitle(d);
				return ! d.is(":text") && !d.is(":password") || k.isEnNum(d.val()) ? !0 : (h.alert(h.getMessage(h.INVALID_EN_NUM, c), function () {
					k.focusOnInvalid(d)
				}), !1)
			},
			isEnNum: function (d) {
				return /^[a-z0-9]*$/i.test(d) ? !0 : !1
			},
			checkPassword: function (d, c) {
				c = c || k.getElementTitle(d);
				if (d.is(":password")) {
					if (!k.isPassword(d.val())) return h.alert(h.getMessage(h.INVALID_PASSWORD, c), function () {
						k.focusOnInvalid(d)
					}),
					!1;
					if (!k.isMixPassword(d.val())) return h.alert(h.getMessage(h.INVALID_MIXPASSWORD, c), function () {
						k.focusOnInvalid(d)
					}),
					!1
				}
				return ! 0
			},
			isPassword: function (d) {
				return /^[a-z0-9_\-!@#$%\^,&\*\(\)\+\|\\\[\]\,\.~`\?]{8,16}$/i.test(d) ? !0 : !1
			},
			isMixPassword: function (d) {
				return /[a-z]/g.test(d) && /[0-9]/g.test(d) ? !0 : !1
			},
			checkUserId: function (d, c) {
				c = c || k.getElementTitle(d);
				return d.is(":text") && !k.isUserId(d.val()) ? (h.alert(h.getMessage(h.INVALID_USER_ID, c), function () {
					k.focusOnInvalid(d)
				}), !1) : !0
			},
			isUserId: function (d) {
				return /^[a-z][a-z0-9_]{5,15}$/i.test(d) ? !0 : !1
			},
			checkPhoneNum: function (d, c) {
				c = c || k.getElementTitle(d);
				return d.is(":text") && !k.isPhoneNum(d.val()) ? (h.alert(h.getMessage(h.INVALID_PHONE_NUM, c), function () {
					k.focusOnInvalid(d)
				}), !1) : !0
			},
			isDate: function (d) {
				return l.formatDateExpression(d) ? !0 : !1
			},
			checkDate: function (d, c) {
				c = c || k.getElementTitle(d);
				return d.is(":text") && !k.isDate(d.val()) ? (h.alert(h.getMessage(h.INVALID_DATE, c), function () {
					k.focusOnInvalid(d)
				}), !1) : !0
			},
			isPhoneNum: function (d) {
				return /^([\d]{2,4}-[\d]{3,4}-[\d]{4})*$/.test(d) ? !0 : !1
			},
			getElementTitle: function (d) {
				var c = a.trim(d.attr("title"));
				c || (d = d.attr("id")) && (d = a(document).find("label[for=" + d + "]")) && (c = a.trim(d.text()));
				return v.coalesce(c, "")
			}
		});
		return k
	} (),
	x = function k() {
		var d = Object.create(k.prototype);
		d.PROP_CACHED_VALUE = "__cachedValue";
		d.PROP_ORIGINAL_MAX_LENGTH = "__originalMaxLength";
		a.extend(k.prototype, {
			onFocus: function (c) {
				c = a(this);
				c.prop("readonly") || (c.is(n.SELECTOR_INPUT_DATE_PICKER) ? d.cacheValueOnFocus(c) : c.is(n.SELECTOR_INPUT_AMOUT) && d.parseAmountOnFocus(c));
				return ! 0
			},
			onBlur: function (c) {
				c = a(this);
				c.prop("readonly") || (n.forceToTrimmed(c), c.is(n.SELECTOR_INPUT_NUMBER) ? d.forceToNumber(c) : c.is(n.SELECTOR_INPUT_EN_NUM) ? d.forceToEnNum(c) : c.is(n.SELECTOR_INPUT_DATE_PICKER) ? d.formatDateOnBlur(c) : c.is(n.SELECTOR_INPUT_AMOUT) && d.formatAmountOnBlur(c));
				return ! 0
			},
			forceToNumber: function (c) {
				var e = c.val().replace(/\D/g, "");
				e !== c.val() && c.val(e)
			},
			forceToEnNum: function (c) {
				var e = c.val().replace(/[^a-z0-9]/gi, "");
				e !== c.val() && c.val(e)
			},
			cacheValueOnFocus: function (c) {
				c.prop(d.PROP_CACHED_VALUE, c.val())
			},
			formatDateOnBlur: function (c) {
				var e = c.prop(d.PROP_CACHED_VALUE);
				c.removeProp(d.PROP_CACHED_VALUE);
				try {
					c.val(l.formatDate(a.trim(c.val()), l.ONM_DEFAULT_DATE_PATTERN))
				} catch(k) {
					e ? c.val(e) : c.val("")
				}
				c.val() !== e && c.trigger("onSelect")
			},
			parseAmountOnFocus: function (c) {
				var e = l.parseNumber(c.val()),
				e = isNaN(e) ? "": "" + e;
				e !== c.val() && c.val(e);
				var e = c.prop(d.PROP_ORIGINAL_MAX_LENGTH),
				a = c.prop("maxLength"); ! e && a && 16 < a && (c.prop(d.PROP_ORIGINAL_MAX_LENGTH, a), c.prop("maxLength", 16))
			},
			formatAmountOnBlur: function (c) {
				var e = l.formatAmount(c.val());
				e !== c.val() && c.val(e);
				if (e = c.prop(d.PROP_ORIGINAL_MAX_LENGTH)) c.prop("maxLength", e),
				c.removeProp(d.PROP_ORIGINAL_MAX_LENGTH)
			}
		});
		return d
	} (),
	l = function d() {
		var c = Object.create(d.prototype);
		c.DEFAULT_DATE_DELIM = ".";
		c.DEFAULT_DATE_PATTERN = "yyyy-MM-dd";
		c.DEFAULT_DATETIME_PATTERN = "yyyy-MM-dd HH:mm:ss";
		c.HOST_DATE_PATTERN = "yyyyMMdd";
		c.ONM_DEFAULT_DATE_PATTERN = "yyyy-MM-dd";
		c.ONM_DEFAULT_DATETIME_PATTERN = "yyyy-MM-dd HH:mm:ss";
		c.cacheDatePatternInternal = {};
		a.extend(d.prototype, {
			parseDate: function (e) {
				try {
					if (e && e.getTime) return e;
					if ("string" === typeof e && e) {
						var d = a.trim(e);
						if ( - 1 < d.indexOf(c.DEFAULT_DATE_DELIM)) return a.datepicker.parseDate(c.getDatePatternInternal(c.DEFAULT_DATE_PATTERN), d);
						d = d.replace(/[^0-9]/g, "");
						return a.datepicker.parseDate(c.getDatePatternInternal(c.HOST_DATE_PATTERN), d.substr(0, 8))
					}
					return null
				} catch(u) {
					return null
				}
			},
			formatDate: function (e, d) {
				if (e && e.getTime) return a.datepicker.formatDate(c.getDatePatternInternal(d), e);
				var u = c.parseDate(e);
				return u ? a.datepicker.formatDate(c.getDatePatternInternal(d), u) : ""
			},
			formatTimeToDate: function (e, d) {
				if (e) {
					var a = e;
					a && !a.getTime && (a = new Date(c.parseInt(e)));
					var f = d || c.ONM_DEFAULT_DATETIME_PATTERN,
					f = f.replace("yyyy", a.getFullYear()),
					f = f.replace("MM", v.lpad(a.getMonth() + 1, 2, "0")),
					f = f.replace("dd", v.lpad(a.getDate(), 2, "0")),
					f = f.replace("HH", v.lpad(a.getHours(), 2, "0")),
					f = f.replace("mm", v.lpad(a.getMinutes(), 2, "0")),
					f = f.replace("sss", v.lpad(a.getMilliseconds(), 3, "0"));
					return f = f.replace("ss", v.lpad(a.getSeconds(), 2, "0"))
				}
			},
			getDatePatternInternal: function (e) {
				if ("string" !== typeof e || !e) return e;
				var d = c.cacheDatePatternInternal[e];
				d || (d = e.replace(/yy/g, "y").replace(/M/g, "m"), c.cacheDatePatternInternal[e] = d);
				return d
			},
			formatDateExpression: function (e) {
				return c.formatDate(e, c.ONM_DEFAULT_DATE_PATTERN)
			},
			formatDateHost: function (e) {
				return c.formatDate(e, c.HOST_DATE_PATTERN)
			},
			today: function () {
				return c.formatDate(new Date, c.HOST_DATE_PATTERN)
			},
			parseInt: function (c, d) {
				return parseInt(c, d || 10)
			},
			parseNumber: function (c) {
				if ("number" === typeof c) return c;
				var d = NaN;
				if (isNaN(c) || isNaN(d = parseFloat(c, 10))) c = a.trim("" + c).replace(/,/g, ""),
				!c || isNaN(c) || (d = parseFloat(c, 10));
				return d
			},
			formatAmount: function (d) {
				d = ("" + d).replace(/[^0-9\.\+\-]/g, "");
				d = c.parseNumber(d);
				var a, u, f, b, g;
				if (!isFinite(d)) return "";
				a = "" + d;
				if (0 <= a.indexOf("e") || 0 <= a.indexOf("E")) return "";
				d = 0 > d ? "-": "";
				a = a.replace(/^[\+\-]/, "").split(".");
				f = a[0];
				u = [];
				g = f.length;
				b = g % 3;
				for (0 < b && (u[0] = f.substr(0, b)); b < g; b += 3) u[u.length] = f.substr(b, 3);
				d += u;
				1 < a.length && (d += "." + a[1]);
				return d
			}
		});
		return c
	} (),
	y = function c() {
		var e = Object.create(c.prototype);
		e.YEAR = 1;
		e.MONTH = 2;
		e.WEEK_OF_YEAR = 3;
		e.WEEK_OF_MONTH = 4;
		e.DATE = 5;
		e.DAY_OF_MONTH = 5;
		e.DAY_OF_YEAR = 6;
		e.DAY_OF_WEEK = 7;
		e.JANUARY = 0;
		e.FEBRUARY = 1;
		e.MARCH = 2;
		e.APRIL = 3;
		e.MAY = 4;
		e.JUNE = 5;
		e.JULY = 6;
		e.AUGUST = 7;
		e.SEPTEMBER = 8;
		e.OCTOBER = 9;
		e.NOVEMBER = 10;
		e.DECEMBER = 11;
		e.SUNDAY = 0;
		e.MONDAY = 1;
		e.TUESDAY = 2;
		e.WEDNESDAY = 3;
		e.THURSDAY = 4;
		e.FRIDAY = 5;
		e.SATURDAY = 6;
		a.extend(c.prototype, {
			get: function (c, a) {
				var f, b, g;
				switch (a) {
				case e.YEAR:
					f = c.getFullYear();
					break;
				case e.MONTH:
					f = c.getMonth();
					break;
				case e.WEEK_OF_YEAR:
					b = new Date(c.getFullYear(), e.JANUARY, 1);
					f = (e.get(c, e.DAY_OF_YEAR) + b.getDay() - c.getDay() + e.SATURDAY) / 7;
					break;
				case e.WEEK_OF_MONTH:
					b = new Date(c.getFullYear(), c.getMonth(), 1);
					f = c.getDate() + b.getDay() - c.getDay() + e.SATURDAY;
					break;
				case e.DATE:
					f = c.getDate();
					break;
				case e.DAY_OF_YEAR:
					f = 0;
					for (g = e.FEBRUARY; g <= c.getMonth(); g++) b = new Date(c.getFullYear(), g, 0),
					f += b.getDate();
					f += c.getDate();
					break;
				case e.DAY_OF_WEEK:
					f = c.getDay();
					break;
				default:
					f = NaN
				}
				return f
			},
			add: function (c, a, f) {
				var b = new Date(c.getTime());
				2 == arguments.length && (f = arguments[1], a = e.DATE);
				switch (a) {
				case e.YEAR:
					b.setFullYear(b.getFullYear() + f);
					for (var g = b.getMonth(); g == b.getMonth() && b.getDate() < c.getDate();) b.setDate(b.getDate() - 1);
					break;
				case e.MONTH:
					b.setMonth(b.getMonth() + f);
					for (g = b.getMonth(); g == b.getMonth() && b.getDate() < c.getDate();) b.setDate(b.getDate() - 1);
					break;
				case e.WEEK_OF_YEAR:
				case e.WEEK_OF_MONTH:
					b.setDate(b.getDate() + 7 * f);
					break;
				case e.DATE:
				case e.DAY_OF_YEAR:
				case e.DAY_OF_WEEK:
					b.setDate(b.getDate() + f)
				}
				return b
			},
			diffDate: function (c, a) {
				var f = 0,
				b = e.compareTo(c, a),
				g,
				p,
				h,
				l;
				if (0 != b) {
					0 < b ? (g = new Date(c.getTime()), p = new Date(a.getTime())) : (g = new Date(a.getTime()), p = new Date(c.getTime()));
					h = p.getFullYear();
					f += e.get(g, e.DAY_OF_YEAR);
					for (l = g.getFullYear(); l > h; l--) g = e.add(g, e.YEAR, -1),
					f += e.getMaximum(g, e.DAY_OF_YEAR);
					f -= e.get(p, e.DAY_OF_YEAR);
					f *= b
				}
				return f
			},
			compareTo: function (c, a) {
				var e = 0,
				b = c.getFullYear(),
				g = a.getFullYear();
				b > g ? e = 1 : b < g ? e = -1 : (b = c.getMonth(), g = a.getMonth(), b > g ? e = 1 : b < g ? e = -1 : (b = c.getDate(), g = a.getDate(), b > g ? e = 1 : b < g && (e = -1)));
				return e
			},
			getMaximum: function (c, a) {
				var f, b;
				switch (a) {
				case e.MONTH:
					f = e.DECEMBER;
					break;
				case e.WEEK_OF_YEAR:
					b = e.getMaximum(c, e.DAY_OF_YEAR);
					f = new Date(c.getFullYear(), e.JANUARY, 1);
					b += f.getDay();
					f.setFullYear(c.getFullYear() + 1);
					f.setDate(0);
					b += e.SATURDAY - f.getDay();
					f = b / 7;
					break;
				case e.WEEK_OF_MONTH:
					b = e.getMaximum(c, e.DATE);
					f = new Date(c.getFullYear(), c.getMonth(), 1);
					b += f.getDay();
					f.setMonth(c.getMonth() + 1);
					f.setDate(0);
					b += e.SATURDAY - f.getDay();
					f = b / 7;
					break;
				case e.DATE:
					f = new Date(c.getFullYear(), c.getMonth() + 1, 0);
					f = f.getDate();
					break;
				case e.DAY_OF_YEAR:
					f = new Date(c.getFullYear(), e.MARCH, 0);
					f = 337 + f.getDate();
					break;
				case e.DAY_OF_WEEK:
					f = e.SATURDAY;
					break;
				default:
					f = NaN
				}
				return f
			},
			getBeforeWeek: function (c, a) {
				c = c ? l.parseInt(c) : 1;
				a = a || l.ONM_DEFAULT_DATE_PATTERN;
				var e = new Date;
				e.setDate(e.getDate() - 7 * c);
				return l.formatDate(e, a)
			},
			getBeforeMonth: function (c, a) {
				c = c ? l.parseInt(c) : 1;
				a = a || l.ONM_DEFAULT_DATE_PATTERN;
				var e = new Date;
				e.setMonth(e.getMonth() - c);
				return l.formatDate(e, a)
			}
		});
		return e
	} (),
	v = function e() {
		var h = Object.create(e.prototype);
		a.extend(e.prototype, {
			coalesce: function (a, e) {
				return a || 0 === a || !1 === a ? a: e
			},
			lpad: function (a, e, b) {
				var g = String(a),
				p = g.length,
				h = 0,
				l = p,
				n = "";
				if (3 > arguments.length || 0 == b.length) b = " ";
				for (h = b.length; l < e;) n = n.concat(b),
				l += h;
				return n.substr(0, e - p).concat(g.substr(0, e))
			},
			toCamelCase: function (a) {
				return a.replace(/(-|_)(.)/g, function (a, b, g) {
					return g.toUpperCase()
				})
			}
		});
		return h
	} (),
	h = function t() {
		var h = Object.create(t.prototype);
		h.MESSAGE_ID_UNKNOWN = "8999";
		h.MESSAGE_UNKNOWN = "\uc11c\ubc84 \uc624\ub958\uac00 \ubc1c\uc0dd\ud558\uc600\uc2b5\ub2c8\ub2e4";
		h.INVALID_REQUIRED_INPUT = "[{0}] \ud544\uc218 \uc785\ub825\ud56d\ubaa9\uc785\ub2c8\ub2e4";
		h.INVALID_REQUIRED_SELECT = "[{0}] \ud544\uc218 \uc120\ud0dd\ud56d\ubaa9\uc785\ub2c8\ub2e4";
		h.INVALID_REQUIRED_FILE = "\ucca8\ubd80\ud30c\uc77c\uc740 \ud544\uc218 \uc120\ud0dd\ud56d\ubaa9\uc785\ub2c8\ub2e4";
		h.INVALID_NUMBER = "[{0}] \ud56d\ubaa9\uc740 \uc22b\uc790\ub9cc \uc785\ub825\uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.INVALID_EN_NUM = "[{0}] \ud56d\ubaa9\uc740 \uc601\ubb38/\uc22b\uc790\ub9cc \uc785\ub825\uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.INVALID_PASSWORD = "[{0}] \ud56d\ubaa9\uc740 8~16\uc790\ub9ac \uc601\ubb38/\uc22b\uc790/\ud2b9\uc218\ubb38\uc790\ub9cc \uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.INVALID_MIXPASSWORD = "[{0}] \ud56d\ubaa9\uc740 \uc601\ubb38 \uc18c\ubb38\uc790\uc640 \uc22b\uc790\ub97c \uc870\ud569\ud574\uc57c\ud569\ub2c8\ub2e4";
		h.INVALID_USER_ID = "[{0}] \ud56d\ubaa9\uc740 \uc601\ubb38\uc73c\ub85c \uc2dc\uc791\ud558\ub294 6~16\uc790\ub9ac \uc601\ubb38/\uc22b\uc790/_(\uc5b8\ub354\uc2a4\ucf54\uc5b4)\ub9cc \uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.INVALID_PHONE_NUM = "[{0}] \ud56d\ubaa9\uc740 \uc804\ud654\ubc88\ud638 \ud3ec\ub9f7\uc758 \uc22b\uc790/-(\ud558\uc774\ud508)\ub9cc \uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.INVALID_DATE = "[{0}] \ud56d\ubaa9\uc740 \ub0a0\uc9dc \ud3ec\ub9f7\ub9cc \uac00\ub2a5\ud569\ub2c8\ub2e4";
		h.ALERT_DEFAULT_OPTIONS = {
			height: "auto",
			minHeight: 120,
			width: 380,
			modal: !0,
			duration: 100,
			btnText: "\ud655\uc778"
		};
		h.CONFIRM_DEFAULT_OPTIONS = {
			height: "auto",
			minHeight: 120,
			width: 380,
			modal: !0,
			duration: 100,
			btnConfirmText: "\ud655\uc778",
			btnCancelText: "\ucde8\uc18c"
		};
		a.extend(t.prototype, {
			alert: function (f, b) {
				var g;
				try {
					var p = {};
					if ("string" === typeof f) p.msg = f,
					b && a.isFunction(b) && (p.callback = b),
					h.alert(p);
					else if (b && a.isFunction(b)) a.extend(!0, f, {
						callback: b
					}),
					h.alert(f);
					else {
						a.extend(!0, p, h.ALERT_DEFAULT_OPTIONS, f);
						var q = p.close;
						p.close = function () {
							g.remove();
							q && a.isFunction(q) && q.apply(this)
						};
						p.msg && (p.msg = p.msg.replace(/\n/g, "<br />"));
						g = a("<div />", {
							"class": "default_dialog"
						}).append(a("<div />", {
							"class": "default_dialog_content",
							html: p.msg
						})).append(a("<div />", {
							"class": "default_dialog_buttons"
						}).append(a("<button />", {
							type: "button",
							id : "closeBtn",//lsj
							text: p.btnText,
							"class": "btn_page_rd"
						}).one("click", function () {
							g.dialog("close");
							p.callback && a.isFunction(p.callback) && p.callback.apply(this)
						}).prepend(a("<span />", {
							"class": "ico_apply"
						}))));
						window.self !== window.top && (a.extend(!0, p, {
							appendTo: a("body", top.document),
							position: {
								my: "center",
								at: "center",
								of: window.top
							}
						}), g.dialog(p));
						g.dialog(p)
					}
				} catch(l) {
					g && g.remove()
				}
			},
			defaultAlert: function (f, b) {
				window.alert(f);
				b && a.isFunction(b) && b()
			},
			confirm: function (f, b, g) {
				var p;
				try {
					var q = {};
					if ("string" === typeof f) q.msg = f,
					b && a.isFunction(b) && (q.confirm = b),
					g && a.isFunction(g) && (q.cancel = g),
					h.confirm(q);
					else if (b && a.isFunction(b)) a.extend(!0, f, {
						confirm: b
					}),
					h.confirm(f);
					else if (g && a.isFunction(g)) a.extend(!0, f, {
						cancel: g
					}),
					h.confirm(f);
					else {
						a.extend(!0, q, h.CONFIRM_DEFAULT_OPTIONS, f);
						var l = q.close;
						q.close = function () {
							p.remove();
							l && a.isFunction(l) && l.apply(this)
						};
						q.msg && (q.msg = q.msg.replace(/\n/g, "<br />"));
						p = a("<div />", {
							"class": "default_dialog"
						}).append(a("<div />", {
							"class": "default_dialog_content",
							html: q.msg
						})).append(a("<div />", {
							"class": "default_dialog_buttons"
						}).append(a("<button />", {
							type: "button",
							"class": "btn_page_rd ",
							text: q.btnConfirmText
						}).one("click", function () {
							p.dialog("close");
							q.confirm && a.isFunction(q.confirm) && q.confirm.apply(this)
						}).prepend($('<span>', {
							"class": "ico_apply"
						}))).append(a("<button />", {
							type: "button",
							"class": "btn_page_rd ",
							text: q.btnCancelText
						}).one("click", function () {
							p.dialog("close");
							q.cancel && a.isFunction(q.cancel) && q.cancel.apply(this)
						}).prepend($('<span>', {
							"class": "ico_cancle"
						}))));
						p.appendTo("body").dialog(q)
					}
				} catch(n) {
					p && p.remove()
				}
			},
			alertError: function (a, b) {
				a = a || {};
				//h.alert(" [" + (a.responseCode ? a.responseCode: h.MESSAGE_ID_UNKNOWN) + "]\n" + (a.responseMessage ? a.responseMessage: h.MESSAGE_UNKNOWN), b)
			},
			getMessage: function (a, b) {
				return a.replace(/\{0\}/g, b)
			}
		});
		return h
	} (),
	z = function u() {
		var f = Object.create(u.prototype);
		f.PARAM_PATTERN = new RegExp(/^(.*)=(.*)$/);
		a.extend(u.prototype, {
			parseParam: function (b, a) {
				a = a || {};
				if (b) for (var h = b.replace(/^\?/, "").split("&"), q, l = 0, n = h.length; l < n; l++)(q = f.PARAM_PATTERN.exec(h[l])) && 3 === q.length && (q[2] ? a[q[1]] = q[2] : delete a[q[1]]);
				return a
			},
			paramUpdate: function (b, a) {
				"string" === typeof b && (b = f.parseParam(b));
				var h = b || {};
				a && f.parseParam(a, h);
				return h
			},
			paramUpdateToString: function (b, a) {
				return f.paramToString(f.paramUpdate(b, a))
			},
			paramToString: function (b, g) {
				var f = "";
				g = g || "&amp;";
				return "object" === typeof b && (a.each(b, function (b, a) {
					f += b + "=" + a + g
				}), f) ? f.replace(new RegExp(g + "$", "gi"), "") : f
			},
			encode: function (b) {
				return encodeURIComponent(b)
			},
			decode: function (b) {
				return decodeURIComponent(b)
			}
		});
		return f
	} (),
	B = function f() {
		var b = Object.create(f.prototype);
		b.TIMER_VIEWER;
		b.TIMER_IS_APPLY;
		b.SESSION_TIMEOUT;
		b.SESSION_TIMEOUT_MANUAL;
		b.TIMER_INTERVAL_OBJ;
		b.TIMER_TOTAL_SECONDS;
		b.TIMER_MINUTES;
		b.TIMER_SECONDS;
		b.TIMER_COUNT = 0;
		a.extend(f.prototype, {
			setTimer: function (a, f, h, n) {
				a && (b.TIMER_VIEWER = a, b.TIMER_IS_APPLY = f, b.SESSION_TIMEOUT = l.parseInt(h), b.SESSION_TIMEOUT_MANUAL = n, b.TIMER_TOTAL_SECONDS = 60 * b.SESSION_TIMEOUT, b.TIMER_MINUTES = b.SESSION_TIMEOUT, b.TIMER_SECONDS = 0, b.startTimer(), b.timerManual())
			},
			resetTimer: function () {
				b.TIMER_COUNT = 0
			},
			timerManual: function () {
				if ("Y" === b.SESSION_TIMEOUT_MANUAL) b.TIMER_VIEWER.on("dblclick", function () {
					b.TIMER_IS_APPLY ? (clearInterval(b.TIMER_INTERVAL_OBJ), r.ajax({
						url: _contextPath_ + "/cmn/timer/modeChange.json",
						data: {
							mode: "manual"
						},
						success: function (a) {
							b.TIMER_IS_APPLY = !1;
							b.timerPrint()
						}
					})) : onm.ajax({
						url: _contextPath_ + "/cmn/timer/modeChange.json",
						success: function (a) {
							b.resetTimer();
							b.TIMER_IS_APPLY = !0;
							b.startTimer()
						}
					})
				})
			},
			timerPrint: function () {
				if (b.TIMER_IS_APPLY) {
					var a = b.TIMER_TOTAL_SECONDS - b.TIMER_COUNT;
					b.TIMER_VIEWER.text(l.parseInt(a / 60) + ":" + v.lpad(a, 2, "0"))
				} else b.TIMER_VIEWER.text("Timeout Manual")
			},
			startTimer: function () {
				b.timerPrint();
				b.TIMER_IS_APPLY && (b.TIMER_INTERVAL_OBJ = setInterval(function () {
					b.timerProcess()
				},
				1E3))
			},
			timerProcess: function () {
				b.timerPrint();
				b.TIMER_COUNT >= b.TIMER_TOTAL_SECONDS && (clearInterval(b.TIMER_INTERVAL_OBJ), location.href = _pssoLogoutUrl_);
				b.TIMER_COUNT++
			}
		});
		return b
	} (),
	A = function b() {
		var g = Object.create(b.prototype);
		g.DEFAULT_SETTINGS = {
			target: "#layout_content",
			titleText: "&nbsp;"
		};
		g.SETTINGS = {};
		g.AJAX_DEFAULT_OPTIONS = {
			success: function (b) {
				g.SETTINGS.detailViewContent$.empty().append(b);
				b = g.SETTINGS.detailViewContent$.find("h1");
				b.length && (b.remove(), g.SETTINGS.detailViewTitle$.find("h4").text(b.text()));
				r.initializeForm(g.SETTINGS.detailViewContent$.find("form"));
				g.resize()
			}
		};
		a.extend(b.prototype, {
			initialize: function (b) {
				a.extend(!0, g.SETTINGS, g.DEFAULT_SETTINGS, b || {});
				g.SETTINGS.target$ = a(g.SETTINGS.target);
				g.SETTINGS.detailView$ || (g.SETTINGS.detailView$ = a("<div />", {
					"class": "detail_view"
				}));
				g.SETTINGS.detailViewInner$ = a("<div />", {
					"class": "detail_view_inner"
				}).appendTo(g.SETTINGS.detailView$);
				g.SETTINGS.detailViewTitle$ = a("<div />", {
					"class": "detail_view_title"
				}).append(a("<h4 />", {
					html: g.SETTINGS.titleText
				})).appendTo(g.SETTINGS.detailViewInner$);
				g.SETTINGS.detailViewControl$ = a("<div />", {
					"class": "detail_view_control open"
				}).appendTo(g.SETTINGS.detailViewTitle$);
				g.SETTINGS.detailViewContentWrap$ = a("<div />", {
					"class": "detail_view_content_wrap"
				}).appendTo(g.SETTINGS.detailViewInner$);
				g.SETTINGS.detailViewContent$ = a("<div />", {
					"class": "detail_view_content"
				}).appendTo(g.SETTINGS.detailViewContentWrap$);
				g.SETTINGS.target$.append(g.SETTINGS.detailView$);
				g.SETTINGS.detailViewTitleHeight = g.SETTINGS.detailViewTitle$.outerHeight()
			},
			view: function (b) {
				var h = {};
				a.extend(!0, h, g.AJAX_DEFAULT_OPTIONS, b);
				a.isFunction(b.success) && (h.success = function (a, h, l) {
					g.AJAX_DEFAULT_OPTIONS.success.apply(this, [a, h, l]);
					b.success.apply(this, [a, h, l])
				});
				a.isFunction(b.error) && (h.error = function (a, h, l) {
					g.AJAX_DEFAULT_OPTIONS.error.apply(this, [a, h, l]);
					b.error.apply(this, [a, h, l])
				});
				a.isFunction(b.callback) && (g.SETTINGS.callback = b.callback);
				r.ajaxHtml(h)
			},
			close: function () {
				g.SETTINGS.detailViewControl$.hasClass("close") && (g.SETTINGS.detailViewContentWrap$.css({
					height: 0
				}), g.SETTINGS.detailViewInner$.stop().animate({
					top: 0,
					height: g.SETTINGS.detailViewTitleHeight,
					queue: !1
				},
				{
					duration: 200,
					complete: function () {
						g.SETTINGS.detailViewTitle$.off("click");
						g.SETTINGS.detailViewControl$.add(g.SETTINGS.detailViewTitle$).removeClass("close").addClass("open");
						g.SETTINGS.detailViewContent$.empty()
					}
				}))
			},
			callback: function (b) {
				g.SETTINGS.callback && a.isFunction(g.SETTINGS.callback) && g.SETTINGS.callback.apply(this, b)
			},
			resize: function () {
				var b = g.SETTINGS.detailViewContent$.prop("scrollHeight"),
				a = g.SETTINGS.target$.outerHeight() / 2;
				b + g.SETTINGS.detailViewTitleHeight > a && (b = a - g.SETTINGS.detailViewTitleHeight);
				g.SETTINGS.detailViewContentWrap$.css({
					height: b
				});
				g.SETTINGS.detailViewInner$.stop().animate({
					top: -b,
					height: b + g.SETTINGS.detailViewTitleHeight,
					queue: !1
				},
				{
					duration: 200,
					complete: function () {
						g.SETTINGS.detailViewControl$.hasClass("open") && (g.SETTINGS.detailViewControl$.add(g.SETTINGS.detailViewTitle$).removeClass("open").addClass("close"), g.SETTINGS.detailViewTitle$.on("click", function () {
							g.close()
						}))
					}
				})
			}
		});
		return g
	} ();
	a.fn.extend({
		ajax: function (b) {
			if (!this.is("form")) throw Error('This object is not support "ajax" function.');
			r.ajaxSubmit(this, b)
		},
		serializeJson: function () {
			var b = {},
			g = a(this).serializeArray();
			a.each(g, function (a, g) {
				b[g.name] = g.value
			});
			return b
		}
	});
	a.extend(!0, window, {
		onm: {
			ajax: function (b) {
				r.ajax(b)
			},
			ajaxHtml: function (b) {
				r.ajaxHtml(b)
			},
			ajaxPopup: function (b) {
				r.ajaxPopup(b)
			},
			ajaxModal: function (b) {
				a.extend(!0, b, {
					dialogOptions: {
						modal: !0
					}
				});
				r.ajaxPopup(b)
			},
			goUrl: function (b, a, h) {
				return w.goUrl(b, a, h)
			},
			parseDate: function (b) {
				return l.parseDate(b)
			},
			formatDate: function (b, a) {
				return a ? l.formatDate(b, a) : l.formatDateExpression(b)
			},
			parseNumber: function (b) {
				return l.parseNumber(b)
			},
			today: function () {
				return l.today()
			},
			todayFmt: function () {
				return l.formatDate(new Date, l.ONM_DEFAULT_DATE_PATTERN)
			},
			initializeForm: function (b) {
				r.initializeForm(b)
			},
			initializeElement: function (b) {
				n.bindValidationRulesToElement(b.get(0))
			},
			checkRequired: function (b, a) {
				return n.checkRequired(b, a)
			},
			checkRequiredNum: function (b, a) {
				return n.checkRequiredNum(b, a)
			},
			checkRequiredFile: function (b, a) {
				return n.checkRequiredFile(b, a)
			},
			isEmail: function (b) {
				return n.isEmail(b)
			},
			checkNumber: function (b, a) {
				return n.checkNumber(b, a)
			},
			isNumber: function (b) {
				return n.isNumber(b)
			},
			checkEnNum: function (b, a) {
				return n.checkEnNum(b, a)
			},
			isEnNum: function (b) {
				return n.isEnNum(b)
			},
			checkPassword: function (b, a) {
				return n.checkPassword(b, a)
			},
			isPassword: function (b) {
				return n.isPassword(b)
			},
			checkUserId: function (b, a) {
				return n.checkUserId(b, a)
			},
			isUserId: function (b) {
				return n.isUserId(b)
			},
			checkPhoneNum: function (b, a) {
				return n.checkPhoneNum(b, a)
			},
			isPhoneNum: function (b) {
				return n.isPhoneNum(b)
			},
			isDate: function (b) {
				return n.isDate(b)
			},
			checkDate: function (b, a) {
				return n.checkDate(b, a)
			},
			formatAmount: function (b) {
				return l.formatAmount(b)
			},
			addDate: function (b, a) {
				var h = y.add(l.parseDate(b), y.DATE, a);
				return b.getTime ? h: -1 < b.indexOf(l.DEFAULT_DATE_DELIM) ? l.formatDateExpression(h) : l.formatDateHost(h)
			},
			diffDate: function (b, a) {
				return y.diffDate(l.parseDate(b), l.parseDate(a))
			},
			diffMonth: function(b, a) {
				b = l.parseDate(b);
				a = l.parseDate(a);
				var months;
				months = (b.getFullYear() - a.getFullYear()) * 12;
				months -= a.getMonth() + 1;
				months += b.getMonth() + 1;
				return months;
			},
			parseParam: function (b, a) {
				return z.parseParam(b, a)
			},
			paramUpdate: function (b, a) {
				return z.paramUpdate(b, a)
			},
			encode: function (b) {
				return z.encode(b)
			},
			decode: function (b) {
				return z.decode(b)
			},
			dialog: function (b) {
				return r.DIALOG_LIST[b]
			},
			toCamelCase: function (b) {
				return v.toCamelCase(b)
			},
			print: function (b) {
				w.print(b)
			},
			rexpertOpen: function (b, a) {
				rexpertOpen(b, a)
			},
			alert: function (b, a) {
				h.alert(b, a)
			},
			confirm: function (b, a, l) {
				h.confirm(b, a, l)
			},
			confirm2: function (b, a, l) {
				h.confirm({
					title: '알림',
					msg: b,
					btnConfirmText: '예',
					btnCancelText: '아니오',
					confirm: a,
					cancel: l,
					open: function () {
						var div$ = $(this).find('.default_dialog_buttons');
						div$.css({'text-align':'center'});
						div$.find('button').each(function(index) {
							if (index === 1) {
								$(this).css({'cssText': 'margin-left: 15px !important;'});
							}
							$(this).width(80);
						});
					}
				})
			},
			parseInt: function (b, a) {
				return l.parseInt(b, a)
			},
			lpad: function (b, a, h) {
				return v.lpad(b, a, h)
			},
			startsWith: function (b, a) {
				return w.startsWith(b, a)
			},
			formatTimeToDate: function (b, a) {
				return l.formatTimeToDate(b, a)
			},
			setTimer: function (b, a, h, l) {
				B.setTimer(b, a, h, l)
			},
			resetTimer: function () {
				B.resetTimer()
			},
			getBeforeWeek: function (b, a) {
				return y.getBeforeWeek(b, a)
			},
			getBeforeMonth: function (b, a) {
				return y.getBeforeMonth(b, a)
			},
			detailInit: function (a) {
				A.initialize(a)
			},
			detailView: function (a) {
				A.view(a)
			},
			detailClose: function () {
				A.close()
			},
			detailCallback: function () {
				A.callback(arguments)
			},
			detailResize: function () {
				A.resize()
			},
			alertError: function (a, g) {
				h.alertError(a, g)
			},
			getContextPath: function () {
				return _contextPath_
			},
			paramUpdateToString: function (a, g) {
				return z.paramUpdateToString(a, g)
			},
			createLoadingBar: function () {
				return r.createLoadingBar()
			},
			errorHandle: function (a, g, h, l) {
				r.errorHandle(a, g, h, l)
			},
			showLoadingBar: function () {
				r.showLoadingBar()
			},
			hideLoadingBar: function () {
				r.hideLoadingBar()
			},
			nvl: function (str, defaultStr) {
				if (str === null || str === undefined) {
					if (defaultStr === null || defaultStr === undefined) {
						return '';
					} else {
						return defaultStr;
					}
				} else {
					return str;
				}
			},
			isWhitespace: function (ch) {
				//           \t,   \n,   \v,   \f,   \r
				var arr = [0x09, 0x0a, 0x0b, 0x0c, 0x0d];
				return arr.indexOf(String(ch).charCodeAt(0)) > -1;
			},
			strip: function (str, stripChars) {
				if (str === null || str === undefined || str.length === 0) {
					return str;
				} else {
					str = onm.stripStart(str, stripChars);
					return onm.stripEnd(str, stripChars);
				}
			},
			stripStart: function (str, stripChars) {
				var strLen;
				if (str !== null && str !== undefined && (strLen = str.length) !== 0) {
					var start = 0;
					if (stripChars === null || stripChars === undefined) {
						while (start = strLen && a.isWhitespace(str.charAt(start))) {
							++start;
						}
					} else {
						if (stripChars.length === 0) return str;

						while (start !== strLen && stripChars.indexOf(str.charAt(start)) !== -1) {
							++start;
						}
					}
					return str.substring(start);
				} else {
					return str;
				}
			},
			stripEnd: function (str, stripChars) {
				var end;
				if (str !== null && str !== undefined && (end = str.length) !== 0) {
					if (stripChars === null || stripChars === undefined) {
						while (end !== 0 && a.isWhitespace(str.charAt(end - 1))) {
							--end;
						}
					} else {
						if (stripChars.length === 0) return str;

						while (end !== 0 && stripChars.indexOf(str.charAt(end - 1)) !== -1) {
							--end;
						}

						return str.substring(0, end);
					}
				} else {
					return str;
				}
			},
			stripList: function (items, keys, stripChars) {
				$.each(items, function (i, item) {
					$.each(keys, function (j, key) {
						var val = item[key];
						if (val == stripChars) {
							return true;
						}
						if ($.type(val) === 'number') {
							item[key] = Number(onm.stripStart(String(val), stripChars))
						} else {
							item[key] = onm.stripStart(val, stripChars);
						}
					});
				});
			},
			checkValidity: function (el) {
				if (el.willValidate) {
					var valid = el.checkValidity();
					if (!valid) {
						el.reportValidity();
					}
					return valid;
				}
			}
		}
	})
})(jQuery);
jQuery(function (a) {
//	onm.initializeForm();
	a(window).bind("resize", function () {
		a(".ui-jqgrid").each(function () {
			var that = this;
			a(this).find(".ui-jqgrid-btable").each(function(){

				if (a(this).parent().hasClass('frozen-bdiv')) {
					return true;
				}

				var shrink = false;

				if (a(this).getGridParam('shrinkToFit') === true) {
					shrink = true;
				}

				var C = a(that).parent().width() - 18;
				a(this).setGridWidth(C, shrink);

				var groupHeader = a(this).getGridParam('groupHeader');
				if (groupHeader) {
					a(this).destroyGroupHeader(false);
					a(this).setGroupHeaders(groupHeader);
				}
			});

		})
	}).trigger("resize");
//	a(window).on("contextmenu selectstart", function (a) {
//		return ! 1
//	})

	if ($.jgrid) {
		$.extend($.jgrid.formatter, {
			integer: {
				thousandsSeparator: ",", defaultValue: "-"
			},
			number: {
				decimalSeparator: ".", thousandsSeparator: "", decimalPlaces: 1, defaultValue: "-"
			}
		});
	}


	if (window.Highcharts !== undefined) {
		Highcharts.setOptions({
			global: {
				useUTC: false
			},
			lang: {
				thousandsSep: ',',
				months: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
				shortMonths: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
				weekdays: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
				numericSymbols:['천', '백만', 'G', 'T', 'P', 'E']//G:Billion, T:Trillion, P:Quadrillion, E:Quintillion
			},
			tooltip: {
				dateTimeLabelFormats: {
					millisecond: '%b-%e %A %H:%M:%S.%L',
					second: '%b-%e %A %H:%M:%S',
					minute: '%b-%e %A %H:%M',
					hour: '%b-%e %A %H:%M',
					day: '%Y-%b-%e %A',
					week: '%Y-%b-%e %A',
					month: '%Y-%B',
					year: '%Y'
				}
			},
			title: {
				text: undefined
			},
			yAxis: {
				title: {
					text: undefined
				}
			},
			plotOptions: {
				series: {
					lineWidth: 1,
					marker: {
						enabled: false
					},
					states: {
						hover: {
							enabled: false
						}
					}
				}
			},
			exporting: {
				enabled: false
			},
			credits: {
				enabled: false
			}
		});
	}

});