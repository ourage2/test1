package com.enpem.web.common.util.file;

import java.io.File;
import java.io.FilenameFilter;

public class FilenameFilterImpl implements FilenameFilter {

	private final String fileExt;

	/**
	 * Instantiates a new filename filter impl.
	 *
	 * @param fileExt - 파일 확장자명
	 */
	public FilenameFilterImpl( String fileExt ){
		this.fileExt = fileExt;
	}

	/* (non-Javadoc)
	 * @see java.io.FilenameFilter#accept(java.io.File, java.lang.String)
	 */
	@Override
	public boolean accept(File dir, String name) {
		return name.toLowerCase( ).endsWith( fileExt );
	}
}
