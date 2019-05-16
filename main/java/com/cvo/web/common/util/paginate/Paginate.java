package com.enpem.web.common.util.paginate;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.ui.ModelMap;

import com.enpem.web.common.constants.CmnConst;
import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.ConfigUtil;
import com.enpem.web.common.util.ExcelUtil;
import com.enpem.web.common.util.HttpUtil;
import com.enpem.web.common.util.StringUtil;

@Component
public class Paginate {

	@Value("#{config['paginate.pageUnit']}")
	private int paginatePageUnit;

	@Value("#{config['paginate.pageSize']}")
	private int paginatePageSize;

	private String getPaginateParam(String name, String suffix) {
		if(StringUtil.isNotEmpty(suffix)) {
			name = name + "_" + suffix;
		}
		return StringUtil.camelToLower(name);
	}

	public void init(Box paramBox, ModelMap modelMap, int totalRecords) throws Exception {
		PaginateModel paginateModel = init(paramBox, totalRecords);
		String paramPaginate = getPaginateParam(CmnConst.PARAM_PAGINATE, paginateModel.getSuffix());
		modelMap.addAttribute(paramPaginate, paramBox.get(paramPaginate));
	}
	
	public void init(Box paramBox, ModelMap modelMap) throws Exception {
		PaginateModel paginateModel = init(paramBox, -1);
		String paramPaginate = getPaginateParam(CmnConst.PARAM_PAGINATE, paginateModel.getSuffix());
		modelMap.addAttribute(paramPaginate, paramBox.get(paramPaginate));
	}

	public PaginateModel init(Box paramBox, int totalRecords) throws Exception {
		PaginateModel paginateModel = new PaginateModel();
		String paramPaginateSuffix = paramBox.getParameter(CmnConst.PARAM_PAGINATE_SUFFIX, "");
		paginateModel.setSuffix(paramPaginateSuffix);

		int pageUnit = paramBox.getInt("pageUnit") == 0 ? paginatePageUnit : paramBox.getInt("pageUnit");
		int paramRecordSize = paramBox.getInt(getPaginateParam(CmnConst.PARAM_PAGINATE_RECORD_SIZE, paramPaginateSuffix));
		if(paramRecordSize > 0) {
			pageUnit = paramRecordSize;
		}
		int pageSize = paginatePageSize;
		int paramPageSize = paramBox.getInt(getPaginateParam(CmnConst.PARAM_PAGINATE_PAGE_SIZE, paramPaginateSuffix));
		if(paramPageSize > 0) {
			pageSize = paramPageSize;
		}
		paginateModel.setPageParam(getPaginateParam(CmnConst.PARAM_PAGINATE_PAGE, paramPaginateSuffix));
		paginateModel.setRecordSize(pageUnit);
		paginateModel.setPageSize(pageSize);
		
		if (totalRecords == -1) 
			paginateModel.init2(paramBox);
		else
			paginateModel.init(paramBox, totalRecords);

		String paramPaginate = getPaginateParam(CmnConst.PARAM_PAGINATE, paramPaginateSuffix);
		paramBox.put(paramPaginate, paginateModel);
		if (ExcelUtil.isExcel()) {
			paginateModel.setEndNum(ConfigUtil.getInt("excel.max.row"));
		}
		return paginateModel;
	}

}

