@echo off
echo.
echo 	%~nx0 v1.2 By 延时qwq 
echo.
echo ^<BiliBili^>	https://space.bilibili.com/431304449
echo ^<Github^>	https://github.com/Yanshiqwq/data2filename
echo 还原速度:	约204KB/s
if "%~1" == "" (
	echo 用法:		%~nx0 待解密的文件
	pause >nul
	goto :EOF
)
set RAND=%RANDOM%
for /f %%i in ('where /r "%~1" index_*') do (set INDEXFILE=%%~ni)
for /f %%i in ('where /r "%~1" filename_*') do (set NAMEFILE=%%~ni)
for /f "delims=_ tokens=2" %%i  in ('echo %NAMEFILE%') do (set FILENAME=%%i)
for /f "delims=._ tokens=3" %%i  in ('echo %NAMEFILE%') do (set FILEEXT=%%i)
if "%FILEEXT%" NEQ "~1" (
	set FILENAME=%FILENAME%.%FILEEXT%
)
for /f "delims=_ tokens=2,3" %%i in ('echo %INDEXFILE%') do (set FILERAND=%%i)
for /f "delims=_ tokens=3" %%i in ('echo %INDEXFILE%') do (set FILECOUNT=%%i)

echo 文件名称:	%FILENAME%
set /a GB=%~z1/1024/1024/1024
set /a MB=%~z1/1024/1024%%1024
set /a KB=%~z1/1024%%1024
echo 文件大小:	%GB%GB %MB%MB %KB%KB
set /a FILESIZE=%~z1/1024
set /a COMPLETESEC=%FILESIZE%/204%%60
set /a COMPLETEMIN=%FILESIZE%/204/60%%60
set /a COMPLETEHOUR=%FILESIZE%/204/3600%%60
echo 约需时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒

echo [INFO] 正在合并文件...
setlocal enabledelayedexpansion
for /f "delims=_ tokens=3" %%i in ('dir /b /od /on /oe "%~1\*."') do (
	set FILEDATA=%%i
	echo !FILEDATA! >> %~dp1fileraw%RAND%.tmp
)
endlocal

echo [INFO] 合并完成!正在解码文件...
sed -e "s/-/\//g" "%~dp1fileraw%RAND%.tmp" > "%~dp1file%RAND%.tmp"
del /f /q %~dp1fileraw%RAND%.tmp >nul
basenc -di --base64 %~dp1file%RAND%.tmp > %~dp1%FILENAME%
del /f /q %~dp1file%RAND%.tmp >nul

echo [INFO] 解码完成!正在校验文件哈希值...
for /f %%i in ('where /r "%~1" hash_*') do (set HASHFILE=%%~ni)
set FILEHASH=%HASHFILE:~5%
certutil -hashfile %~dp1%FILENAME% MD5 | findstr /V 哈希 | findstr /V 完成 > %~dp1hash%RAND%.tmp
for /f %%i in ('type %~dp1hash%RAND%.tmp') do (set HASH=%%i)
del /f /q %~dp1hash%RAND%.tmp >nul
if "%HASH%" == "%FILEHASH%" (
	echo [INFO] 校验完成!
	goto :EOF
)
echo [WARN] 校验失败!请检查文件夹内文件是否完整.