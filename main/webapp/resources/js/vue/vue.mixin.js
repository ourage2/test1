Vue.mixin({
	data: function () {
		return {
			sortOrder: [
				{value: 'desc', text: '날짜역순'},
				{value: 'asc', text: '날짜순'}
			],
			srch: {
				pg: 1,
				// paramPaginateRecordSize: 2,
				sortOrder: 'desc'
			},
			emptyList: '조회된 내역이 없습니다',
			list: [],
			view: {},
			paginate: {}
		}
	},
	methods: {
		getParam: function () {
			var search = location.search.substring(1);
			var param = $.parseJSON('{"' + search.replace(/&/g, '","').replace(/=/g, '":"') + '"}', function (key, value) {
				return key === "" ? value : decodeURIComponent(value)
			});
			return param;
		},
		setPaginatedList: function (res) {
			this.paginate = res.paginate;

			if (res.paginate.currPage === 1) {
				this.list = res.list;
			} else {
				this.list = this.list.concat(res.list);
			}
		},
		setData: function(data, name, org) {
			this[name] = data;
			if (true === org) {
				switch($.type(data)){
					case 'array':
						this['org' + name] = $.extend(true, [], data);
						break;
					case 'object':
						this['org' + name] = $.extend(true, {}, data);
						break;
				}
			}
		},
		isDataChanged: function (name) {
			var obj1 = this['org' + name];
			var obj2 = this[name];
			var type1 = $.type(obj1);
			var type2 = $.type(obj2);

			var isObjectChanged = function (orgObj, obj) {
				for (var key in orgObj) {
					if (orgObj[key] != obj[key]) {
						return true;
					}
				}
				return false;
			};

			var isArrayChanged = function (arr1, arr2) {
				var changed = false;
				$.each(arr1, function (i, item) {
					changed = isObjectChanged(item, arr2[i]);
					if (changed) return false;
				});
				return changed;
			};

			if (type1 === 'array' && type2 === 'array') {
				return isArrayChanged(obj1, obj2);
			} else if (type1 === 'object' && type2 === 'object') {
				return isObjectChanged(obj1, obj2);
			}

			return true; // type 다르면 true ??
		},
		incPg: function (srch$) {
			if ($.type(srch$) === 'object' && srch$.jquery) {
				com.setVal(srch$, vMain.srch);
			}
			this.srch.pg++;
		},
		resetPg: function (srch$) {
			if ($.type(srch$) === 'object' && srch$.jquery) {
				$.extend(true, this.srch, com.getData(srch$));
			}
			this.srch.pg = 1;
		},
		getYmd: function (time) {
			return onm.formatDate(new Date(time));
		},
		getHms: function (time) {
			return onm.formatTimeToDate(time, 'HH:mm:ss')
		},
		formatTimeToDate: function (time, pattern) {
			return onm.formatTimeToDate(time, pattern)
		},
		hasMore: function () {
			var cur = this.paginate.currPage || 1;
			var tot = this.paginate.totalPages || 1;
			return cur >= tot;
		},
		btnMoreTxt: function () {
			var cur = this.paginate.currPage || 1;
			var tot = this.paginate.totalPages || 1;
			return '더보기(' + cur + '/' + tot + ')'
		},
		selectVal: function (e) {
			var el = e.target;
			if (!el.readOnly && !el.disabled) {
				el.select();
			}
		},
		validRefs: function(refNms) {
			if ($.type(refNms) !== 'array' || refNms.length === 0) return false;

			var i, j, refNm;
			for (i = 0; i < refNms.length; i++) {
				refNm = refNms[i];
				if($.type('refNm') !== 'string') {
					console.warn('$refs', refNm, 'not string');
					return false;
				}

				var arr = this.$refs[refNm];
				if (arr === undefined) {
					console.warn('$refs', refNm, 'not exits');
					return false;
				}
				for (j = 0; j < arr.length; j++) {
					if (!onm.checkValidity(arr[i])) return false;
				}
			}
			return true
		},
		clearInput: function (e) {
			var el = e.target;
			if (!el.readOnly && !el.disabled) {
				el.value = '';
			}
		},
		determineInputVal: function (e, i, prop) {
			var el = e.target;
			if (!el.readOnly && !el.disabled) {
				var val = $.trim(el.value);
				if (val === '') {
					el.value = this.orglist[i][prop];
				} else {
					this.orglist[i][prop] = el.value;
				}
			}
		}
	},
	computed: {
		queryParam: function () {
			return this.getParam();
		}
	}
});