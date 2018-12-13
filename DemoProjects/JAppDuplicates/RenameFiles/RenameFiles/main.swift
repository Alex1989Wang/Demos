//
//  main.swift
//  RenameFiles
//
//  Created by JiangWang on 2018/12/13.
//  Copyright © 2018 JiangWang. All rights reserved.
//

import Foundation

var dir = "/Users/jiang/Documents/GitRepos/Demos/DemoProjects/JAppDuplicates/RenameFiles/TestFiles"
var project = "/Users/jiang/Documents/GitRepos/Demos/DemoProjects/JAppDuplicates/RenameFiles/TestFiles/project.pbxproj"
var projectStr = ""
var prefix = "SC" //selfie camera
var newPrefix = "PC" //pinca
var files = [String]()
let fileManager = FileManager.default

class FileRenamer {
    let console = ConsoleIO()

    /// start renaming files
    public func rename() {
        files = allFiles(in: dir)
        let prjStr = try? String.init(contentsOfFile: project)
        assert(prjStr != nil)
        projectStr = prjStr!

        //rename
        for file in files {
            autoreleasepool(invoking: {
                let renamed = rename(file: file, project: projectStr)
                if !renamed {
                    console.writeMessage("failed to rename: " + file, to: .error)
                }
            })
        }
        
        //remove old proj
        try? fileManager.removeItem(atPath: project)
        let prjData = projectStr.data(using: .utf8)
        fileManager.createFile(atPath: project, contents: prjData, attributes: nil)
    }
    
    
    /// Find files with extension .xib|.h|.m
    private func allFiles(in dir:String) -> [String] {
        var files = [String]()
        let contents = try? FileManager.default.contentsOfDirectory(atPath: dir)
        if let contentList = contents {
            for content in contentList {
                let fullPath = dir.appending("/"+content)
                var isDir: ObjCBool = false
                fileManager.fileExists(atPath: fullPath, isDirectory: &isDir)
                if isDir.boolValue {
                    let subFiles = allFiles(in: fullPath)
                    files.append(contentsOf: subFiles)
                    continue
                }
                
                //not dir - extension match
                if fileExtensionValid(file: content) {
                    files.append(fullPath)
                }
            }
        }
        return files
    }
    
    
    /// rename a single file
    private func rename(file: String, project: String) -> Bool {
        var ret = false
        let nsFile = file as NSString
        let fileName = nsFile.lastPathComponent
        assert(fileExtensionValid(file: fileName))
        
        if let newFileName = newFileName(with: fileName) {
            console.writeMessage("==============\n"
                + "rename: " + fileName + "\n"
                + "to: " + newFileName)

            //project file substitution
            projectStr = project.replacingOccurrences(of: fileName, with: newFileName)

            //source files import && xib
            for anyFile in files {
                if let anyFileStr = try? String.init(contentsOfFile: anyFile) {
                    let fileContent = anyFileStr.replacingOccurrences(of: fileName, with: newFileName)
                    try? fileManager.removeItem(atPath: anyFile)
                    let fileData = fileContent.data(using: .utf8)
                    fileManager.createFile(atPath: anyFile, contents: fileData, attributes: nil)
                }
                else {
                    console.writeMessage("failed to read: " + anyFile, to: .error)
                }
            }

            ret = true
        }
        
        return ret
    }
    
    private func fileExtensionValid(file: String) -> Bool {
        var valid = false
        let nsFile: NSString = file as NSString
        let pathExt = nsFile.pathExtension
        valid = (pathExt == "xib" || pathExt == "h" || pathExt == "m")
        return valid
    }
    
    private func newFileName(with old: String) -> String? {
        var new: String? = old
        new = old.contains(prefix) ? old.replacingOccurrences(of: prefix, with: newPrefix) : nil
        return new
    }
}

let renamer = FileRenamer()
renamer.rename()

