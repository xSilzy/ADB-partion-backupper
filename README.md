### ADB Partion Backupper v1.0

A simple batch script to back up Android a/b partition from a rooted device using ADB. 

---

**Features**
* :white_check_mark: Detects current active slot (`_a` or `_b`)
* :white_check_mark: Locates important partitions: `boot`, `init_boot`, `vendor_boot`, `vendor_kernel_boot`, `super`, `userdata`, `efs`, `efs_backup`
* :white_check_mark: Creates timestamped backup folder (`YYYY.MM.DD_HHMM`)
* :white_check_mark: Checks for `adb.exe` presence and handles missing directories
* :white_check_mark: Outputs `.img` files of partitions in the backup directory
* :white_check_mark: Cleans up temporary files after backup
* :white_check_mark: Uses emojis and readable console output for better UX

**Usage**

1. Place the adb-backup.bat file into the same folder as your Android Debugging Bridge installation (Where the `adb.exe` file is located at).
2. Run the batch file and enter a folder path for storing the backups.
3. Wait for the script to complete; backups will be saved in a timestamped folder.

**Compatibility:**

* Tested on **Windows 11**.
* Tested with **Pixel 7 Pro** (rooted).
* Should work on similar Windows versions and rooted Android devices with ADB support and a/b partitions, though not fully tested.

---

**Note:**

* Requires a **rooted** Android device.
* Large partitions may take a while to back up depending on device/cable speed.
* Make sure ADB is functional and your device is securely connected.

---

