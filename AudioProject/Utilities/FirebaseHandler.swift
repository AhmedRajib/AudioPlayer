//
//  FirebaseHandler.swift
//  AudioProject
//
//  Created by ahmed rajib on 21/11/23.
//

import Foundation
import Firebase

class FirebaseHandler {
    static func fetchDataFromFirestore(completionHandler: @escaping([String: Any])-> Void)  {
        // Get a reference to the Firestore database
        let db = Firestore.firestore()
        var info: [String : String] = [:]
        
        // Reference to a specific collection in Firestore
        let yourCollectionRef = db.collection("AudioURL")
        
        // Perform a query to get documents from the collection
       
        yourCollectionRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {

//                guard let value = querySnapshot.value as? [String: Any] else {
//                    completionHandler(nil)
//                    return
//                }\
                guard let documents = querySnapshot?.documents else {
                    print("No documents found.")
                    return
                }
                for document in documents {
                    // Convert the document data to [String: Any]
//                    let documentData = document.data()
                    
                    completionHandler(document.data())
                }
            }
        }
    }
}
