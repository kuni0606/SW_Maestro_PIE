package model;

public class UserInfo {
	private int userCode;
	private String userId;
	private String userPw;
	private String userName;
	
	public UserInfo(){
		this.userCode = -1;
		this.userId = "";
		this.userPw = "";
		this.userName = "";
	}
	
	public UserInfo(int userCode, String userId, String userPw, String userName){
		this.userCode = userCode;
		this.userId = userId;
		this.userPw = userPw;
		this.userName = userPw;
	}
	
	public UserInfo(String userId, String userPw){
		this.userCode = -1;
		this.userId = userId;
		this.userPw = userPw;
		this.userName = "";
	}
	
	public UserInfo(int userCode, String userId, String userName){
		this.userCode = userCode;
		this.userId = userId;
		this.userPw = "";
		this.userName = userName;
	}
	
	public UserInfo(String userId, String userPw, String userName){
		this.userCode = -1;
		this.userId = userId;
		this.userPw = userPw;
		this.userName = userName;
	}	
	
	public UserInfo(int userCode, String userName){
		this.userCode = userCode;
		this.userId = "";
		this.userPw = "";
		this.userName = userName;
	}

	public int getUserCode() {
		return userCode;
	}

	public void setUserCode(int userCode) {
		this.userCode = userCode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPw() {
		return userPw;
	}

	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}
