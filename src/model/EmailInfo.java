package model;

public class EmailInfo {
	private int emailType;
	private String emailId;
	private String emailPw;
	
	public EmailInfo(){
		this.emailType = -1;
		this.emailId = "";
		this.emailPw = "";
	}
	
	public EmailInfo(int emailType, String emailId, String emailPw){
		this.emailType = emailType;
		this.emailId = emailId;
		this.emailPw = emailPw;
	}
	
	public EmailInfo(String emailId, String emailPw){
		this.emailType = -1;
		this.emailId = emailId;
		this.emailPw = emailPw;
	}

	public int getEmailType() {
		return emailType;
	}

	public void setEmailType(int emailType) {
		this.emailType = emailType;
	}

	public String getEmailId() {
		return emailId;
	}

	public void setEmailId(String emailId) {
		this.emailId = emailId;
	}

	public String getEmailPw() {
		return emailPw;
	}

	public void setEmailPw(String emailPw) {
		this.emailPw = emailPw;
	}
}
