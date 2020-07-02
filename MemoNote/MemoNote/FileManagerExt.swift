//
//  FileManagerExt.swift
//  MemoNote
//
//  Created by Ma Xueyuan on 2020/07/02.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
