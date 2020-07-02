//
//  Memo.swift
//  MemoNote
//
//  Created by Ma Xueyuan on 2020/07/02.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import Foundation

struct Memo: Hashable {
    var id = UUID().uuidString
    var title = ""
    var detail = ""
    var editTime = Date()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
