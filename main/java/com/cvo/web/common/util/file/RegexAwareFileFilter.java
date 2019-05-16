package com.enpem.web.common.util.file;

import java.io.File;
import java.io.FileFilter;
import java.util.regex.Pattern;

public class RegexAwareFileFilter implements FileFilter {

	private final Pattern PATTERN;

	/**
	 * Instantiates a new regex aware file filter.
	 *
	 * @param regex the regex
	 */
	public RegexAwareFileFilter(String regex) {
		PATTERN = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);
	}

	/* (non-Javadoc)
	 * @see java.io.FileFilter#accept(java.io.File)
	 */
	@Override
	public boolean accept(File file) {
		if(file.isFile()) {
			return PATTERN.matcher(file.getName()).matches();
		}
		return true;
	}
}
