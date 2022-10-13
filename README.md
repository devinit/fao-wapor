# fao-wapor


## url_scrape.py

This script is designed to scrape all of the tif files from the FAO WAPOR repository over time.

Important things that must be done to allow this to work are:
1. Put a breakpoint at Print("Stop"). This can be done easily on something like VSCode.
2. When the script stops at the breakpoint, open the automated Firefox window and Sign in.
3. After you are signed in, put the URL of the download page into the browser so it is back in its original location
4. Allow the script to continue.
