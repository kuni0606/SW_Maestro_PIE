package model;

public class PictureInfo {
	@Override
	public String toString() {
		return "PictureInfo [pictureCode=" + pictureCode + ", picturePath=" + picturePath + "]";
	}

	private int pictureCode;
	private String picturePath;
	
	public PictureInfo(){
		this.pictureCode = -1;
		this.picturePath = "";
	}
	
	public PictureInfo(int pictureCode, String picturePath){
		this.pictureCode = pictureCode;
		this.picturePath = picturePath;
	}
	
	public int getPictureCode() {
		return pictureCode;
	}

	public void setPictureCode(int pictureCode) {
		this.pictureCode = pictureCode;
	}

	public String getPicturePath() {
		return picturePath;
	}

	public void setPicturePath(String picturePath) {
		this.picturePath = picturePath;
	}
}
