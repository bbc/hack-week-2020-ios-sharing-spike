//
//  ViewController.swift
//  SharingSpike
//
//  Created by William Robinson on 05/12/2020.
//

import UIKit
import LinkPresentation
import MobileCoreServices

class ViewController: UIViewController {

    // IRL url & the promo image will be on the episode object
    let url = URL(string: "https://www.bbc.co.uk/iplayer/episode/m0008s9l")
    let promoImage = UIImage(named: "promoImage")

    var metadata: LPLinkMetadata?

    @IBOutlet weak var button: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = url else {
            return
        }
        triggerMetadataFetch(url: url)
    }

    func triggerMetadataFetch(url: URL) {
        let metadataProvider = LPMetadataProvider()
        metadataProvider.startFetchingMetadata(for: url) { metadata, error in

            if error != nil {
                print("😎 error: \(error.debugDescription)")
                return
            }

            guard let metadata = metadata else {
                print("😎 No metadata")
                return
            }

            self.metadata = metadata
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {

        // Without an image provided Instagram doesn't show up
        let itemProvider = UIActivityItemProvider(placeholderItem: promoImage!)

        let activityViewController = UIActivityViewController(activityItems: [self, itemProvider],
                                                              applicationActivities: nil)

        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.bounds

        present(activityViewController,
                animated: true,
                completion: nil)
    }
}

extension ViewController: UIActivityItemSource {
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {

        guard let activityType = activityType else {
            print("😎 no idea")
            return nil
        }

        if activityType.rawValue.contains("instagram") {

            guard let url = URL(string: "instagram-stories://share"),
                  let promoImage = promoImage,
                  let imageData = promoImage.pngData() else {
                return nil
            }

            let items = [["com.instagram.sharedSticker.backgroundTopColor": "#EA2F3F",
                          "com.instagram.sharedSticker.backgroundBottomColor": "#8845B9",
                          "com.instagram.sharedSticker.stickerImage" : imageData]]

            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: Date().addingTimeInterval(60*5)]
            UIPasteboard.general.setItems(items, options: pasteboardOptions)

            return UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        return metadata?.originalURL
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}
