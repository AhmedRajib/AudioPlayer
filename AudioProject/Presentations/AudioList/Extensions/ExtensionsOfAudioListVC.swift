//
//  ExtensionsOfAudioListVC.swift
//  AudioProject
//
//  Created by ahmed rajib on 19/11/23.
//

import UIKit
import AVFoundation

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vm.audioList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioTableViewCell.identifier, for: indexPath) as! AudioTableViewCell
        cell.titleLabel.text = vm.keyArray[indexPath.row]
        cell.imageIcon.image = UIImage(named: "audio")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let audioUrl = vm.audioList[vm.keyArray[indexPath.row]] {
            let str = audioUrl as? String ?? ""
            playAudioFilesWithURL(url: str)
        }
        showingAudioPlayer()
        addTimeObserver()
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
}
