//
//  FileManagerExt.swift
//  NamesToFaces
//
//  Created by Ma Xueyuan on 2020/06/11.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit

extension FileManager {
    func getImageInDocumentsDirectory(imageName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(imageName)
        return UIImage(contentsOfFile: url.path)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
