//
//  UserPayload.swift
//  TodoAPI
//
//  Created by GaneshBalaraju on 21/06/25.
//


import JWT
import Foundation

struct UserPayload: JWTPayload , @unchecked Sendable{
    var subject: SubjectClaim       // 👈 user ID
    var expiration: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try expiration.verifyNotExpired()
    }
    
    var userID: UUID {
        UUID(uuidString: subject.value)!
    }
}

