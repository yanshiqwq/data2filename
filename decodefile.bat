@echo off
set /a START_TIMESTAMP=%time:~0,2%*360000+%time:~3,2%*6000+%time:~6,2%*100+%time:~9,2%
echo.
echo 	%~nx0 v1.2.3-color By 延时qwq 
echo.
print -e \\033[1;36m[PID #0]\\033[0m BiliBili:	https://space.bilibili.com/431304449
print -e \\033[1;36m[PID #0]\\033[0m Github: https://github.com/Yanshiqwq/data2filename
REM 还原速度:	约64KB/s
if "%~1" == "" (
	print -e \\033[1;36m[PID #0]\\033[0m 用法:		%~nx0 待解密的文件
	pause
	goto :END
)
if not exist "%~1"/ (
	print -e \\033[1;33m[PID #0]\\033[0m 只能解密文件夹.
	goto :END
)
set RAND=%RANDOM%
for /f %%i in ('where /r "%~1" index_*') do (set INDEXFILE=%%~ni)
for /f %%i in ('where /r "%~1" filename_*') do (set NAMEFILE=%%~ni)
for /f %%i in ('where /r "%~1" hash_*') do (set HASHFILE=%%~ni)
for /f "delims=_ tokens=2,3" %%i in ('echo %INDEXFILE%') do (set FILERAND=%%i)
for /f "delims=_ tokens=3" %%i in ('echo %INDEXFILE%') do (set FILESCOUNT=%%i)
for /f "delims=_ tokens=2" %%i  in ('echo %NAMEFILE%') do (set FILENAME=%%i)
for /f "delims=._ tokens=3" %%i  in ('echo %NAMEFILE%') do (set FILEEXT=%%i)
if "%FILEEXT%" NEQ "~1" (
	set FILENAME=%FILENAME%.%FILEEXT%
)
print -e \\033[1;36m[PID #0]\\033[0m 文件名称:	%FILENAME%
set FILEHASH=%HASHFILE:~5%
set /a FILESIZE=%FILESCOUNT%*340/1934*1024
set /a GB=%FILESIZE%/1024/1024/1024
set /a MB=%FILESIZE%/1024/1024%%1024
set /a KB=%FILESIZE%/1024%%1024
print -e \\033[1;36m[PID #0]\\033[0m 文件大小:	%GB%GB %MB%MB %KB%KB
set /a FILESIZE_=%FILESIZE%/1024/1024
set /a COMPLETESEC=%FILESIZE_%%%60
set /a COMPLETEMIN=%FILESIZE_%/60%%60
set /a COMPLETEHOUR=%FILESIZE_%/3600
print -e \\033[1;36m[PID #0]\\033[0m 解码时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒
set /a FILESIZE_=%FILESIZE%/1024
set /a COMPLETESEC=%FILESIZE_%/64%%60
set /a COMPLETEMIN=%FILESIZE_%/64/60%%60
set /a COMPLETEHOUR=%FILESIZE_%/64/3600
print -e \\033[1;36m[PID #0]\\033[0m 合并时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒

set COUNT=0
for /f "delims=_ tokens=3" %%i in ('dir /b /od /on /oe "%~1\*."') do (
	setlocal enabledelayedexpansion
	set FILEDATA=%%i
	set /a "COMPLETESEC=(%FILESCOUNT%-!COUNT!)*9/4/1024%%60"
	set /a "COMPLETEMIN=(%FILESCOUNT%-!COUNT!)*9/4/1024/60%%60"
	set /a "COMPLETEHOUR=(%FILESCOUNT%-!COUNT!)*9/4/1024/3600%%60"
	echo !FILEDATA: =! >> %~dp1fileraw%RAND%.tmp
	set /a PER=!COUNT!%%71
	if "!PER!" == "0" print -en \\033[1;36m[PID #!COUNT!]\\033[0m 正在合并文件...	\\033[1;32m[!COUNT!/%FILESCOUNT%] \\033[1;33m[ETA !COMPLETEHOUR!时!COMPLETEMIN!分!COMPLETESEC!秒] \\033[0m \r
	endlocal
	set /a COUNT+=1
)
endlocal
print -e \\033[1;36m[PID #0]\\033[0m 正在解码文件...
sed -e "s/-/\//g;s/ //g" "%~dp1fileraw%RAND%.tmp" > "%~dp1file%RAND%.tmp"
base64 -di %~dp1file%RAND%.tmp > %~dp1%FILENAME%
del /f /q %~dp1fileraw%RAND%.tmp >nul
del /f /q %~dp1file%RAND%.tmp >nul

print -e \\033[1;36m[PID #0]\\033[0m 正在校验文件哈希值...

for /f %%i in ('certutil -hashfile "%~dp1%FILENAME%" MD5 ^| findstr /V 哈希 ^| findstr /V 完成') do (set HASH=%%i)
print -e \\033[1;36m[PID #0]\\033[0m 哈希值:	%HASH%
print -e \\033[1;36m[PID #0]\\033[0m 原哈希值:	%FILEHASH%
if "%HASH%" == "%FILEHASH%" (
	print -e \\033[1;36m[PID #0]\\033[0m 校验完成!
	goto :END
)
print -e \\033[1;33m[PID #0]\\033[0m 校验失败!请检查文件夹内文件是否完整.

:END
set /a END_TIMESTAMP=%time:~0,2%*360000+%time:~3,2%*6000+%time:~6,2%*100+%time:~9,2%
set /a COST=(%END_TIMESTAMP%-%START_TIMESTAMP%)*10+%RANDOM%%%10
print -en \\033[1;32m[PID #0]\\033[0m [Process completed (%COST%ms) - press Enter]
set /p =