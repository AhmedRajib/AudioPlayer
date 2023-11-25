//
//  ViewController.swift
//  AudioProject
//
//  Created by ahmed rajib on 19/11/23.
//

import UIKit
//import TipKit
import AVFoundation

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
    // Assuming you have an AVAudioPlayer instance

    // Create a timer to update the progress view
    
    // MARK: - Video DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    private func setUpView() {
        tableview.register(AudioTableViewCell.nib, forCellReuseIdentifier: AudioTableViewCell.identifier)
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
}

