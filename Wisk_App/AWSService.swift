//
//  AWSService.swift
//  Wisk
//
//  Created by Michael Westbrooks II on 5/13/18.
//  Copyright © 2018 MVPGurus. All rights reserved.
//

import Foundation
import AWSS3
import AWSCore

class AWSService {
    static let shared = AWSService()
    private init() {
        print("Wisk | AWS Service Initialized")
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                                identityPoolId: awsIDPool)
        let configuration = AWSServiceConfiguration(region:.USEast1,
                                                    credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
}
