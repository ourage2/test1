(function($, undefined) {
"use strict";
jQuery.extend(jQuery.fn.fmatter, {
	method:{
		getLinkData:function(cellvalue, opt, rowdata, options) {
			var url = opt.url || '';
			if(url && onm.startsWith(url, '/')) {
				url = onm.getContextPath() + url;
			}
			var paramObj = {};
			if(opt.addParam) {
				if(typeof opt.addParam === 'string') {
					paramObj = onm.parseParam(opt.addParam, paramObj);
				} else if(typeof opt.addParam === 'object') {
					$.extend(paramObj, opt.addParam);
				}
			}
			if(opt.dataParam) {
				$.each(opt.dataParam, function(k, v) {
					paramObj[v] = rowdata[k];
				});
			}
			opt.idName = opt.idName || 'id';
			if(opt.idName) {
				paramObj[opt.idName] = cellvalue;
			}
			var param = onm.paramUpdateToString(paramObj);
			if(param) {
				param = '?' + param;
			}
			var attr = '';
			if(opt.rowId) {
				attr += ' row-id="' + options.rowId + '"';
			}
			if(opt.attr) {
				$.each(opt.attr, function(k, v) {
					attr += ' data-' + k + '="' + (v||'') + '"';
				});
			}
			var dataAttr = '';
			if(opt.dataAttr) {
				$.each(opt.dataAttr, function(k, v) {
					dataAttr += ' data-' + k + '="' + rowdata[v] + '"';
				});
			}
			return {'url':url, 'param':param, 'attr':attr, 'dataAttr':dataAttr};
		}
	},
	link:function(cellvalue, options, rowdata) {
		if(!cellvalue) {
			return '-';
		}
		var opt = options.colModel.formatoptions || {};
		if(opt.validFunc && $.isFunction(opt.validFunc)) {
			if(!opt.validFunc.apply(this, [cellvalue, rowdata])) {
				return cellvalue;
			}
		}
		var linkData = $.fn.fmatter.method.getLinkData(cellvalue, opt, rowdata, options);
		var ignoreLink = [];
		if(opt.ignoreLink) {
			if(typeof opt.ignoreLink === 'string') {
				ignoreLink.push(opt.ignoreLink);
			} else if(typeof opt.ignoreLink === 'object') {
				ignoreLink = opt.ignoreLink;
			}
			if($.inArray(cellvalue, ignoreLink) > -1) {
				return cellvalue;
			}
		}
		if(true === opt.amount) {
			cellvalue = onm.formatAmount(cellvalue);
		}
		return '<a href="' + linkData.url + linkData.param + '"' + linkData.attr + linkData.dataAttr + '>'+cellvalue+'</a>';
	},
	button:function(cellvalue, options, rowdata) {
		var opt = options.colModel.formatoptions || {};
		var linkData = $.fn.fmatter.method.getLinkData(cellvalue, opt, rowdata, options);
		var btnType = opt.btnType || 'button';
		var btnText = opt.btnText || (cellvalue || '확인');
		var btnIconClass = opt.btnIconClass;
		var btnSize = opt.btnSize || 'medium';
		var btnClass = 'btn_pack';
		var disabledStr = '';
		if(opt.validFunc && $.isFunction(opt.validFunc)) {
			if(!opt.validFunc.apply(this, [cellvalue, rowdata])) {
				btnClass = 'btn_pack_disable';
				disabledStr = ' disabled="disabled"';
			}
		}
		if(opt.enableBtn) {
			var enableBtn = [];
			if(typeof opt.enableBtn === 'string') {
				enableBtn.push(opt.enableBtn);
			} else if(typeof opt.enableBtn === 'object') {
				enableBtn = opt.enableBtn;
			}
			if($.inArray(cellvalue, enableBtn) < 0) {
				btnClass = 'btn_pack_disable';
				disabledStr = ' disabled="disabled"';
			}
		} else if(opt.disableBtn) {
			var disableBtn = [];
			if(opt.disableBtn) {
				if(typeof opt.disableBtn === 'string') {
					disableBtn.push(opt.disableBtn);
				} else if(typeof opt.disableBtn === 'object') {
					disableBtn = opt.disableBtn;
				}
				if($.inArray(cellvalue, disableBtn) > -1) {
					btnClass = 'btn_pack_disable';
					disabledStr = ' disabled="disabled"';
				}
			}
		}
		var btn = '<span class="' + btnClass + ' ' + btnSize;
		if(btnIconClass) {
			btn += ' icon"><span class="' + btnIconClass + '"></span>';
		} else {
			btn += '">';
		}
		if(btnType === 'link') {
			btn += '<a href="' + linkData.url + linkData.param + '"' + linkData.attr + linkData.dataAttr + '>'+btnText+'</a>';
		} else {
			btn += '<button type="button"' + linkData.attr + linkData.dataAttr + disabledStr + '>'+btnText+'</button>';
		}
		return btn;
	},
	datetime:function(cellvalue, options, rowdata) {
		return onm.formatTimeToDate(cellvalue, 'yyyy-MM-dd HH:mm:ss') || '';
	},
	dateday:function(cellvalue, options, rowdata) {
		return onm.formatTimeToDate(cellvalue, 'yyyy-MM-dd') || '';
	},
	amount:function(cellvalue, options, rowdata) {
		return onm.formatAmount(cellvalue) || '';
	},
//	hp: function(cellVal) {
//		if (cellVal) {
//			if (cellVal.substring(3, 4) == '0') cellVal = cellVal.substring(0, 3) + cellVal.substring(4, cellVal.length);
//			return naw.valMask(cellVal, 'mobile');
//		}
//		return '';
//	},
	tel: function(cellVal) {
		var isHp = false;
		if (cellVal) {
			if (cellVal.substring(0, 2) == '01' || cellVal.substring(0, 2) == '11') {
				isHp = true;
			}
			if (cellVal.substring(0, 2) != '02' && cellVal.substring(0, 3) != '002' && cellVal.substring(3, 4) == '0') {
				cellVal = cellVal.substring(0, 3) + cellVal.substring(4, cellVal.length);
			}
			if (cellVal.substring(0, 2) == '02' && cellVal.substring(2, 3) == '0') {
				cellVal = cellVal.substring(0, 2) + cellVal.substring(3, cellVal.length);
			}
			if (cellVal.substring(0, 3) == '002' && cellVal.substring(3, 4) == '0') {
				cellVal = cellVal.substring(1, 3) + cellVal.substring(4, cellVal.length);
			}
			if (cellVal.substring(0, 3) == '002') {
				cellVal = cellVal.substring(1, 2) + cellVal.substring(2, cellVal.length);
			}

			if (isHp) {
				return naw.valMask(cellVal, 'mobile');
			} else {
				return naw.valMask(cellVal, 'tel');
			}
		}
		return '';
	},
	center: function(cellVal, options, rowdata) {
		var rtnStr = '';
		var colNm = (options.colModel.name).replaceAll('Nm', 'Cd');
//		console.log(colNm);
		var val = rowdata[colNm];
		if (typeof val === 'string') {
			for (var idx = 0; idx < val.split(',').length; idx++) {
				rtnStr += com.getCenter(val.split(',')[idx]) + ',';
			}
			if (val.split(',').length > 0) {
				rtnStr = rtnStr.substring(0, rtnStr.length - 1);
			}
		}
		return rtnStr;
	},
//	restCnt: function(cellVal, options, rowdata) {
//		var rtnCnt = 0;
//		for (var idx = 1; idx <= 31; idx++) {
//			if (rowdata['day' + idx] != 'N') {
//				rtnCnt++;
//			}
//		}
//		return rtnCnt;
//	},
	restCd: function(cellVal, options, rowdata) {
		var rtnStr = '';
		var cdObj = com.getCd('REST_CD',  rowdata[options.colModel.name]);
		if (cdObj.cd == 'N') {
			rtnStr = '-';
		} else {
			rtnStr = cdObj.cdNm;
		}
		return rtnStr;
	}
});

$.extend($.jgrid.defaults, {
	autowidth:true,
	autoload:false,
	sortable:true,
	mtype:'POST',
	height:'auto',
	datatype:'json',
	multiSort:true,
//	rowNum:1000000,
	rowNum:50000,
	prmNames:{
		page:'pg',
		sort:'sortColumn',
		order:'sortOrder'
	},
	pager:'#pager',
	jsonReader:{
		root:'list',
		page:'paginate.pg',
		total:'paginate.totalPages',
		records:'paginate.totalRecords',
		repeatItems:false
	},
	beforeSelectRow:function(rowid, e) { //rowid 미존재시 선택이 안되게
		if (rowid) {
			return true;
		} else {
			return false;
		}
	},
	beforeRequest:function() {
		var gridParam = $(this).getGridParam();
		if(!gridParam.pagerCenter$) {
			var pager$ = $(gridParam.pager);
			var pagerId = pager$.attr('id');
			gridParam.pagerCenter$ = pager$.find('#'+pagerId+'_center');
			gridParam.pagerRight$ = pager$.find('#'+pagerId+'_right');
		}
		gridParam.pagerCenter$.add(gridParam.pagerRight$).empty();
		if(!gridParam.autoload) {
			gridParam.autoload = true;
			$('#load_'+gridParam.id).html(onm.createLoadingBar().css({display:'block'})[0].outerHTML);
			return false;
		}
		if(gridParam.paging) {
			gridParam.page = 1;
			delete gridParam.paging;
		}
	},
	beforeProcessing:function(data) {
		var grid$ = $(this);
		var gridParam = grid$.getGridParam();
		if(data) {
			var rowNum = 0;
			if(data.paginate) {
				rowNum = data.paginate.totalRecords;
			} else if(data[gridParam.jsonReader.root]) {
				rowNum = data[gridParam.jsonReader.root].length;
			}
			grid$.setGridParam({
				'rowNum':rowNum
			});
		}
	},
	loadComplete:function(data) {
		try {
			onm.resetTimer();
			var grid$ = $(this);
			var gridParam = grid$.getGridParam() || {};
			var list;
			if(gridParam.datatype === 'local') {
				list = gridParam.data;
			} else {
				list = data[gridParam.jsonReader.root];
			}
			gridParam.gridData = list;
			var paginate = data.paginate;
			if(paginate && (list && list.length)) {
				if(gridParam.pager) {
					var pager$ = $(gridParam.pager);
					var pagerId = pager$.attr('id');
					var pagerCenter$ = gridParam.pagerCenter$;
					if(paginate.totalRecords > 0) {
						var row = '<div class="paginate">';
						if(paginate.currBlock > 1) {
							row += '<a href="#" class="paginate_item paginate_first" data-page="1"></a>';
							row += '<a href="#" class="paginate_item paginate_prev" data-page="'+paginate.prevPage+'"></a>';
						} else {
							row += '<span class="paginate_first"></span>';
							row += '<span class="paginate_prev"></span>';
						}
						for(var i=paginate.startPage; i<=paginate.endPage; i++) {
							if(i===paginate.currPage) {
								row += '<strong>'+i+'</strong><input type="hidden" id="' + grid$.attr('id') + '_pg" value="' + i +'" />';
							}else{
								row += '<a href="#" class="paginate_item" data-page="'+i+'">'+i+'</a>';
							}
						}
						if(paginate.currBlock < paginate.totalBlock) {
							row += '<a href="#" class="paginate_item paginate_next" data-page="'+paginate.nextPage+'"></a>';
							row += '<a href="#" class="paginate_item paginate_last" data-page="'+paginate.totalPages+'"></a>';
						} else {
							row += '<span class="paginate_next"></span>';
							row += '<span class="paginate_last"></span>';
						}
						row += '</div>';
						pagerCenter$.css('width', 'auto');
						pagerCenter$.append(row);

//						var nowGridId = $(this).getGridParam('id');
						$(document).one('click', '#'+pagerId+'_center .paginate_item', function(e) {
							e.preventDefault();
							if (typeof view1$ !== 'undefined' && !grid$.getGridParam('id').endsWith('p')) {
								com.init(view1$, true);
							}
							var goPage = $(this).attr('data-page');
							grid$.setGridParam({page:goPage, paging:true}).trigger('reloadGrid');
						});
						/*
						$(document).off('click', '#'+pagerId+'_center .paginate_item').on('click', '#'+pagerId+'_center .paginate_item', function(e) {
							e.preventDefault();
							var goPage = $(this).attr('data-page');
							grid$.setGridParam({page:goPage}).trigger('reloadGrid');
						});
						*/

					} else {
						$(grid$[0]).find('tbody').append('<tr class="ui-widget-content jqgrow"><td colspan="'+gridParam.colModel.length+'" role="gridcell" style="text-align:center;">'+gridParam.emptyrecords+'</td></tr>');
					}
					gridParam.pagerRight$.text('총 ' + paginate.totalRecords + '건').addClass('fr');
				}
			} else {
				if (grid$.getGridParam('reccount') == 0) {
					grid$.find('tbody').append('<tr class="ui-widget-content jqgrow"><td colspan="'+gridParam.colModel.length+'" role="gridcell" style="text-align:center;">'+gridParam.emptyrecords+'</td></tr>');
				} else {
					//페이징 쿼리를 하지 않은 그리드의 총 카운트 표시
//					console.log($('#' + $(this).getGridParam('id')).getGridData().length);
//					console.log(grid$.getGridParam('reccount'));
					gridParam.pagerRight$.text('총 ' + grid$.getGridParam('reccount') + '건').addClass('fr');
				}
			}
			if(gridParam.complete && $.isFunction(gridParam.complete)) {
				gridParam.complete(data);
			}

			grid$.syncFrozenColsHeight();

		} catch (e) {
			console.log(e);
//			onm.alert('grid loadComplete error');
			alert("세션이 만료되었습니다."); //정확한 오류표시 필요(세션 만료로 일괄 처리) -> 오류로 인한 exception은 세션만료로 간주
			onm.goUrl("/main/login.do");
		}
	},
	loadError:function(jqXHR, textStatus, errorThrown) {
		onm.errorHandle(jqXHR, textStatus, errorThrown);
	}
});

$.jgrid.extend({
	getGridData:function(rowId) {
		var gridParam = this.getGridParam() || {};
		var list, data;
		/*
		if(gridParam.datatype === 'local') {
			list = gridParam.data;
			if(rowId) {
				data = list[rowId-1];
			} else {
				data = list;
			}
		} else {
			if(rowId) {
				data = this.jqGrid('getRowData', rowId);
			} else {
				data = this.jqGrid('getRowData');
			}
		}
		*/
		var gridParam = this.getGridParam() || {};
		var list, data;
		if(gridParam.datatype === 'local') {
			list = gridParam.data;
		} else {
			list = gridParam.gridData;
		}
		if(rowId) {
			data = data = list[rowId-1];
		} else {
			data = list;
		}
		return data;
	},

	getSelGridData: function () {
		var grid = this;
		var multiSel = grid.getGridParam('multiselect');
		if (multiSel) {
			var selArrRow = grid.getGridParam('selarrrow');
			return selArrRow.map(function (item) {
				return grid.getRowData(item);
			});

		} else {
			var selRow = grid.getGridParam('selrow');
			if (!selRow) return [];
			var rowData = grid.getRowData(selRow);
			return $.makeArray(rowData);
		}
	},

	setFrozenColumns2: function() {

		var grid = this;

		grid.setFrozenColumns();

		var __jqGridAfterGridComplete = function () {
			grid.closest('.ui-jqgrid').find('.frozen-div').css({top: '1px', height: grid[0].grid.hDiv.offsetHeight - 1});

			var $frozenBdiv = grid.closest('.ui-jqgrid').find('.frozen-bdiv');
			var top = $(grid[0].grid.bDiv).prop('offsetTop');
			var height = parseInt($frozenBdiv.css('height')) - 1;
			$frozenBdiv.css({top: top + 'px', left: '-1px', height: height + 'px'});

			grid.off('jqGridAfterGridComplete', __jqGridAfterGridComplete);
		};

		grid.on('jqGridAfterGridComplete', __jqGridAfterGridComplete);

		if (true === grid.getGridParam('footerrow')) {

			grid.each(function () {
				if ( !this.grid ) {return;}
				var $t = this, cm = $t.p.colModel,i=0, len = cm.length, maxfrozen = -1, frozen= false;
				if($t.p.subGrid === true || $t.p.treeGrid === true || $t.p.cellEdit === true || $t.p.sortable || $t.p.scroll )
				{
					return;
				}
				if($t.p.rownumbers) { i++; }
				if($t.p.multiselect) { i++; }

				// get the max index of frozen col
				while(i<len)
				{
					// from left, no breaking frozen
					if(cm[i].frozen === true)
					{
						frozen = true;
						maxfrozen = i;
					} else {
						break;
					}
					i++;
				}

				$t.grid.fsDiv = $('<div style="position:absolute;left:0px;top:' + (parseInt($t.grid.sDiv.offsetTop, 10) + 1) + 'px;overflow-y:hidden" class=""></div>');

				$("#gview_"+$.jgrid.jqID($t.p.id)).append($t.grid.fsDiv);

				$($t).bind('jqGridAfterGridComplete.setFrozenColumns', function () {
					$("#"+$.jgrid.jqID($t.p.id)+"_footerfrozen").remove();
					$($t.grid.fsDiv).height($($t.grid.sDiv).height());
					var btbl = $($t.grid.sDiv).find('table').clone(true);
					$("tr[role=row]",btbl).each(function(){
						$("td[role=gridcell]:gt("+maxfrozen+")",this).remove();
					});

					$(btbl).width(1).attr("id",$t.p.id+"_footerfrozen");
					$($t.grid.fsDiv).append(btbl);
					btbl=null;
				});
			});
		}
	},

	frozenFooterData: function(action, data, format) {
		if ("set" !== action) return false;
		var nm, success=false, title;
		function isEmpty(obj) {
			var i;
			for(i in obj) {
				if (obj.hasOwnProperty(i)) { return false; }
			}
			return true;
		}
		if(typeof format !== "boolean") { format  = true; }

		this.each(function(){
			var t = this, vl;
			if(!t.grid || !t.p.footerrow) {return false;}
			if(action === "set") { if(isEmpty(data)) { return false; } }
			success=true;
			$(this.p.colModel).each(function(i){
				if(true !== this.frozen) return true;
				nm = this.name;
				if (data[nm] !== undefined) {
					vl = format ? t.formatter("", data[nm], i, data, 'edit') : data[nm];
					title = this.title ? {"title": $.jgrid.stripHtml(vl)} : {};
					$("tr.footrow td:eq(" + i + ")", t.grid.fsDiv).html(vl).attr(title);
					success = true;
				}
			});
		});
		return success;
	},

	footerData2: function(action, data, format) {
		var grid = this;
		grid.footerData(action, data, format);
		grid.frozenFooterData(action, data, format);
	},

	clearFooterData: function() {
		var grid = this;
		grid.each(function(){
			$(".ui-jqgrid-ftable td", this.grid.sDiv).html("&#160;");
			$(".ui-jqgrid-ftable td", this.grid.fsDiv).html("&#160;");
		});

	},

	syncFrozenColsHeight: function () {

		var grid = this;
		var gridParam = grid.getGridParam();

		if (true === gridParam.frozenColumns) {

			var arr = $(grid[0].grid.bDiv).find('tr.jqgrow').map(function () {
				return $(this).height();
			});

			$(grid[0].grid.fbDiv).find('tr.jqgrow').each(function (idx) {
				$(this).height(arr[idx]);
			});
		}
	},

	enableWheelPaging: function() {

		var grid = this;
		var nextCnt = 0, prevCnt = 0;

		var bDib = grid[0].grid.bDiv;
		var wheelEvents = $._data(bDib, 'events').wheel;

		if (wheelEvents && wheelEvents.length > 0) {
			return false;
		}

		$(bDib).on('wheel', function (e) {
			if (this.offsetHeight === this.scrollHeight - this.scrollTop && e.originalEvent.wheelDeltaY < 0) {
				if (nextCnt > 1) {
					nextCnt = 0;
					var gridParam = grid.getGridParam();
					var pg = parseInt(gridParam.postData.pg);

					if (pg < gridParam.lastpage) {
						grid.trigger('reloadGrid', {page: pg + 1});
					}
				} else {
					nextCnt++;
					prevCnt = 0;
				}
			} else if (0 === this.scrollTop && e.originalEvent.wheelDeltaY > 0) {
				if (prevCnt > 1) {
					prevCnt = 0;
					var gridParam = grid.getGridParam();
					var pg = parseInt(gridParam.postData.pg);

					if (pg > 1) {
						grid.trigger('reloadGrid', {page: pg - 1});
					}
				} else {
					prevCnt++;
					nextCnt = 0;
				}
			} else {
				prevCnt = 0;
				nextCnt = 0;
			}
		});
	}
});

//날짜및 공통 (1주 : 1w, 1달 : 1m, 3딜 : 3m)
$.extend(true, window, {
	onm:{
		setDatePeriod:function(date1$, date2$, period) {
			DateUtil.setDatePeriod(date1$, date2$, period);
		},
		setCustomerInfo:function(custInfo, suid, suidMasking, custNmMasking, custAge) {
			var custInfoJson = JSON.stringify(custInfo);
			onm.ajax({
				url:_contextPath_+'/cmn/onm/setCustomerInfo.json',
				data:{
					'custInfoJson':custInfoJson,
					'suid':suid,
					'suidMasking':suidMasking,
					'custNmMasking':custNmMasking,
					'custAge':custAge
				},
				success:function() {
					$('#header_custInfo_suid').text(suidMasking);
					$('#header_custInfo_name').text(custNmMasking);
				}
			});
		},
		clearCustomerInfo:function() {
			onm.ajax({
				url:_contextPath_+'/cmn/onm/clearCustomerInfo.json',
				success:function(data) {
					$('#header_custInfo_name').text(data.customerInfo.name);
					$('#header_custInfo_suid').text(data.customerInfo.suid);
				}
			});
		},
		compareDate:function (startDate, endDate, startDateNm, endDateNm,maxDt){
			var dStartDate = new Date(startDate);
			var dEndDate = new Date(endDate);
			if (dEndDate - dStartDate < 0){
				if (null != startDateNm && null != endDateNm) {
					var msg = endDateNm + "이 " + startDateNm + "보다 이전일수 없습니다";
				} else {
					var msg = "종료일이 시작일보다 이전일수 없습니다";
				}
				onm.alert(msg, function() {
					return false;
				});
			} else {
				//var maxDate = onm.getMaxMonth(endDate,maxDt/30); // 마지막 일을 따져서 최대 날짜일을 가져 오는 부분
				if((dEndDate.getTime() - dStartDate.getTime())/ 1000 / 60 / 60 / 24 > maxDt){ //창에 시작된 날짜 와 끝날짜의 일을 max일과 비교
					var msg = "최대기간이 " + Math.floor(maxDt/30) + "개월을 초과 할수 없습니다";
					onm.alert(msg, function() {
						return false;
					});
				} else {
					return true;
				}
			}
		},
		compareValue:function(firstVal, secondVal, firstNm, secondNm) {
			if (parseInt(firstVal.replace(',', '')) <= parseInt(secondVal.replace(',', ''))) {
				var msg = secondNm + "이 " + firstNm + "보다 작아야 합니다";
				onm.alert(msg, function() {
					return false;
				});
			} else {
				return true;
			}
		},
		// getMaxMonth - END 날짜에 따른 size에 따른 몇달전 날짜를 YYYY.MM.DD형식으로 리턴
		getMaxMonth : function (endDate, size) {
			var dEndDate = new Date(endDate); //날짜 변환
			var temp = dEndDate;
			var monthTemp = temp.getMonth() - parseInt(size);// 기존 월에 최대 개월 -부분
			temp.setMonth(monthTemp);
			var month = ("0" + (temp.getMonth() + 1)).slice(-2);
			var day = ("0" + temp.getDate()).slice(-2);
			var yymmdd = new Date(temp.getFullYear() + "-" + (month) + "-" + (day));
			var maxDate = (endDate.getTime() - yymmdd.getTime())/ 1000 / 60 / 60 / 24; //일짜 로 계산 하는 부분
			return Math.ceil(maxDate); // 올림값 으로 반환
		},
		checkUrl : function (el$, msg) {
			var regExp = /^[a-z0-9A-Z-\.\/]*$/;
			if (!regExp.test(el$.val())) {
				onm.alert(msg + " 패턴 오류입니다", function() {
					el$.focus();
					return false;
				});
				return false;
			} else {
				return true;
			}
		}
	}
});

//날짜 가져오는 공통 (1주 : 1w, 1달 : 1m, 3딜 : 3m)
var DateUtil = (function DateUtilImpl() {
	var that = Object.create(DateUtilImpl.prototype);
	that.PARAM_PATTERN = new RegExp(/^(.*)=(.*)$/);
	$.extend(DateUtilImpl.prototype, {
		setDatePeriod:function(date1$, date2$, period) {
			if(typeof date1$ === 'string') {
				that.setDatePeriod($(date1$), date2, period);
			}
			if(typeof date2$ === 'string') {
				that.setDatePeriod(date1, $(date2$), period);
			}
			var p = /^([0-9]+)([w,m])$/g.exec(period);
			if(!p) {
				alert('기간 지정 오류');
				return;
			}
			if(p[2] === 'w') {
				date1$.val(onm.getBeforeWeek());
			} else if(p[2] === 'm') {
				date1$.val(onm.getBeforeMonth(p[1]));
			}
			date2$.val(onm.todayFmt());
		}
	});
	return that;
}());

}(jQuery));
