//
//  ViewController.swift
//  AudioProject
//
//  Created by ahmed rajib on 19/11/23.
//

import UIKit
import AVFoundation
import Photos
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet var popupView: UIView!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pausePlayBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    
    var audioLinks: [String] = []
    let vm = AudioListViewModel()
    var player : AVPlayer?
    var isPlaying: Bool = false
    var timeObserver: Any?
    var audioFiles: [URL] = []
    // Assuming you have an AVAudioPlayer instance

    // Create a timer to update the progress view
    
    // MARK: - Video DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        
//        getAllAudioFiles()
        tableview.register(AudioCell.nib, forCellReuseIdentifier: AudioCell.identifier)
        tableview.separatorColor = .clear
        
        playerImage.image = UIImage(named: "audio")
        playerImage.layer.cornerRadius = playerImage.frame.height / 2
        progressView.progress = 0.0
        view.addSubview(popupView)
        popupView.isHidden = true
        backBtn.setImage(UIImage(systemName: "backward.circle.fill"), for: .normal)
        pausePlayBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        forwardBtn.setImage(UIImage(systemName: "forward.circle.fill"), for: .normal)
        
        player = AVPlayer()
        NotificationCenter.default.addObserver(self, selector: #selector(playerTimeControlStatusChanged), name: .AVPlayerItemTimeJumped, object: player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        popupView.frame = CGRect(x: 8, y: Constants.screenHeight + 200 , width: Constants.screenWidth - 16, height: 200)
        // Set the progress view style
        progressView.progressViewStyle = .default
        
        // Set the progress bar color
        progressView.progressTintColor = UIColor.red
        
        // Set the track color (background color of the progress view)
        progressView.trackTintColor = UIColor.gray
        
        bindViewModel()
        
//        let audioFiles = getAllAudioFiles()
//        print("Audio files: \(audioFiles)")

        MPMediaLibrary.requestAuthorization { (status) in
            if status == .authorized {
                // Permission granted, proceed with retrieving MP3 files
                self.getMP3Files()
                self.listDownloadedAudioFiles()
            } else {
                // Permission denied
                print("Media library permission denied")
            }
        }
    }
    
    private func bindViewModel() {
        vm.getAudioList { [weak self] isSuccess in
            switch isSuccess {
            case true:
                self?.reloadTableView()
            case false:
                break
            }
        }
    }
    
    
    @objc func playerTimeControlStatusChanged() {
         if let player = player {
             switch player.timeControlStatus {
             case .playing:
                 print("AVPlayer is playing.")
                 isPlaying = true
             case .paused:
                 print("AVPlayer is paused.")
                 isPlaying = false
             case .waitingToPlayAtSpecifiedRate:
                 print("AVPlayer is waiting to play at specified rate.")
                 isPlaying = false
             @unknown default:
                 print("Unexpected timeControlStatus.")
                 isPlaying = false
             }
         }
     }

    
    @IBAction func backBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func pasuBtnTapped(_ sender: UIButton) {
        if isPlaying {
            pausePlayBtn.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
            player?.pause()
            isPlaying = false
            addTimeObserver()
        }else {
            player?.play()
            pausePlayBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)

            isPlaying = true
            removeTimeObserver()
        }
    }
    
    @IBAction func nextBtnTapped(_ sender: UIButton) {
        
    }
    
    deinit {
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            NotificationCenter.default.removeObserver(self, name: .AVPlayerItemTimeJumped, object: player?.currentItem)
        }
    
//    func getAllAudioFiles() -> [URL] {
//        let fileManager = FileManager.default
//        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        
//        do {
//            let audioFiles = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
//            
//            // Filter the list to include only audio files based on their file extensions
//            let audioFileExtensions = ["mp3", "m4a", "wav", "aac"]
//            let filteredAudioFiles = audioFiles.filter { fileURL in
//                return audioFileExtensions.contains(fileURL.pathExtension.lowercased())
//            }
//            
//            return filteredAudioFiles
//        } catch {
//            print("Error reading contents of directory: \(error)")
//            return []
//        }
//    }
    
    func getMP3Files() {
        let query = MPMediaQuery.songs()
        let predicate = MPMediaPropertyPredicate(value: "mp3", forProperty: MPMediaItemPropertyAssetURL, comparisonType: .contains)
        query.addFilterPredicate(predicate)

        if let items = query.items {
            for item in items {
                if let title = item.title {
                    print("Title: \(title)")
                    // You can also access other properties like artist, album, etc.
                }
                if let assetURL = item.assetURL {
                    print("Asset URL: \(assetURL)")
                    // Use the assetURL to play or manipulate the MP3 file
                }
            }
        }
    }
    
    func listDownloadedAudioFiles() {
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

            for fileURL in fileURLs {
                // Check if the file is an audio file based on its extension
                if fileURL.pathExtension.lowercased() == "mp3" {
                    print("Audio File: \(fileURL.lastPathComponent)")
                    // Add the fileURL to your list or perform any other actions
                }
            }
        } catch {
            print("Error listing downloaded audio files: \(error.localizedDescription)")
        }
    }

}

