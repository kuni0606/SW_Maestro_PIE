package model;

public class ScheduleInfo {
	private int scheduleCode;
	private String scheduleDate;
	private String scheduleTitle;
	private Boolean scheduleFlag;
	
	public ScheduleInfo(int scheduleCode, String scheduleDate, String scheduleTitle, Boolean scheduleFlag){
		this.scheduleCode = scheduleCode;
		this.scheduleDate = scheduleDate;
		this.scheduleTitle = scheduleTitle;
		this.scheduleFlag = scheduleFlag;
	}
	
	public ScheduleInfo(int scheduleCode, String scheduleDate, String scheduleTitle){
		this.scheduleCode = scheduleCode;
		this.scheduleDate = scheduleDate;
		this.scheduleTitle = scheduleTitle;
		this.scheduleFlag = false;
	}
	
	public ScheduleInfo(String scheduleDate, String scheduleTitle, Boolean scheduleFlag){
		this.scheduleCode = -1;
		this.scheduleDate = scheduleDate;
		this.scheduleTitle = scheduleTitle;
		this.scheduleFlag = scheduleFlag;
	}

	public int getScheduleCode() {
		return scheduleCode;
	}

	public void setScheduleCode(int scheduleCode) {
		this.scheduleCode = scheduleCode;
	}

	public String getScheduleDate() {
		return scheduleDate;
	}

	public void setScheduleDate(String scheduleDate) {
		this.scheduleDate = scheduleDate;
	}

	public String getScheduleTitle() {
		return scheduleTitle;
	}

	public void setScheduleTitle(String scheduleTitle) {
		this.scheduleTitle = scheduleTitle;
	}

	public Boolean getScheduleFlag() {
		return scheduleFlag;
	}

	public void setScheduleFlag(Boolean scheduleFlag) {
		this.scheduleFlag = scheduleFlag;
	}
}
