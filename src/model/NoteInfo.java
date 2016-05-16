package model;

public class NoteInfo {
	private String noteTitle;
	private String noteContent;
	
	public NoteInfo(){
		this.noteTitle = "";
		this.noteContent = "";
	}
	
	public NoteInfo(String noteTitle, String noteContent){
		this.noteTitle = noteTitle;
		this.noteContent = noteContent;
	}
	
	public NoteInfo(String noteContent){
		this.noteTitle = "";
		this.noteContent = noteContent;
	}

	public String getNoteTitle() {
		return noteTitle;
	}

	public void setNoteTitle(String noteTitle) {
		this.noteTitle = noteTitle;
	}

	public String getNoteContent() {
		return noteContent;
	}

	public void setNoteContent(String noteContent) {
		this.noteContent = noteContent;
	}
}
