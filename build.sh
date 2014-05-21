flex --outfile=wx.c wx.l

if (( $? )); then
	echo "Flex run failed." >&2
	exit 1
else
	echo "Flex executed and wx.c generated."
fi

gcc -O3 -Wall wx.c -o build/wx

if (( $? )); then
	echo "Build failed." >&2
	exit 1
else
	echo "Build completed successfully."
fi

exit 0
