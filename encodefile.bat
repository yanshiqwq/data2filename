@echo off
echo.
echo 	%~nx0 v1.2.2 By 延时qwq 
echo.
echo BiliBili:	https://space.bilibili.com/431304449
echo Github:		https://github.com/Yanshiqwq/data2filename
echo 生成速度:	约170KB/s
echo 生成数量:	约6文件/KB
if "%~1" == "" (
	echo 用法:		%~nx0 待加密的文件
	pause
	goto :EOF
)
echo 文件名称:	%~nx1
set /a GB=%~z1/1024/1024/1024
set /a MB=%~z1/1024/1024%%1024
set /a KB=%~z1/1024%%1024
echo 文件大小:	%GB%GB %MB%MB %KB%KB
set /a FILESCOUNT=%~z1/1024*1934/340
echo 生成文件:	%FILESCOUNT%个
set /a FILESIZE=%~z1/1024
set /a COMPLETEMINSEC=%FILESIZE%/256%%1000
set /a COMPLETESEC=%FILESIZE%/256/1000
echo 编码时间:	%COMPLETESEC%秒 %COMPLETEMINSEC%毫秒
set /a FILESIZE=%~z1/1024/1024
set /a COMPLETESEC=%FILESIZE%%%60
set /a COMPLETEMIN=%FILESIZE%/60%%60
set /a COMPLETEHOUR=%FILESIZE%/3600%%60
echo 转码时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒
set /a FILESIZE=%~z1/1024
set /a COMPLETESEC=%FILESIZE%/170%%60
set /a COMPLETEMIN=%FILESIZE%/170/60%%60
set /a COMPLETEHOUR=%FILESIZE%/170/3600%%60
echo 约需时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒
set RAND=%RANDOM%
set OUTFILE=%~nx1_encode
set OUTFILE=%OUTFILE: =_%
if exist "%~dp1%OUTFILE%" rd /s /q "%~dp1%OUTFILE%" >nul
mkdir "%~dp1%OUTFILE%" >nul

echo [INFO] 正在编码文件...
base64 -w235 "%~1" > "%~dp1fileraw%RAND%.tmp"

echo [INFO] 正在转码文件...
sed -e "s/\//-/g" "%~dp1fileraw%RAND%.tmp" > "%~dp1file%RAND%.tmp"
del /f /q "%~dp1fileraw%RAND%.tmp"

echo [INFO] 正在计算文件哈希值...
for /f "delims=" %%i in ('certutil -hashfile %1 MD5 ^| findstr /V 哈希 ^| findstr /V 完成') do (cd. > "%~dp1%OUTFILE%\hash_%%i.encode") 

echo [INFO] 正在分解文件...
set COUNT=0
for /f "delims=" %%i in ('type "%~dp1file%RAND%.tmp"') do (
	setlocal enabledelayedexpansion
	cd. > "%~dp1%OUTFILE%\data%RAND%_!COUNT!_%%i"
	set /a PER=!COUNT!%%595 >nul
	if "!PER!" == "0" echo [INFO] 已完成!COUNT!/%FILESCOUNT% 
	endlocal
	set /a COUNT+=1
)

del /f /q "%~dp1file%RAND%.tmp" >nul
set /a COUNT=%COUNT%-1
cd. > "%~dp1%OUTFILE%\index_%RAND%_%COUNT%.encode"
set FILEEXT=%~x1
cd. > "%~dp1%OUTFILE%\filename_%~n1_%FILEEXT:~1%.encode"
echo [INFO] 分解完成!
goto :EOF