//
//  SingleViewController.swift
//  ImageFeed
//
//  Created by Pavel Razumov on 05.12.2022.
//

import UIKit

final class SingleViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView! {
        didSet {
            guard isViewLoaded else { return }
            fullImageView.image = image
        }
    }
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fullImageView.image = image
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
}
