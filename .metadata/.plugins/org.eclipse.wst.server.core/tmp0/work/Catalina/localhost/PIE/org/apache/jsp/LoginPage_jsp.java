/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/8.0.22
 * Generated at: 2016-01-08 23:35:26 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class LoginPage_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent,
                 org.apache.jasper.runtime.JspSourceImports {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  private static final java.util.Set<java.lang.String> _jspx_imports_packages;

  private static final java.util.Set<java.lang.String> _jspx_imports_classes;

  static {
    _jspx_imports_packages = new java.util.HashSet<>();
    _jspx_imports_packages.add("javax.servlet");
    _jspx_imports_packages.add("javax.servlet.http");
    _jspx_imports_packages.add("javax.servlet.jsp");
    _jspx_imports_classes = null;
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public java.util.Set<java.lang.String> getPackageImports() {
    return _jspx_imports_packages;
  }

  public java.util.Set<java.lang.String> getClassImports() {
    return _jspx_imports_classes;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

final java.lang.String _jspx_method = request.getMethod();
if (!"GET".equals(_jspx_method) && !"POST".equals(_jspx_method) && !"HEAD".equals(_jspx_method) && !javax.servlet.DispatcherType.ERROR.equals(request.getDispatcherType())) {
response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "JSPs only permit GET POST or HEAD");
return;
}

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\r\n");
      out.write("<!DOCTYPE html>\r\n");
      out.write("<html lang=\"en\">\r\n");
      out.write("<head>\r\n");
      out.write("    <meta charset=\"UTF-8\">\r\n");
      out.write("    <title>Piece in everything - Login</title>\r\n");
      out.write("    <link rel=\"shortcut icon\" type=\"image/png\" href=\"image/logo.png\"/>\r\n");
      out.write("    <script src=\"http://code.jquery.com/jquery-1.10.2.js\"></script>\r\n");
      out.write("    <!-- Latest compiled and minified CSS -->\r\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css\"\r\n");
      out.write("          integrity=\"sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7\" crossorigin=\"anonymous\">\r\n");
      out.write("    <!-- Optional theme -->\r\n");
      out.write("    <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css\"\r\n");
      out.write("          integrity=\"sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r\" crossorigin=\"anonymous\">\r\n");
      out.write("    <!-- Latest compiled and minified JavaScript -->\r\n");
      out.write("    <script src=\"https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js\"\r\n");
      out.write("            integrity=\"sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS\"\r\n");
      out.write("            crossorigin=\"anonymous\"></script>\r\n");
      out.write("\t<style>\r\n");
      out.write("\t\thtml{\r\n");
      out.write("\t\twidth:100%;\r\n");
      out.write("\t\theight:100%;\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\tbody{\r\n");
      out.write("\t\twidth:100%;\r\n");
      out.write("\t\theight:100%;\r\n");
      out.write("\t\tbackground-size:cover;\r\n");
      out.write("\t\tbackground-repeat:no-repeat;\r\n");
      out.write("\t\tbackground:url('image/main_background.jpg');\r\n");
      out.write("\t\t}\r\n");
      out.write("\t\t\r\n");
      out.write("\t</style>\r\n");
      out.write("    <script type=\"text/javascript\">\r\n");
      out.write("    window.onpageshow = function (event) {\r\n");
      out.write("    \tif (event.persisted) {\r\n");
      out.write("            document.location.reload();\r\n");
      out.write("        }\r\n");
      out.write("    \t//location.href = \"http://210.118.74.117:8100/PIE/login_page\";\r\n");
      out.write("    };\r\n");
      out.write("        /* $.get(\"http://210.118.74.117:8100/PIE/get_back_ground\", function (data) {\r\n");
      out.write("            if (data.msg == 'Success') {\r\n");
      out.write("                var b_body_c = document.getElementById('body');\r\n");
      out.write("                b_body_c.style.background = \"url(\" + data.back_ground_path + \")\";\r\n");
      out.write("                b_body_c.style.backgroundRepeat = \"no-repeat\";\r\n");
      out.write("                b_body_c.style.backgroundSize = \"cover\";\r\n");
      out.write("            }\r\n");
      out.write("        }); */\r\n");
      out.write("    \r\n");
      out.write("        function login() {\r\n");
      out.write("            var regix_email = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\\.[_0-9a-zA-Z-]+){1,2}$/;\r\n");
      out.write("        \tvar regix_pw = /^[a-z0-9]{4,12}$/;\r\n");
      out.write("        \t\r\n");
      out.write("        \tvar user_email = document.getElementById(\"user_email\");\r\n");
      out.write("\t\t\tvar user_pw = document.getElementById(\"user_password\");\r\n");
      out.write("        \t\r\n");
      out.write("\t\t\tif(user_email.value == \"\"){\r\n");
      out.write("                alert(\"이메일을 입력하세요.\");\r\n");
      out.write("                user_email.focus();\r\n");
      out.write("                return;\r\n");
      out.write("            }\r\n");
      out.write("            if(regix_email.test(user_email.value) != true){\r\n");
      out.write("            \talert(\"이메일 형식이 틀렸습니다. (xx@xx.xx)\");\r\n");
      out.write("            \tuser_email.focus();\r\n");
      out.write("                return;\r\n");
      out.write("            }\r\n");
      out.write("            if(user_pw.value == \"\"){\r\n");
      out.write("                alert(\"비밀번호를 입력하세요.\");\r\n");
      out.write("                user_pw.focus();\r\n");
      out.write("                return;\r\n");
      out.write("            }\r\n");
      out.write("            if(regix_pw.test(user_pw.value) != true){\r\n");
      out.write("            \talert(\"비밀번호 형식이 틀렸습니다. (영문 / 숫자 - 4~12글자)\");\r\n");
      out.write("            \tuser_pw.focus();\r\n");
      out.write("                return;\r\n");
      out.write("            }\r\n");
      out.write("        \t\r\n");
      out.write("            $.post(\"http://210.118.74.117:8100/PIE/login\", {\r\n");
      out.write("            \temail : user_email.value,\r\n");
      out.write("            \tpassword : user_pw.value\r\n");
      out.write("            }, function(data){\r\n");
      out.write("            \tif( data.msg == \"Success\" ){\r\n");
      out.write("            \t\tlocation.href = \"http://210.118.74.117:8100/PIE/\";\r\n");
      out.write("            \t}\r\n");
      out.write("            \telse{\r\n");
      out.write("            \t\talert(data.msg);\r\n");
      out.write("            \t\talert(\"아이디 또는 비밀번호가 틀렸습니다.\");\r\n");
      out.write("            \t}\r\n");
      out.write("            });\r\n");
      out.write("        }\r\n");
      out.write("\r\n");
      out.write("        function toSignupPage() {\r\n");
      out.write("            location.href = \"http://210.118.74.117:8100/PIE/sign_up_page\";\r\n");
      out.write("        }\r\n");
      out.write("    </script>\r\n");
      out.write("</head>\r\n");
      out.write("<body>\r\n");
      out.write("<table id=\"login_Table\" style=\"width:100%\">\r\n");
      out.write("    <tbody>\r\n");
      out.write("    <tr style=\"width:100%\">\r\n");
      out.write("        <td style=\"width:40%\"></td>\r\n");
      out.write("        <td style=\"width:20%; padding-top:10%;\">\r\n");
      out.write("            <img src=\"image/logo_all.png\" width=\"400\" height=\"200\">\r\n");
      out.write("        </td>\r\n");
      out.write("        <td style=\"width:40%\"></td>\r\n");
      out.write("    </tr>\r\n");
      out.write("    <tr style=\"width:100%\">\r\n");
      out.write("        <td style=\"width:40%\"></td>\r\n");
      out.write("        <td style=\"width:20%; padding-top:5%;\">\r\n");
      out.write("        <div style=\"width:100%;\">\r\n");
      out.write("        <div style=\"width:60%; margin:auto;\">\r\n");
      out.write("                <div class=\"form-group\">\r\n");
      out.write("                    <input name=\"user_email\" id=\"user_email\" type=\"email\" class=\"form-control\" placeholder=\"Enter your E-mail\">\r\n");
      out.write("                </div>\r\n");
      out.write("                <div class=\"form-group\">\r\n");
      out.write("                    <input name=\"user_password\" id=\"user_password\" type=\"password\" class=\"form-control\" placeholder=\"Enter your Password\">\r\n");
      out.write("                </div>\r\n");
      out.write("            <div>\r\n");
      out.write("                <button style=\"float:right;\" class=\"btn btn-default\" onclick=\"login();\">Sign in</button>\r\n");
      out.write("                <button style=\"margin-right:10px; float:right;\" class=\"btn btn-default\" onclick=\"toSignupPage()\">Sign up</button>\r\n");
      out.write("            </div>\r\n");
      out.write("            </div>\r\n");
      out.write("            </div>\r\n");
      out.write("        </td>\r\n");
      out.write("        <td style=\"width:40%\"></td>\r\n");
      out.write("    </tr>\r\n");
      out.write("    </tbody>\r\n");
      out.write("</table>\r\n");
      out.write("</body>\r\n");
      out.write("</html>");
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try {
            if (response.isCommitted()) {
              out.flush();
            } else {
              out.clearBuffer();
            }
          } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
