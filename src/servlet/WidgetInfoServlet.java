package servlet;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.regex.Pattern;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import db.WidgetInfoDAO;
import email.Email;
import email.ReadingGoogleEmail;
import email.ReadingNaverEmail;
import model.BookMarkInfo;
import model.EmailInfo;
import model.NoteInfo;
import model.PictureInfo;
import model.ScheduleInfo;
import model.WidgetInfo;
import sun.misc.Perf.GetPerfAction;

/**
 * Servlet implementation class WidgetInfoServlet
 */

@MultipartConfig
@WebServlet(urlPatterns = {"/get_widget_list", "/update_widget", "/update_widget_content", "/get_widget_content", 
		"/last_search_bar", "/get_email_id",
		"/get_email_list", "/add_email_info", "/get_new_email_cnt", //"/delete_email_info", 
		"/save_book_mark", "/get_book_mark", "/delete_book_mark",
		"/upload_picture", "/get_picture_list", "/delete_picture",
		"/update_schedule", "/get_schedule_list"})

public class WidgetInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String uri = request.getRequestURI();
		
		int lastIndex = uri.lastIndexOf("/");
		String action = uri.substring(lastIndex+1);
		
		String dispatchUrl = null;
		//System.out.println(session.getId());
		//System.out.println(action);
		
		if( action.equals("get_widget_list")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String errorMsg = "Success";
					
					JSONObject json = new JSONObject();
					JSONArray widgetList = new JSONArray();
					JSONObject widget;
					
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<WidgetInfo> tempList = wid.selectWidgetInfoByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					wid = new WidgetInfoDAO();
					
					int lastSearchBar = wid.selectLastSearchBarByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					try {
						for (int i = 0; i < tempList.size(); i++) {
							widget = new JSONObject();
						
							widget.put("w_Code", tempList.get(i).getWidgetCode());
							widget.put("widgetId", tempList.get(i).getWidgetId());
							widget.put("widgetType", tempList.get(i).getWidgetType());
							widget.put("xPos", tempList.get(i).getWidgetXPos());
							widget.put("yPos", tempList.get(i).getWidgetYPos());
							widget.put("xSize", tempList.get(i).getWidgetXSize());
							widget.put("ySize", tempList.get(i).getWidgetYSize());
							
							//System.out.println(tempList.get(i));

							widgetList.put(widget);
							
							//System.out.println(widget.toString());
						}

						json.put("widgetList", widgetList);
						json.put("lastSearchBar", lastSearchBar);
						json.put("msg", errorMsg);
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("last_search_bar")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String lastSearchBar = request.getParameter("last_search_bar");
					
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					wid.updateLastSearchBar(Integer.parseInt(userCode), Integer.parseInt(lastSearchBar));
					
					wid.disconnect();
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("get_new_email_cnt") ){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<EmailInfo> emailInfoList = wid.selectEmailInfoByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					if( emailInfoList.size() == 0 ){ // 등록된 이메일 정보 없음
						msg = "NoEmailInfo";
						
						try{
							json.put("msg", msg);
						}
						catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					else{
						JSONArray newEmailList = new JSONArray();
						JSONObject newEmailInfo;
						
						for(EmailInfo tempEmailInfo : emailInfoList){		
							int newMailCnt = -1;
							
							if( tempEmailInfo.getEmailType() == 1 ){ // Google
								ReadingGoogleEmail rge = new ReadingGoogleEmail(tempEmailInfo.getEmailId(), tempEmailInfo.getEmailPw());
								newMailCnt = rge.getNewMailCount();
							}
							else if( tempEmailInfo.getEmailType() == 2 ){ // Naver
								ReadingNaverEmail rne = new ReadingNaverEmail(tempEmailInfo.getEmailId(), tempEmailInfo.getEmailPw());
								newMailCnt = rne.getNewMailCount();
							}	
							
							if( newMailCnt == -1 ){
								msg = "ID/PW Error!";
							}
							else{
								try{
									newEmailInfo = new JSONObject();
										
									newEmailInfo.put("emailType", tempEmailInfo.getEmailType());
									newEmailInfo.put("newEmailCnt", newMailCnt);
									
									newEmailList.put(newEmailInfo);
								}
								catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
						}
						
						try{					
							json.put("newEmailCntList", newEmailList); 
							json.put("msg", msg);
						}
						catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("get_email_list") ){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<EmailInfo> emailInfoList = wid.selectEmailInfoByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					String emailType = request.getParameter("email_type");
					
					if( emailType != null && emailInfoList.size() != 0 ){
						int emailTypeNum = Integer.parseInt(emailType);
			
						String emailId = "";
						String emailPw = "";
						int flag = -1;
						
						for(EmailInfo tempEmailInfo : emailInfoList){
							if( tempEmailInfo.getEmailType() == emailTypeNum ){ // Google
								flag = 1;
								emailId = tempEmailInfo.getEmailId();
								emailPw = tempEmailInfo.getEmailPw();
								break;
							}
						}
						
						if( flag == 1 ){					
							JSONArray emailList = new JSONArray();
							JSONObject emailInfo;
							
							ArrayList<Email> emailContent = new ArrayList<Email>();
									
							if( emailTypeNum == 1 ){ // Google
								ReadingGoogleEmail rge = new ReadingGoogleEmail(emailId, emailPw);
								emailContent = rge.readMail();
							}
							else if( emailTypeNum == 2 ){ // Naver
								ReadingNaverEmail rne = new ReadingNaverEmail(emailId, emailPw);
								emailContent = rne.readMail();
							}
							
							
							if( emailContent == null ){
								msg = "ID/PW Error!";
							}
							else{
								try{
									for(Email tempEmail : emailContent){
										emailInfo = new JSONObject();
												
										emailInfo.put("sender_address", tempEmail.getSenderAddress());
										emailInfo.put("send_date", tempEmail.getSendDate());
										emailInfo.put("title", tempEmail.getTitle());
										emailInfo.put("flag", tempEmail.getFlag());
												
										emailList.put(emailInfo);
									}
									
									json.put("email_list", emailList); 
								}
								catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
						}
						else{
							msg = "NoEmailInfo";
						}
					}
					else if( emailType == null ){
						msg = "EmailTypeNull";
					}
					else{
						msg = "NoEmailInfo";
					}
					
						
					try{
						json.put("msg", msg);
					}
					catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("get_email_id") ){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String emailType = request.getParameter("email_type");
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					if( emailType != null ){
						WidgetInfoDAO wid = new WidgetInfoDAO();
						EmailInfo emailInfo = wid.selectEmailInfoByUserCodeEmailType(Integer.parseInt(userCode), Integer.parseInt(emailType));
						wid.disconnect();
						
						if( emailInfo != null ){
							try{
								json.put("email_id", emailInfo.getEmailId());
							}
							catch (JSONException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
						else{
							msg = "NoEmailInfo";
						}
					}
					else{
						msg = "ParameterError";
					}
					
					try{
						json.put("msg", msg);
					}
					catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("get_schedule_list")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<ScheduleInfo> scheduleList = wid.selectScheduleInfoByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					if( scheduleList.size() == 0 ){
						msg = "NoSchedule";
					}
					else{
						JSONArray scheduleListJson = new JSONArray();
						JSONObject scheduleInfo;
						
						try{
							for(ScheduleInfo temp : scheduleList){
								scheduleInfo = new JSONObject();
								
								scheduleInfo.put("date", temp.getScheduleDate());
								scheduleInfo.put("task", temp.getScheduleTitle());
								scheduleInfo.put("check", temp.getScheduleFlag().toString());
								
								scheduleListJson.put(scheduleInfo);
							}
							
							json.put("scheduleList", scheduleListJson);
						}
						catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					try{
						json.put("msg", msg);
					}
					catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("get_picture_list")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<PictureInfo> pictureList = wid.selectPictureInfoByUserCode(Integer.parseInt(userCode));
					
					wid.disconnect();
					
					String msg = "Success";
					
					JSONObject json = new JSONObject();
					
					if( pictureList.size() == 0 ){
						msg = "NoPicture";
					}
					else{
						JSONArray pictureListJson = new JSONArray();
						JSONObject pictureInfo;
						
						try{
							for(PictureInfo temp : pictureList){
								pictureInfo = new JSONObject();
								
								pictureInfo.put("code", temp.getPictureCode());
								pictureInfo.put("path", temp.getPicturePath());
								
								pictureListJson.put(pictureInfo);
								
								//System.out.println(temp);
								
								//System.out.println(temp);
							}
							
							json.put("pictureList", pictureListJson);
						}
						catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					try{
						json.put("msg", msg);
					}
					catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}			
		}
		else if( action.equals("get_book_mark") ){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1";
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<BookMarkInfo> bookmarkList = wid.selectBookMarkInfoByUserCode(Integer.parseInt(userCode));
					
					if( bookmarkList.size() == 0 ){
						msg = "NoBookmark";
					}
					else{
						JSONArray bookmarkListJson = new JSONArray();
						JSONObject bookmarkInfo;
						
						try{
							for(BookMarkInfo temp : bookmarkList){
								bookmarkInfo = new JSONObject();
								
								bookmarkInfo.put("code", temp.getCode());
								bookmarkInfo.put("title", temp.getTitle());
								bookmarkInfo.put("url", temp.getContent());
								
								bookmarkListJson.put(bookmarkInfo);
								
								//System.out.println(temp);
							}
							
							json.put("bookmarkList", bookmarkListJson);
						}
						catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
					
					try{
						json.put("msg", msg);
					}
					catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		
		if( dispatchUrl != null ){
			RequestDispatcher view = request.getRequestDispatcher(dispatchUrl);
			view.forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");
		
		String uri = request.getRequestURI();
		
		int lastIndex = uri.lastIndexOf("/");
		String action = uri.substring(lastIndex+1);
		
		//String dispatchUrl = null;
		
		//System.out.println(action);
		
		if(action.equals("update_widget")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					WidgetInfoDAO wid = new WidgetInfoDAO();
					
					ArrayList<WidgetInfo> beforeWidgetList = wid.selectWidgetInfoByUserCode(Integer.parseInt(userCode));
					ArrayList<WidgetInfo> currentWidgetList = new ArrayList<WidgetInfo>();
					
					wid.disconnect();
					
					String jsonData = request.getParameter("widget_list");
					StringBuilder realData = new StringBuilder();
					
					for(int i=0; i<jsonData.length(); i++){
						if( !(jsonData.charAt(i) == '[' || jsonData.charAt(i) == ']') ){
							realData.append(jsonData.charAt(i));
						}
					}
					
					//System.out.println(realData);
					
					ArrayList<WidgetInfo> newWidget = new ArrayList<WidgetInfo>();
					
					JSONObject widgetList = new JSONObject(realData.toString());
					Iterator<Object> widgetIdIt = widgetList.keys();
					
					while(widgetIdIt.hasNext()){
						String widgetId = widgetIdIt.next().toString();
						JSONObject widget = (JSONObject)(widgetList.get(widgetId));
						
						Iterator<Object> widgetInfoit = widget.keys();
						
						WidgetInfo widgetInfo = new WidgetInfo();
						
						widgetInfo.setWidgetId(widgetId);
						//System.out.println("<<<<<"+widgetId+">>>>>");
						
						while(widgetInfoit.hasNext()){
							String dataType = widgetInfoit.next().toString();
							Object data = widget.get(dataType);
							
							if( dataType.equals("w_Code") ){
								//System.out.println("widgetCode : " + data);
								widgetInfo.setWidgetCode(Integer.parseInt(data.toString()));
							}
							else if( dataType.equals("widgetType") ){
								//System.out.println("widgetType : " + data);
								widgetInfo.setWidgetType(Integer.parseInt(data.toString()));
							}
							else if( dataType.equals("xPos") ){
								//System.out.println("xPos : " + data);
								widgetInfo.setWidgetXPos(Double.parseDouble(data.toString()));
							}
							else if( dataType.equals("yPos") ){
								//System.out.println("yPos : " + data);
								widgetInfo.setWidgetYPos(Double.parseDouble(data.toString()));
							}
							else if( dataType.equals("xSize") ){
								//System.out.println("xSize : " + data);
								widgetInfo.setWidgetXSize(Double.parseDouble(data.toString()));
							}
							else if( dataType.equals("ySize") ){
								//System.out.println("ySize : " + data);
								widgetInfo.setWidgetYSize(Double.parseDouble(data.toString()));
							}
							
							//System.out.println(dataType + " :: " + data.toString());
						}
						
						wid = new WidgetInfoDAO();
						
						if( widgetInfo.getWidgetCode() == -1 ){ // 새로 생긴 위젯
							wid.insertWidgetInfo(Integer.parseInt(userCode), widgetInfo.getWidgetId(), widgetInfo.getWidgetType(), widgetInfo.getWidgetXPos(), widgetInfo.getWidgetYPos(), widgetInfo.getWidgetXSize(), widgetInfo.getWidgetYSize());
							
							newWidget.add(widgetInfo);
						}
						else{
							wid.updateWidgetInfo(widgetInfo);
						}
						
						wid.disconnect();
						
						currentWidgetList.add(widgetInfo);
					}
					
					for(WidgetInfo before : beforeWidgetList){
						int flag = -1;
						
						for(WidgetInfo current : currentWidgetList){
							if( current.getWidgetCode() == before.getWidgetCode() ){ // 기존에 있던거
								flag = 1;
							}
						}
						
						if( flag != 1 ){ // 없어진거라는 뜻
							wid = new WidgetInfoDAO();
							wid.deleteWidgetInfoByWidgetCode(before.getWidgetCode());
							wid.disconnect();
						}
					}
					
					String msg = "Success";
					
					JSONObject json = new JSONObject();
					
					try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("get_widget_content") ){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					int widgetType = Integer.parseInt(request.getParameter("widgetType"));
			        int widgetCode = Integer.parseInt(request.getParameter("w_Code"));
			        
			        JSONObject json = new JSONObject();
			        String msg = "Success";
			        
		        	WidgetInfoDAO wid = new WidgetInfoDAO();
		        	
		        	//System.out.println(widgetType + " : " + widgetCode);
			        
			        if( widgetType == 1 ){ // 뉴스
			        	String category = wid.selectNewsInfoByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	if( category == null ){
			        		msg = "Fail";
			        	}
			        	else{
			        		try{
			        			json.put("category", category);
							}
							catch(JSONException e){
								e.printStackTrace();
							}
			        	}
			        }
			        else if( widgetType == 3 ){ // 웹페이지
			        	String url = wid.selectWebpageInfoByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	if( url == null ){
			        		msg = "Fail";
			        	}
			        	else{
			        		try{
			        			json.put("url", url);
							}
							catch(JSONException e){
								e.printStackTrace();
							}
			        	}
			        }
			        else if( widgetType == 6 ){ // 노트
			        	NoteInfo noteInfo = wid.selectNoteInfoByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	if( noteInfo == null ){
			        		msg = "Fail";
			        	}
			        	else{
			        		try{
			        			json.put("title", noteInfo.getNoteTitle());
			        			json.put("content", noteInfo.getNoteContent());
							}
							catch(JSONException e){
								e.printStackTrace();
							}
			        	}
			        }
			        
			        try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("update_widget_content")){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					int widgetType = Integer.parseInt(request.getParameter("widgetType"));
			        int widgetCode = Integer.parseInt(request.getParameter("w_Code"));
			        
			        if( widgetType == 1 ){ // 뉴스	        	
			        	String category = request.getParameter("category");
			        	
			        	WidgetInfoDAO wid = new WidgetInfoDAO();
			        	
			        	int temp = wid.selectNewsWidgetCodeByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	wid = new WidgetInfoDAO();
			        	
			        	if( temp == -1 ){
			        		wid.insertNews(widgetCode, category);
			        	}
			        	else{
			        		wid.updateNews(widgetCode, category);
			        	}
			        	
			        	wid.disconnect();
			        }
			        else if( widgetType == 3 ){ // 웹페이지
			        	String url = request.getParameter("url");
			        	
			        	WidgetInfoDAO wid = new WidgetInfoDAO();
			        	
			        	int temp = wid.selectWebpageWidgetCodeByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	wid = new WidgetInfoDAO();
			        	
			        	if( temp == -1 ){
			        		wid.insertWebpage(widgetCode, url);
			        	}
			        	else{
			        		wid.updateWebpage(widgetCode, url);
			        	}
			        	
			        	wid.disconnect();
			        }
			        else if( widgetType == 6 ){ // 노트
			        	String title = request.getParameter("title");
			        	String content = request.getParameter("content");
			        	
			        	if( title == null ){
			        		title = "";
			        	}
			        	
			        	WidgetInfoDAO wid = new WidgetInfoDAO();
			        	
			        	int temp = wid.selectNoteWidgetCodeByWidgetCode(widgetCode);
			        	
			        	wid.disconnect();
			        	
			        	wid = new WidgetInfoDAO();
			        	
			        	if( temp == -1 ){
			        		wid.insertNote(widgetCode, title, content);
			        	}
			        	else{
			        		wid.updateNote(widgetCode, title, content);
			        	}
			        	
			        	wid.disconnect();
			        }
			        
			        String msg = "Success";
			        JSONObject json = new JSONObject();
			        
			        try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("add_email_info")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			//System.out.println("애드 이메일");
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String emailType = request.getParameter("email_type");
					String emailId = request.getParameter("email_id");
					String emailPw = request.getParameter("email_pw");
					
					String msg = "Success";
					boolean flag = true;
					
					if( emailType != null ){
						if( Integer.parseInt(emailType) == 1 ){
							ReadingGoogleEmail rge = new ReadingGoogleEmail(emailId, emailPw);
							flag = rge.checkIdPw();
						}
						else if( Integer.parseInt(emailType) == 2 ){
							ReadingNaverEmail rne = new ReadingNaverEmail(emailId, emailPw);
							flag = rne.checkIdPw();
						}
					}
					
					if( flag ){
						WidgetInfoDAO wid = new WidgetInfoDAO();
						
						EmailInfo tempEmailInfo = wid.selectEmailInfoByUserCodeEmailType(Integer.parseInt(userCode), Integer.parseInt(emailType));
						
						wid.disconnect();
						
						if( tempEmailInfo == null ){
							//String widgetCode = request.getParameter("w_code");
							
							wid = new WidgetInfoDAO();
							
							int widgetCode = wid.selectWidgetCodeByUserCodeWidgetType(Integer.parseInt(userCode), 2);
							
							wid.disconnect();
							
							wid = new WidgetInfoDAO();
							
							wid.insertEmailInfo(Integer.parseInt(userCode), widgetCode, Integer.parseInt(emailType), emailId, emailPw);
							
							wid.disconnect();
						}
						else{
							wid = new WidgetInfoDAO();
							
							wid.updateEmailInfo(Integer.parseInt(userCode), Integer.parseInt(emailType), emailId, emailPw);
							
							wid.disconnect();
						}
					}
					else{
						msg = "ID/Password Error!";
					}
					
			        JSONObject json = new JSONObject();
			        
			        try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}			
		}
		/*else if(action.equals("delete_email_info")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					if( cookie[i].getName().equals("user_code")){ // 여러대 확인해
						//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
						//System.out.println("Index : " +cookie[i].getValue());
						userCode = cookie[i].getValue();
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					// 집어 넣어
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
			
			
			String emailType = request.getParameter("email_type");
			
			WidgetInfoDAO wid = new WidgetInfoDAO();
			
			EmailInfo tempEmailInfo = wid.selectEmailInfoByUserCodeEmailType(Integer.parseInt(userCode), Integer.parseInt(emailType));
			
			wid.disconnect();
			
			if( tempEmailInfo != null ){
				wid = new WidgetInfoDAO();
				
				wid.deleteEmailInfoByUserCodeEmailType(Integer.parseInt(userCode), Integer.parseInt(emailType));
				
				wid.disconnect();
			}
		}*/
		else if(action.equals("upload_picture")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					//System.out.println("Upload File Directory="+getServletContext().getRealPath("/").toString());
					
					String applicationPath = request.getServletContext().getRealPath("");
					String uploadFilePath = applicationPath + "picture/" + userCode + "/";
			        //String uploadFilePath = "C:\\PIE\\picture\\" + userCode + "\\";
			          
			        java.io.File fileSaveDir = new java.io.File(uploadFilePath);
			        if (!fileSaveDir.exists()) {
			            fileSaveDir.mkdirs();
			        }
			         
			        String msg = "Success";
			        
			        if( request.getPart("file").getContentType().equals("application/octet-stream") ){
			        	msg = "NoFile";
			        }
			        else{
			        	WidgetInfoDAO wid = new WidgetInfoDAO();
			        	
			        	ArrayList<PictureInfo> pictureList = wid.selectPictureInfoByUserCode(Integer.parseInt(userCode));
			        	
			        	wid.disconnect();
			        	
			        	//System.out.println(uploadFilePath);
			        	//System.out.println("업로드 파일 갯수 : " + request.getParts().size());
			        	//System.out.println("DB에 있는 파일 갯수 : " + pictureList.size());
			        	
			        	if (((request.getParts().size()) + (pictureList.size())) > 10 ){
			        		msg = "TooMuchFile";
			        	}
			        	else{
			        		// To do
				        	// File name : JPG / JPEG / PNG 만 받기
				        	// File size : X mb 이하만 받기
				        	
				        	String fileName = null;
					       
					        //System.out.println(request.getParts().size());
					        
					        int uploadFileCnt = 0;
					        
					        for (Part part : request.getParts()) {
					            fileName = getFilename(part);
					            
					            if( fileName != null ){
					            	int fileTypeIndex = fileName.lastIndexOf(".");
						    		String fileType = fileName.substring(fileTypeIndex+1);
						    		
						    		if( !(fileType.trim().equals("")) && (fileType.equals("png") || fileType.equals("PNG") || fileType.equals("jpg") || fileType.equals("JPG") || fileType.equals("jpeg") || fileType.equals("JPEG"))){
						    			int randomNum = -1;
						            	
						            	wid = new WidgetInfoDAO();
						            	
						            	while(true){
						            		randomNum = (int)(Math.random() * 100000000);
						    				if(wid.selectPictureCodeByPictureCode(randomNum) == -1){
						    					//System.out.println(randomNum);
						    					break;
						    				}
						            	}
						            	
						            	wid.disconnect();
						            	
						            	part.write(uploadFilePath + Integer.toString(randomNum)+"." + fileType);
						            	
						            	//String widgetCode = request.getParameter("w_code");
						            	
						            	wid = new WidgetInfoDAO();
						            	
						            	int widgetCode = wid.selectWidgetCodeByUserCodeWidgetType(Integer.parseInt(userCode), 5);
						            	
						            	wid.disconnect();
						            	
						            	wid = new WidgetInfoDAO();
						            	wid.insertPictureInfo(Integer.parseInt(userCode), widgetCode, randomNum, "picture/"+userCode+"/"+Integer.toString(randomNum)+"."+fileType);
						            	wid.disconnect();
						            	
						            	uploadFileCnt++;
						    		}
						    		else{
						    			msg = "fileTypeError";
						    		}
					            }
					            else{
					            	msg = "ParameterError!";
					            }
					        }
					        
					        if( uploadFileCnt != request.getParts().size() ){
					        	msg = "Fail";
					        }
			        	}
			        }
					
			        JSONObject json = new JSONObject();
			        
			        try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("delete_picture")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String msg = "Success";
					
					if( userCode == null || userCode.equals("") ){
						msg = "Fail";
					}
					else{
						String code = request.getParameter("picture_code");
						
						if( code == null || code == "" ){
							msg = "ParameterError";
						}
						else{
							WidgetInfoDAO wid = new WidgetInfoDAO();
							PictureInfo pictureInfo = wid.selectPictureInfoByPictureCode(Integer.parseInt(code));
							wid.disconnect();
							
							if( pictureInfo == null ){
								msg = "NoPicture";
							}
							else{
								String applicationPath = request.getServletContext().getRealPath("");
								
								//System.out.println(applicationPath + pictureInfo.getPicturePath());
								
								try{
									Files.delete(Paths.get(applicationPath + pictureInfo.getPicturePath()));
								}
								catch(Exception e){
									msg = "DeleteFail";
								}
								
								wid = new WidgetInfoDAO();
								wid.deletePictureInfoByPictureCode(Integer.parseInt(userCode), Integer.parseInt(code));
								wid.disconnect();
							}
						}			
					}
					
					JSONObject json = new JSONObject();
			        
			        try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if(action.equals("update_schedule")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String jsonData = request.getParameter("schedule_list");
					
					//System.out.println(jsonData);
					
					JSONObject scheduleDateList = new JSONObject(jsonData.toString());
					Iterator<Object> scheduleDateIt = scheduleDateList.keys();
					
					while(scheduleDateIt.hasNext()){ // 날짜 1개에 대해				
						String scheduleDate = scheduleDateIt.next().toString();
						JSONArray scheduleArray = (JSONArray)(scheduleDateList.get(scheduleDate));
						
						WidgetInfoDAO wid = new WidgetInfoDAO();
						
						wid.deleteScheduleInfoByUserCodeScheduleDate(Integer.parseInt(userCode), scheduleDate);
						
						wid.disconnect();
						
						//System.out.println(scheduleDate + " : " + scheduleArray.length());
						
						for(int i=0 ; i<scheduleArray.length(); i++){
							JSONObject taskJson = new JSONObject(scheduleArray.get(i).toString());
							Iterator<Object> taskIt = taskJson.keys();
							
							//System.out.println(taskJson.toString());
							
							String task = "";
							int flag = -1;
							
							while(taskIt.hasNext()){						
								String dataType = taskIt.next().toString();
								Object data = taskJson.get(dataType);
								
								if( dataType.equals("task") ){
									task = data.toString();
								}
								else if( dataType.equals("check") ){
									if( data.toString().equals("true") ){
										flag = 1;
									}
									else{
										flag = 0;
									}
								}
							}
							
							//String widgetCode = request.getParameter("w_code");
							
							wid = new WidgetInfoDAO();
							
							int widgetCode = wid.selectWidgetCodeByUserCodeWidgetType(Integer.parseInt(userCode), 4);
							
							wid.disconnect();
							
							wid = new WidgetInfoDAO();
							
							wid.insertSchedule(Integer.parseInt(userCode), widgetCode, scheduleDate, task, flag);
							
							wid.disconnect();
						}
					}
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("save_book_mark")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String title = request.getParameter("bookmark_title");
					String url = request.getParameter("bookmark_url");
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					if( title == null || url == null ){
						msg = "ParameterError";
					}
					else{
						if( title.equals("") || url.equals("") ){
							msg = "NoParameter";
						}
						else{
							//String widgetCode = request.getParameter("w_code");
							
							WidgetInfoDAO wid = new WidgetInfoDAO();
							
							int widgetCode = wid.selectWidgetCodeByUserCodeWidgetType(Integer.parseInt(userCode), 8);
							
							wid.disconnect();
							
							if( widgetCode != -1 ){
								wid = new WidgetInfoDAO();
								
								int code = wid.insertBookmark(Integer.parseInt(userCode), widgetCode, title, url);
								
								wid.disconnect();
								
								if( code == -1 ){
									msg = "SaveError";
								}
								else{
									try{
										json.put("code", code);
									}
									catch(JSONException e){
										e.printStackTrace();
									}
								}
							}
							else{
								msg = "SaveError!";
							}
						}
					}
					
					try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
		else if( action.equals("delete_book_mark")){
			//HttpSession session = request.getSession();
			//String userCode = (String)session.getAttribute("user_code");
			
			//String userCode = "1"; // 임시 유저코드
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // 여러대 확인해
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String code = request.getParameter("bookmark_code");
					
					JSONObject json = new JSONObject();
					String msg = "Success";
					
					if( code == null ){
						msg = "ParameterError";
					}
					else{
						if( code.equals("") ){
							msg = "NoParameter";
						}
						else{
							WidgetInfoDAO wid = new WidgetInfoDAO();
							
							wid.deleteBookmarkByUserCodeBookmarkCode(Integer.parseInt(userCode), Integer.parseInt(code));
							
							wid.disconnect();
						}
					}
					
					try{
						json.put("msg", msg);
					}
					catch(JSONException e){
						e.printStackTrace();
					}
					
					response.setContentType("application/json");
					response.getWriter().write(json.toString());
				} else {
					response.sendRedirect("");
				}
			}
			else{
				response.sendRedirect("");
			}
		}
				
		/*if( dispatchUrl != null ){
			RequestDispatcher view = request.getRequestDispatcher(dispatchUrl);
			view.forward(request, response);
		}*/
	}
	
	private String getFilename(Part part) {
        String contentDispositionHeader = part.getHeader("content-disposition");
        String[] elements = contentDispositionHeader.split(";");
        
        for(String element:elements){
        	if( element.trim().startsWith("filename")){
        		return element.substring(element.indexOf('=')+1).trim().replace("\"", "");
        	}
        }
        
        return null;
	}
}
