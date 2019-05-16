package com.enpem.web.common.util.paginate;

import java.io.Serializable;

import com.enpem.web.common.data.Box;
import com.enpem.web.common.util.NumberUtil;
import com.enpem.web.common.util.StringUtil;

public class PaginateModel implements Serializable {

	/**
	 *
	 */
	private static final long serialVersionUID = -6119717142471756964L;

	// 페이지 파라미터 변수
	private String pageParam = "pg";

	// 페이지 사이즈
	private int pageSize;

	// 레코드 사이즈
	private int recordSize;

	// 현재 페이지
	private int currPage;

	// 총 레코드 수
	private int totalRecords = 0;

	// 총 페이지수
	private int totalPages;

	// 현재페이지 시작번호
	private int startNum;

	// 현재페이지 종료번호
	private int endNum;

	// 블럭 시작 페이지
	private int startPage;

	// 블럭 종료 페이지
	private int endPage;

	// 이전 블럭의 마지막 페이지
	private int prevPage;

	// 다음 블럭의 첫번째 페이지
	private int nextPage;

	// 현재 블럭
	private int currBlock;

	// 전체 블럭
	private int totalBlock;

	// paginate suffix
	private String suffix;


	public String getPageParam() {
		return pageParam;
	}

	public void setPageParam(String pageParam) {
		this.pageParam = pageParam;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
	}

	public int getRecordSize() {
		return recordSize;
	}

	public void setRecordSize(int recordSize) {
		this.recordSize = recordSize;
	}

	public int getCurrPage() {
		return currPage;
	}

	public void setCurrPage(int currPage) {
		this.currPage = currPage;
	}

	public int getTotalRecords() {
		return totalRecords;
	}

	public void setTotalRecords(int totalRecords) {
		this.totalRecords = totalRecords;
	}

	public int getTotalPages() {
		return totalPages;
	}

	public void setTotalPages(int totalPages) {
		this.totalPages = totalPages;
	}

	public int getStartNum() {
		return startNum;
	}

	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}

	public int getEndNum() {
		return endNum;
	}

	public void setEndNum(int endNum) {
		this.endNum = endNum;
	}

	public int getStartPage() {
		return startPage;
	}

	public void setStartPage(int startPage) {
		this.startPage = startPage;
	}

	public int getEndPage() {
		return endPage;
	}

	public void setEndPage(int endPage) {
		this.endPage = endPage;
	}

	public int getPrevPage() {
		return prevPage;
	}

	public void setPrevPage(int prevPage) {
		this.prevPage = prevPage;
	}

	public int getNextPage() {
		return nextPage;
	}

	public void setNextPage(int nextPage) {
		this.nextPage = nextPage;
	}

	public int getCurrBlock() {
		return currBlock;
	}

	public void setCurrBlock(int currBlock) {
		this.currBlock = currBlock;
	}

	public int getTotalBlock() {
		return totalBlock;
	}

	public void setTotalBlock(int totalBlock) {
		this.totalBlock = totalBlock;
	}

	public String getSuffix() {
		return suffix;
	}

	public void setSuffix(String suffix) {
		this.suffix = suffix;
	}

	public void init(Box paramBox) {
		String currPageStr = paramBox.getString(pageParam);
		currPage = StringUtil.isEmpty(currPageStr) ? 1 : Integer.parseInt(currPageStr);
		if(currPage<1) {
			currPage = 1;
		}
		totalPages = (totalRecords - 1) / recordSize + 1;
		if(currPage > totalPages) {
			currPage = totalPages;
		}
		startNum = (currPage - 1) * recordSize + 1;
		endNum = currPage * recordSize;
		prevPage = ((currPage - 1) / pageSize) * pageSize;
		startPage = prevPage + 1;

		nextPage = startPage + pageSize;
		endPage = nextPage - 1;
		if(endPage > totalPages) {
			endPage = totalPages;
		}
		currBlock = NumberUtil.toInt(Math.ceil((double)currPage/pageSize));
		totalBlock = NumberUtil.toInt(Math.ceil((double)totalPages/pageSize));
	}
	
	public void init2(Box paramBox) {
		String currPageStr = paramBox.getString(pageParam);
		currPage = StringUtil.isEmpty(currPageStr) ? 1 : Integer.parseInt(currPageStr);
		if (currPage < 1) {
			currPage = 1;
		}
		
		startNum = (currPage - 1) * recordSize + 1;
		endNum = currPage * recordSize;
	}

	public void init(Box paramBox, int totalRecords) {
		setTotalRecords(totalRecords);
		init(paramBox);
	}

	@Override
	public String toString() {
		return "PaginateModel [pageParam=" + pageParam + ", pageSize="
				+ pageSize + ", recordSize=" + recordSize + ", currPage="
				+ currPage + ", totalRecords=" + totalRecords + ", totalPages="
				+ totalPages + ", startNum=" + startNum + ", endNum=" + endNum
				+ ", startPage=" + startPage + ", endPage=" + endPage
				+ ", prevPage=" + prevPage + ", nextPage=" + nextPage
				+ ", currBlock=" + currBlock + ", totalBlock=" + totalBlock
				+ ", suffix=" + suffix + "]";
	}



}
