//
//  AmazonS3Service.swift
//  monochrome
//
//  Created by Siew Mai Chan on 08/12/2015.
//  Copyright © 2015 Siew Mai Chan. All rights reserved.
//

import Foundation
import AmazonS3RequestManager

class AmazonS3Service {
    static let instance = AmazonS3Service()
    
    private let amazonS3Manager: AmazonS3RequestManager!
    
    init() {
        amazonS3Manager = AmazonS3RequestManager(bucket: BUCKET_NAME,
            region: REGION,
            accessKey: ACCESS_KEY,
            secret: SECRET_KEY)
    }
    
    func uploadImageData(imageData: NSData, folderName: String, fileName: String, completion: (nsurl: NSURL) -> Void){
        amazonS3Manager.putObject(imageData, destinationPath: "\(folderName)/\(fileName)").responseS3Data { response in
            print(response.debugDescription)
            if response.result.error == nil {
                completion(nsurl: (response.response?.URL)!)
            }
        }
    }
    
}