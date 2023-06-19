# 🚀Welcome to Terraria Server Modding Utility - Your Tool easing the redundancies, and pain of modding and version management

Assuming you have hosted a server at one point and it had more than 10 mods, you probably ran into an issue of where you were monotonously opening and trying to figure out what version the steam launcher downloaded and trying to version match your mods to the server, etc... This program fixes that such issue!

## 📂 The Mods Directory Layout

![Mods Directory](https://storage.googleapis.com/psycho_upload/ShareX/2023/06/explorer_TzVGLpFKVc.png)

This is what the root folder of Terraria mods looks like. Assuming that you downloaded it from the steam workshop

And, the individual folders appear something like this:

![Internal Folders](https://storage.googleapis.com/psycho_upload/ShareX/2023/06/explorer_XFYSkCNq8Q.png)

## 🛠 The Config File Example 

```json
{
    "blacklist":  {
                      "ImprovedTeleporters":  false,
                      "BossesAsNPCs":  false,
                      "PortalCursor":  true,
                      "GodNPC":  false,
                      "AdvancedWorldGen":  false,
                      "WingSlotExtra":  false
                  },
    "modsDirectoryTarget":  "C:\\Program Files (x86)\\Steam\\steamapps\\workshop\\content\\1281930",
    "clearOutputDir":  true,
    "loggingEnabled":  false,
    "collectVersions":  true,
    "outputFolder":  "C:\\Users\\<your name>\\Desktop\\Terraria",
    "preferredDates":  [
                           "2022.9",
                           "2022.8",
                           "2022.7",
                           "2022.6"
                       ],
    "runSilent":  false
}
```

Here's a brief explanation of the config file:

- `blacklist`: Set to `true` to avoid specific mods. Useful for client mods, which cannot be loaded on the server.
- `modsDirectoryTarget`: Specifies the location of your local mod repository.  (should look like the The Mods Directory Layout)
- `clearOutputDir`: If `true`, it clears the output directory before starting a new operation. 
- `loggingEnabled`: Enable/Disable logging.
- `collectVersions`: If `true`, the tool will collect and save different mod versions to individual folders (regardless of preferredDates's filtering (mods that dont have versions are categorized in a folder called "root"))
- `outputFolder`: Set your desired output directory. (probably a desktop folder or somewhere you can manage)
- `preferredDates`: Specifies a date range to filter mod versions. (open the workshop mods / your tmodloader versions that are compatable)
- `runSilent`: Running the program without any GUI initalizing

This tool, scripted in PowerShell, aids in managing and organizing mods effectively, saving significant time for server owners. You have the power to group all mods into folders depending on their availability in your local mod repository.

So, are you interested? Your feedback is always appreciated and will help me enhance this tool further! Feel free to share if you want to add this tool to your repertoire or if you are just excited about tools like these. We are more than happy to evolve it and even write comprehensive documentation based on your needs and interests!

Let's make Terraria modding a delightful experience, together! 🎮
