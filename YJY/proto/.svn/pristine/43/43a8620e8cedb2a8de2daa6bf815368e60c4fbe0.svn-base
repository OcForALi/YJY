::当前批处理文件需要配置protoc的环境变量
cd /d %~dp0
protoc.exe comm\Stat.proto comm\Area.proto comm\comm.proto comm\Err.proto comm\lbs.proto --java_out=..\..\src\main\java
protoc.exe *.proto --java_out=..\..\src\main\java
pause