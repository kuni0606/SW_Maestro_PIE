package servlet;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
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

import org.json.JSONException;
import org.json.JSONObject;

import db.UserInfoDAO;
import db.WidgetInfoDAO;
import model.PictureInfo;
import model.UserInfo;

/**
 * Servlet implementation class UserInfoServlet
 */

@MultipartConfig
@WebServlet(urlPatterns = { "", "/index", "/id_check", "/login", "/sign_up", "/logout", "/log_out_unload",
		"/change_pw", "/withdrawal", "/upload_back_ground",
		"/login_page", "/sign_up_page", "/edit_page", "/main_page",
		"/save_back_ground", "/get_back_ground",
		"/save_bug_report"})

public class UserInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private static final String emailRegex = "^[_a-zA-Z0-9-\\.]+@[\\.a-zA-Z0-9-]+\\.[a-zA-Z]+$";
	private static final String passwordRegex = "^[a-z0-9]{4,12}$";
	private static final String nameRegex = "^[��-�Ra-z]{2,8}$";

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String uri = request.getRequestURI();

		int lastIndex = uri.lastIndexOf("/");
		String action = uri.substring(lastIndex + 1);

		String dispatchUrl = null;
		
		//System.out.println(uri);
		//System.out.println(action);

		if (action.equals("index") || action.trim().equals("") || action.trim().equals("PIE")) {			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					if( cookie[i].getName().equals("user_code")){ // ������ Ȯ����
						//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
						//System.out.println("Index : " +cookie[i].getValue());
						userCode = cookie[i].getValue();
					}
				}
				
				if (userCode != null && !(userCode.equals("")) && Pattern.matches("^[0-9]+$", userCode)) {
					response.sendRedirect("main_page");
				} else {
					response.sendRedirect("login_page");
				}
			}
			else{
				response.sendRedirect("login_page");
			}
		} else if (action.equals("logout")) {
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code") || cookieName.equals("user_check") || cookieName.equals("user_id") || cookieName.equals("user_name")){
							cookie[i].setValue(null);
							cookie[i].setMaxAge(0);
							response.addCookie(cookie[i]);
						}
					}
				}
			}

			response.sendRedirect("");
		}
		else if( action.equals("log_out_unload") ){
			//System.out.println("������ ������ ����");
			
			boolean flag = false;
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_check") ){
							if( cookie[i].getValue().equals("true")){
								System.out.println("flag!");
								flag = true;
							}
						}
					}
				}
			}
			
			if( flag == false ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code") || cookieName.equals("user_check")){
							cookie[i].setValue(null);
							cookie[i].setMaxAge(0);
							response.addCookie(cookie[i]);
						}
					}
				}
			}
		}
		else if( action.equals("save_back_ground")){
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
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					UserInfoDAO uid = new UserInfoDAO();
					String backGroundPath = uid.selectBackGroundPathByUserCode(Integer.parseInt(userCode));
					uid.disconnect();
					
					String msg = "Success";
					
					if( backGroundPath == null ){
						msg = "NoBackGroundNum";
					}
					else{
						String newBackGroundPath = request.getParameter("back_ground_path");
						
						//System.out.println(newBackGroundPath);
						
						if( newBackGroundPath == null || newBackGroundPath.equals("") ){
							msg = "ParameterError";
						}
						else{
							uid = new UserInfoDAO();
							uid.updateBackgroundPath(Integer.parseInt(userCode), newBackGroundPath);
							uid.disconnect();
						}
					}
					
					JSONObject json = new JSONObject();
					
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
		else if( action.equals("get_back_ground")){
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
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					UserInfoDAO uid = new UserInfoDAO();
					String backGroundPath = uid.selectBackGroundPathByUserCode(Integer.parseInt(userCode));
					uid.disconnect();
					
					String msg = "Success";
					JSONObject json = new JSONObject();
					
					if( backGroundPath == null || backGroundPath.equals("") ){
						msg = "NoBackGroundNum";
					}
					else{
						try{
							json.put("back_ground_path", backGroundPath);
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
		else if( action.equals("login_page") ){
			//System.out.println("�α��� ������");
			
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
			}
			
			if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))){
				response.sendRedirect("main_page");
			}
			else{
				dispatchUrl = "LoginPage.jsp";
			}
		}
		else if( action.equals("sign_up_page") ){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
			}
			
			if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))){
				response.sendRedirect("main_page");
			}
			else{
				dispatchUrl = "SignupPage.jsp";
			}
		}
		else if( action.equals("edit_page") ){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
			}
			
			if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))){
				dispatchUrl = "EditPage.jsp";
			}
			else{
				response.sendRedirect("login_page");
			}
		}
		else if( action.equals("main_page") ){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
			}
			
			if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))){
				dispatchUrl = "MainPage.jsp";
			}
			else{
				response.sendRedirect("login_page");
			}
		} 

		if (dispatchUrl != null) {
			RequestDispatcher view = request.getRequestDispatcher(dispatchUrl);
			view.forward(request, response);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		response.setCharacterEncoding("UTF-8");

		String uri = request.getRequestURI();

		int lastIndex = uri.lastIndexOf("/");
		String action = uri.substring(lastIndex + 1);

		String dispatchUrl = null;

		//System.out.println(action);

		if (action.equals("id_check")) {
			String errorMsg = "Success";

			String id = request.getParameter("email");

			// email ���İ˻�
			if (!(Pattern.matches(emailRegex, id))) {
				errorMsg = "EmailRegixError";
			}

			// �ִ� e-mail���� �˻�
			UserInfoDAO uid = new UserInfoDAO();
			UserInfo temp = uid.selectUserInfoByUserId(id);
			uid.disconnect();

			if (temp != null) {
				errorMsg = "ExistentEmailError";
			}

			response.setContentType("text/plain");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(errorMsg);
		} else if (action.equals("sign_up")) {
			String id = request.getParameter("email");
			String pw = request.getParameter("password");
			String name = request.getParameter("name");

			String msg = "Success";

			if (id == null || id.trim().equals("")) {
				msg = "NoInputId";
			} 
			else if (pw == null || pw.trim().equals("")) {
				msg = "NoInputPassword";
			} 
			else if (name == null || name.trim().equals("")) {
				msg = "NoInputName";
			} 
			else {
				int flag = 1;

				// email ���İ˻�
				if (!(Pattern.matches(emailRegex, id))) {
					msg = "EmailRegixError";
					flag = -1;
				}

				// �ִ� e-mail���� �˻�
				UserInfoDAO uid = new UserInfoDAO();
				UserInfo temp = uid.selectUserInfoByUserId(id);
				uid.disconnect();

				if (temp != null) {
					msg = "ExistentEmailError";
					flag = -1;
				}

				// ��й�ȣ ��ȿ�� �˻� (���� ���� ���� 8~12����)
				if (!(Pattern.matches(passwordRegex, pw))) {
					msg = "PasswordRegixError";
					flag = -1;
				}

				if (!(Pattern.matches(nameRegex, name))) {
					msg = "NameRegixError";
					flag = -1;
				}

				if (flag == 1) {
					uid = new UserInfoDAO();
					uid.insertUserInfo(id, pw, name);
					uid.disconnect();

					uid = new UserInfoDAO();
					UserInfo userInfo = uid.selectUserInfoByUserId(id);
					uid.disconnect();

					WidgetInfoDAO wid = new WidgetInfoDAO();
					wid.insertLastSearchBar(userInfo.getUserCode(), 1);
					wid.disconnect();
					
					uid = new UserInfoDAO();
					uid.insertBackGround(userInfo.getUserCode(), "");
					uid.disconnect();
				}
			}
			
			JSONObject json = new JSONObject();

			try {
				json.put("msg", msg);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			response.setContentType("application/json");
			response.getWriter().write(json.toString());
		} 
		else if (action.equals("login")) {
			String id = request.getParameter("email");
			String pw = request.getParameter("password");
			
			//System.out.println(id + " : " + pw);

			//String checkBox = request.getParameter("checkbox");
			
			String msg = "Success";

			if (id == null || id.trim().equals("")) {
				msg = "NoInputId";
			} 
			else if (pw == null || pw.trim().equals("")) {
				msg = "NoInputPassword";
			}
			else {
				int flag = 1;

				// email ���İ˻�
				if (!(Pattern.matches(emailRegex, id))) {
					msg = "EmailRegixError";
					flag = -1;
				}

				// �ִ� e-mail���� �˻�
				UserInfoDAO uid = new UserInfoDAO();
				UserInfo temp = uid.selectUserInfoByUserId(id);
				uid.disconnect();

				if (temp == null) {
					msg = "NoEmailError";
					flag = -1;
				}

				// ��й�ȣ ��ȿ�� �˻� (���� ���� ���� 8~12����)
				if (!(Pattern.matches(passwordRegex, pw))) {
					msg = "PasswordRegixError";
					flag = -1;
				}

				if (flag == 1) {
					if (temp.getUserPw().equals(pw)) {
						// �α��� ����
						Cookie cookie = new Cookie("user_code", Integer.toString(temp.getUserCode()));
						
						cookie.setMaxAge(24*60*60); // 24�ð� ��Ű ����
						
						response.addCookie(cookie);
						
						cookie = new Cookie("user_name", URLEncoder.encode(temp.getUserName(), "UTF-8"));
						
						cookie.setMaxAge(24*60*60); // 24�ð� ��Ű ����
						
						response.addCookie(cookie);
						
						cookie = new Cookie("user_id", temp.getUserId());
						
						cookie.setMaxAge(24*60*60); // 24�ð� ��Ű ����
						
						response.addCookie(cookie);
						
						//if( checkBox != null ){ // ����
							cookie = new Cookie("user_check", "true");
							
							cookie.setMaxAge(24*60*60); // 24�ð� ��Ű ����
							
							response.addCookie(cookie);
						//}
						
						//response.sendRedirect("");
						
						//dispatchUrl = "MainPage.jsp";
					} 
					else {
						msg = "PasswordError";
					}
				}
			}
			
			JSONObject json = new JSONObject();
			
			//System.out.println(msg);
			
			try{
				json.put("msg", msg);
			}
			catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			response.setContentType("application/json");
			response.getWriter().write(json.toString());
		}
		else if( action.equals("save_bug_report")){
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
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String title = request.getParameter("bug_title");
					String content = request.getParameter("bug_content");
					
					String msg = "Success";
					
					if( title == null || content == null ){
						msg = "ParameterError";
					}
					else{
						UserInfoDAO uid = new UserInfoDAO();
						uid.insertBugReport(Integer.parseInt(userCode), title, content);
						uid.disconnect();
					}
					
					JSONObject json = new JSONObject();
					
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
		else if( action.equals("change_pw") ){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String currentPw = request.getParameter("current_pw");
					String newPw = request.getParameter("new_pw");
					
					String msg = "Success";
					
					if( currentPw == null || newPw == null ){
						msg = "ParameterError";
					}
					else if( currentPw.trim().equals("") || newPw.trim().equals("") ||  !(Pattern.matches(passwordRegex, currentPw)) || !(Pattern.matches(passwordRegex, newPw))){
						msg = "ParameterError";
					}
					else{
						UserInfoDAO uid = new UserInfoDAO();
						UserInfo userInfo = uid.selectUserInfoByUserCode(Integer.parseInt(userCode));
						uid.disconnect();
						
						if( userInfo.getUserPw().equals(currentPw) ){
							uid = new UserInfoDAO();
							uid.updatePassword(Integer.parseInt(userCode), newPw);
							uid.disconnect();
						}
						else{
							msg = "PasswordError";
						}
					}
					
					JSONObject json = new JSONObject();
					
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
		else if( action.equals("withdrawal")){
			String userCode = null;
			
			Cookie[] cookie = request.getCookies();
			
			if( cookie != null ){
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();
					
					if( cookieName != null ){
						if( cookieName.equals("user_code")){ // ������ Ȯ����
							//System.out.println(cookie[i].getName() + " : " + cookie[i].getValue());
							//System.out.println("Index : " +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}
				
				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					String userPw = request.getParameter("user_pw");
					
					String msg = "Success";
					
					if( userPw == null || userPw.trim().equals("") || !(Pattern.matches(passwordRegex, userPw))){
						msg = "ParameterError";
					}
					else{
						UserInfoDAO uid = new UserInfoDAO();
						UserInfo userInfo = uid.selectUserInfoByUserCode(Integer.parseInt(userCode));
						uid.disconnect();
						
						if( userInfo.getUserPw().equals(userPw) ){
							uid = new UserInfoDAO();
							uid.deleteUser(Integer.parseInt(userCode));
							uid.disconnect();
						}
						else{
							msg = "PasswordError";
						}
					}
					
					JSONObject json = new JSONObject();
					
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
		else if (action.equals("upload_back_ground")) {
			// HttpSession session = request.getSession();
			// String userCode = (String)session.getAttribute("user_code");

			// String userCode = "1"; // �ӽ� �����ڵ�

			String userCode = null;

			Cookie[] cookie = request.getCookies();

			if (cookie != null) {
				int cLen = cookie.length;
				for (int i = 0; i < cLen; i++) {
					String cookieName = cookie[i].getName();

					if (cookieName != null) {
						if (cookieName.equals("user_code")) { // ������ Ȯ����
							// System.out.println(cookie[i].getName() + " : " +
							// cookie[i].getValue());
							// System.out.println("Index : "
							// +cookie[i].getValue());
							userCode = cookie[i].getValue();
						}
					}
				}

				String msg = "Success";

				if (userCode != null && !(userCode.equals("") && Pattern.matches("^[0-9]+$", userCode))) {
					// System.out.println("Upload File
					// Directory="+getServletContext().getRealPath("/").toString());

					String applicationPath = request.getServletContext().getRealPath("");
					String uploadFilePath = applicationPath + "picture/" + userCode + "/";
					// String uploadFilePath = "C:\\PIE\\picture\\" + userCode +
					// "\\";

					java.io.File fileSaveDir = new java.io.File(uploadFilePath);
					if (!fileSaveDir.exists()) {
						fileSaveDir.mkdirs();
					}

					if (request.getPart("file").getContentType().equals("application/octet-stream")) {
						msg = "NoFile";
					} else {
						String fileName = null;

						// System.out.println(request.getParts().size());

						for (Part part : request.getParts()) {
							fileName = getFilename(part);

							if (fileName != null) {
								int fileTypeIndex = fileName.lastIndexOf(".");
								String fileType = fileName.substring(fileTypeIndex + 1);

								if (!(fileType.trim().equals("")) && (fileType.equals("png") || fileType.equals("PNG")
										|| fileType.equals("jpg") || fileType.equals("JPG") || fileType.equals("jpeg")
										|| fileType.equals("JPEG") || fileType.equals("bmp") || fileType.equals("BMP")
										|| fileType.equals("gif") || fileType.equals("GIF"))) {
									part.write(uploadFilePath + "background." + fileType);

									UserInfoDAO uid = new UserInfoDAO();
									uid.updateBackgroundPath(Integer.parseInt(userCode),
											"picture/" + userCode + "/background." + fileType);
									uid.disconnect();
								} else {
									msg = "fileTypeError";
								}
							} else {
								msg = "ParameterError!";
							}
						}
					}
				}

				JSONObject json = new JSONObject();

				try {
					json.put("msg", msg);
				} catch (JSONException e) {
					e.printStackTrace();
				}

				response.setContentType("application/json");
				response.getWriter().write(json.toString());
			} else {
				response.sendRedirect("");
			}
		} else {
			response.sendRedirect("");
		}

		if (dispatchUrl != null) {
			RequestDispatcher view = request.getRequestDispatcher(dispatchUrl);
			view.forward(request, response);
		}
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
