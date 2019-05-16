package com.enpem.web.common.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.enpem.web.common.data.Box;

public class BoxUtil {

	/**
	 * To box.
	 *
	 * @param obj the obj
	 * @return the box
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public static Box toBox(Object obj) {
		Box box = null;
		if(obj != null) {
			if(obj instanceof Map) {
				box = new Box((Map)obj);
			} else if(obj instanceof String) {
				String objStr = (String)obj;
				if(StringUtil.isNotEmpty(objStr)) {
					box = JsonUtil.toObject(objStr, Box.class);
				}
			} else {
				box = JsonUtil.convertValue(obj, Box.class);
			}
		}
		return box;
	}

	/**
	 * copy box.
	 *
	 * @param obj the obj
	 * @return the box
	 */
	public static Box copy(Object obj) {

		Box newBox = null;
		ByteArrayOutputStream byteArrOs = null;
		ObjectOutputStream objOs = null;
		ByteArrayInputStream byteArrIs = null;
		ObjectInputStream objIs;
		Object deepCopy;
		try {
			Box orgMap = new Box((Box)obj);
			byteArrOs = new ByteArrayOutputStream();
			objOs = new ObjectOutputStream(byteArrOs);
			objOs.writeObject(orgMap);
			byteArrIs = new ByteArrayInputStream(byteArrOs.toByteArray());
			objIs = new ObjectInputStream(byteArrIs);
			deepCopy = objIs.readObject();
			newBox = (Box)deepCopy;
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} finally {
			if (null != byteArrIs) { byteArrIs = null; }
			if (null != byteArrOs) { byteArrOs = null; }
			if (null != objOs) { objOs = null; }
		}
		return newBox;
	}

	/**
	 * copy box.
	 *
	 * @param obj the obj
	 * @return the box
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public static Box copyAll(Object obj) {
		Box box = new Box();
		Box reBox = new Box();
		if(obj != null) {
			if(obj instanceof Map) {
				Map map = (Map)obj;
				for (Object key : map.keySet()) {
					if (map.get(key) instanceof Map) {
//						LOG.debug(">>>>map:" + key + "     " + map.get(key));
						Map inMap = new HashMap((Map)map.get(key));
						box.put((String)key, inMap);
						reBox.putAll(copy(box));
					} else if (map.get(key) instanceof List) {
//						LOG.debug(">>>>list:" + key + "     " + map.get(key));
						List inList = new ArrayList((ArrayList)map.get(key));
						box.put((String)key, inList);
						List<Box> boxLst = new ArrayList<Box>();
						for(Box rowBox : box.getList((String)key)){
							boxLst.add(rowBox);
						}
						reBox.put((String)key, boxLst);
					} else {
//						LOG.debug(">>>>normal:" + key + "     " + map.get(key));
						box.put((String)key, map.get(key));
					}
				}
			}
		}
		return reBox;

	}

	/**
	 * copy List<Box>.
	 *
	 * @param obj the obj
	 * @return the List<Box>
	 */
	public static List<Box> listCopy(List<Box> obj) {
		List<Box> reBox = new ArrayList<Box>();
		if(obj != null) {
			for(Object rowBox : obj){
				reBox.add((Box) rowBox);
			}
		}
		return reBox;
	}


	/**
	 * List<Box> 필터 : AND (조건식을 모두 만족해야 처리)
	 * BoxUtil.listFilter(list, "aplStrDate", "20130201", "aplEndDate", "20140302"); //원본 list 객체, box안의 비교할 키값, 비교 값
	 *
	 * @param list
	 * @param ifStrArry
	 * @return
	 */
	public static List<Box> listFilter(List<Box> list, String... ifStrArry) {
		List<Box> filterList = new ArrayList<Box>();
		if (null == list || list.isEmpty()) {
			return filterList;
		}
		if (null == ifStrArry) {
			return filterList;
		}

		int ifStrCnt = ifStrArry.length;
		if (ifStrCnt < 2 || (ifStrCnt % 2) == 1) {
			return filterList;
		}

		for (Box rowBox : list) {
			boolean isFlag = true;
			Box filterBox = new Box();

			for (int idx = 0; idx < ifStrCnt / 2; idx++) {
				int ifIdx = idx * 2;
				String key = ifStrArry[ifIdx];
				String ifVal = ifStrArry[ifIdx + 1];
				if (rowBox.ne(key, ifVal)) {
					isFlag = false;
				}
			}

			if (true == isFlag) {
				filterBox.putAll(rowBox);
				filterList.add(filterBox);
			}
		}

		return filterList;
	}

	/**
	 * List<Box> 필터 : OR (조건식중 하나만 만족하면 처리)
	 * BoxUtil.listFilterOr(list, "aplStrDate", "20130201", "aplEndDate", "20140302"); //원본 list 객체, box안의 비교할 키값, 비교 값
	 *
	 * @param list
	 * @param ifStrArry
	 * @return
	 */
	public static List<Box> listFilterOr(List<Box> list, String... ifStrArry) {
		List<Box> filterList = new ArrayList<Box>();
		if (null == list || list.isEmpty()) {
			return filterList;
		}
		if (null == ifStrArry) {
			return filterList;
		}

		int ifStrCnt = ifStrArry.length;
		if (ifStrCnt < 2 || (ifStrCnt % 2) == 1) {
			return filterList;
		}

		for (Box rowBox : list) {
			boolean isFlag = false;
			Box filterBox = new Box();

			for (int idx = 0; idx < ifStrCnt / 2; idx++) {
				int ifIdx = idx * 2;
				String key = ifStrArry[ifIdx];
				String ifVal = ifStrArry[ifIdx + 1];
				if (rowBox.eq(key, ifVal)) {
					isFlag = true;
				}
			}

			if (true == isFlag) {
				filterBox.putAll(rowBox);
				filterList.add(filterBox);
			}
		}

		return filterList;
	}

	/**
	 * list를 반으로 나눠 반환
	 * BoxUtil.getHalf(list, 0); //0은 짝수 1은 홀수 row를 담아서 반환한다
	 * @param list
	 * @param flag
	 * @return
	 */
	public static List<Box> getHalf(List<Box> list, int flag) {
		List<Box> halfList = new ArrayList<Box>();
		if (flag > 2 || flag < 0) {
			return halfList;
		}
		if (null == list || list.isEmpty()) {
			return halfList;
		}

		int idx = 0;
		for (Box rowBox : list) {
			if (flag == 0) {
				if (idx % 2 == 0) {
					halfList.add(rowBox);
				}
			} else {
				if (idx % 2 == 1) {
					halfList.add(rowBox);
				}
			}
			idx++;
		}
		return halfList;
	}
}
