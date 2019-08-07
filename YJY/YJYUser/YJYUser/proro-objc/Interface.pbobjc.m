// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Interface.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "Interface.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - InterfaceRoot

@implementation InterfaceRoot

+ (GPBExtensionRegistry*)extensionRegistry {
  // This is called by +initialize so there is no need to worry
  // about thread safety and initialization of registry.
  static GPBExtensionRegistry* registry = nil;
  if (!registry) {
    GPBDebugCheckRuntimeVersion();
    registry = [[GPBExtensionRegistry alloc] init];
    [registry addExtensions:[ErrRoot extensionRegistry]];
    [registry addExtensions:[AreaRoot extensionRegistry]];
    [registry addExtensions:[CommRoot extensionRegistry]];
    [registry addExtensions:[LbsRoot extensionRegistry]];
    [registry addExtensions:[CmdRoot extensionRegistry]];
    [registry addExtensions:[CommonDataRoot extensionRegistry]];
  }
  return registry;
}

@end

#pragma mark - InterfaceRoot_FileDescriptor

static GPBFileDescriptor *InterfaceRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPBDebugCheckRuntimeVersion();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@""
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - AppError

@implementation AppError

@dynamic errorCode;
@dynamic msg;

typedef struct AppError__storage_ {
  uint32_t _has_storage_[1];
  APP_ERROR_CODE errorCode;
  NSString *msg;
} AppError__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "errorCode",
        .dataTypeSpecific.enumDescFunc = APP_ERROR_CODE_EnumDescriptor,
        .number = AppError_FieldNumber_ErrorCode,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AppError__storage_, errorCode),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor,
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "msg",
        .dataTypeSpecific.className = NULL,
        .number = AppError_FieldNumber_Msg,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AppError__storage_, msg),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AppError class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AppError__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\001\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t AppError_ErrorCode_RawValue(AppError *message) {
  GPBDescriptor *descriptor = [AppError descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AppError_FieldNumber_ErrorCode];
  return GPBGetMessageInt32Field(message, field);
}

void SetAppError_ErrorCode_RawValue(AppError *message, int32_t value) {
  GPBDescriptor *descriptor = [AppError descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:AppError_FieldNumber_ErrorCode];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - ReqHead

@implementation ReqHead

@dynamic yua;
@dynamic guid;
@dynamic sid;
@dynamic hasTerminal, terminal;
@dynamic netType;
@dynamic hasPkginfo, pkginfo;

typedef struct ReqHead__storage_ {
  uint32_t _has_storage_[1];
  NET_TYPE netType;
  NSString *yua;
  NSString *guid;
  NSString *sid;
  Terminal *terminal;
  PkgInfo *pkginfo;
} ReqHead__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "yua",
        .dataTypeSpecific.className = NULL,
        .number = ReqHead_FieldNumber_Yua,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ReqHead__storage_, yua),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "guid",
        .dataTypeSpecific.className = NULL,
        .number = ReqHead_FieldNumber_Guid,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ReqHead__storage_, guid),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "sid",
        .dataTypeSpecific.className = NULL,
        .number = ReqHead_FieldNumber_Sid,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ReqHead__storage_, sid),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "terminal",
        .dataTypeSpecific.className = GPBStringifySymbol(Terminal),
        .number = ReqHead_FieldNumber_Terminal,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ReqHead__storage_, terminal),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "netType",
        .dataTypeSpecific.enumDescFunc = NET_TYPE_EnumDescriptor,
        .number = ReqHead_FieldNumber_NetType,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(ReqHead__storage_, netType),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom | GPBFieldHasEnumDescriptor,
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "pkginfo",
        .dataTypeSpecific.className = GPBStringifySymbol(PkgInfo),
        .number = ReqHead_FieldNumber_Pkginfo,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(ReqHead__storage_, pkginfo),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ReqHead class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ReqHead__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\004\001c\000\002d\000\003c\000\005\007\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t ReqHead_NetType_RawValue(ReqHead *message) {
  GPBDescriptor *descriptor = [ReqHead descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ReqHead_FieldNumber_NetType];
  return GPBGetMessageInt32Field(message, field);
}

