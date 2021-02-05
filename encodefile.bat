@echo off
echo.
echo         %~nx0 v1.1 By 延时qwq https://space.bilibili.com/431304449
echo.
echo 生成速度:	约40KB/s
echo 生成数量:	约21文件/KB
if "%~1" == "" echo 用法: %~nx0 待加密的文件 & goto :EOF
echo 文件名称:	%~nx1
set /a GB=%~z1/1024/1024/1024
set /a MB=%~z1/1024/1024%%1024
set /a KB=%~z1/1024%%1024
echo 文件大小:	%GB%GB %MB%MB %KB%KB
set /a FILESIZE=%~z1/1024
set /a COMPLETESEC=%FILESIZE%/40%%60
set /a COMPLETEMIN=%FILESIZE%/40/60%%60
set /a COMPLETEHOUR=%FILESIZE%/40/3600%%60
echo 约需时间:	%COMPLETEHOUR%时 %COMPLETEMIN%分 %COMPLETESEC%秒
set RAND=%RANDOM%
base32 "%~1" > "%~dp1file%RAND%.tmp"
set OUTFILE=%~nx1_encode
set OUTFILE=%OUTFILE: =_%
mkdir "%~dp1%OUTFILE%" >nul

echo [INFO] 正在计算文件哈希值...
for /f "delims=" %%i in ('certutil -hashfile %1 MD5 ^| findstr /V 哈希 ^| findstr /V 完成') do (cd. > "%~dp1%OUTFILE%\hash_%%i.encode") 

echo [INFO] 正在分解文件...
set COUNT=0
for /f "delims=" %%i in ('type "%~dp1file%RAND%.tmp"') do (
	setlocal enabledelayedexpansion
	set FILEDATA=%%i
	set FILEDATA=!FILEDATA:/=-!
	cd. > "%~dp1%OUTFILE%\data%RAND%_!COUNT!_!FILEDATA!"
	endlocal
	set /a COUNT+=1
)

del /f /q "%~dp1file%RAND%.tmp" >nul
set /a COUNT=%COUNT%-1
cd. > "%~dp1%OUTFILE%\index_%RAND%_%COUNT%.encode"
set FILEEXT=%~x1
cd. > "%~dp1%OUTFILE%\filename_%~n1_%FILEEXT:~1%.encode"
echo [INFO] 分解完成!