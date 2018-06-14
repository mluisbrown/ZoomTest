//
//  ViewController.swift
//  ZoomTest
//
//  Created by Michael Brown on 13/06/2018.
//  Copyright © 2018 Michael Brown. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    let imageView = UIImageView(image: UIImage(named: "cat.jpg"))
    var lastZoomScale: CGFloat = -1


    var imageConstraintTop: NSLayoutConstraint!
    var imageConstraintLeading: NSLayoutConstraint!
    var imageConstraintTrailing: NSLayoutConstraint!
    var imageConstraintBottom: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(imageView)
        scrollView.delegate = self

        imageConstraintTop = imageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -1)
        imageConstraintBottom = imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -1)
        imageConstraintLeading = imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 150)
        imageConstraintTrailing = imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 150)

        NSLayoutConstraint.activate([
            imageConstraintTop,
            imageConstraintBottom,
            imageConstraintLeading,
            imageConstraintTrailing,
            ])

        updateZoom()
    }

    override func viewDidAppear(_ animated: Bool) {
        updateConstraints()
    }

    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height

            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height

            // center image if it is smaller than the scroll view
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }

            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }

            imageConstraintTrailing.constant = hPadding
            imageConstraintLeading.constant = hPadding

            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding

            view.layoutIfNeeded()
        }
    }

    fileprivate func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                              scrollView.bounds.size.height / image.size.height)

            if minZoom > 1 { minZoom = 1 }

            scrollView.minimumZoomScale = 0.3 * minZoom

            // Force scrollViewDidZoom fire if zoom did not change
            if minZoom == lastZoomScale { minZoom += 0.000001 }

            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraints()
    }
}
