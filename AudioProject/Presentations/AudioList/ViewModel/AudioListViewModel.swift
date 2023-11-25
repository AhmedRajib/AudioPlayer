//
//  AudioListViewModel.swift
//  AudioProject
//
//  Created by ahmed rajib on 22/11/23.
//

import Foundation

class AudioListViewModel {
    var audioList: [String : Any] = [:]
    var keyArray: [String] = []
    var valuesArray: [String] = []
    
    ///  Get AudioLists From Firebase
    func getAudioList(completionHandler: @escaping(Bool)-> Void) {
        FirebaseHandler.fetchDataFromFirestore(completionHandler: { [weak self] links in
            self?.audioList = links
            self?.keyArray = self?.audioList.keys.map { String($0) } ?? []
            completionHandler(true)
        })
    }
}
