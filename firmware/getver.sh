VER_FILE=version.in
echo -n " .equ BUILD_VERSION, " > $VER_FILE
echo 0x512e3156 >> $VER_FILE

#note: 0x512e3156 means V1.Q
