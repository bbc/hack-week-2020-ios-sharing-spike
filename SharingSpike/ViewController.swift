//
//  ViewController.swift
//  SharingSpike
//
//  Created by William Robinson on 05/12/2020.
//

import UIKit
import LinkPresentation

class ViewController: UIViewController {

    let url = URL(string: "https://www.bbc.co.uk/iplayer/episode/m0008s9l")
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

        let activityViewController = UIActivityViewController(activityItems: [self],
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
        return metadata?.originalURL
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}
