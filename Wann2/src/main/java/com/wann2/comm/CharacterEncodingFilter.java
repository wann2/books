package com.wann2.comm;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

public class CharacterEncodingFilter implements Filter {
	
	private String characterSet;

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.characterSet = config.getInitParameter("characterSet");
	}
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
		if (req.getCharacterEncoding() == null) {
			req.setCharacterEncoding(characterSet);
			chain.doFilter(req, resp);
		}

	}

	@Override
	public void destroy() {}
	
}