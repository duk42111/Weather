//
//  File.swift
//  Wipro
//
//  Created by Mladen Despotovic on 18/04/2016.
//  Copyright © 2016 Mladen Despotovic. All rights reserved.
//

import Foundation


protocol ErrorHandling {
    
    init(error:NetworkErrorType)
}

class ErrorHandler: ErrorHandling {
    
    required init(error:NetworkErrorType) {}
}