import Foundation

class ScriptConverter {
    var scriptPath: String
    var savePath: String
    var iconPath: String?
    var fullAppPath: String
    var resourcesPath: String
    var iconFileName: String
    var fileManager: NSFileManager
    
    init(scriptPath: String, savePath: String, iconPath: String) {
        self.scriptPath = scriptPath
        self.savePath = savePath
        self.iconPath = iconPath
        
        self.fullAppPath = NSString.pathWithComponents([savePath, "Contents/MacOS/"])
        self.resourcesPath = NSString.pathWithComponents([savePath, "Contents/Resources/"])
        self.iconFileName = iconPath.lastPathComponent.stringByDeletingPathExtension + ".icns"
        
        self.fileManager = NSFileManager.defaultManager()
    }
    
    func createApp() {
        writeScript()
        
        if iconPath != nil {
            writeIcon()
            writePlist()
        }
    }
    
    func writeScript() {
        fileManager.createDirectoryAtPath(fullAppPath,
            withIntermediateDirectories: true,
            attributes: nil,
            error: nil
        )
        
        if fileManager.fileExistsAtPath(scriptPath) {
            writeScriptDirectory()
        } else {
            writeScriptFile()
        }
        
    }
    
    func writePlist() {
        let content =
            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
            "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n"
            "<plist version=\"1.0\">\n"
            "\t<dict>\n"
            "\t\t<key>CFBundleIconFile</key>\n"
            "\t\t<string>\(iconFileName.stringByDeletingPathExtension)</string>\n"
            "\t</dict>\n"
            "</plist>"
        
        let plistPath = NSString.pathWithComponents([savePath, "Contents/info.plist"])
        
        content.writeToFile(plistPath,
            atomically: true,
            encoding: NSUnicodeStringEncoding,
            error: nil
        )
    }
    
    func writeScriptDirectory() {
        let files = fileManager.contentsOfDirectoryAtPath(scriptPath, error: nil)
        let appName = scriptPath.lastPathComponent
        
        for file in files as [String] {
            let fileNoExtension = file.stringByDeletingPathExtension
            let filePath = NSString.pathWithComponents([scriptPath, file])
            
            if fileNoExtension == appName {
                makeScriptExecutable(filePath)
            }
            
            fileManager.copyItemAtPath(filePath,
                toPath: NSString.pathWithComponents([fullAppPath, file]),
                error: nil
            )
        }
    }
    
    func writeScriptFile() {
        let appFileName = scriptPath.lastPathComponent.stringByDeletingPathExtension
        let fullPath = NSString.pathWithComponents([fullAppPath, appFileName])
        
        makeScriptExecutable(scriptPath)
        
        fileManager.copyItemAtPath(scriptPath,
            toPath: fullPath,
            error: nil
        )
    }
    
    func makeScriptExecutable(path: String) {
        // TODO
    }
    
    func writeIcon() {
        // TODO
    }
}




