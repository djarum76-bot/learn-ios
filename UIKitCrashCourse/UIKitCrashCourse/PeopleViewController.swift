//
//  PeopleViewController.swift
//  UIKitCrashCourse
//
//  Created by habil . on 22/01/24.
//

import SafariServices
import UIKit

class PeopleViewController: UIViewController {
    private let vm = PeopleViewModel()
    
    private lazy var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: UIScreen.main.bounds.width, height: 130)
        
        let vw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        vw.register(PersonCollectionViewCell.self, forCellWithReuseIdentifier: "PersonCollectionViewCell")
        vw.dataSource = self
        vw.translatesAutoresizingMaskIntoConstraints = false
        return vw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        vm.delegate = self
        vm.getUsers()
    }
}

extension PeopleViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        vm.people.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = vm.people[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PersonCollectionViewCell", for: indexPath) as! PersonCollectionViewCell
        cell.delegate = self
        cell.item = item
        return cell
    }
}

extension PeopleViewController: PeopleViewModelDelegate{
    func didFinish() {
        cv.reloadData()
    }
    
    func didFail(error: Error) {
        print(error)
    }
}

extension PeopleViewController: PersonCollectionViewCellDelegate{
    func didTapSubscribe() {
        let url = URL(string: "https://shinigamitoon.com/series/wind-breaker/chapter-12/")!
        let vc = SFSafariViewController(url: url)
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
    }
}

private extension PeopleViewController{
    func setup(){
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Only You"
        self.view.backgroundColor = .white
        
        self.view.addSubview(cv)
        
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: view.topAnchor),
            cv.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
