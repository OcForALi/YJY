// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Lbs.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30001
#error This file was generated by a different version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class AddrInfo;
@class LbsCell;
@class LbsLocation;
@class LbsWifiMac;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - LbsRoot

/// Exposes the extension registry for this file.
///
/// The base class provides:
/// @code
///   + (GPBExtensionRegistry *)extensionRegistry;
/// @endcode
/// which is a @c GPBExtensionRegistry that includes all the extensions defined by
/// this file and all files that it depends on.
@interface LbsRoot : GPBRootObject
@end

#pragma mark - LbsLocation

typedef GPB_ENUM(LbsLocation_FieldNumber) {
  LbsLocation_FieldNumber_Latitude = 1,
  LbsLocation_FieldNumber_Longitude = 2,
  LbsLocation_FieldNumber_Altitude = 3,
  LbsLocation_FieldNumber_Accuracy = 4,
  LbsLocation_FieldNumber_Bearing = 5,
  LbsLocation_FieldNumber_Speed = 6,
  LbsLocation_FieldNumber_Time = 7,
  LbsLocation_FieldNumber_LocationId = 8,
  LbsLocation_FieldNumber_AdCode = 9,
};

//////////////// LBSData结构///////////////////////////
@interface LbsLocation : GPBMessage

///维度
@property(nonatomic, readwrite) double latitude;

///经度
@property(nonatomic, readwrite) double longitude;

///海拔高度
@property(nonatomic, readwrite) uint32_t altitude;

///精确
@property(nonatomic, readwrite) uint32_t accuracy;

///方向
@property(nonatomic, readwrite) uint32_t bearing;

///速度
@property(nonatomic, readwrite) uint32_t speed;

@property(nonatomic, readwrite) uint64_t time;

///位置ID
@property(nonatomic, readwrite) uint64_t locationId;

/// adCode
@property(nonatomic, readwrite) uint32_t adCode;

@end

#pragma mark - LbsCell

typedef GPB_ENUM(LbsCell_FieldNumber) {
  LbsCell_FieldNumber_Mcc = 1,
  LbsCell_FieldNumber_Mnc = 2,
  LbsCell_FieldNumber_Lac = 3,
  LbsCell_FieldNumber_CellId = 4,
  LbsCell_FieldNumber_Rssi = 5,
};

@interface LbsCell : GPBMessage

/// mcc	国家码 (MCC for GSM and CDMA)
@property(nonatomic, readwrite) uint32_t mcc;

/// mnc	网络码 (MNC for GSM, SystemID for CDMA)
@property(nonatomic, readwrite) uint32_t mnc;

/// lac	小区号 (LAC for GSM, NetworkID for CDMA)
@property(nonatomic, readwrite) uint32_t lac;

/// cellid	基站ID (CID for GSM, BaseStationID for CDMA)
@property(nonatomic, readwrite) uint32_t cellId;

/// rssi	信号强度（dBm）
@property(nonatomic, readwrite) uint32_t rssi;

@end

#pragma mark - LbsWifiMac

typedef GPB_ENUM(LbsWifiMac_FieldNumber) {
  LbsWifiMac_FieldNumber_Mac = 1,
  LbsWifiMac_FieldNumber_Rssi = 2,
};

@interface LbsWifiMac : GPBMessage

/// mac wifi接入点的mac地址
@property(nonatomic, readwrite, copy, null_resettable) NSString *mac;

/// rssi	信号强度（dBm）
@property(nonatomic, readwrite) uint32_t rssi;

@end

#pragma mark - AddrInfo

typedef GPB_ENUM(AddrInfo_FieldNumber) {
  AddrInfo_FieldNumber_Province = 1,
  AddrInfo_FieldNumber_City = 2,
  AddrInfo_FieldNumber_District = 3,
  AddrInfo_FieldNumber_StreetName = 4,
  AddrInfo_FieldNumber_StreetNum = 5,
  AddrInfo_FieldNumber_AddrStr = 6,
};

@interface AddrInfo : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *province;

@property(nonatomic, readwrite, copy, null_resettable) NSString *city;

@property(nonatomic, readwrite, copy, null_resettable) NSString *district;

@property(nonatomic, readwrite, copy, null_resettable) NSString *streetName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *streetNum;

@property(nonatomic, readwrite, copy, null_resettable) NSString *addrStr;

@end

#pragma mark - LbsData

typedef GPB_ENUM(LbsData_FieldNumber) {
  LbsData_FieldNumber_Location = 1,
  LbsData_FieldNumber_AddrInfo = 2,
  LbsData_FieldNumber_CellsArray = 3,
  LbsData_FieldNumber_WifisArray = 4,
};

@interface LbsData : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) LbsLocation *location;
/// Test to see if @c location has been set.
@property(nonatomic, readwrite) BOOL hasLocation;

@property(nonatomic, readwrite, strong, null_resettable) AddrInfo *addrInfo;
/// Test to see if @c addrInfo has been set.
@property(nonatomic, readwrite) BOOL hasAddrInfo;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LbsCell*> *cellsArray;
/// The number of items in @c cellsArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger cellsArray_Count;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<LbsWifiMac*> *wifisArray;
/// The number of items in @c wifisArray without causing the array to be created.
@property(nonatomic, readonly) NSUInteger wifisArray_Count;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
