BIN_PATH=bin/
BIN_NAME=little_guys

bin_windows:
	godot --export-release "Windows Desktop" ${BIN_PATH}${BIN_NAME}.exe

bin_linux:
	godot --export-release "Linux Desktop" ${BIN_PATH}${BIN_NAME}.x86_64

bin_web:
	godot --export-release "Web" ${BIN_PATH}${BIN_NAME}.html
