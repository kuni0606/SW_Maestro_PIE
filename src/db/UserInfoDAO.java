package db;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.UserInfo;

public class UserInfoDAO extends BaseDAO{
	public int insertUserInfo(String userId, String userPw, String userName){
		int insertRowCnt = 0;
		int randomNum = -1;
		
		PreparedStatement ps=null;
		try
		{
			String sql="INSERT INTO user_tb VALUES(?,?,?,?,1)";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setString(2,userId);
			ps.setString(3,userPw);
			ps.setString(4,userName);
			
			while(true){
				randomNum = (int)(Math.random() * 100000000);
				if(this.selectUserIdByUserCode(randomNum).equals("")){
					//System.out.println(randomNum);
					break;
				}
			}
			
			ps.setInt(1, randomNum);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
	
	public int insertBackGround(int userCode, String backGroundPath){
		int insertRowCnt = 0;
		
		PreparedStatement ps=null;
		try
		{
			String sql="INSERT INTO background_tb VALUES(?,?)";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setInt(1, userCode);
			ps.setString(2, backGroundPath);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
	
	public int insertBugReport(int userCode, String title, String content){
		int insertRowCnt = 0;
		int randomNum = -1;
		
		PreparedStatement ps=null;
		try
		{
			String sql="INSERT INTO bug_report_tb VALUES(?,?,?,?)";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setInt(1, userCode);
			ps.setString(3, title);
			ps.setString(4, content);
			
			while(true){
				randomNum = (int)(Math.random() * 100000000);
				if(this.selectBugReportCodeByBugReportCode(randomNum) == -1 ){
					//System.out.println(randomNum);
					break;
				}
			}
			
			ps.setInt(2, randomNum);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
	
	public String selectUserIdByUserCode(int userCode){
		String userId = "";
		PreparedStatement ps=null;
		
		try
		{
			String sql="SELECT * FROM user_tb WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			ps.setInt(1, userCode);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				userId = rs.getString("user_id");
			}
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return userId;
	}
	
	public int selectBugReportCodeByBugReportCode(int bugReportCode){
		int tempCode = -1;
		PreparedStatement ps=null;
		
		try
		{
			String sql="SELECT * FROM bug_report_tb WHERE bug_report_code=?";
			ps=super.getConn().prepareStatement(sql);
			ps.setInt(1, bugReportCode);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				tempCode = rs.getInt("bug_report_code");
			}
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return tempCode;
	}
	
	public String selectBackGroundPathByUserCode(int userCode){
		String backGroundPath = null;
		PreparedStatement ps=null;
		
		try
		{
			String sql="SELECT * FROM background_tb WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			ps.setInt(1, userCode);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				backGroundPath = rs.getString("back_ground_path");
			}
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return backGroundPath;
	}
	
	public UserInfo selectUserInfoByUserId(String userId){
		UserInfo userInfo = null;
		PreparedStatement ps=null;
		
		try
		{
			String sql="SELECT * FROM user_tb WHERE user_id=?";
			ps=super.getConn().prepareStatement(sql);
			ps.setString(1, userId);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				int userCode = rs.getInt("user_code");
				String userPw = rs.getString("user_password");
				String userName = rs.getString("user_name");
				int userFlag = rs.getInt("use_flag");
				
				if( userFlag == 1 ){
					userInfo = new UserInfo(userCode, userId, userPw, userName);
					userInfo.setUserName(userName);
				}
			}
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return userInfo;
	}
	
	public UserInfo selectUserInfoByUserCode(int userCode){
		UserInfo userInfo = null;
		PreparedStatement ps=null;
		
		try
		{
			String sql="SELECT * FROM user_tb WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			ps.setInt(1, userCode);
			ResultSet rs=ps.executeQuery();
			while(rs.next()){
				String userId = rs.getString("user_id");
				String userPw = rs.getString("user_password");
				String userName = rs.getString("user_name");
				int userFlag = rs.getInt("use_flag");
				
				if( userFlag == 1 ){
					userInfo = new UserInfo(userCode, userId, userPw, userName);
					userInfo.setUserName(userName);
				}
			}
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return userInfo;
	}
	
	public int updateBackgroundPath(int userCode, String backGroundPath){
		int insertRowCnt = 0;
		
		PreparedStatement ps=null;
		try
		{
			String sql="UPDATE background_tb SET back_ground_path=? WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setString(1,backGroundPath);
			ps.setInt(2,userCode);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
	
	public int updatePassword(int userCode, String newPw){
		int insertRowCnt = 0;
		
		PreparedStatement ps=null;
		try
		{
			String sql="UPDATE user_tb SET user_password=? WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setString(1,newPw);
			ps.setInt(2,userCode);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
	
	public int deleteUser(int userCode){
		int insertRowCnt = 0;
		
		PreparedStatement ps=null;
		try
		{
			String sql="DELETE FROM user_tb WHERE user_code=?";
			ps=super.getConn().prepareStatement(sql);
			
			ps.setInt(1,userCode);
			
			insertRowCnt = ps.executeUpdate();
		}
		catch (SQLException se)
		{
			System.out.println(se.getMessage());
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
		finally
		{
			if(ps!=null)
			{
				try
				{
					ps.close();
				}
				catch (SQLException se)
				{
					System.out.println(se.getMessage());
				}
			}
		}
		
		return insertRowCnt;
	}
}