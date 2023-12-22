//
//  ExtensionsOfAudioListVC.swift
//  AudioProject
//
//  Created by ahmed rajib on 19/11/23.
//

import UIKit
import AVFoundation
import Photos
import MediaPlayer

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.audioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioCell.identifier, for: indexPath) as! AudioCell
        cell.audioTitle.text = vm.keyArray[indexPath.row]
//        cell.musciTypeIcon.image = UIImage(named: "audio")
//        cell.downloadIcon.image = UIImage(named: "audio")
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.masksToBounds = true
        cell.layer.shadowOpacity = 0.6
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let audioUrl = vm.audioList[vm.keyArray[indexPath.row]] {
//            let str = audioUrl as? String ?? ""
//            playAudioFilesWithURL(url: str)
//        }
//        showingAudioPlayer()
//        addTimeObserver()
        showAudioScreen()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           // Set the distance between cells by specifying the height of the header between sections.
           // You can adjust this value based on your desired spacing.
           return 10.0
       }

    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableview.reloadData()
        }
    }
    
    private func playAudioFilesWithURL(url: String) {
        player = AVPlayer(url: URL(string: url)!)
        pausePlayBtn.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        player?.volume = 1
        player?.play()
    }
    
    private func showAudioScreen() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AudioScreen") as! AudioScreen
        self.present(vc, animated: true, completion: nil)
    }
}


extension ViewController {
    // MARK: - Showing MP3 player View
    private func showingAudioPlayer() {
        popupView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: { [weak self] in
            self?.popupView.frame = CGRect(x: 8, y: Constants.screenHeight - 220 , width: Constants.screenWidth - 16, height: 200)
        }, completion: nil)
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main) { [weak self] time in
            // Update progress view or perform other tasks based on time
            let currentTime = CMTimeGetSeconds(time)
            let duration = CMTimeGetSeconds(self?.player?.currentItem?.duration ?? CMTime.zero)
            let progress = Float((currentTime) / duration)
            // Update your progress view here Float((currentTime * 100) / duration)
            
            let roundedProgress = round(progress * 100) / 100
            self?.progressView.progress = roundedProgress
            debugPrint("DEBUG:  Progress ",roundedProgress)
        }
    }
    
    func removeTimeObserver() {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
            timeObserver = nil
        }
    }
    
    @objc func playerDidFinishPlaying() {
        // This method will be called when the audio has finished playing
        progressView.progress = 1.0
        pausePlayBtn.setImage(UIImage(systemName: "memories"), for: .normal)
        progressView.progress = 0.0
    }
    
    
    // MARK: - Get All audio files from devices
    func getAudioFileLists() {
        // Specify the directory where your audio files are located
        let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        do {
            // Get the contents of the directory
            let directoryContents = try FileManager.default.contentsOfDirectory(at: directoryPath, includingPropertiesForKeys: nil, options: [])
            
            // Filter the files based on their extensions (e.g., mp3, wav, etc.)
            audioFiles = directoryContents.filter { $0.pathExtension.lowercased() == "mp3" || $0.pathExtension.lowercased() == "wav" }
            
            // Reload the table view to display the audio file names
            
            
            tableview.reloadData()
        } catch {
            // Handle the error
            print("Error reading directory: \(error.localizedDescription)")
        }
    }
    
    
    func getAllAudioFiles() -> [URL] {
        var audioFiles: [URL] = []

        // Check if the app has permission to access the media library
        if MPMediaLibrary.authorizationStatus() == .authorized {
            // Create a media query for audio files
            let mediaQuery = MPMediaQuery.songs()

            if let items = mediaQuery.items {
                for item in items {
                    // Get the asset URL for each audio file
                    if let assetURL = item.assetURL {
                        audioFiles.append(assetURL)
                    }
                }
            }
        } else {
            // Handle the case where permission is not granted
            print("Permission not granted for media library")
        }

        return audioFiles
    }
}
