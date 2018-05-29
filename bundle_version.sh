#!/bin/sh
#开放权限，否则会报错 $sudo chmod -R 777 bundle_version.sh
cd ./

installerName = "root";
for i in "$@"; do
installerName=$i
done

#更新个人开发版本===================>

#如果当前用户不存在则添加用户
STRING=$(/usr/libexec/PlistBuddy -c "Print DevelopBundleVersion:`whoami`" "$INFOPLIST_FILE")
if [ -z "$STRING" ]; then
#添加用户 并初始化 user bundleVersion
/usr/libexec/PlistBuddy -c "Add :DevelopBundleVersion:`whoami` string 0" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :DevelopBundleVersion:users array" "$INFOPLIST_FILE"
/usr/libexec/PlistBuddy -c "Add :DevelopBundleVersion:users:0 string `whoami`" "$INFOPLIST_FILE"
fi

#累加user bundleVersion
buildNumber=$(/usr/libexec/PlistBuddy -c "Print DevelopBundleVersion:`whoami`" "$INFOPLIST_FILE")
buildNumber=$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :DevelopBundleVersion:`whoami` $buildNumber" "$INFOPLIST_FILE"

#更新个人开发版本===================<

#为了预防多人开发冲突这里只允许一个用户更新app bundleVersion===================>

if [ "`whoami`"x == "$installerName"x ]
then

#遍历用户计算app bundleVersion===================>
buildNumber=0
isStart=
array=$(/usr/libexec/PlistBuddy -c "Print DevelopBundleVersion:users" "$INFOPLIST_FILE")
for value in ${array[@]}; do

if [ "$value"x == "}"x ]
then
isStart="NO"
fi

if [ "$isStart"x == "YES"x ]
then
buildNumberTemp=$(/usr/libexec/PlistBuddy -c "Print DevelopBundleVersion:$value" "$INFOPLIST_FILE")
buildNumber=$(($buildNumber + $buildNumberTemp))
fi

if [ "$value"x == "{"x ]
then
isStart="YES"
fi
done
#遍历用户计算app bundleVersion<===================

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "$INFOPLIST_FILE"

fi

#为了预防多人开发冲突这里只允许一个用户更新app bundleVersion<===================

