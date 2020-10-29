copy Swiss721Condensed.ttf "%windir%\Fonts"
copy Swiss721Condensed.ttf "%SystemRoot%\Fonts"
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v Swis721 Cn BT (TrueType)" /t REG_SZ /d Swiss721Condensed.ttf /f
regedit /s font.reg