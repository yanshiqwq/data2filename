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
pause