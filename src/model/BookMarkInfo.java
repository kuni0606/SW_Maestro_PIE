package model;

public class BookMarkInfo {
	private int code;
	private String title;
	private String content;
	
	public BookMarkInfo(){
		this.code = -1;
		this.title = "";
		this.content = "";
	}
	
	public BookMarkInfo(int code, String title, String content){
		this.code = code;
		this.title = title;
		this.content = content;
	}
	
	public BookMarkInfo(String content){
		this.code = -1;
		this.title = "";
		this.content = content;
	}

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}
