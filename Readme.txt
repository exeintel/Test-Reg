================================================================================
                    REGISTRY MONITORING EXPERIMENT
================================================================================

OBJECTIVE:
Test whether a running program can detect registry changes in real-time
without polling delays or restart.

================================================================================
FILES DESCRIPTION:
================================================================================

1. regedit.reg
   - Creates registry key: HKCR\test
   - Creates DWORD parameter "reg" with value 0
   - Run this first to initialize the test environment

2. servers.cmd
   - Administrator privilege launcher
   - Continuously monitors HKCR\test\reg value
   - Outputs timestamp and current value every second
   - HIGHLIGHTS changes when detected
   - Uses reg.exe query for reading values

3. 1.reg
   - Changes the "reg" parameter value from 0 to 1
   - Run this while servers.cmd is running to test detection

================================================================================
EXPERIMENT PROCEDURE:
================================================================================

PHASE 1 - Setup:
   1. Run regedit.reg (double-click) to create registry structure
   2. Verify creation with Windows Registry Editor (regedit.exe)

PHASE 2 - Monitoring:
   1. Run servers.cmd as Administrator
   2. Observe console output showing "Current value: 0x0"

PHASE 3 - Change Test:
   1. While servers.cmd is running, execute 1.reg
   2. Observe if console detects the change immediately
   3. Expected: "[TIME] VALUE CHANGED: 0x0 -> 0x1 <<< DETECTED!"

PHASE 4 - Manual Verification:
   1. Open regedit.exe
   2. Navigate to HKEY_CLASSES_ROOT\test
   3. Modify "reg" value manually
   4. Check if servers.cmd detects the change

PHASE 5 - Advanced Test (if needed):
   1. If changes not detected, try:
      - Restart servers.cmd after registry modification
      - Kill explorer.exe process and restart it
      - Check if Windows broadcasts registry change events

================================================================================
TECHNICAL DETAILS:
================================================================================

Polling Method:
   - Interval: 1 second (configurable in script)
   - Command: reg query HKCR\test /v reg
   - Comparison: Previous vs Current value

Limitations:
   - Windows registry does not provide real-time notifications to CLI tools
   - Some registry hives may be cached by OS
   - HKCR is a merged view of HKLM\Software\Classes and HKCU\Software\Classes

Alternative Methods (for future experiments):
   - PowerShell: Get-ItemProperty with WMI events
   - C#: Microsoft.Win32.RegistryKey with EventLog
   - C++: RegNotifyChangeKeyValue API (true real-time)

================================================================================
EXPECTED RESULTS:
================================================================================

HYPOTHESIS:
Batch script with polling WILL detect changes, but with 1-second delay.
True real-time detection (instant) requires Windows API (RegNotifyChangeKeyValue).

SUCCESS CRITERIA:
[ ] servers.cmd shows value 0 at start
[ ] After running 1.reg, console shows "VALUE CHANGED: 0x0 -> 0x1"
[ ] Manual edit in regedit.exe is also detected within 1 second

================================================================================
GITHUB REPOSITORY STRUCTURE:
================================================================================

Test-reg/
├── README.md          (copy of this file in Markdown)
├── servers.cmd        (monitoring script)
├── regedit.reg        (initial setup)
├── 1.reg              (value changer)
└── docs/
    └── RESULTS.md     (your experiment results)

================================================================================
AUTHOR: [Your Name]
DATE: 2026-03-07
LICENSE: MIT
================================================================================