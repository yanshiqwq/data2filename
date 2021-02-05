@echo off
echo.
echo %~nx0 By 延时qwq https://space.bilibili.com/431304449
echo.
set RAND=%RANDOM%
for /f %%i in ('where /r "%~1" index_*') do (set INDEXFILE=%%~ni)
for /f %%i in ('where /r "%~1" filename_*') do (set NAMEFILE=%%~nxi)
for /f "delims=_ tokens=2" %%i  in ('echo %NAMEFILE%') do (set FILENAME=%%i)
for /f "delims=_ tokens=2,3" %%i in ('echo %INDEXFILE%') do (set FILERAND=%%i)
for /f "delims=_ tokens=3" %%i in ('echo %INDEXFILE%') do (set FILECOUNT=%%i)
echo 还原速度:	约7KB/s
if "%1" == "" echo 用法: %~nx0 待解密的文件 & goto :EOF
echo 文件名称:	%FILENAME%
set /a COMPILETIME=%~z1/7000
echo 约需时间:	%COMPILETIME%秒
echo [INFO] 正在合并文件...
echo -----BEGIN CERTIFICATE----- >> .\filedata%RAND%.tmp

set COUNT=0
:loop
setlocal enabledelayedexpansion
for /f "delims=_ tokens=4" %%i in ('where /r "%~1" /f data%FILERAND%_%COUNT%_*') do (
	set FILEDATA=%%i
	set FILEDATA=!FILEDATA:-=/!
	set FILEDATA=!FILEDATA:"=!
	echo !FILEDATA! >> .\filedata%RAND%.tmp
)
if "%COUNT%"=="%FILECOUNT%" endlocal & goto :end
endlocal
set /a COUNT=%COUNT%+1
goto :loop
:end
echo -----END CERTIFICATE----- >> .\filedata%RAND%.tmp

echo [INFO] 合并完成!正在解码文件...
certutil -decode .\filedata%RAND%.tmp .\%FILENAME% >nul
del /f /q .\filedata%RAND%.tmp >nul

echo [INFO] 解码完成!正在校验文件哈希值...
for /f %%i in ('where /r "%~1" hash_*') do (set HASHFILE=%%~ni)
set FILEHASH=%HASHFILE:~5%
certutil -hashfile .\%FILENAME% .\hash%RAND%.tmp MD5
for /f %%i in ('type .\hash%RAND%.tmp') do (set HASH=%%i)
del /f /q .\hash%RAND%.tmp >nul
if "%HASH%" == "%FILEHASH%" (
	echo [INFO] 校验完成!
	goto :EOF
)
echo [WARN] 校验失败!请检查文件夹内文件是否完整.