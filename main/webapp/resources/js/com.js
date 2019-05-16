var fileHtml =
		  '<li class="fileLi #gubun#">'
		+ '	<span class="fileNm" id="file_#fileSeq#">'
		+ '		<a href="#fileUrl#">#fileNm#</a>'
		+ '	</span>&nbsp;&nbsp;'
		+ '	<span class="fileSize">#fileSize# Kb</span>&nbsp;&nbsp;'
		+ '	<button type="button" class="dosubmit delBtn" onclick="com.fileDelete(this);">삭제</button>'
		+ '</li>';

//naw.defineBizFunction('com', {
var com = {

	/* 해당 영역(area)을 초기화 한다.*/
	init : function(area, isDisable){
//		if (area == 'all') {area = naw('body #wrap');}
		var this$ = area.find('input, textarea, select, button[class!=btn_list_rd]');
		this$.attr('readonly', false); //tag readonly 해제
		com.reset(area);
		com.disable(area, isDisable);
		com.calDp(area, false);

		if (isDisable == false) {
			area.find('input[noinput=""], textarea[noinput=""], select[noinput=""]').attr('readonly', true).attr('value', '신규입력');
//			this$.each(function() {
//				if (this.name) {
//					if (typeof $(this).attr('noinput') !== 'undefined' && $(this).attr('noinput') == '') {
//						$(this).attr('disabled', true);
//					}
//				}
//			});
		}
		//area.find('input:first').focus();
	},

	/* 해당 영역의 모든 값을 초기화 한다 */
	reset : function(area) {
		var this$ = area.find('input[type=text], input[type=hidden], input[type=password], textarea, select');
		this$.val('');

		this$ = area.find('input[type=checkbox], input[type=radio]');
		this$.attr('checked', false);
	},

	/* 해당 영역(area)에 요소를 isFlag(true, false)값에 따라 enable, disable 시킨다 */
	disable : function(area, isFlag){
		if (typeof(isFlag) === 'undefined') { return; }
		var this$ = area.find('input, textarea, select, button[class!=btn_list_rd]');
		this$.attr('disabled', isFlag);

//		area.find('.date').next().attr('disabled', isFlag);
		this$.trigger('chosen:updated');
	},

	/* 해당 영역(area)에 달력을 찾아 isFlag(true, false)값에 따라 enable, disable 시킨다 */
	calDp : function(area, isFlag) {
		area.find('input').each(function() {
			var classNm = new String($(this).attr('class'));
			if (classNm.indexOf('calendar') > -1){
				if (isFlag) {
					$(this).siblings('img.ui-datepicker-trigger').show();
				} else {
					$(this).siblings('img.ui-datepicker-trigger').hide();
				}
			}
		});
	},

	/* 해당 객체에 달력을 찾아 isFlag(true, false)값에 따라 enable, disable 시킨다 */
	calThisDp : function(this$, isFlag) {
		var classNm = new String(this$.attr('class'));
		if (classNm.indexOf('calendar') > -1){
			if (isFlag) {
//				console.log(1);
				this$.siblings('img.ui-datepicker-trigger').show();
			} else {
//				console.log(0);
				this$.siblings('img.ui-datepicker-trigger').hide();
			}
		}
	},

	/* 해당 영역(area)의 flag를 crud값에 따라 변경한다 */
	setFlag : function(area, crud) {
		if (typeof(crud) === 'undefined') { return;}
		if (typeof($('#' + area.attr('id') + 'Flag')) === 'undefined' || $('#' + area.attr('id') + 'Flag').length == 0) {
			var htmlStr = '<input type="hidden" name="' + area.attr('id') + 'Flag"' + ' id="' + area.attr('id') + 'Flag" />';
			$('body').append(htmlStr);
		}
		var id$ = $('#' + area.attr('id') + 'Flag');
		id$.val(crud);
//		console.log(crud);
	},

	/* 해당 영역(area)의 flag값을 반환한다. */
	getFlag : function(area) {
		var id$ = $('#' + area.attr('id') + 'Flag');
		if (typeof(id$) === 'undefined' || id$.length == 0) {
			return '';
		}
		return id$.val();
	},

	/* 해당 영역(area)의 값(data:서버요청값)을 세팅한다 */
	set : function(area, action, fileYn){
		var data = com.getData(area);
//		com.setComboData(area.id(), data);

		if (action != null && action != '') {
			data['OP_FLAG'] = action;
		}

		if (fileYn && fileYn == 'Y') {
			var fileList = [];
			var idx = 0;
			$('.fileLi.new').each(function() {
				fileList[idx] = 'new,' + $(this).children().attr('id').replaceAll('file_', '');
				idx++;
			});
			$('.fileLi.old').each(function() {
				fileList[idx] = 'old,' + $(this).children().attr('id').replaceAll('file_', '');
				idx++;
			});
			$('.fileLi.del').each(function() {
				fileList[idx] = 'del,' + $(this).children().attr('id').replaceAll('file_', '');
				idx++;
			});
			data.fileList = fileList;
		}

		return data;
	},

	getData : function(area, pageUnit, arry) {
		var data = {};
		area.find('input, textarea, select').each(function() {
			var this$ = $(this);
			if (this.tagName == 'TEXTAREA') {
				if (this.name) {
					data[this.name] = this$.val();
				} else if (this.id) {
					data[this.id] = this$.val();
				}
			} else if (this.tagName == 'SELECT') {
				if (this.name) {
					if (arry) { //배열로 반환
						data[this.name] = this$.val();
					} else { //(*default)문자열 구분자로 반환 - 예) '111','222'
						if(Array.isArray(this$.val())) {
							data[this.name] = this$.val().join(',');
						} else {
							data[this.name] = this$.val();
						}
					}
//				} else if (this.id) {
//					data[this.id] = this$.val();
				}
			} else {
				var thisType = this.type;
				if (thisType == 'text' || thisType == 'hidden' || thisType == 'password') {	//일반 input박스.
					if (this.name) {
						if (typeof $(this).attr('tel') !== 'undefined' && $(this).attr('tel') == '') {
							data[this.name] = naw.unValMask(this$.val(), 'tel');
						} else if (typeof $(this).attr('num') !== 'undefined' && $(this).attr('num') == '') {
							data[this.name] = naw.unValNum(this$.val());
						} else {
							data[this.name] = this$.val();
						}
						if (thisType == 'text' && (this.className.indexOf('calendar') > -1 || this.className.indexOf('monthPicker') > -1)) {
							data[this.name] = this$.val().replaceAll('-', '');
						}
					} else if (this.id) {
						if (typeof $(this).attr('tel') !== 'undefined' && $(this).attr('tel') == '') {
							data[this.name] = naw.unValMask(this$.val(), 'tel');
						} else if (typeof $(this).attr('num') !== 'undefined' && $(this).attr('num') == '') {
							data[this.name] = naw.unValNum(this$.val());
						} else {
							data[this.name] = this$.val();
						}
					}
				} else if (thisType == 'radio') { //radio
					//radio는 하나만 체크.
					if (this.name) {
						if (this$.prop('checked')) {
							data[this.name] = this$.val();
						}
					}
				} else if (thisType == 'checkbox') { //checkbox
					if (this.name) {
						if (arry) { //배열로 반환
							if (typeof data[this.name] === 'undefined') {
								data[this.name] = [];
							}
							if (this$.val()) {
								if (this$.prop('checked')) {
									data[this.name].push(this$.val());
								}
							}
						} else { //(*default)문자열 구분자로 반환 - 예) '111','222'

							if (typeof data[this.name] === 'undefined') {
								data[this.name] = '';
							}
							if (this$.val()) {
								if (this$.prop('checked')) {
									data[this.name] = (data[this.name] ? data[this.name] + ',' : '') + this$.val();
								}
							}
						}
					}
				} else {
					;
				}
			}
		});
		if (pageUnit) {
			data['pageUnit'] = pageUnit;
		}
		return data;
	},

	setData : function(area, data, arry) {
		data = com.getData(area, null, arry);
	},

	/* 해당 영역(area)에 값(data:서버응답값)을 세팅한다 */
	setVal : function(area, data){
		com.init(area, false); //해당 영역을 초기화 한다
		com.calDp(area, true); //달력 아이콘을 다시 표시한다
		area.find('input[type=text], input[type=hidden], input[type=password], textarea, select').each(function() {
			if (this.name) {
				if (null != data[this.name] && 'undefined' !== typeof(data[this.name])) {
					if (this.type == 'select-multiple') {
						if (typeof data[this.name] === 'string') {
							var arry = data[this.name].split(',');
							var val = [];
							for (var idx = 0; idx < arry.length; idx++) {
								val.push(arry[idx]);
							}
							$(this).val(val);
						}
					} else {
						if (typeof $(this).attr('datetime') !== 'undefined' && $(this).attr('datetime') == '') {
							$(this).val($.fn.fmatter.datetime(data[this.name]));
						} else if ($(this).hasClass('calendar')) {
							$(this).val(onm.formatDate(data[this.name]));
						} else {
							$(this).val(data[this.name]);
						}
					}
				}
				if ($(this).hasClass('chosen')) { //chosen을 사용하는 selectbox일경우 다시 그려준다.
//					$(this).chosen('destroy').chosen({width: '95%'});
					$(this).trigger('chosen:updated');

				}
			}
			if (this.tagName == 'TEXTAREA') {
				$(this).keyup();
			}
		});
		area.find('input[type=checkbox], input[type=radio]').each(function() {
			var this$ = $(this);
			var thisType = this.type;
			if (thisType == 'radio') {
				if (this$.val() == data[this.name]) {
					this$.prop('checked', true);
//				} else {
//					this$.attr('checked', false);
				}
			} else if (thisType == 'checkbox') {
				if (data[this.name]) {
					var arry = data[this.name].split(',');
					for (var idx = 0; idx < arry.length; idx++) {
						if (this$.val() == arry[idx]) {
							this$.prop('checked', true);
						}
					}
				}
			}
		});

		com.setFlag(area, 'U');

		//'read'로 설정되어 있는 요소를 readonly 처리한다
		area.find('input, textarea, select').each(function() {
			if (typeof $(this).attr('read') === 'undefined') { return true; }
			if ($(this).attr('read') == '') {
				$(this).attr('readonly', true);
//				if (this.nodeName == 'SPAN') {
//					naw(this).disable(true);
//				}
				com.calThisDp($(this), false);
			}
		});
	},

	/* paging 변수를 grid에 세팅한다 */
	setPg : function(data, grid){
//		var paging = data.get('paging');
//		grid.updateBottom(paging.pageNumber, paging.totalCount);
	},

	/* 서버에서 받은 데이터(data)를 그리드(grid)에 세팅한다*/
	setGrid : function(data, keyNm, grid) {
//		grid.removeAll();
//		grid.toGrid(data.getListDataSet(keyNm), function(gRow, dsRow, gRowIdx){});
	},

	//그리드에서 선택한 row를 area에 세팅한다
	setView : function(data, area) {
		area.find('input:text, input:hidden, textarea, select').each(function() {
			$(this).val(data[$(this).attr('name')]);
		});
	},

	/*setChk : function(area, nm, val, obj, allNm) {
		var this$ = area.find('[name=' + nm + ']');

		if (this$.eq(0).val() == '') {
			this$.on('click', function() {
				//전체 선택을 클릭했을 경우
				if (this.value == '') {
					if (this.checked == true) {
						this$.prop('checked', true);
					} else {
						this$.prop('checked', false);
					}
				} else { //각 요소를 선택했을 경우
					var cnt = this$.filter(':checked').length;
					if (this.checked) {
						if (this$.length - cnt <= 1) {
							if (!this$.eq(0).prop('checked')) {
								this$.eq(0).prop('checked', true);
							}
						}
					} else {
						if (this$.length - cnt <= 1) {
							if (this$.eq(0).prop('checked')) {
								this$.eq(0).prop('checked', false);
							}
						}
					}
				}
			});
		}

		//val로 넘어온 값 세팅
		if (typeof val === 'string') {
			var arry = val.split(',');
			for (var idx = 0; idx < arry.length; idx++) {
	//	 		console.log(arry[idx]);
				this$.each(function() {
					if ($(this).val() == arry[idx]) {
						$(this).prop('checked', true);
					}
				});
			}
		}

		if (this$.eq(0).val() == '') {
			if (this$.length - this$.filter(':checked').length <= 1) {
				this$.eq(0).prop('checked', true);
			}
		}
	},*/

	//checkbox, radio, select를 표시하고 넘어온 값을 세팅한다
	//type: 체크유형, area: 영역, nm: 개체명, val: 설정될 값, obj: combo 쿼리id or combo object, allNm: 전체유무및 명칭, width: 가로사이즈(고정시)
	setCombo :function(type, area, nm, val, obj, allNm, width){
		var this$ = area.find('[name=' + nm + ']');

		if (typeof obj === 'undefined') { //obj가 없을 경우(이미 display되었다고 가정함)
			com.comboDp(type, area, this$, val, obj);
		} else if (typeof obj === 'string') { //obj가 queryId일 경우
			onm.ajax({
				url: _contextPath_ + '/cmn/objList.json',
				data: {'queryId':obj},
				success: function(res) {
					com.comboDp(type, area, this$, val, res.list, allNm, width);
				}
			});
		} else if (typeof obj === 'object' && Array.isArray(obj)) { //obj가 combo list일 경우
			com.comboDp(type, area, this$, val, obj, allNm, width);
		}
	},

	//combo를 출력한다
	comboDp : function(type, area, sel$, val, list, allNm, width) {
		if (type == 'select') {
			if (typeof list === 'undefined') { //콤보가 이미 display 되어있음
				if (typeof val === 'string') {
					var opt = sel$.children('option');
					var valArry = [];
					for (var idx = 0; idx < opt.length; idx++) {
						for (var jdx = 0; jdx < val.split(',').length; jdx++) {
							if (opt[idx].value == val.split(',')[jdx]) {
								valArry.push(val.split(',')[jdx]);
							}
						}
					}
					if (valArry.length != 0) {
						sel$.val(valArry);
					}
				}
			} else {  //list를 가지고 combo를 display
				sel$.html('');
				var html = '';
				var sel;
				if (typeof allNm === 'string') {
					html += '<option value="">' + allNm + '</option>';
				}

				for (var idx = 0; idx < list.length; idx++) {
					sel = '';
					if (typeof val === 'string') {
						for (var jdx = 0; jdx < val.split(',').length; jdx++) {
							if (list[idx].cd == val.split(',')[jdx]) {
								sel = 'selected';
							}
						}
					}
					html += '<option value="' + list[idx].cd + '"' + sel + '>' + list[idx].nm + '</option>';
				}
				sel$.html(html);
			}

			var minWidth = 100;
			if (width) {
				sel$.css('width', width + 'px');
			} else if (sel$.css('width').replaceAll('px', '') < minWidth) {
				sel$.css('width', minWidth + 'px');
			}

			if (sel$.hasClass('chosen')) { //chosen을 사용하는 selectbox일경우 다시 그려준다.
//				sel$.chosen('destroy').chosen({width: '95%'});
				sel$.trigger('chosen:updated');

			}
		} else if (type == 'checkbox') {
			if (typeof list === 'undefined') { //콤보가 이미 display 되어있음
				com.setAllChk(sel$, val);
			} else {  //list를 가지고 combo를 display
				sel$.html('');
				var html = '';
				var nm = sel$.attr('name');
				var chk;
				if (typeof allNm === 'string') {
					html += '<label><input type="checkbox" name="' + nm + '" value="" />' + allNm + '</label>&nbsp;&nbsp;&nbsp';
				}
				for (var idx = 0; idx < list.length; idx++) {
					chk = '';
					if (typeof val === 'string') {
						for (var jdx = 0; jdx < val.split(',').length; jdx++) {
							if (list[idx].cd == val.split(',')[jdx]) {
								chk = 'checked="checked"';
							}
						}
					}
					html += '<label><input type="checkbox" name="' + nm + '" value="' + list[idx].cd + '" ' + chk + ' />' + list[idx].nm + '</label>' + (idx == (list.length - 1) ? '' : '&nbsp;&nbsp;&nbsp');
				}
				sel$.html(html);

				if (typeof allNm === 'string') {
					var chk$ = area.find('input[name=' + nm + ']');
					com.setAllChk(chk$);
				}
			}
			com.disable(area, true);
		} else if (type == 'radio') {
			if (typeof list === 'undefined') { //콤보가 이미 display 되어있음
				com.setAllChk(sel$, val);
			} else {  //list를 가지고 combo를 display
				sel$.html('');
				var html = '';
				var nm = sel$.attr('name');
				var chk;
				if (typeof allNm === 'string') {
					html += '<label><input type="radio" name="' + nm + '" value="" />' + allNm + '</label>&nbsp;&nbsp;&nbsp';
				}
				for (var idx = 0; idx < list.length; idx++) {
					chk = '';
					if (typeof val === 'string') {
						for (var jdx = 0; jdx < val.split(',').length; jdx++) {
							if (list[idx].cd == val.split(',')[jdx]) {
								chk = 'checked="checked"';
							}
						}
					}
					html += '<label><input type="radio" name="' + nm + '" value="' + list[idx].cd + '" ' + chk + ' />' + list[idx].nm + '</label>' + (idx == (list.length - 1) ? '' : '&nbsp;&nbsp;&nbsp');
				}
				sel$.html(html);

				if (typeof allNm === 'string') {
					var chk$ = area.find('input[name=' + nm + ']');
					com.setAllChk(chk$);
				}
			}
			com.disable(area, true);
		}
	},

	setAllChk : function(sel$, val) {
		if (sel$.eq(0).val() == '') {
			sel$.on('click', function() {
				//전체 선택을 클릭했을 경우
				if (this.value == '') {
					if (this.checked == true) {
						sel$.prop('checked', true);
					} else {
						sel$.prop('checked', false);
					}
				} else { //각 요소를 선택했을 경우
					var cnt = sel$.filter(':checked').length;
					if (this.checked) {
						if (sel$.length - cnt <= 1) {
							if (!sel$.eq(0).prop('checked')) {
								sel$.eq(0).prop('checked', true);
							}
						}
					} else {
						if (sel$.length - cnt <= 1) {
							if (sel$.eq(0).prop('checked')) {
								sel$.eq(0).prop('checked', false);
							}
						}
					}
				}
			});
		}

		//val로 넘어온 값 세팅
		if (typeof val === 'string') {
			var arry = val.split(',');
			for (var idx = 0; idx < arry.length; idx++) {
				sel$.each(function() {
					if ($(this).val() == arry[idx]) {
						$(this).prop('checked', true);
					}
				});
			}
		}

		if (sel$.eq(0).val() == '') {
			if (sel$.length - sel$.filter(':checked').length <= 1) {
				sel$.eq(0).prop('checked', true);
			}
		}
	},

	/* grid에서 check된 row만 data에 세팅한다 */
	setChkRow : function(data, grid, keyNm, action) {
		/*
		data.reset();
		var listDs = data.getListDataSet(keyNm);
		grid.toDataSetOption({
			checked:true
			//setFlag:"OP_FLAG"	//flag네임 지정.
		});
		grid.toDataSet(listDs, function(dsRow, gRow, dsRowIdx){
			dsRow.OP_FLAG = action;
		});
		*/
	},

	/* 해당 영역(area)의 값을 유효성(필수, 길이, 형식등)을 체크한다. */
	validChk : function(area){
		var isValid = true;

		var this$ = area.find('.state-required');
		this$.each(function() {
			var obj$ = $(this).next().find('input, textarea, select');
			if(!obj$.prop('disabled')) {
				if('INPUT' == obj$.prop('tagName') || 'TEXTAREA' == obj$.prop('tagName')) {
					var obj$ = $('#' + area.attr('id') + ' [name=' + obj$.prop('name') + ']');
					if('text' == obj$.prop('type') || 'hidden' == obj$.prop('type') || 'textarea' == obj$.prop('type')) {
						if(!$.trim(obj$.val())){
							onm.alert($(this).text() + '은(는) 필수입력 입니다.');
							isValid = false;
							return false;
						}
					} else if('radio' == obj$.prop('type') || 'checkbox' == obj$.prop('type')) {
						if(!obj$.is(':checked')){
							onm.alert($(this).text() + '은(는) 필수선택 입니다.');
							isValid = false;
							return false;
						}
					}
				} else if('SELECT' == obj$.prop('tagName')) {
					var obj$ = $('#' + area.attr('id') + ' [name=' + obj$.prop('name') + ']');
					if(!$.trim(obj$.val())){
						onm.alert($(this).text() + '은(는) 필수선택 입니다.');
						isValid = false;
						return false;
					}
				}
			}
		});

		if (isValid) {

			/* 유효성 체크 */
			area.find('input').each(function() {
				if (this.type == 'text') {	//일반 input박스.

					/* 전화번호 유효성 체크*/
					if (typeof $(this).attr('tel') !== 'undefined' && $(this).attr('tel') == '' && !$(this).prop('readonly') && !$(this).prop('disabled')) {
						var telNo = $(this).val();
						if (telNo) {
							var isHp = false;
							if (telNo.substring(0, 2) == '01' || telNo.substring(0, 2) == '11') {
								isHp = true;
							}
							if (isHp) {
								if (!naw.isMobile(telNo)) {
									onm.alert($(this).parent().prev().html() + '의 번호가 잘못되었습니다.');
									isValid = false;
									return false;
								}
							} else {
								if (!naw.isTel(telNo)) {
									onm.alert($(this).parent().prev().html() + '의 번호가 잘못되었습니다.');
									isValid = false;
									return false;
								}
							}
						}
					}

					/* email형식 유효성 체크*/
					if (typeof $(this).attr('email') !== 'undefined' && $(this).attr('email') == '' && !$(this).prop('readonly') && !$(this).prop('disabled')) {
						var emailVal = $(this).val();
						if (emailVal) {
							if (!naw.isEmail(emailVal)) {
								onm.alert($(this).parent().prev().html() + '의 형식이 잘못되었습니다.');
								isValid = false;
								return false;
							}
						}
					}

					/* 숫자타입 유효성 체크*/
					if (typeof $(this).attr('num') !== 'undefined' && $(this).attr('num') == '' && !$(this).prop('readonly') && !$(this).prop('disabled')) {
						var numVal = $(this).val();
						if (numVal) {
							numVal = numVal.replaceAll(',', '');
							if (!naw.isNum(numVal)) {
								onm.alert($(this).parent().prev().html() + '은 숫자만 입력가능합니다.');
								isValid = false;
								return false;
							}
						}
					}
				}
			});
		}

		return isValid;
	},

	/* callback시 message를 출력하고 action에 따라 flag를 변경한다(isMessage가 true일 경우 메시지를 출력한다)*/
	afterSave : function(data, area, action, isMessage) {
		var message;
		if (action == 'C') {
			com.setFlag(area, 'U');
			message = '등록되었습니다';
		} else if (action == 'U') {
			message = '수정되었습니다';
		} else if (action == 'D') {
//			com.init(area);
			com.setFlag(area, 'C');
			message = '삭제되었습니다';
		} else {
			message = '오류입니다';
		}

		if (action == 'U' && 0 >= data.result) {
			message = '변경된 사항이 존재하므로 수정할 수 없습니다.';
		}
		if (isMessage) {
			onm.alert(message);
		}
	},

	/* callback error시 message를 출력하고 action에 따라 flag를 변경한다 */
	afterSaveError : function(area, action, isMessage) {
		if (action == 'C') {
			//com.setFlag(area, 'U');
		} else if (action == 'U') {
			;
		} else if (action == 'D') {
			//com.setFlag(area, 'C');
		}
		if (isMessage) {
			onm.alert('오류입니다');
		}
	},

	/* 서버전송전(before) 해당 action이 유효한지 체크하고 서버에 전송할(OP_FLAG) flag를 담는다 */
	beforeChk : function(area, action) {
		var disableFlag = true;
		area.find('input, textarea, select').each(function(i) {
			if('disabled' != $(this).attr('disabled')){
				disableFlag = false;
			}
		});

		if (action == undefined || action == '') {
			onm.alert('저장할 데이터가 없습니다.');
			return false;
		}
		if ((action == 'U' || action == 'C') && disableFlag) {
			onm.alert('저장할 데이터가 없습니다.');
			return false;
		}
		if (action == 'D' && disableFlag) {
			onm.alert('삭제할 데이터가 없습니다.');
			return false;
		}
		if (com.getFlag(area) == 'C' && action == 'D') {
			onm.alert('삭제할 데이터가 없습니다.');
			return false;
		}

		if (action == 'D') {
//			onm.confirm({
//				title:'확인',
//				msg:'삭제하시겠습니까?',
//				confirm:function() {
//					return true;
//				},
//				cancel:function() {
//					return false;
//				}
//			});
			if(!confirm('삭제하시겠습니까?')) {
				return false;
			}
		}

		if (action == 'U') {
			if (!com.updateAuthChk()) {
				onm.alert('수정할 권한이 없습니다.');
				return false;
			}
		}

		return true;
	},

	updateAuthChk: function () {
		var uri = location.href;
		var ext = uri.substring(uri.lastIndexOf(".") + 1, uri.length);
		var menuCd = uri.substring(uri.lastIndexOf("/") + 1, uri.lastIndexOf("."));
		var roleList = sUserData.roleList;
		if (ext.startsWith('m')) { return true; } //모바일일 경우 권한 컨트롤을 하지 않는다.
		for (var idx = 0; idx < roleList.length; idx++) {
			if (menuCd.indexOf(roleList[idx].menuCd) > -1 && roleList[idx].updateYn == 'N') {
				return false;
			}
		}

		return true;
	},

	/**
	 * setComboData
	 */
	setComboData : function(area, data){
//		var nawThis;
//		naw('#'+area+' *').foreach(function() {
//			nawThis = naw(this);
//			if(nawThis.name == 'combobox'){	//combobox인 경우
//				var name = this.id.substring(this.id.indexOf('_') + 1, this.id.length);
//				data.set(name, nawThis.val());
//			}
//		});
	},

	/**
	 * resDs 객체 값 복사(function 제외)
	 * ex) com.copy(orgObj);
	 */
	copy : function (data) {
		if (null == data || undefined == data || undefined == data.getAllRow()) { return data;}
//		var rtnObj = {};
		var rtnObj = [];
		for (var idx=0; idx < data.getAllRow().length; idx++) {
			var orgRow = data.getAllRow()[idx];
			var row = {};
			for (var property in orgRow) {
				if (typeof(orgRow[property]) != 'function') {
					row[property] = orgRow[property];
				}
			}
//			rtnObj[idx] = row;
			rtnObj.push(row);
		}

		return rtnObj;
	},

 	nvl : function(value, defaultValue) {
 		return naw.isEmpty(value) ? (naw.isEmpty(defaultValue) ? "" : defaultValue) : value;

 	},

 	comboNumAdd: function(std, end) {
 		if (naw.isEmpty(std)) { std = 1980;}
 		if (naw.isEmpty(end)) { end = 2020;}
 		if (std > end) { std = end;}

 		var rtnCombo = [];
 		for (var idx = std; idx <= end; idx++) {
 			rtnCombo.push({text: idx, value: idx});
 		}
 		return rtnCombo;
 	},

 	comboDept: function(allYn) {
 		var rtnCombo = [];
 		if (!naw.isEmpty(allYn) && 'Y' == allYn) {
 			rtnCombo.push({text:'전체', value:''});
 		}
 		for (var idx = 0; idx < bizOrgan.length; idx++) {
 			if (bizOrgan[idx].lv == 2) {
 				rtnCombo.push({text: bizOrgan[idx].dptNm, value: bizOrgan[idx].dptCd});
 			}
 		}
 		return rtnCombo;
 	},

 	cuCombobox: function(obj){

 		if(typeof obj !==  'undefined' && obj.length > 0){

			for(var x in obj){
				for(var idx = 0; idx < naw(obj[x].target).count(); idx++){
					for(var cdIdx = 0; cdIdx < obj[x].delCd.length; cdIdx++){
						if(naw(obj[x].target).getItemValue(idx) == obj[x].delCd[cdIdx]){
							naw(obj[x].target).removeIndex(idx);
						}
					}
				}
			}
		}
 	},
 	objToXml : function(obj){
 		var xml = '';
 		for (var prop in obj) {
 			if (!obj.hasOwnProperty(prop)) { continue;}
 			if (typeof obj[prop] === 'undefined') { continue;}
 			xml += '<' + prop +'>';
 			if (typeof obj[prop] == 'object') {
 				xml += com.objToXml(new Object(obj[prop]));
 			} else {
 				xml += obj[prop];
 			}
 			xml += '</' + prop + '>';
 		}
 		return xml;
 	},

	/**
	 * 공통코드를 list로 가져온다(사용여부의 Y).
	 * @param {String} grpCd 그룹코드
	 * @returns {Object}
	 * @example
	 * com.getCdList('030');
	 * com.getCdList('030', {ect2:'N'});
	 */
	getCdList : function(grpCd, ectCd){
		var filterYnData = com.___filterData(gCdList, {text:'useYn', value:'Y'})[0];
		var filterGrpCd;

		if(grpCd && !ectCd) { //그룹코드
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			return filterGrpCd;
		} else if(grpCd && ectCd) {//그룹코드, 상세코드
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			for(var key in ectCd){
				filterEtcCd = com.___filterData(filterGrpCd, {text : key, value : ectCd[key]})[0];
			}
			return filterEtcCd;
		} else {
			return onm.alert('보내는 인자가 잘못 되었습니다. 확인바랍니다.');
		}
	},

	/**
	 * 공통코드를 가져온다(사용여부의 Y).
	 * @param {String} grpCd 그룹코드
	 * @param {String} cd 코드
	 * @returns {Object}
	 * @example
	 * com.getCd('030', '20');
	 * com.getCd('030', '20', {ect2:'N'});
	 */
	getCd : function(grpCd, cd, etcCd){
		var filterYnData = com.___filterData(gCdList, {text:'useYn', value:'Y'})[0];
		var filterGrpCd;
		var filterCd;

		if(cd == null){//cd가 null일 경우 빈값 return;
			var objKeys = Object.keys(cdList[0]);
			var nullObj = new Object();

			for(var key in objKeys){
				nullObj[objKeys[key]] = '';
			}

			return nullObj;
		}

		if(grpCd && !cd && !etcCd) {
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			return filterGrpCd[0];
		} else if(grpCd && !cd && etcCd) {
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			var filterEtcCd;
			for(var key in etcCd){
				filterEtcCd = com.___filterData(filterGrpCd, {text : key, value : etcCd[key]})[0];
			}
			return filterEtcCd[0];
		} else if(grpCd && cd && !etcCd) {
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			filterCd = com.___filterData(filterGrpCd, {text : 'cd', value : cd})[0];
			return filterCd[0];
		} else if(grpCd && cd && etcCd) {
			filterGrpCd = com.___filterData(filterYnData, {text : 'grpCd', value : grpCd})[0];
			filterCd = com.___filterData(filterGrpCd, {text : 'cd', value : cd})[0];

			var filterEtcCd;
			for(var key in etcCd){
				filterEtcCd = com.___filterData(filterCd, {text : key, value : etcCd[key]})[0];
			}
			return filterEtcCd[0];
		} else {
			return onm.alert('보내는 인자가 잘못 되었습니다. 확인바랍니다.');
		}
	},

	/**
	 * 모든 공통코드를 가져온다(사용여부의 관계 없이 모두).
	 * @param {String} grpCd 그룹코드
	 * @param {Array} etcCd 기타코드
	 * @returns {Object}
	 * @example
	 * com.getCdAllList('030');
	 * com.getCdAllList('030', {'ect1' : 'N'});
	 */
	getCdAllList : function(grpCd, etcCd){
		var filterGrpCd;

		if (grpCd && !etcCd) {
			filterGrpCd = com.___filterData(gCdList, {text : 'grpCd', value : grpCd})[0];
			return filterGrpCd;
		} else if(grpCd && etcCd) {
			filterGrpCd = com.___filterData(gCdList, {text : 'grpCd', value : grpCd})[0];
			var filterEtcCd;
			for(var key in etcCd){
				filterEtcCd = com.___filterData(filterGrpCd, {text : key, value : etcCd[key]})[0];
			}
			return filterEtcCd;
		} else {
			return onm.alert('보내는 인자가 잘못 되었습니다. 확인바랍니다.');
		}
	},

	/**
	 * 공통코드 or 배열을 가져와 지정된 target에 append하여 컴포넌트를 세팅한다.
	 * @param {Object} obj 객체(radio, checkbox)
	 * @param {String} grpCd 그룹코드 or arrayList
	 * @example
	 * com.combo({name:'radio', targetId:'authDiv', targetNm:'authCd', defaultValue:'100'}, 'AUTH_CD');
	 * com.combo({name:'radio', targetId:'authDiv', targetNm:'authCd', defaultValue:'100'}, gCenterList);
	 * com.combo({name:'checkbox', targetId:'authDiv', targetNm:'authCd', defaultValue:'100,104'}, 'AUTH_CD');
	 * com.combo({name:'checkbox', targetId:'authDiv', targetNm:'authCd', defaultValue:['100','104']}, 'AUTH_CD');
	 */

	combo : function(objComp, div){
		var argLength = arguments.length;
		var lastArg = {};
		var ectCd;

		if(objComp.name == 'radio') { //radio버튼인 경우
			var etcCd = objComp.etc;
			var radioData;
			if ($.isArray(div)) {
				radioData = div;
			} else {
				radioData = this.getCdList(div, etcCd);
			}

			var radioDataLength = radioData.length;
			var radioText = '';
			var chk;
			var radioText = '<span class="selection-grp">';
			for(var i=0; i<radioDataLength; i++){
				chk = '';
				if(!naw.isEmpty(objComp.defaultValue)){
					if (radioData[i]['cd'] == objComp.defaultValue) {
						chk = 'checked="checked"';
					}
				}
				radioText += '<label><input name="'+objComp.targetNm+'" type="radio" value="'+radioData[i]['cd']+'" ' + chk + ' />'+radioData[i]['nm']+'&nbsp;</label>';
			}
			radioText += '</span>';

			$('#' + objComp.targetId).append(radioText);
//			if(!naw.isEmpty(objComp.defaultValue)){
//				$('[name='+objComp.targetNm+']').val(objComp.defaultValue);
//			}

		} else if(objComp.name == 'checkbox') { //checkbox버튼인 경우
			var etcCd = objComp.etc;
			var checkboxData;
			if ($.isArray(div)) {
				checkboxData = div;
			} else {
				checkboxData = this.getCdList(div, etcCd);
			}

			var checkboxDataLength = checkboxData.length;

			var checkText = '<span class="selection-grp">';
			for(var i=0; i<checkboxDataLength; i++){
				chk = '';
				if(!naw.isEmpty(objComp.defaultValue)){
					var val;
					if($.isArray(objComp.defaultValue)){
						val = objComp.defaultValue;
					} else {
						val = objComp.defaultValue.split(',');
					}

					for (var jdx = 0; jdx < val.length; jdx++) {
						if (checkboxData[i]['cd'] == val[jdx]) {
							chk = 'checked="checked"';
						}
					}
				}
				checkText += '<label><input name="'+objComp.targetNm+'" type="checkbox" value="'+checkboxData[i]['cd']+'" ' + chk + ' />'+checkboxData[i]['nm']+'&nbsp;</label>';
			}
			checkText += '</span>';

			$('#'+objComp.targetId).append(checkText);
		} else {
			return onm.alert('잘못 요청하였습니다. 다시 확인하시기 바랍니다.');
		}
	},

	___filterData : function(filter, filterInfo){

		var filterData = filter;
		var filterObj = [];

		filterObj.push(filterData.filter(function(root){return root[filterInfo.text] == filterInfo.value}))
		return filterObj;
	},

 	getMsg: function(msgId) {
		var filterData = gMsgList.filter(function(data){return data['msgId'] == msgId})[0];
		return (filterData) ? filterData.msgNm : '-';
	},

 	getMsgDesc: function(msgId) {
		var filterData = gMsgList.filter(function(data){return data['msgId'] == msgId})[0];
		return (filterData) ? filterData.msgDesc.replaceAll('NNN', '\n') : '-';
	},

 	getMsgList: function(msgType) {
		var filterData = gMsgList.filter(function(data){return data['msgType'] == msgType});
		return (filterData) ? filterData : '-';
	},

 	getCenter: function(cd) {
		var filterData = gCenterList.filter(function(data){return data['cd'] == cd})[0];
		return (filterData) ? filterData.nm : '-';
	},

	sAuthCenterList: function() {
		var rtnList = [];
		if (gCenterList && sUserData.authCenterCd) {
			var authCenterArry = sUserData.authCenterCd.split(',');
			for (var idx = 0; idx < authCenterArry.length; idx++) {
				for (var jdx = 0; jdx < gCenterList.length; jdx++) {
					if (authCenterArry[idx] == gCenterList[jdx].cd) {
						rtnList.push(gCenterList[jdx]);
						break;
					}
				}
			}
		}
		return rtnList;
	},

	//javascript - box 객체로 변환(box util 추가 확장)
	toBox : function(obj) {
		var area = obj;
		$.extend(area, {
			get : function(key) {
				return $(this).find('[name=' + key + ']').val();
			},
			nvl: function (key, defaultVal) {
				if (!defaultVal) defaultVal = '';
				return ($(this).find('[name=' + key + ']').val() == '') ? defaultVal : this.box[key];
			},
			put: function (key, value) {
				$(this).find('[name=' + key + ']').val(value);
			}
		});
		return area;
	},

	//파일추가
	fileAdd: function(area) {
		var fileCnt = area.find('.fileLi.new').length + area.find('.fileLi.old').length;
		if (fileMaxCnt <= fileCnt) {
			onm.alert('첨부가능 파일수(' + fileMaxCnt + ')를 초과했습니다.');
			return;
		}
		area.find('[name=uploadFile]').trigger('click');
	},

	//파일업로드
	fileUpload: function(area, edit$, files, fileMeta) {

		var formData = new FormData();
		if (!com.fileCntChk(area, files)) { return;}
		for (var idx = 0; idx < files.length; idx++) {
			if (!com.fileChk(files[idx])) { return;}
			formData.append('file', files[idx]);
		}
		formData.append('fileDiv', fileMeta.fileDiv);
		formData.append('fileKey', fileMeta.fileKey);
		formData.append('jsonData', JSON.stringify(com.getData(area)));

		onm.ajax({
			url: _contextPath_ + '/cmn/fileUpload.json',
			data : formData,
			type: 'POST',
			contentType : false,
			processData : false,
			success : function(res) {
				var list = res.fileList;
				for (var idx = 0; idx < list.length; idx++) {
					var row = list[idx];
					if (imgExt.indexOf(row.fileExt) > -1) {
						edit$.summernote('insertImage', row.url);
					} else {
						row.gubun = 'new';
						area.find('#fileTable').append(com.liMake(row));
					}
				}
			}
		});
	},

	//파일목록을 받아 표시한다
	fileList: function(area, list, fileTbNm) {
		fileTbNm = fileTbNm || 'fileTable';
		for (var idx = 0; idx < list.length; idx++) {
			var row = list[idx];
			if (row.fileKind == 'F') {
				row.gubun = 'old';
				area.find('#' + fileTbNm).append(com.liMake(row));
			}
		}
	},

	//li 문자를 치환하여 반환한다.
	liMake: function(row) {
		var li$ = fileHtml.replace(/#fileSeq#/g, row.fileSeq).replace(/#fileUrl#/g, row.fileSeq ? 'javascript:com.fileDown(' + row.fileSeq + ');' : row.url)
						.replace(/#fileNm#/g, row.saveFileNm).replace(/#fileSize#/g, comma(Math.round(row.fileSize / 1000))).replace(/#gubun#/g, row.gubun);
//		console.log(li$);
		return li$;
	},

	//첨부가능 파일수 체크
	fileCntChk: function(area, files) {
		var fileCnt = area.find('.fileLi.new').length + area.find('.fileLi.old').length;
		var imgCnt = 0;
		for (var idx = 0; idx < files.length; idx++) {
			var fileType = files[idx].type;
			if (fileType.startsWith('image')) {
				imgCnt++;
			} else {
				fileCnt++;
			}
		}

		if (imgMaxCnt < imgCnt) {
			onm.alert('첨부가능 파일수(' + imgMaxCnt + ')를 초과했습니다.');
			return false;
		}

		if (fileMaxCnt < fileCnt) {
			onm.alert('첨부가능 파일수(' + fileMaxCnt + ')를 초과했습니다.');
			return false;
		}
		return true;
	},

	//파일체크
	fileChk: function(file) {
// 		console.log(file);
// 		console.log(file.size);
// 		console.log(file.type);

		var fileNm = file.name;
		var ext = fileNm.substring(fileNm.lastIndexOf('.') + 1, fileNm.length);
		if ((file.type).startsWith('image')) {
			if (imgMaxSize < file.size) {
				onm.alert('첨부가능 용량(' + (imgMaxSize / 1000 / 1000) + 'M)을 초과했습니다.');
				return false;
			}
			if (imgExt.indexOf(ext) <= -1) {
				onm.alert('허용(' + imgExt + ')되지 않은 첨부파일(' + ext + ') 형식입니다.');
				return false;
			}
		} else {
			if (fileMaxSize < file.size) {
				onm.alert('첨부가능 용량(' + (fileMaxSize / 1000 / 1000) + 'M)을 초과했습니다.');
				return false;
			}
			if (fileExt.indexOf(ext) <= -1) {
				onm.alert('허용(' + fileExt + ')되지 않은 첨부파일(' + ext + ') 형식입니다.');
				return false;
			}
		}
		return true;
	},

	//파일다운로드
	fileDown: function(fileSeq) {
//		onm.ajax({
//			url: _contextPath_ + '/cmn/fileDown.json',
//			data: {'fileSeq': fileSeq},
//			success: function(res) {
//				document.location.href = res.view.url;
//			}
//		});

//		lupin.ajaxFileDownload({
//			url : _contextPath_ + '/cmn/fileDown.json',
//			data: {'fileSeq': fileSeq}
//		});

		cvo.ajaxFileDown({url: _contextPath_ + '/cmn/fileDown.json', data: {'fileSeq': fileSeq}});
	},

	//대용량엑셀 다운로드
	csvDown: function(csvSeq) {
		cvo.ajaxFileDown({url: _contextPath_ + '/cmn/csvDown.json', data: {'csvSeq': csvSeq}});
	},

	//파일삭제
	fileDelete : function(obj) {
		$(obj).parent().removeClass('new');
		$(obj).parent().removeClass('old');
		$(obj).parent().addClass('del');
		$(obj).parent().hide();
	},


	//신규 시퀀스 가져오기
	getSeq: function(area, nm, tableNm, columnNm) {
		onm.ajax({
			url: _contextPath_ + '/cmn/seqView.json',
			data: {'tableNm': tableNm, 'columnNm': columnNm},
			success: function(res) {
				area.find('[name=' + nm + ']').val(res.view.seq);
			}
		});
	},

	//editor destroy
	editDel : function() {
		if ($('.summernote').length != 0) {
			$('.summernote').summernote('destroy');
		}
	},

	pushArry: function(row) {
		var list = [];
		var pushIds = row.pushIds.split(',');
		var pushNms = row.pushNms.split(',');
		if (pushIds[0]) {
			for (var idx = 0; idx < pushIds.length; idx++) {
				var obj = {};
				obj.userId = pushIds[idx];
				obj.userNm = pushNms[idx];
				list.push(obj);
			}
		}
		return list;
	},

	pushShow: function(list) {
		var html = '<span class="mR10 sel" style="background:#e1f9ff;border:1px solid #d2d2d2;vertical-align:middle;padding:2px;" id="push_$1" onclick="com.pushRemove(view1$, \'$1\', \'$2\');">$2 X</span>'
		var addHtml = '';
		for (var idx = 0; idx < list.length; idx++) {
			addHtml += html.replaceAll('$1', list[idx].userId).replaceAll('$2', list[idx].userNm);
		}
		$('#pushSpan').append(addHtml);
	},

	pushRemove: function(area, id, nm) {
		var pushIds = area.find('[name=pushIds]').val().split(',');
		var pushNms = area.find('[name=pushNms]').val().split(',');
		pushIds = fnRemove(pushIds, id);
		pushNms = fnRemove(pushNms, nm);
		area.find('[name=pushIds]').val(pushIds.join(','))
		area.find('[name=pushNms]').val(pushNms.join(','))
		$('#push_' + id).remove();
	},

	pushAllDel: function(area) {
		if (!area.find('[name=pushIds]').val()) {
			onm.alert('삭제할 수신자가 없습니다.');
			return false;
		}
		area.find('[name=pushIds]').val('');
		area.find('[name=pushNms]').val('');
		$('#pushSpan').html('');
	}

}
//});
