#使用方法

if [ ! -d ./IPADir ];
then
mkdir -p IPADir;
fi

#工程绝对路径
project_path=$(cd `dirname $0`; pwd)

#工程名 将XXX替换成自己的工程名
project_name=YHWanGuoTechnicians

#scheme名 将XXX替换成自己的sheme名
scheme_name=YHWanGuoTechnicians

#打包模式 Debug/Release
development_mode=Release

#build文件夹路径
build_path=${project_path}/build

#plist文件所在路径
exportOptionsPlistPath=${project_path}/ExportOptions.plist

#导出.ipa文件所在路径
exportIpaPath=${project_path}/IPADir/${development_mode}


echo ""
echo "///............................................................................................."
echo "/// 佛祖保佑,永无BUG"
echo "///............................................................................................."
echo ""

#number=2
echo "Place enter the number you want to export ?"

echo "************************************************************************************************"
echo "*                               *                             *                                *"
echo "*            1:debug            *            2:test           *           3:appStore           *"
echo "*                               *                             *                                *"
echo "************************************************************************************************"


##
read number
while([[ $number != 1 ]] && [[ $number != 2 ]] && [[ $number != 3 ]])
do
echo "Error! Should enter  1 or 2 or 3 "
echo "Place enter the number you want to export ?"

echo "************************************************************************************************"
echo "*                               *                             *                                *"
echo "*            1:debug            *            2:test           *           3:appStore           *"
echo "*                               *                             *                                *"
echo "************************************************************************************************"


read number
done

#if [ $number == 1 ];then
#development_mode=Release
#exportOptionsPlistPath=${project_path}/DistributionSummary.plist
#else
#development_mode=Debug
#exportOptionsPlistPath=${project_path}/ExportOptions.plist
#fi
if [ $number == 1 ];then
development_mode=Debug
exportOptionsPlistPath=${project_path}/ExportOptions.plist
elif [ $number == 2 ];then
development_mode=Test
exportOptionsPlistPath=${project_path}/ExportOptions.plist
else
development_mode=Release
exportOptionsPlistPath=${project_path}/DistributionSummary.plist
fi


# 删除之前创建的bulid文件夹
rm -rf ${build_path}
rm -rf ${exportIpaPath}/changelog


echo "///............................................................................................."
echo '/// 正在清理工程'
echo "///............................................................................................."
xcodebuild \
clean -configuration ${development_mode} -quiet  || exit


echo "///............................................................................................."
echo '/// 清理完成 🎉 🎉 🎉'
echo "///............................................................................................."
echo ''

echo "///............................................................................................."
echo '/// 正在编译工程:'${development_mode}
echo "///............................................................................................."
xcodebuild \
archive -workspace ${project_path}/${project_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive  -quiet  || exit

echo "///............................................................................................."
echo '/// 编译完成 🎉 🎉 🎉'
echo "///............................................................................................."
echo ''

echo "///............................................................................................."
echo '/// 开始ipa打包 '
echo "///............................................................................................."
xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
-configuration ${development_mode} \
-exportPath ${exportIpaPath} \
-exportOptionsPlist ${exportOptionsPlistPath} \
-quiet || exit

if [ -e $exportIpaPath/$scheme_name.ipa ]; then
echo "///............................................................................................."
echo '/// ipa包已导出 🎉 🎉 🎉'
echo "///............................................................................................."
# open $exportIpaPath
else
echo "///............................................................................................."
echo '/// ipa包导出失败 😢 😢 😢'
echo "///............................................................................................."
fi
echo "///............................................................................................."
echo '/// 打包ipa完成 🎉 🎉 🎉'
echo "///............................................................................................."
echo ''

echo "///............................................................................................."
echo '/// 开始发布ipa包 '
echo "///............................................................................................."

if [ $number == 3 ];then

#验证并上传到App Store
# 将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
altoolPath="/Applications/Xcode.app/Contents/Applications/Application Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
"$altoolPath" --validate-app -f ${exportIpaPath}/${scheme_name}.ipa -u XXX -p XXX -t ios --output-format xml
"$altoolPath" --upload-app -f ${exportIpaPath}/${scheme_name}.ipa -u  XXX -p XXX -t ios --output-format xml
else

# GIT_LOG=`git log -10 --pretty=format:"%s"`
GIT_LOG=`git log -20 --date=format:'%Y-%m-%d %H:%M:%S'  --pretty=format:'[%ad]: %s [%an]' --abbrev-commit`
# git log -10 --pretty=format:"%s" >> ${exportIpaPath}/changelog
git log  --date=format:'%Y-%m-%d %H:%M:%S'  --pretty=format:'【%ad】: %s [%an]' --abbrev-commit >> ${exportIpaPath}/changelog

#echo ${GIT_LOG} | sed 's/ /\n/g ' > ${exportIpaPath}/changelog
#echo $GIT_LOG > ${exportIpaPath}/changelog
#上传到Fir
# 将XXX替换成自己的Fir平台的token
fir login -T 7996aa12af2ec8d360477d2ca671daf6
fir publish $exportIpaPath/$scheme_name.ipa --changelog=${exportIpaPath}/changelog

open -a "/Applications/Safari.app" https://fir.im/jjns

#$GIT_LOG
curl -i "http://127.0.0.1/app/public/api/appSumbit?debug=99&json" -X POST -d "log=$GIT_LOG"
echo ""
echo "///............................................................................................."
echo "///使用脚本打包总耗时: ${SECONDS}s"
echo "///............................................................................................."


fi

exit 0


