//
//  APICaller.swift
//  infiniting scr
//
//  Created by Admin on 02/12/22.
//

import Foundation

class APICaller {
    
    var isPaginating = false
    
    func fetchData(pagination: Bool = false, completion: @escaping(Result<[String],Error>) -> Void){
        if isPaginating{
            isPaginating = true
        }
        //for delaying our data
        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 1), execute: {
            let originalData = [
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook",
                "apple",
                "google",
                "facebook"
            ]
            
            let newData = [
                "vivo",
                "oppo",
                "realme"
            ]
            completion(.success(pagination ? newData : originalData))
            if pagination {
                self.isPaginating = false
            }
        } )
        
    }
}
