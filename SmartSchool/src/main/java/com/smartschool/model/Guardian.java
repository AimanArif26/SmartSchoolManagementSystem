package com.smartschool.model;

public class Guardian {

	private int guardianID;
	private String guardianIC;

	// Empty Constructor
	public Guardian() {
	}

	// Constructor with fields
	public Guardian(int guardianID, String guardianIC) {
		this.guardianID = guardianID;
		this.guardianIC = guardianIC;
	}

	// Getters and Setters
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