@echo off
echo.
echo 	%~nx0 v1.2.2 By 延时qwq 
echo.
echo ^<BiliBili^>	https://space.bilibili.com/431304449
echo ^<Github^>	https://github.com/Yanshiqwq/data2filename
echo 还原速度:	约331KB/s
if "%~1" == "" (
	echo 用法:		%~nx0 待解密的文件
	pause
	goto :EOF
)
if not exist "%~1"/ (
	echo [ERROR] 只能解密文件夹.
)
set RAND=%RANDOM%
for /f %%i in ('where /r "%~1" index_*') do (set INDEXFILE=%%~ni)
for /f %%i in ('where /r "%~1" filename_*') do (set NAMEFILE=%%~ni)
for /f %%i in ('where /r "%~1" hash_*') do (set HASHFILE=%%~ni)
for /f "delims=_ tokens=2,3" %%i in ('echo %INDEXFILE%') do (set FILERAND=%%i)
for /f "delims=_ tokens=3" %%i in ('echo %INDEXFILE%') do (set FILECOUNT=%%i)
for /f "delims=_ tokens=2" %%i  in ('echo %NAMEFILE%') do (set FILENAME=%%i)
for /f "delims=._ tokens=3" %%i  in ('echo %NAMEFILE%') do (set FILEEXT=%%i)
for /f "delims=" %%i in ('dir /b /a-d "%~1" ^| find /v /c ""') do (set FILECOUNT=%%i)
if "%FILEEXT%" NEQ "~1" (
	set FILENAME=%FILENAME%.%FILEEXT%
)
echo 文件名称:	%FILENAME%
set FILEHASH=%HASHFILE:~5%
set /a FILESIZE=%FILECOUNT%*340/1934*1024
set /a GB=%FILESIZE%/1024/1024/1024
set /a MB=%FILESIZE%/1024/1024%%1024
set /a KB=%FILESIZE%/1024%%1024
echo 文件大小:	%GB%GB %MB%MB %KB%KB
set /a FILESIZE_=%FILESIZE%/1024/1024
set /a COMPLETESEC=%FILESIZE_%%%60
set /a COMPLETEMIN=%FILESIZE_%/60%%60
set /a COMPLETEHOUR=%FILESIZE_%/3600
echo 解码时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒
set /a FILESIZE_=%FILESIZE%/1024
set /a COMPLETESEC=%FILESIZE_%/331%%60
set /a COMPLETEMIN=%FILESIZE_%/331/60%%60
set /a COMPLETEHOUR=%FILESIZE_%/331/3600
echo 约需时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒

echo [INFO] 正在合并文件...
set COUNT=0
for /f "delims=_ tokens=3" %%i in ('dir /b /od /on /oe "%~1\*."') do (
	setlocal enabledelayedexpansion
	set FILEDATA=%%i
	echo !FILEDATA! >> %~dp1fileraw%RAND%.tmp
	set /a PER=!COUNT!%%596
	if "!PER!" == "0" echo [INFO] 已完成!COUNT!/%FILESCOUNT%
	endlocal
	set /a COUNT+=1
)
endlocal

echo [INFO] 正在解码文件...
sed -e "s/-/\//g;s/ //g" "%~dp1fileraw%RAND%.tmp" > "%~dp1file%RAND%.tmp"
base64 -di %~dp1file%RAND%.tmp > %~dp1%FILENAME%
del /f /q %~dp1fileraw%RAND%.tmp >nul
del /f /q %~dp1file%RAND%.tmp >nul

echo [INFO] 正在校验文件哈希值...

for /f %%i in ('certutil -hashfile "%~dp1%FILENAME%" MD5 ^| findstr /V 哈希 ^| findstr /V 完成') do (set HASH=%%i)
echo [INFO] 哈希值:		%HASH%
echo [INFO] 原哈希值:	%FILEHASH%
if "%HASH%" == "%FILEHASH%" (
	echo [INFO] 校验完成!
	goto :EOF
)
echo [WARN] 校验失败!请检查文件夹内文件是否完整.