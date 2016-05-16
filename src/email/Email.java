package email;

public class Email {
	//private String senderName;
	private String senderAddress;
	private String sendDate;
	private String title;
	private Boolean flag;
	
	public Email(){
		this.senderAddress = "";
		this.sendDate = "";
		this.title = "";
		this.flag = false;
	}
	
	public Email(String senderAddress, String sendDate, String title, Boolean flag){
		this.senderAddress = senderAddress;
		this.sendDate = sendDate;
		this.title = title;
		this.flag = flag;
	}

	public String getSenderAddress() {
		return senderAddress;
	}

	public void setSenderAddress(String senderAddress) {
		this.senderAddress = senderAddress;
	}

	public String getSendDate() {
		return sendDate;
	}

	public void setSendDate(String sendDate) {
		this.sendDate = sendDate;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Boolean getFlag() {
		return flag;
	}

	public void setFlag(Boolean flag) {
		this.flag = flag;
	}

	@Override
	public String toString() {
		return "Email \n [senderAddress : " + senderAddress 
				+ ",\n sendDate : " + sendDate + 
				",\n title : " + title +
				",\n flag : " + flag + "]";
	}
}