package com.chitek.model.entity;

public class BLEDevice {
    private String deviceId;

    private String qrticket;

    private String deviceLicence;

    private String customData;

    private String mac;

    private String connectProtocol;

    private String authKey;

    private Integer closeStrategy;

    private Integer connStrategy;

    private Integer cryptMethod;

    private Integer authVer;

    private Integer manuMacPos;

    private Integer serMacPos;

    private Integer bleSimpleProtocol;

    private String deviceName;
    
    private String deviceType;
    
    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId == null ? null : deviceId.trim();
    }

    public String getQrticket() {
        return qrticket;
    }

    public void setQrticket(String qrticket) {
        this.qrticket = qrticket == null ? null : qrticket.trim();
    }

    public String getDeviceLicence() {
        return deviceLicence;
    }

    public void setDeviceLicence(String deviceLicence) {
        this.deviceLicence = deviceLicence == null ? null : deviceLicence.trim();
    }

    public String getCustomData() {
        return customData;
    }

    public void setCustomData(String customData) {
        this.customData = customData == null ? null : customData.trim();
    }

    public String getMac() {
        return mac;
    }

    public void setMac(String mac) {
        this.mac = mac == null ? null : mac.trim();
    }

    public String getConnectProtocol() {
        return connectProtocol;
    }

    public void setConnectProtocol(String connectProtocol) {
        this.connectProtocol = connectProtocol;
    }

    public String getAuthKey() {
        return authKey;
    }

    public void setAuthKey(String authKey) {
        this.authKey = authKey == null ? null : authKey.trim();
    }

    public Integer getCloseStrategy() {
        return closeStrategy;
    }

    public void setCloseStrategy(Integer closeStrategy) {
        this.closeStrategy = closeStrategy;
    }

    public Integer getConnStrategy() {
        return connStrategy;
    }

    public void setConnStrategy(Integer connStrategy) {
        this.connStrategy = connStrategy;
    }

    public Integer getCryptMethod() {
        return cryptMethod;
    }

    public void setCryptMethod(Integer cryptMethod) {
        this.cryptMethod = cryptMethod;
    }

    public Integer getAuthVer() {
        return authVer;
    }

    public void setAuthVer(Integer authVer) {
        this.authVer = authVer;
    }

    public Integer getManuMacPos() {
        return manuMacPos;
    }

    public void setManuMacPos(Integer manuMacPos) {
        this.manuMacPos = manuMacPos;
    }

    public Integer getSerMacPos() {
        return serMacPos;
    }

    public void setSerMacPos(Integer serMacPos) {
        this.serMacPos = serMacPos;
    }

    public Integer getBleSimpleProtocol() {
        return bleSimpleProtocol;
    }

    public void setBleSimpleProtocol(Integer bleSimpleProtocol) {
        this.bleSimpleProtocol = bleSimpleProtocol;
    }

	public String getDeviceName() {
		return deviceName;
	}

	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}
    
    
}