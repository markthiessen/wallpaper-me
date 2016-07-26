#http://stackoverflow.com/questions/19721554/rundll32-updateperusersystemparameters-not-working-with-windows-7
Add-Type @"
using System;
using System.Runtime.InteropServices;
using Microsoft.Win32;
namespace Wallpaper
{
   public class Setter {
      public const int SetDesktopWallpaper = 20;
      public const int UpdateIniFile = 0x01;
      public const int SendWinIniChange = 0x02;
      [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
      private static extern int SystemParametersInfo (int uAction, int uParam, string lpvParam, int fuWinIni);
      public static void SetWallpaper ( string path) {
         SystemParametersInfo( SetDesktopWallpaper, 0, path, UpdateIniFile | SendWinIniChange );
         RegistryKey key = Registry.CurrentUser.OpenSubKey("Control Panel\\Desktop", true);
         key.Close();
      }
   }
}
"@

#get the path of the current landscape lock screen image
$lockScreenRegistryEntry = Get-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative\"
$lockScreenAssetPath = $lockScreenRegistryEntry.LandscapeAssetPath

#copy it to a file with .jpg extension so we can use it as a wallpaper..
$newFileName = "$($lockScreenAssetPath).jpg"
Copy-Item "$lockScreenAssetPath" "$newFileName"

[Wallpaper.Setter]::SetWallpaper("$newFileName")
