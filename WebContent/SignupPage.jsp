<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Piece in everything - Sign up</title>
    <script src="http://code.jquery.com/jquery-1.10.2.js"></script>
<link rel="shortcut icon" type="image/png" href="image/logo.png"/>
    <!-- Latest compiled and minified CSS -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
          integrity="sha384-1q8mTJOASx8j1Au+a5WDVnPi2lkFfwwEAa8hDDdjZlpLegxhjVME1fgjWPGmkzs7" crossorigin="anonymous">
    <!-- Optional theme -->
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap-theme.min.css"
          integrity="sha384-fLW2N01lMqjakBkx3l/M9EahuwpSfeNvV63J5ezn3uZzapT0u7EYsXMjQV+0En5r" crossorigin="anonymous">
    <!-- Latest compiled and minified JavaScript -->
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"
            integrity="sha384-0mSbJDEHialfmuBBQP6A4Qrprq5OVfW37PRR3j5ELqxss1yVqOtnepnHVP9aJ7xS"
            crossorigin="anonymous"></script>
<style>
		html{
		width:100%;
		height:100%;
		}
		body{
		width:100%;
		height:100%;
		background-size:cover;
		background-repeat:no-repeat;
		background:url('image/main_background.jpg');
		}
		
	</style>
    <script type="text/javascript">
        function signUp(){
        	var regix_email = /[0-9a-zA-Z][_0-9a-zA-Z-]*@[_0-9a-zA-Z-]+(\.[_0-9a-zA-Z-]+){1,2}$/;
        	var regix_pw = /^[a-z0-9]{4,12}$/;
    		var regix_name = /^[a-zA-Z0-9가-힣]{2,8}$/;

			var user_name = document.getElementById("user_name");
			var user_email = document.getElementById("user_email");
			var user_pw = document.getElementById("user_password");
			var user_chk_pw = document.getElementById("user_password_confirm");
    		
			
            if(user_name.value == ""){
                alert("이름을 입력하세요.");
                user_name.focus();
                return;
            }
            if(regix_name.test(user_name.value) != true){
                alert("이름 형식이 틀렸습니다. (영문 / 한글 - 2~8글자)");
                user_name.focus();
                return;
            }
            if(user_email.value == ""){
                alert("이메일을 입력하세요.");
                user_email.focus();
                return;
            }
            if(regix_email.test(user_email.value) != true){
            	alert("이메일 형식이 틀렸습니다. (xx@xx.xx)");
            	user_email.focus();
                return;
            }
            if(user_pw.value == ""){
                alert("비밀번호를 입력하세요.");
                user_pw.focus();
                return;
            }
            if(regix_pw.test(user_pw.value) != true){
            	alert("비밀번호 형식이 틀렸습니다. (영문 / 숫자 - 4~12글자)");
            	user_pw.focus();
                return;
            }
            if(user_chk_pw.value == ""){
                alert("확인 비밀번호를 입력하세요.");
                user_chk_pw.focus();
                return;
            }
            if(regix_pw.test(user_chk_pw.value) != true){
            	alert("확인 비밀번호 형식이 틀렸습니다. (4~12글자 영문 / 숫자)");
            	user_chk_pw.focus();
                return;
            }
            if(!(user_pw.value == user_chk_pw.value)){
                alert("비밀번호와 확인 비밀번호가 다릅니다.");
                user_chk_pw.focus();
                return;
            }
            
            /* alert(user_email.value);
            alert(user_pw.value);
            alert(user_name.value); */
            
            $.post("http://210.118.74.117:8100/PIE/sign_up", {
            	email : user_email.value,
            	password : user_pw.value,
            	name : user_name.value
            }, function(data){
            		if( data.msg == "Success" ){
            			alert("회원가입이 완료되었습니다.");
            			location.href = "http://210.118.74.117:8100/PIE/";
            		}
            		else{
            			alert(data.msg);
            			alert("아이디 또는 비밀번호가 틀렸습니다.");
            		}
            });
        }

        function toLoginPage(){
            location.href = "http://210.118.74.117:8100/PIE/login_page";
        }
    </script>
</head>
<body>

<table id="login_Table" style="width:100%">
    <tbody>
    <tr style="width:100%">
        <td style="width:40%"></td>
        <td style="width:20%; padding-top:10%;">
            <img src="image/logo_all.png" width="400" height="200">
        </td>
        <td style="width:40%"></td>
    </tr>
    <tr style="width:100%">
        <td style="width:40%"></td>
        <td style="width:20%; padding-top:5%;">
            <div style="width:100%;">
        <div style="width:60%; margin:auto;">
            <div class="form-group">
                    <input name="user_name" id="user_name" type="text" class="form-control" placeholder="Enter your Name">
                </div>
                <div class="form-group">
                    <input name="user_email" id="user_email" type="email" class="form-control" placeholder="Enter your E-mail">
                </div>
                <div class="form-group">
                    <input name="user_password" id="user_password" type="password" class="form-control" placeholder="Enter your Password">
                </div>
                <div class="form-group">
                    <input name="user_password_confirm" id="user_password_confirm" type="password" class="form-control" placeholder="Confirm Password">
                </div>
            <div>
                <button style="float:right;" class="btn btn-default" onclick="toLoginPage()">Cancel</button>
                <button style="margin-right:10px; float:right;" class="btn btn-default" onclick="signUp()">Sign up</button>
            </div>
            </div>
            </div>
        </td>
        <td style="width:40%"></td>
    </tr>
    </tbody>
</table>
</body>
</html>