package com.wann2.cntl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.wann2.domain.Navi;
import com.wann2.service.NaviService;

@Controller
@RequestMapping("/m")
public class MobileCntl {

	private static final Logger logger = LoggerFactory.getLogger(IndexCntl.class);

	@Autowired
	private NaviService naviService;

	@RequestMapping(value={"","/mMapGoogle"}, method=RequestMethod.GET)
	public String index(Model model) {
		
		ArrayList<Navi> listNavi = naviService.listNavi();

		model.addAttribute("listNavi", listNavi);
		model.addAttribute("menuIdx", 0);
		
		return "m/mMapGoogle";
		
	}
	
	@RequestMapping(value={"/mMapDaum"}, method=RequestMethod.GET)
	public String mapDaum(Model model) {
		
		ArrayList<Navi> listNavi = naviService.listNavi();

		model.addAttribute("listNavi", listNavi);
		model.addAttribute("menuIdx", 1);
		
		return "m/mMapDaum";
		
	}
	
	@RequestMapping(value={"/mMapNaver"}, method=RequestMethod.GET)
	public String mapNaver(Model model) {
		
		ArrayList<Navi> listNavi = naviService.listNavi();

		model.addAttribute("listNavi", listNavi);
		model.addAttribute("menuIdx", 2);
		
		return "m/mMapNaver";
		
	}
	
	@RequestMapping(value={"/getDataForMapNaver"}, method={RequestMethod.POST})
    public @ResponseBody void getDataForMapNaver(
    		HttpServletRequest request,
    		HttpServletResponse response) throws Exception {
		
		request.setCharacterEncoding("UTF-8");
		
    	String addr = request.getParameter("addr");
    	
		URL urlNaver;
		StringBuffer sb = new StringBuffer();
		JSONObject jsonObj = null;
		
		urlNaver = new URL("http://openapi.map.naver.com/api/geocode.php?key=b37f67029df29035ca76ce97c158fd83&encoding=utf-8&coord=latlng&query="+addr);
		BufferedReader br = new BufferedReader(new InputStreamReader(urlNaver.openStream(), "UTF-8"));
		String inputLine;
		
		while ((inputLine = br.readLine()) != null) {
			sb.append(inputLine.trim());
		}
		
		br.close();
		jsonObj = (JSONObject)new XMLSerializer().read(sb.toString());
		
		response.setContentType("application/json; charset=UTF-8");
        PrintWriter printout = response.getWriter();
        
        printout.print(jsonObj.toString());
        printout.flush();
	}

	@RequestMapping(value={"/mMapT"}, method=RequestMethod.GET)
	public String mapT(Model model) {
		
		ArrayList<Navi> listNavi = naviService.listNavi();

		model.addAttribute("listNavi", listNavi);
		model.addAttribute("menuIdx", 3);
		
		return "m/mMapT";
		
	}

	@RequestMapping(value={"/getAddr"}, method={RequestMethod.GET})
    public @ResponseBody void getAddr(
    		HttpServletRequest request,
    		HttpServletResponse response) throws Exception {
		
		request.setCharacterEncoding("UTF-8");
		
    	String mapType = request.getParameter("mapType");
    	String callback = request.getParameter("callback");
    	
        String addr = naviService.getAddr(mapType);
		
		response.setContentType("application/json; charset=UTF-8");
        PrintWriter printout = response.getWriter();
        
        Map<String, String> dataMap = new HashMap<String ,String>();
        StringBuffer sbJson = new StringBuffer();

        sbJson.append(callback+"(");
    	dataMap.put("addr", addr); 
    	sbJson.append(new Gson().toJson(dataMap));
        sbJson.append(")");
        
        logger.info("DATA: {}", sbJson.toString());

        printout.print(sbJson.toString());
        printout.flush();
	}
	
}
