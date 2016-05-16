package model;

public class WidgetInfo {
	private int widgetCode;
	private String widgetId;
	private int widgetType;
	private double widgetXPos;
	private double widgetYPos;
	private double widgetXSize;
	private double widgetYSize;
	
	public WidgetInfo(){
		this.widgetCode = -1;
		this.widgetId = "";
		this.widgetType = -1;
		this.widgetXPos = -1;
		this.widgetYPos = -1;
		this.widgetXSize = -1;
		this.widgetYSize = -1;
	}
	
	public WidgetInfo(int widgetCode, String widgetId, int widgetType, double widgetStartX, double widgetEndX, double widgetStartY, double widgetEndY){
		this.widgetCode = widgetCode;
		this.widgetId = widgetId;
		this.widgetType = widgetType;
		this.widgetXPos = widgetStartX;
		this.widgetYPos = widgetEndX;
		this.widgetXSize = widgetStartY;
		this.widgetYSize = widgetEndY;
	}
	
	public WidgetInfo(int widgetCode, String widgetId, double widgetStartX, double widgetEndX, double widgetStartY, double widgetEndY){
		this.widgetCode = widgetCode;
		this.widgetId = widgetId;
		this.widgetType = -1;
		this.widgetXPos = widgetStartX;
		this.widgetYPos = widgetEndX;
		this.widgetXSize = widgetStartY;
		this.widgetYSize = widgetEndY;
	}

	public int getWidgetCode() {
		return widgetCode;
	}

	public void setWidgetCode(int widgetCode) {
		this.widgetCode = widgetCode;
	}

	public String getWidgetId() {
		return widgetId;
	}

	public void setWidgetId(String widgetId) {
		this.widgetId = widgetId;
	}

	public int getWidgetType() {
		return widgetType;
	}

	public void setWidgetType(int widgetType) {
		this.widgetType = widgetType;
	}

	public double getWidgetXPos() {
		return widgetXPos;
	}

	public void setWidgetXPos(double widgetXPos) {
		this.widgetXPos = widgetXPos;
	}

	public double getWidgetYPos() {
		return widgetYPos;
	}

	public void setWidgetYPos(double widgetYPos) {
		this.widgetYPos = widgetYPos;
	}

	public double getWidgetXSize() {
		return widgetXSize;
	}

	public void setWidgetXSize(double widgetXSize) {
		this.widgetXSize = widgetXSize;
	}

	public double getWidgetYSize() {
		return widgetYSize;
	}

	public void setWidgetYSize(double widgetYSize) {
		this.widgetYSize = widgetYSize;
	}

	@Override
	public String toString() {
		return "WidgetInfo [widgetCode=" + widgetCode + ", widgetId=" + widgetId + ", widgetType=" + widgetType
				+ ", widgetXPos=" + widgetXPos + ", widgetYPos=" + widgetYPos + ", widgetXSize=" + widgetXSize
				+ ", widgetYSize=" + widgetYSize + "]";
	}
	
	
}
