#!/bin/bash
currentPath=`dirname $0`
echo
echo "当前工作目录:$currentPath"
echo "正在执行转换...."
cd $currentPath
protoc --objc_out=./proro-objc -I ./proto ./proto/*.proto
protoc --objc_out=./proro-objc/comm -I ./proto/comm ./proto/comm/*.proto
echo "转换成功"
