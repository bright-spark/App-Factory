import Foundation
import Cocoa

public class IAScriptDrop : NSImageView {
    public var scriptPath: String?
    @IBOutlet var scriptLabel: NSTextField?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerForDraggedTypes([NSURLPboardType])
    }
    
    public override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        let pboard     = sender.draggingPasteboard()
        let scriptPath = NSURL(fromPasteboard: pboard)?.path
        
        if scriptSizeValid(scriptPath!) {
            self.scriptPath = scriptPath
            
            if var displayName = scriptPath?.lastPathComponent {
                self.scriptLabel?.stringValue = displayName
                self.scriptLabel?.textColor   = NSColor.controlDarkShadowColor()
            }
        } else {
            var alert = NSAlert()
            alert.messageText = "Error"
            alert.informativeText = "Script must be larger than 28 bytes"
            alert.runModal()
        }
        
        return true
    }
    
    private func scriptSizeValid(scriptPath: NSString) -> Bool {
        var err: NSErrorPointer = nil
        let fileManager = NSFileManager.defaultManager()
        let attrs       = fileManager.attributesOfItemAtPath(scriptPath, error: err) as NSDictionary!
        
        return attrs.fileSize() > 28
    }
}
