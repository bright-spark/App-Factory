import Foundation

@objc
public class ScriptConverter : NSObject {
    private var scriptPath: String
    private var savePath: String
    private var iconPath: String?
    
    private var fullAppPath: String {
        return NSString.pathWithComponents([savePath, "Contents/MacOS/"])
    }
    
    private var resourcesPath: String {
        return NSString.pathWithComponents([savePath, "Contents/Resources/"])
    }
    
    private var fileManager: NSFileManager {
        return NSFileManager.defaultManager()
    }
    
    private var iconFileName: String {
        return iconPath!.lastPathComponent.stringByDeletingPathExtension + ".icns"
    }
    
    public init(scriptPath: String, savePath: String, iconPath: String) {
        self.scriptPath = scriptPath
        self.savePath = savePath
        self.iconPath = iconPath
    }
    
    public func createApp() {
        writeScript()
        
        if iconPath != nil {
            writeIcon()
            writePlist()
        }
    }
    
    private func writeScript() {
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
    
    private func writePlist() {
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
    
    private func writeScriptDirectory() {
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
    
    private func writeScriptFile() {
        let appFileName = scriptPath.lastPathComponent.stringByDeletingPathExtension
        let fullPath = NSString.pathWithComponents([fullAppPath, appFileName])
        
        makeScriptExecutable(scriptPath)
        
        fileManager.copyItemAtPath(scriptPath,
            toPath: fullPath,
            error: nil
        )
    }
    
    private func makeScriptExecutable(path: String) {
        if fileManager.isExecutableFileAtPath(path) {
            return
        }
        
        NSTask.launchedTaskWithLaunchPath("/bin/chmod",
            arguments: ["+x", path]
        ).waitUntilExit()
    }
    
    private func writeIcon() {
        fileManager.createDirectoryAtPath(resourcesPath,
            withIntermediateDirectories: true,
            attributes: nil,
            error: nil)
        
        let destPath = NSString.pathWithComponents([resourcesPath, iconFileName])
        
        let imgUrl = NSURL(string: iconPath!) as CFURL!
        let img = CGImageSourceCreateWithURL(imgUrl, nil);
        let ref = CGImageSourceCreateImageAtIndex(img, 1, nil)
        
        let destUrl = NSURL(string: destPath) as CFURL!
        let dest = CGImageDestinationCreateWithURL(destUrl, kUTTypeAppleICNS, 1, nil)
        
        CGImageDestinationAddImageFromSource(dest, img, 0, nil)
        CGImageDestinationFinalize(dest)
    }
}




