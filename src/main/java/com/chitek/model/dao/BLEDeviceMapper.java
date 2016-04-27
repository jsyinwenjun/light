package com.chitek.model.dao;

import java.util.List;

import com.chitek.model.entity.BLEDevice;

public interface BLEDeviceMapper {
    int deleteByPrimaryKey(String deviceId);

    int insert(BLEDevice record);

    int insertSelective(BLEDevice record);

    BLEDevice selectByPrimaryKey(String deviceId);

    int updateByPrimaryKeySelective(BLEDevice record);

    int updateByPrimaryKey(BLEDevice record);
    
    List<BLEDevice> selectAll();
}