void SetReqHead_NetType_RawValue(ReqHead *message, int32_t value) {
  GPBDescriptor *descriptor = [ReqHead descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ReqHead_FieldNumber_NetType];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - RequestItem

@implementation RequestItem

@dynamic command;
@dynamic encrypt;
@dynamic binBody;

typedef struct RequestItem__storage_ {
  uint32_t _has_storage_[1];
  APP_COMMAND command;
  uint32_t encrypt;
  NSData *binBody;
} RequestItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "command",
        .dataTypeSpecific.enumDescFunc = APP_COMMAND_EnumDescriptor,
        .number = RequestItem_FieldNumber_Command,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(RequestItem__storage_, command),
        .flags = GPBFieldOptional | GPBFieldHasEnumDescriptor,
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "encrypt",
        .dataTypeSpecific.className = NULL,
        .number = RequestItem_FieldNumber_Encrypt,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(RequestItem__storage_, encrypt),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "binBody",
        .dataTypeSpecific.className = NULL,
        .number = RequestItem_FieldNumber_BinBody,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(RequestItem__storage_, binBody),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[RequestItem class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(RequestItem__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\007\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t RequestItem_Command_RawValue(RequestItem *message) {
  GPBDescriptor *descriptor = [RequestItem descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:RequestItem_FieldNumber_Command];
  return GPBGetMessageInt32Field(message, field);
}

void SetRequestItem_Command_RawValue(RequestItem *message, int32_t value) {
  GPBDescriptor *descriptor = [RequestItem descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:RequestItem_FieldNumber_Command];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - AppRequest

@implementation AppRequest

@dynamic hasHead, head;
@dynamic hasGpsInfo, gpsInfo;
@dynamic requestId;
@dynamic version;
@dynamic reqsArray, reqsArray_Count;

typedef struct AppRequest__storage_ {
  uint32_t _has_storage_[1];
  uint32_t requestId;
  uint32_t version;
  ReqHead *head;
  LbsData *gpsInfo;
  NSMutableArray *reqsArray;
} AppRequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "head",
        .dataTypeSpecific.className = GPBStringifySymbol(ReqHead),
        .number = AppRequest_FieldNumber_Head,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AppRequest__storage_, head),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "gpsInfo",
        .dataTypeSpecific.className = GPBStringifySymbol(LbsData),
        .number = AppRequest_FieldNumber_GpsInfo,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AppRequest__storage_, gpsInfo),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "requestId",
        .dataTypeSpecific.className = NULL,
        .number = AppRequest_FieldNumber_RequestId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AppRequest__storage_, requestId),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "version",
        .dataTypeSpecific.className = NULL,
        .number = AppRequest_FieldNumber_Version,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(AppRequest__storage_, version),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "reqsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(RequestItem),
        .number = AppRequest_FieldNumber_ReqsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(AppRequest__storage_, reqsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AppRequest class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AppRequest__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\002\007\000\003\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - RspHead

@implementation RspHead

@dynamic guid;
@dynamic sid;

typedef struct RspHead__storage_ {
  uint32_t _has_storage_[1];
  NSString *guid;
  NSString *sid;
} RspHead__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "guid",
        .dataTypeSpecific.className = NULL,
        .number = RspHead_FieldNumber_Guid,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(RspHead__storage_, guid),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "sid",
        .dataTypeSpecific.className = NULL,
        .number = RspHead_FieldNumber_Sid,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(RspHead__storage_, sid),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[RspHead class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(RspHead__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\002\001d\000\002c\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - ResponseItem

@implementation ResponseItem

@dynamic command;
@dynamic encrypt;
@dynamic hasErr, err;
@dynamic binBody;

typedef struct ResponseItem__storage_ {
  uint32_t _has_storage_[1];
  APP_COMMAND command;
  uint32_t encrypt;
  AppError *err;
  NSData *binBody;
} ResponseItem__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "command",
        .dataTypeSpecific.enumDescFunc = APP_COMMAND_EnumDescriptor,
        .number = ResponseItem_FieldNumber_Command,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(ResponseItem__storage_, command),
        .flags = GPBFieldOptional | GPBFieldHasEnumDescriptor,
        .dataType = GPBDataTypeEnum,
      },
      {
        .name = "encrypt",
        .dataTypeSpecific.className = NULL,
        .number = ResponseItem_FieldNumber_Encrypt,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(ResponseItem__storage_, encrypt),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "err",
        .dataTypeSpecific.className = GPBStringifySymbol(AppError),
        .number = ResponseItem_FieldNumber_Err,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(ResponseItem__storage_, err),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "binBody",
        .dataTypeSpecific.className = NULL,
        .number = ResponseItem_FieldNumber_BinBody,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(ResponseItem__storage_, binBody),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[ResponseItem class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(ResponseItem__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\004\007\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

int32_t ResponseItem_Command_RawValue(ResponseItem *message) {
  GPBDescriptor *descriptor = [ResponseItem descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ResponseItem_FieldNumber_Command];
  return GPBGetMessageInt32Field(message, field);
}

void SetResponseItem_Command_RawValue(ResponseItem *message, int32_t value) {
  GPBDescriptor *descriptor = [ResponseItem descriptor];
  GPBFieldDescriptor *field = [descriptor fieldWithNumber:ResponseItem_FieldNumber_Command];
  GPBSetInt32IvarWithFieldInternal(message, field, value, descriptor.file.syntax);
}

#pragma mark - AppResponse

@implementation AppResponse

@dynamic hasHead, head;
@dynamic hasErrInfo, errInfo;
@dynamic requestId;
@dynamic sysTimeStamp;
@dynamic rspsArray, rspsArray_Count;

typedef struct AppResponse__storage_ {
  uint32_t _has_storage_[1];
  uint32_t requestId;
  RspHead *head;
  AppError *errInfo;
  NSMutableArray *rspsArray;
  uint64_t sysTimeStamp;
} AppResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "head",
        .dataTypeSpecific.className = GPBStringifySymbol(RspHead),
        .number = AppResponse_FieldNumber_Head,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(AppResponse__storage_, head),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "errInfo",
        .dataTypeSpecific.className = GPBStringifySymbol(AppError),
        .number = AppResponse_FieldNumber_ErrInfo,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(AppResponse__storage_, errInfo),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeMessage,
      },
      {
        .name = "requestId",
        .dataTypeSpecific.className = NULL,
        .number = AppResponse_FieldNumber_RequestId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(AppResponse__storage_, requestId),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "sysTimeStamp",
        .dataTypeSpecific.className = NULL,
        .number = AppResponse_FieldNumber_SysTimeStamp,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(AppResponse__storage_, sysTimeStamp),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeUInt64,
      },
      {
        .name = "rspsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(ResponseItem),
        .number = AppResponse_FieldNumber_RspsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(AppResponse__storage_, rspsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[AppResponse class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(AppResponse__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\002\007\000\003\t\000\004\014\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PingReq

@implementation PingReq

@dynamic str;

typedef struct PingReq__storage_ {
  uint32_t _has_storage_[1];
  NSString *str;
} PingReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "str",
        .dataTypeSpecific.className = NULL,
        .number = PingReq_FieldNumber_Str,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PingReq__storage_, str),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PingReq class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PingReq__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - PingRsp

@implementation PingRsp

@dynamic str;

typedef struct PingRsp__storage_ {
  uint32_t _has_storage_[1];
  NSString *str;
} PingRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "str",
        .dataTypeSpecific.className = NULL,
        .number = PingRsp_FieldNumber_Str,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(PingRsp__storage_, str),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[PingRsp class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(PingRsp__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UploadImageRsp

@implementation UploadImageRsp

@dynamic code;
@dynamic msg;
@dynamic imgId;

typedef struct UploadImageRsp__storage_ {
  uint32_t _has_storage_[1];
  uint32_t code;
  NSString *msg;
  uint64_t imgId;
} UploadImageRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "code",
        .dataTypeSpecific.className = NULL,
        .number = UploadImageRsp_FieldNumber_Code,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UploadImageRsp__storage_, code),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "msg",
        .dataTypeSpecific.className = NULL,
        .number = UploadImageRsp_FieldNumber_Msg,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UploadImageRsp__storage_, msg),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "imgId",
        .dataTypeSpecific.className = NULL,
        .number = UploadImageRsp_FieldNumber_ImgId,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UploadImageRsp__storage_, imgId),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeUInt64,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UploadImageRsp class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UploadImageRsp__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\005\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - UploadExcelRsp

@implementation UploadExcelRsp

@dynamic code;
@dynamic msg;
@dynamic excelURL;

typedef struct UploadExcelRsp__storage_ {
  uint32_t _has_storage_[1];
  uint32_t code;
  NSString *msg;
  NSString *excelURL;
} UploadExcelRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "code",
        .dataTypeSpecific.className = NULL,
        .number = UploadExcelRsp_FieldNumber_Code,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(UploadExcelRsp__storage_, code),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
      {
        .name = "msg",
        .dataTypeSpecific.className = NULL,
        .number = UploadExcelRsp_FieldNumber_Msg,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(UploadExcelRsp__storage_, msg),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "excelURL",
        .dataTypeSpecific.className = NULL,
        .number = UploadExcelRsp_FieldNumber_ExcelURL,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(UploadExcelRsp__storage_, excelURL),
        .flags = GPBFieldOptional | GPBFieldTextFormatNameCustom,
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[UploadExcelRsp class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(UploadExcelRsp__storage_)
                                         flags:0];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\003\006!!\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - StatReportReq

@implementation StatReportReq

@dynamic itemsArray, itemsArray_Count;

typedef struct StatReportReq__storage_ {
  uint32_t _has_storage_[1];
  NSMutableArray *itemsArray;
} StatReportReq__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "itemsArray",
        .dataTypeSpecific.className = GPBStringifySymbol(StatReportItem),
        .number = StatReportReq_FieldNumber_ItemsArray,
        .hasIndex = GPBNoHasBit,
        .offset = (uint32_t)offsetof(StatReportReq__storage_, itemsArray),
        .flags = GPBFieldRepeated,
        .dataType = GPBDataTypeMessage,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[StatReportReq class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(StatReportReq__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - StatReportRsp

@implementation StatReportRsp

@dynamic ret;

typedef struct StatReportRsp__storage_ {
  uint32_t _has_storage_[1];
  uint32_t ret;
} StatReportRsp__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "ret",
        .dataTypeSpecific.className = NULL,
        .number = StatReportRsp_FieldNumber_Ret,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(StatReportRsp__storage_, ret),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeUInt32,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[StatReportRsp class]
                                     rootClass:[InterfaceRoot class]
                                          file:InterfaceRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(StatReportRsp__storage_)
                                         flags:0];
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)