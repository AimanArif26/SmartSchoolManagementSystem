package com.smartschool.model;

public class Guardian {
	private int guardianID;
	private String guardianIC;

	public Guardian() {
	}

	public Guardian(int guardianID, String guardianIC) {
		this.guardianID = guardianID;
		this.guardianIC = guardianIC;
	}

	public int getGuardianID() {
		return guardianID;
	}

	public void setGuardianID(int guardianID) {
		this.guardianID = guardianID;
	}

	public String getGuardianIC() {
		return guardianIC;
	}

	public void setGuardianIC(String guardianIC) {
		this.guardianIC = guardianIC;
	}
}