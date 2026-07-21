      brightnessctl s 0
    elif echo "$line" | grep -q "value 0"; then
      # Lid opened
      if [[ -f "$SAVED" ]]; then
        brightnessctl s "$(cat $SAVED)"
        rm "$SAVED"
      fi
    fi
  fi
done
EOF

sudo chmod +x /usr/local/bin/lid-watcher.sh
sudo pacman -S evtest  # if not installed
sudo tee /etc/systemd/system/lid-watcher.service << 'EOF'
[Unit]
Description=Lid brightness handler
After=multi-user.target

[Service]
ExecStart=/usr/local/bin/lid-watcher.sh
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now lid-watcher
sudo evtest /dev/input/event0
# then close the lid — you should see SW_LID events
    sudo dmidecode -s bios-version
~ #     sudo dmidecode -s bios-version
1.34.0
~ # sudo pacman -S fwupd
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
sudo pacman -S fwupd
sudo fwupdmgr refresh
sudo fwupdmgr get-updates
Packages (8) confuse-3.3-5  flashrom-1.7.0-1  fwupd-efi-1.8-2
             libcbor-0.14.0-1  libftdi-1.5-10  libjcat-0.2.6-1
             passim-0.1.11-1  fwupd-2.1.2-1
Total Download Size:   13.79 MiB
Total Installed Size:  27.96 MiB
:: Proceed with installation? [Y/n] y
:: Retrieving packages...
 libjcat-0.2.6-1-...    89.5 KiB   184 KiB/s 00:00 [#################] 100%
 passim-0.1.11-1-...    83.4 KiB   144 KiB/s 00:01 [#################] 100%
 libftdi-1.5-10-x...   122.9 KiB   210 KiB/s 00:01 [#################] 100%
 libcbor-0.14.0-1...    49.1 KiB   311 KiB/s 00:00 [#################] 100%
 confuse-3.3-5-x86_64   45.0 KiB   145 KiB/s 00:00 [#################] 100%
 fwupd-efi-1.8-2-any    29.3 KiB  91.2 KiB/s 00:00 [#################] 100%
 flashrom-1.7.0-1...     5.0 MiB  1678 KiB/s 00:03 [#################] 100%
 fwupd-2.1.2-1-x86_64    8.4 MiB   920 KiB/s 00:09 [#################] 100%
 Total (8/8)            13.8 MiB  1397 KiB/s 00:10 [#################] 100%
(8/8) checking keys in keyring                     [#################] 100%
(8/8) checking package integrity                   [#################] 100%
(8/8) loading package files                        [#################] 100%
(8/8) checking for file conflicts                  [#################] 100%
(8/8) checking available disk space                [#################] 100%
:: Processing package changes...
(1/8) installing confuse                           [#################] 100%
(2/8) installing libftdi                           [#################] 100%
Optional dependencies for libftdi
    python: library bindings [installed]
(3/8) installing flashrom                          [#################] 100%
Optional dependencies for flashrom
    dmidecode: for SMBIOS/DMI table decoder support [installed]
(4/8) installing fwupd-efi                         [#################] 100%
(5/8) installing libcbor                           [#################] 100%
(6/8) installing libjcat                           [#################] 100%
(7/8) installing passim                            [#################] 100%
(8/8) installing fwupd                             [#################] 100%
Optional dependencies for fwupd
    python-dbus: Firmware packaging tools [installed]
    python-gobject: Firmware packaging tools [installed]
    udisks2: UEFI firmware upgrade support [installed]
:: Running post-transaction hooks...
(1/6) Creating system user accounts...
Creating group 'fwupd' with GID 947.
Creating user 'fwupd' (Firmware update daemon) with UID 947 and GID 947.
Creating group 'passim' with GID 946.
Creating user 'passim' (Local Caching Server) with UID 946 and GID 946.
(2/6) Reloading system manager configuration...
(3/6) Reloading device manager configuration...
(4/6) Arming ConditionNeedsUpdate...
(5/6) Reloading system bus configuration...
(6/6) Updating icon theme caches...
Updating lvfs
Downloading…             ▕⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦▏
Successfully downloaded new metadata:
 • 13 devices are updatable
 • 5 devices are supported in the enabled remotes (an update has been published)
Devices with no available firmware updates:
 • Internal SPI Controller (BIOS)
 • Bios DB Key
 • Bios FW Aux Authority
 • Key Exchange Key
 • PCH SPI Controller
 • TPM
 • UEFI Device Firmware
 • UEFI Device Firmware
 • Windows Production PCA
Devices with the latest available firmware version:
 • PM991a NVMe Samsung 512GB
Dell Inc. Inspiron 15 3520
│
├─KEK CA:
│ │   Device ID:          b7a1d3d90faa1f6275d9a98da4fb3be7118e61c7
│ │   Current version:    2011
│ │   Vendor:             Microsoft (UEFI:Microsoft)
│ │   GUIDs:              814e950f-1449-566a-a190-42c9d3a3a2df ← UEFI\VENDOR_Microsoft&NAME_Microsoft-KEK-CA
│ │                       dfa66406-6568-5bdf-bb8e-b53ddb4be4cf ← UEFI\CRT_9F402B1CC0243CBEDC58A525789816CCCA7687A9
│ │   Device Flags:       • Internal device
│ │                       • Updatable
│ │                       • Supported on remote server
│ │                       • Needs a reboot after installation
│ │                       • Device is usable for the duration of the update
│ │                       • Signed Payload
│ │                       • Can tag for emulation
│ │ 
│ └─Secure Boot KEK Configuration Update:
│       New version:      2023
│       Remote ID:        lvfs
│       Release ID:       113921
│       Summary:          UEFI Secure Boot Key Exchange Key
│       Variant:          Dell
│       License:          Proprietary
│       Size:             2.9 kB
│       Created:          2025-04-29 00:00:00
│       Urgency:          High
│       Vendor:           Linux Foundation
│       Release Flags:    • Trusted metadata
│                         • Is upgrade
│       Description:      
│       This updates the UEFI Signature Database (the "KEK") to the latest release from Microsoft, signed by Dell Inc.Platform Key.
│       Checksum:         8c6f7c473afceac2bd26b1598e26991f710875cc25d0ce08cbe0a90867ea9914
│     
├─System Firmware:
│ │   Device ID:          ee94f8e437ac3be6602c7f3916939dbb63f7556f
│ │   Summary:            UEFI System Resource Table device (updated via NVRAM)
│ │   Current version:    1.34.0
│ │   Minimum Version:    1.34.0
│ │   Vendor:             Dell (DMI:Dell Inc.)
│ │   Update State:       Success
│ │   GUID:               86cb8db0-84f3-4340-8b2f-682c305f2083
│ │   Device Flags:       • Internal device
│ │                       • Updatable
│ │                       • System requires external power source
│ │                       • Supported on remote server
│ │                       • Needs a reboot after installation
│ │                       • Cryptographic hash verification is available
│ │                       • Device is usable for the duration of the update
│ │   Device Requests:    • Message
│ │ 
│ └─Inspiron 15 3520, Inspiron 15 3520, Vostro 3520, Vostro 3520, Vostro 3420, Vostro 3420 System Update:
│       New version:      1.39.0
│       Remote ID:        lvfs
│       Release ID:       134893
│       Summary:          Firmware for the Dell Inspiron 15 3520, Inspiron 15 3520, Vostro 3520, Vostro 3520, Vostro 3420, Vostro 3420
│       License:          Proprietary
│       Size:             43.7 MB
│       Created:          2025-12-29 03:38:53
│       Urgency:          Critical
│       Vendor:           Dell
│       Release Flags:    • Trusted metadata
│                         • Is upgrade
│       Description:      
│       Fixes and Enhancements
│       
│       ==========================
│       
│       • This release contains security updates as disclosed in the Dell Security Advisories.
│       Checksum:         e9923d41744dff57a510d874afeb147f95f0314a3c00c83512bc228b18e26ec8
│     
├─UEFI CA:
│ │   Device ID:          5bc922b7bd1adb5b6f99592611404036bd9f42d0
│ │   Current version:    2011
│ │   Vendor:             Microsoft (UEFI:Microsoft)
│ │   GUIDs:              26f42cba-9bf6-5365-802b-e250eb757e96 ← UEFI\VENDOR_Microsoft&NAME_Microsoft-UEFI-CA
│ │                       c34a7e6a-bd86-5244-8bd0-7db66fd3c073 ← UEFI\CRT_E30CF09DABEAB32A6E3B07A7135245DE05FFB658
│ │   Device Flags:       • Internal device
│ │                       • Updatable
│ │                       • Supported on remote server
│ │                       • Needs a reboot after installation
│ │                       • Signed Payload
│ │                       • Can tag for emulation
│ │ 
│ └─Secure Boot Signature Database Configuration Update:
│       New version:      2023
│       Remote ID:        lvfs
│       Release ID:       116503
│       Summary:          UEFI Secure Boot Signature Database
│       License:          Proprietary
│       Size:             10.0 kB
│       Created:          2025-04-29 00:00:00
│       Urgency:          High
│         Tested:         2026-04-20 00:00:00
│         Distribution:   ubuntu 25.10
│         Old version:    2011
│         Version[fwupd]: 2.0.16
│         Tested:         2025-10-17 00:00:00
│         Distribution:   fedora 42 (workstation)
│         Old version:    2011
│         Version[fwupd]: 2.0.16
│         Tested:         2025-09-17 00:00:00
│         Distribution:   fedora 42 (workstation)
│         Old version:    2011
│         Version[fwupd]: 2.0.16
│         Tested:         2025-07-24 00:00:00
│         Distribution:   nixos 25.11
│         Old version:    2011
│         Version[fwupd]: 2.0.12
│       Vendor:           Microsoft
│       Release Flags:    • Trusted metadata
│                         • Is upgrade
│       Description:      
│       This updates the 3rd Party UEFI Signature Database (the "db") to the latest release from Microsoft.It also adds the latest OptionROM UEFI Signature Database update.
│       Checksum:         4bdf420ad7e5ddde89d7a66ffe1b4328927059d56551f03afac855c4ed80f6c3
│     
└─UEFI dbx:
  │   Device ID:          362301da643102b9f38477387e2193e57abaa590
  │   Summary:            UEFI revocation database
  │   Current version:    20210401
  │   Minimum Version:    20210401
  │   Vendor:             Microsoft (UEFI:Microsoft)
  │   Install Duration:   1 second
  │   GUIDs:              4a6cd2cb-8741-5257-9d1f-89a275dacca7 ← UEFI\CRT_E28D59CA489BD2AD580F2EA5D62D6A29BB9C02AE5A818434A37DA7FC11DFF9E9&ARCH_X64
  │                       f8ba2887-9411-5c36-9cee-88995bb39731 ← UEFI\CRT_A1117F516A32CEFCBA3F2D1ACE10A87972FD6BBE8FE0D0B996E09E65D802A503&ARCH_X64
  │   Device Flags:       • Internal device
  │                       • Updatable
  │                       • Supported on remote server
  │                       • Needs a reboot after installation
  │                       • Device is usable for the duration of the update
  │                       • Only version upgrades are allowed
  │                       • Signed Payload
  │                       • Can tag for emulation
  │ 
  ├─Secure Boot dbx Configuration Update:
  │     New version:      20250902
  │     Remote ID:        lvfs
  │     Release ID:       130035
  │     Summary:          UEFI Secure Boot Forbidden Signature Database
  │     Variant:          x64
  │     License:          Proprietary
  │     Size:             24.1 kB
  │     Created:          2025-09-02 00:00:00
  │     Urgency:          High
  │       Tested:         2026-04-20 00:00:00
  │       Distribution:   ubuntu 25.10
  │       Old version:    20230501
  │       Version[fwupd]: 2.0.16
  │       Tested:         2026-02-25 00:00:00
  │       Distribution:   ubuntu 25.10
  │       Old version:    20230501
  │       Version[fwupd]: 2.0.18
  │       Tested:         2026-02-13 00:00:00
  │       Distribution:   ubuntu 25.10
  │       Old version:    20230501
  │       Version[fwupd]: 2.0.17
  │       Tested:         2025-12-05 00:00:00
  │       Distribution:   fedora 42 (workstation)
  │       Old version:    20250507
  │       Version[fwupd]: 2.0.17
  │       Tested:         2025-11-10 00:00:00
  │       Distribution:   fedora 43 (kde)
  │       Old version:    20230501
  │       Version[fwupd]: 2.0.16
  │     Vendor:           Linux Foundation
  │     Duration:         1 second
  │     Release Flags:    • Trusted metadata
  │                       • Is upgrade
  │                       • Tested by trusted vendor
  │     Description:      
  │     This updates the list of forbidden signatures (the "dbx") to the latest release from Microsoft.
  │     
  │     Some insecure versions of the IGEL bootloader were added, due to a security vulnerability that allowed an attacker to bypass UEFI Secure Boot.
  │     Issue:            CVE-2025-47827
  │     Checksum:         7178302fa23fcb875e7540900e299fb30a76758663efb7e1c56edc25cd3f316a
  │   
  ├─Secure Boot dbx Configuration Update:
  │     New version:      20250507
  │     Remote ID:        lvfs
  │     Release ID:       115586
  │     Summary:          UEFI Secure Boot Forbidden Signature Database
  │     Variant:          x64
  │     License:          Proprietary
  │     Size:             24.0 kB
  │     Created:          2025-01-17 00:00:00
  │     Urgency:          High
  │       Tested:         2025-10-17 00:00:00
  │       Distribution:   fedora 42 (workstation)
  │       Old version:    20230501
  │       Version[fwupd]: 2.0.16
  │       Tested:         2025-06-11 00:00:00
  │       Distribution:   fedora 42 (workstation)
  │       Old version:    20241101
  │       Version[fwupd]: 2.0.11
  │     Vendor:           Linux Foundation
  │     Duration:         1 second
  │     Release Flags:    • Trusted metadata
  │                       • Is upgrade
  │                       • Tested by trusted vendor
  │     Description:      
  │     This updates the list of forbidden signatures (the "dbx") to the latest release from Microsoft.
  │     
  │     Some insecure versions of BiosFlashShell and Dtbios by DT Research Inc were added, due to a security vulnerability that allowed an attacker to bypass UEFI Secure Boot.
  │     Issues:           806555
  │                       CVE-2025-3052
  │     Checksum:         40d3a4630619b83026f66bc64d97a582bbd9223ad53aa3f519ff5e2121d11ca6
  │   
  └─Secure Boot dbx Configuration Update:
        New version:      20241101
        Remote ID:        lvfs
        Release ID:       105821
        Summary:          UEFI Secure Boot Forbidden Signature Database
        Variant:          x64
        License:          Proprietary
        Size:             15.1 kB
        Created:          2025-01-17 00:00:00
        Urgency:          High
          Tested:         2026-02-25 00:00:00
          Distribution:   ubuntu 24.04
          Old version:    20230501
          Version[fwupd]: 1.9.28
        Vendor:           Linux Foundation
        Duration:         1 second
        Release Flags:    • Trusted metadata
                          • Is upgrade
        Description:      
        This updates the list of forbidden signatures (the "dbx") to the latest release from Microsoft.
        
        An insecure version of Howyar's SysReturn software was added, due to a security vulnerability that allowed an attacker to bypass UEFI Secure Boot.
        Issues:           529659
                          CVE-2024-7344
        Checksum:         093e6913dfecefbdaa9374a2e1caee7bf7e74c7eda847624e456e344884ba5f6
      
~ #sudo fwupdmgr update 
GAME_ROOT="/home/riwxr/Games/The Elder Scrolls - Skyrim - Special Edition" ~/Downloads/mo2installer-6.0.6/install.sh
grep -n "GAME\|game_root\|gamepath\|game_path\|GamePath" ~/Downloads/mo2installer-6.0.6/install.sh | head -30
mkdir -p ~/.local/share/Steam/Steam/steamapps/common
ln -s "/home/riwxr/Games/The Elder Scrolls - Skyrim - Special Edition" ~/.local/share/Steam/Steam/steamapps/common/Skyrim\ Special\ Edition
cat > ~/.local/share/Steam/Steam/steamapps/libraryfolders.vdf << 'EOF'
"libraryfolders"
{
	"0"
	{
		"path"		"/home/riwxr/.local/share/Steam/Steam"
		"apps"
		{
			"489830"		"1"
		}
	}
}
EOF

STEAM_LIBRARY="/home/riwxr/.local/share/Steam/Steam" ~/Downloads/mo2installer-6.0.6/install.sh
mkdir -p ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/gog_store
cat > ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/gog_store/installed.json << 'EOF'
{
  "installed": [
    {
      "appName": "1711230643",
      "install_path": "/home/riwxr/Games/The Elder Scrolls - Skyrim - Special Edition"
    }
  ]
}
EOF

cp ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/nCKGHyY6wwsjGVzqhmNG1b.json    ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1711230643.json
sed -i 's/nCKGHyY6wwsjGVzqhmNG1b/1711230643/g'     ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1711230643.json
STEAM_LIBRARY="/home/riwxr/.local/share/Steam/Steam" ~/Downloads/mo2installer-6.0.6/install.sh
bash -x ~/Downloads/mo2installer-6.0.6/utils/find-heroic-game-installation.sh 2>&1 | grep -E "INFO|ERROR|WARN|skyrim|gog|prefix|wine|1711"
cat ~/Downloads/mo2installer-6.0.6/step/clean_game_prefix.sh
sed -i 's|/home/riwxr/Games/Heroic/Prefixes/default/Skyrim"|/home/riwxr/Games/Heroic/Prefixes/default/Skyrim SE"|g'     ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1711230643.json
grep winePrefix ~/.var/app/com.heroicgameslauncher.hgl/config/heroic/GamesConfig/1711230643.json
STEAM_LIBRARY="/home/riwxr/.local/share/Steam/Steam" ~/Downloads/mo2installer-6.0.6/install.sh
game_gog_id=1711230643 bash -x ~/Downloads/mo2installer-6.0.6/utils/find-heroic-game-installation.sh 2>&1
game_gog_id=1711230643 bash -x ~/Downloads/mo2installer-6.0.6/utils/find-heroic-game-installation.sh 2>&1
find ~ -name "*mo2*" -o -name "*ModOrganizer*" 2>/dev/null | grep -v "Games/mo2" | grep -v Downloads | grep -v lutris
cat ~/.local/share/mo2installer/installations.json 2>/dev/null || find ~ -path "*/mo2installer/*" 2>/dev/null
find ~ -name "*modorganizer*" -o -name "*mo2*" 2>/dev/null | grep -v "\.20260522\|Downloads\|Games/mo2/pfx" | head -20
find ~ -name "*modorganizer*" -o -name "*mo2*"  
find ~ -name "*modorganizer*" -o -name "*mo2*" 2>/dev/null | grep -v "\.20260522\|Downloads\|Games/mo2/pfx" | head -20
ls ~/Games/Heroic/mod-organizer-2-skyrimspecialedition/
cat ~/Games/Heroic/mod-organizer-2-skyrimspecialedition/variables.sh
ls ~/Games/Heroic/mod-organizer-2-skyrimspecialedition/modorganizer2/
find ~ -name "*.sh" -newer ~/Downloads/mo2installer-6.0.6/install.sh 2>/dev/null | grep -v flatpak | head -20
find ~/.local/share/applications -name "*mo2*" -o -name "*organizer*" 2>/dev/null
cat ~/.local/share/applications/modorganizer2-nxm-handler.desktop
cat ~/.local/share/modorganizer2/modorganizer2-nxm-broker.sh
/home/riwxr/Games/Heroic/mod-organizer-2-skyrimspecialedition/modorganizer2/ModOrganizer.exe
cat ~/.local/share/modorganizer2/modorganizer2-nxm-broker.sh | head -20
WINEPREFIX="/home/riwxr/Games/Heroic/Prefixes/default/Skyrim SE" wine "/home/riwxr/Games/Heroic/mod-organizer-2-skyrimspecialedition/modorganizer2/ModOrganizer.exe"
fish
sudo EDITOR=nvim virsh edit win11
sudo virsh dumpxml win11 > /tmp/win11.xml
nvim /tmp/win11.xml
env | grep -E 'GTK_THEME|QT_QPA_PLATFORMTHEME|XDG_CURRENT_DESKTOP'
nwg-look
pacman -Qs qt5ct
pacman -Qs qt6ct
echo $QT_QPA_PLATFORMTHEME
# 1. Make sure flatpak Zen isn't running either
flatpak kill app.zen_browser.zen 2>/dev/null
# 2. Find the flatpak's actual default profile folder name (in case it's not kkhfhl8e anymore after the reinstall)
FLATPAK_PROFILES_INI="$HOME/.var/app/app.zen_browser.zen/.var/app/app.zen_browser.zen/.config/profiles.ini"
cat "$HOME/.var/app/app.zen_browser.zen/.config/profiles.ini" 2>/dev/null
# 3. Backup the entire flatpak data dir just in case (cheap insurance, it's small)
cp -a "$HOME/.var/app/app.zen_browser.zen" "$HOME/.var/app/app.zen_browser.zen.bak-$(date +%Y%m%d%H%M%S)"
echo "Backup done. Now paste me the profiles.ini output above before we proceed to the actual copy."
PROFILE_DIR="$HOME/.var/app/app.zen_browser.zen/.config/kkhfhl8e.Default (release)-1"
SOURCE_DIR="$HOME/.zen/ya5civi8.Default (release)"
# Sanity checks before touching anything
echo "Source exists:"; ls -ld "$SOURCE_DIR"
echo "Target exists:"; ls -ld "$PROFILE_DIR"
# Wipe the old junk profile contents (folder itself stays, contents go)
rm -rf "$PROFILE_DIR"
mkdir -p "$PROFILE_DIR"
# Copy your real profile in
cp -a "$SOURCE_DIR"/. "$PROFILE_DIR"/
# Fix ownership/permissions just in case (flatpak runs as your user, should be fine, but be safe)
chmod 700 "$PROFILE_DIR"
echo "=== Done. Verifying ==="
ls "$PROFILE_DIR" | head -20
du -sh "$PROFILE_DIR"
echo "=== installs.ini ==="
cat "$HOME/.var/app/app.zen_browser.zen/.config/installs.ini" 2>/dev/null
echo "=== profiles.ini (recheck) ==="
cat "$HOME/.var/app/app.zen_browser.zen/.config/profiles.ini" 2>/dev/null
echo "=== Did a NEW profile folder just get created? ==="
ls -la "$HOME/.var/app/app.zen_browser.zen/.config/" | grep -i "release\|profile\|study\|secendory"
echo "=== Confirm our copied data is still actually there ==="
ls "$HOME/.var/app/app.zen_browser.zen/.config/kkhfhl8e.Default (release)-1/bookmarkbackups" 2>/dev/null
echo "=== Is there now ANOTHER profiles.ini key for a new install? ==="
cat "$HOME/.var/app/app.zen_browser.zen/.config/profiles.ini"
echo "=== What's actually inside kkhfhl8e right now ==="
ls -la "$HOME/.var/app/app.zen_browser.zen/.config/kkhfhl8e.Default (release)-1/"
echo "=== What's actually inside the ya5civi8 folder sitting in .config ==="
ls -la "$HOME/.var/app/app.zen_browser.zen/.config/ya5civi8.Default (release)/" 2>/dev/null
echo "=== Check flatpak's actual current install hash ==="
flatpak info --show-metadata app.zen_browser.zen | grep -i instance 2>/dev/null
flatpak run --command=true app.zen_browser.zen 2>&1 | head -5
pgrep -af "app.zen_browser.zen"
echo "---"
ls -la /proc/$(pgrep -f "app/zen/zen --name" | head -1)/cwd 2>/dev/null
echo "---"
cat /proc/$(pgrep -f "app/zen/zen --name" |
    cat /etc/xdg/xdg-desktop-portal/portals.conf 2>/dev/null
    cat ~/.config/xdg-desktop-portal/portals.conf 2>/dev/null
    ls /usr/share/xdg-desktop-portal/portals/
xdg-desktop-portal -v
mkdir -p ~/.config/xdg-desktop-portal
cat > ~/.config/xdg-desktop-portal/portals.conf << 'EOF'
[preferred]
default=gtk
EOF

[preferred]
default=gtk
org.freedesktop.impl.portal.ScreenCast=wlr
org.freedesktop.impl.portal.Screenshot=wlr
systemctl --user daemon-reload
systemctl --user restart xdg-desktop-portal.service
zapzap
systemctl --user status xdg-desktop-portal.service
    cat ~/.config/autostart/*zapzap* 2>/dev/null
exec-once = systemctl --user start xdg-desktop-portal.service xdg-desktop-portal-gtk.service
systemctl --user start xdg-desktop-portal.service
zapzap
swaync --version
cat ~/.config/swaync/config.json 2>/dev/null | head -5
grep -n -i "exec\|battery\|full" ~/.config/mango/waybar/line/config.jsonc
  "exec": "~/player_title.sh",
cat ~/.local/submap.log
cat ~/.local/submap.log
grep -rn "submap.log" ~/.config/mango/
cat /sys/class/power_supply/BAT*/status
WAYLAND_DEBUG=1 swaync 2>&1 | tail -30
WAYLAND_DEBUG=1 swaync 2>&1 | tail -30 | wl-copy 
grep -n swaync ~/.config/*/autostart.sh ~/autostart.sh 2>/dev/null
pgrep -a swaync
nvim ~/.config/mango/autostart.sh
pgrep -a swaync
pkill -9 swaync
sleep 1
pgrep -a swaync
mango --help 2>&1 | grep -i systemd
man mango 2>&1 | grep -i systemd
systemctl --user edit --full --force mango-session.target
sudo systemctl edit ollama.service
sudo ln -sf $(which nvim) /usr/local/bin/vi
which nvim
foot
ls
quit
exitr
exit
