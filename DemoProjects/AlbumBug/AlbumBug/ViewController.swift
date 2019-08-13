//
//  ViewController.swift
//  AlbumBug
//
//  Created by JiangWang on 2019/8/8.
//  Copyright © 2019 JiangWang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var pickerButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerButton = UIButton(type: .custom)
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        pickerButton.setTitle("Present Album Picker", for: .normal)
        pickerButton.setTitleColor(.red, for: .normal)
        pickerButton.addTarget(self, action: #selector(didClickToPresentImagePicker), for: .touchUpInside)
        pickerButton.backgroundColor = .gray
        view.addSubview(pickerButton)
        let constraints = [pickerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           pickerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)];
        view.addConstraints(constraints)
    }
}


// MARK: - Actions
private extension ViewController {
    @objc func didClickToPresentImagePicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .savedPhotosAlbum
        present(picker, animated: true, completion: nil)
    }
}

